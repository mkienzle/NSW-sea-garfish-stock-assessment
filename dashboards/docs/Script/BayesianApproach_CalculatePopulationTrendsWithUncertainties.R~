# CREATED  13 Dec 2016
# MODIFIED 19 May 2019

# PURPOSE estimate abundance and recruitment point estimates and uncertainties

# METHOD according to S. Brandt, Data Analysis, 1999 Springer-Verlag
#        The x% confidence region of the log-likelihood is contains with the minimum log-likelihood + chi-square (0.95, 4 df)
#        Calculating the recruitment from as many points as possible in this region, we use the extreme values to give the 95% confidence
#        interval of the recruitment estimate

x <- 95 # 95% CI

# Use the best fitted model
source("FitModels.R")

# define some variables

n.year <- nrow(nb.at.age.tmp)
n.cohort <- nrow(nb.at.age.tmp) + ncol(nb.at.age.tmp) - 1
n.par <- length(result2$par) # Number of parameters in the best model

# Create a data.frame to hold the resample results
n.resample <- 1e4

resample.results <- as.data.frame(matrix(nrow = n.resample, ncol = n.par + 1 + n.cohort + n.year))
dimnames(resample.results)[[2]] <- c(paste("par", 1:n.par, sep=""), "log.lik", paste("rec", 1:n.cohort, sep = ""),
				     paste("Biomass", 1:n.year, sep = ""))

# Fix number of define the range of values, in unit of sd, to look around the mean of each parameters
n.sigma <- 2

for(resample in 1:n.resample){
print(paste(resample,"/",n.resample,sep=""))

# Create a set of random parameters
rand.par <- rep(NA,n.par)
for(i in 1:n.par) rand.par[i] <- runif(1, min = result2$par[i] -n.sigma * errors2[i], max = result2$par[i] + n.sigma * errors2[i])

resample.results[resample, 1:n.par] <- rand.par
resample.results[resample, 5] <- ll.model2(rand.par, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf)

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
}

# Select the subset of simulated data that fall within the chi-square (x/100, 4df) distance from the minimum log-likelihood
#resample.results.x <- subset(resample.results, (log.lik - result2$value) <= (0.5 * qchisq(x/100, df = 11 * 6 - 4 )))
resample.results.x <- subset(resample.results, (log.lik - result2$value) <= (0.5 * qchisq(x/100, df = 4 )))

# Save the results
write.csv(resample.results.x, file = paste("Results/Data/ProfileLikelihoodOfRecruitmentEstimates-", format(Sys.time(), "%b%d%Y-%H-%M-%S"), ".csv", sep=""))
write.csv(resample.results.x, file = "Results/Data/ProfileLikelihoodOfRecruitmentEstimates.csv")


