# CREATED  13 Dec 2016
# MODIFIED 12 Sep 2020

# PURPOSE compute recruitment and biomass distribution using Bayesian samples 

# METHOD based on the script CalculatePopulationTrendsWithUncertainties.R, this script uses samples from
#        the posterior distributions of the parameters of model 2, stored in file Results/Models/Bayesian_model2.RData,
#        to calculate the distributions of quantities of interest to manage the stock (recruitment, biomass and spawning stock biomass, ...)

# Use the best fitted model
source("FitModels.R")

# Use the MCMC samples
load("Results/Models/Bayesian_model2.RData")

# define some variables

n.year <- nrow(nb.at.age.tmp)
n.cohort <- nrow(nb.at.age.tmp) + ncol(nb.at.age.tmp) - 1
n.par <- length(result2$par) # Number of parameters in the best model

burnIn = 11000

# Create a data.frame to hold the resample results
#n.resample <- 1e4

resample.results <- as.data.frame(matrix(nrow = nrow(out2$chain[-(1:burnIn),]), ncol = n.par + 1 + n.cohort + n.year + n.year))
dimnames(resample.results)[[2]] <- c(paste("par", 1:n.par, sep=""), "log.lik", paste("rec", 1:n.cohort, sep = ""),
				     paste("Biomass", 1:n.year, sep = ""),
				     paste("SSB", 1:n.year, sep = ""))

resample.results[, c("par1", "par2", "par3", "par4", "log.lik")] = out2$chain[(burnIn+1):nrow(out2$chain), c("1", "2", "3", "4", "LL")]

# Fix number of define the range of values, in unit of sd, to look around the mean of each parameters
n.sigma <- 2

#for(resample in 1:n.resample){
for(resample in 1:nrow(resample.results)){
print(paste(resample,"/", nrow(resample.results),sep=""))

# Create a set of random parameters
rand.par = t(resample.results[resample, c("par1","par2","par3", "par4")])[,1]

### Estimate recruitment
P <- prob.for.ll.model2(rand.par, effort = effort, catchability.scaling.factor = csf)
prob <- P 

#print(Coaa2Caaa(prob))

est.nb.at.age.in.catch <- outer(estimated.nb.in.catch, rep(1, 6)) * nb.at.age / outer(rowSums(nb.at.age), rep(1, 6))
est.rec <- rowSums(Caaa2Coaa(est.nb.at.age.in.catch), na.rm = T) / rowSums(P, na.rm = T)

resample.results[resample, grep("rec", names(resample.results))] <- est.rec

### Estimate biomass

# Estimated number in the catch (at age)

prop.at.age.from.agesample <- nb.at.age / outer(rowSums(nb.at.age), rep(1, ncol(nb.at.age)))
catch.at.age <- outer(estimated.nb.in.catch, rep(1, ncol(nb.at.age))) * prop.at.age.from.agesample

s.at.age.model2 <-rbind( outer(rep(1,6), c(rand.par[3], rep(1,5))),
                                outer(rep(1,nrow(effort)-6), c(rand.par[4], rep(1,5))))

F <- rand.par[1] * csf * (effort * s.at.age.model2)
M <- rand.par[2]
#mu <-  F/(F+M) * (1-exp(-(F+M)))# Quinn and Deriso (1999) (Eq. 8.58)
#N.at.age <- catch.at.age / mu
N.at.age <- catch.at.age / F
prop.in.population <- N.at.age / outer(rowSums(N.at.age), rep(1, ncol(nb.at.age)))

biomass.at.age <- N.at.age * weight.at.age

resample.results[resample, grep("Biomass", names(resample.results))] <- rowSums(biomass.at.age * 1e-3)

# Calculate SSB, assuming all but age-group 0-1 are sexually mature
maturity.mat = outer(rep(1, nrow(biomass.at.age)), c(0, rep(1, ncol(biomass.at.age)-1)))
resample.results[resample, grep("SSB", names(resample.results))] <- rowSums(biomass.at.age * maturity.mat * 1e-3)

}

# Save the results
write.csv(resample.results, file = paste("Results/Data/Bayesian_Model2QuantityEstimates-", format(Sys.time(), "%b%d%Y-%H-%M-%S"), ".csv", sep=""))
write.csv(resample.results, file = "Results/Data/Bayesian_Model2QuantityEstimates.csv")


library(tidyverse)
head(resample.results[, grep("Biomass", names(resample.results))])

biomass.data = resample.results[, grep("Biomass", names(resample.results))] %>% gather() %>% mutate(year = as.numeric(str_sub(key, 8, 15)) + 2004, f.year = paste(year-1,"/",year,sep="") )

SSB.data = resample.results[, grep("SSB", names(resample.results))] %>% gather() %>% mutate(year = as.numeric(str_sub(key, 4, 8)) + 2004, f.year = paste(year-1,"/",year,sep="") )

 # A function to calculate the quantiles of the distribution
  mean_cl_quantile <- function(x, q = c(0.025, 0.975), na.rm = TRUE){
    dat <- data.frame(y = mean(x, na.rm = na.rm),
                      ymin = quantile(x, probs = q[1], na.rm = na.rm),
                      ymax = quantile(x, probs = q[2], na.rm = na.rm))
    return(dat)
  }

uniq.year = sort(unique(biomass.data$year))
uniq.f.year = sort(unique(biomass.data$f.year))

p1 = ggplot(data = biomass.data, aes(x = year, y = value)) + 
    stat_summary(geom = "line", fun.y = median, col = "black", size = 1.2) +
    stat_summary(geom = "ribbon", fun.data = mean_cl_quantile, alpha = 0.1, lty = 3) +
    xlab("") + ylab("Biomass (t)") + scale_x_continuous(name = "", breaks = uniq.year[seq(1, length(uniq.year), length = 5)], labels = uniq.f.year[seq(1, length(uniq.f.year), length = 5)]) + theme_light()

ggsave(filename = "Results/Graphics/Bayesian_BiomassTrend.pdf", plot = p1, device = "pdf")

 p2 = ggplot(data = SSB.data, aes(x = year, y = value)) + 
    stat_summary(geom = "line", fun.y = median, col = "black", size = 1.2) +
    stat_summary(geom = "ribbon", fun.data = mean_cl_quantile, alpha = 0.1, lty = 3) +
    xlab("") + ylab("Spawning Stock Biomass (t)") + scale_x_continuous(name = "", breaks = uniq.year[seq(1, length(uniq.year), length = 5)], labels = uniq.f.year[seq(1, length(uniq.f.year), length = 5)]) + theme_light()

ggsave(filename = "Results/Graphics/Bayesian_SSBTrend.pdf", plot = p2, device = "pdf")

# Plot the estimated SSB distribution in the most recent years


pdf(file = "Results/Graphics/Bayesian_SSB_distribution_in_2018-19.pdf")
hist(resample.results$SSB15, xlim = c(50,200), xlab = "SSB (tonnes)", main = "MCMC distribution of SSB in 2018/19")
abline(v=62, lty = 3, col = "red")
dev.off()

pdf(file = "Results/Graphics/Bayesian_SSB_distribution_in_2004-05.pdf")
hist(resample.results$SSB1, xlim = c(0,100), xlab = "SSB (tonnes)", main = "MCMC distribution of SSB in 2004/05")
abline(v=62, lty = 3, col = "red")
dev.off()


# Kobe plot

pdf(file = "Results/Graphics/Bayesian_Kobe_plot.pdf")

plot(effort[,1], with(SSB.data, tapply(value, year, median)), pch = 19, xlab = "Effort (boat-days)", ylab = "SSB (tonnes)", xlim = c(0,1000), ylim = c(0,200), las = 1)
segments(effort[,1], with(SSB.data, tapply(value, year, quantile, 0,025)), effort[,2], with(SSB.data, tapply(value, year, quantile, 0.975)))
abline(v = 700, lty = 1); abline(h = 62, lty = 1)


text(effort[1,1] + 60, with(SSB.data, tapply(value, year, median))[1] + 10, dimnames(catch)[[1]][1])
text(effort[5,1] +  0, with(SSB.data, tapply(value, year, median))[5] - 15, dimnames(catch)[[1]][5])
text(effort[15,1] - 100, with(SSB.data, tapply(value, year, median))[15] -  0, dimnames(catch)[[1]][15])

x0 = effort[-length(effort[,1]), 1]
x1 = effort[-1,1]

y0 = with(SSB.data, tapply(value, year, median))[-length(effort[,1])]
y1 = with(SSB.data, tapply(value, year, median))[-1]

arrows(x0, y0, x1, y1, length = 0.15, lty = 3)
dev.off()
