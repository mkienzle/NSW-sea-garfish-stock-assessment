# CREATED  18 April 2017
# MODIFIED 18 April 2017

# PURPOSE diagnostic of the model

# BACKGROUND the best model is model 2

# Load data
source("LoadTheData.R")

# Load libraries
library(ggplot2)
library(SAFR)

# too time consuming to repeat every time
source("FitModels.R")

## Calculate the number at age predicted by the model
# Get the probability of dying in an interval
prob <- prob.for.ll.model2(result2$par, effort, csf)
tmp <- prob / rowSums(prob, na.rm = TRUE) # Normalized to sum to 1 for each cohort

Est.nb.at.age <- Coaa2Caaa(tmp * outer(rowSums(Caaa2Coaa(nb.at.age), na.rm = T), rep(1, ncol(nb.at.age))))

tmp.data <- data.frame(Year = rep(dimnames(nb.at.age.tmp)[[1]], ncol(nb.at.age.tmp)) , Age.Group = rep(1:ncol(nb.at.age.tmp), each = nrow(nb.at.age.tmp)), nb.at.age = c(nb.at.age), Surv.analysis = c(Est.nb.at.age));
tmp.data[,3] <- replace(tmp.data[,3], tmp.data[,3] == 0, NA)
library(reshape); df.melted <- melt(tmp.data, id = c("Year", "Age.Group")); head(df.melted)

p1 <- ggplot(df.melted, aes(Age.Group, y=value, colour = variable, shape = variable)) + geom_point() + facet_wrap(~Year, nrow = 2)
p1 <- p1 + scale_shape_manual(values = c(16, 3)) + scale_colour_manual(values = c("black", "red"))
p1 <- p1 + scale_x_continuous(name = "Age groups (year)") + scale_y_continuous(name = "Nb at age sampled from catch")
p1 <- p1 + theme(axis.text=element_text(size=12), axis.title=element_text(size=18,face="bold"), legend.text=element_text(size=18))
p1 <- p1 + theme(legend.title=element_text(size=18))

print(p1)
pdf(file = "Results/Graphics/NbAtAgeOverlayedWithModel.pdf")
print(p1)
dev.off()

### Plot fit descrepancy as a function of predicted values
png(file = "Results/Graphics/DiscrepancyFctPrediction.png")
#pdf(file = "Results/Graphics/DiscrepancyFctPrediction.pdf")
with(tmp.data,
	plot(Surv.analysis, nb.at.age - Surv.analysis, xlab = "predicted", ylab = "observed - predicted", main = "Nb at age", las = 1))
abline(h=0)
dev.off()

### Plot observed catch overlayed with predicted

# Calculate predicted catch
png(file = "Results/Graphics/CatchOverlayedWithPredicted.png")
#pdf(file = "Results/Graphics/CatchOverlayedWithPredicted.pdf")
source("DeriveQuantitiesFromModels.R")
pred.catch <- rowSums(Coaa2Caaa(est.rec * prob * Caaa2Coaa(weight.at.age)))

years <- as.numeric(substr(dimnames(catch)[[1]],1,4))

plot(years, catch[,1] * 1e-3, type = "b", pch = 19, axes = FALSE, xlab = "", ylab = "Catch (Tonnes)", ylim = c(0,100))
axis(1, years, dimnames(catch)[[1]])
axis(2, las = 1)

#points(years, pred.catch * 1e-3, type = "b", pch = 19, col = "red")

legend(2011, 100, pch = 19, col = c("black", "red"), legend = c("observed", "predicted"))
box()


#resample.results.x <- read.csv(file = "Results/Data/ProfileLikelihoodOfRecruitmentEstimates-Jan022017-09:03:06.csv")
#resample.results.x <- read.csv(file = "Results/Data/ProfileLikelihoodOfRecruitmentEstimates-Apr202017-09:22:08.csv")
#resample.results.x <- read.csv(file = "Results/Data/ProfileLikelihoodOfRecruitmentEstimates-Apr202017-16:32:27.csv")
#resample.results.x <- read.csv(file = "Results/Data/ProfileLikelihoodOfRecruitmentEstimates-May092017-15:11:49.csv")
resample.results.x <- read.csv(file = "Results/Data/ProfileLikelihoodOfRecruitmentEstimates-Jul062017-23-30-48.csv")

#pred.catch <- apply(resample.results.x,2,mean)[grep("Biomass", names(resample.results.x))]

stored.pred.catch <- data.frame(matrix(ncol = nrow(nb.at.age), nrow = nrow(resample.results.x)))

for(i in 1:nrow(resample.results.x)){
print(paste(i,"/", nrow(resample.results.x), sep=""))
#for(i in 1:10){

rand.par <- as.numeric(resample.results.x[i, grep("par", names(resample.results.x))])

prop.at.age.from.agesample <- nb.at.age / outer(rowSums(nb.at.age), rep(1, ncol(nb.at.age)))
catch.at.age <- outer(estimated.nb.in.catch, rep(1, ncol(nb.at.age))) * prop.at.age.from.agesample

s.at.age.model2 <-rbind( outer(rep(1,6), c(rand.par[3], rep(1,5))),
                                outer(rep(1,nrow(effort)-6), c(rand.par[4], rep(1,5))))

F <- rand.par[1] * csf * (effort * s.at.age.model2)
M <- rand.par[2]
mu <-  F/(F+M) * (1-exp(-(F+M)))# Quinn and Deriso (1999) (Eq. 8.58)
#N.at.age <- catch.at.age / mu
N.at.age <- catch.at.age / F

prop.in.population <- N.at.age / outer(rowSums(N.at.age), rep(1, ncol(nb.at.age)))

biomass.est <- resample.results.x[i,grep("Biomass", names(resample.results.x))] * 1e3
#est.in.pop <- Estimate.NbOfFishInCatch(biomass.est, nb.at.age, weight.at.age)


est.in.pop <- Estimate.NbOfFishInCatch(biomass.est, N.at.age, weight.at.age)
N.at.age.tmp <- outer(as.numeric(est.in.pop), rep(1, ncol(prop.at.age.from.agesample))) * prop.in.population

#pred.catch.tmp <- rowSums(outer(as.numeric(biomass.est), rep(1, ncol(prop.at.age.from.agesample))) * prop.at.age.from.agesample * mu)
#pred.catch.tmp <- rowSums(outer(as.numeric(biomass.est), rep(1, ncol(prop.at.age.from.agesample))) * prop.at.age.from.agesample / weight.at.age * F)
pred.catch.tmp <- rowSums(N.at.age.tmp * F * weight.at.age)
stored.pred.catch[i,] <- pred.catch.tmp

#prob.tmp <- prob.for.ll.model2(as.numeric(resample.results.x[i, grep("par", names(resample.results.x))]), effort, csf)
#pred.catch.tmp <- rowSums(Coaa2Caaa(as.numeric(resample.results.x[i, grep("rec", names(resample.results.x))]) * prob.tmp * Caaa2Coaa(weight.at.age)))
lines(years, pred.catch.tmp * 1e-3, col = "lightgrey")
}

points(years, apply(stored.pred.catch,2,mean) * 1e-3, type = "b", pch = 19, col = "red")
points(years, catch[,1] * 1e-3, type = "b", pch = 19)
dev.off()


# ## test

# expl.rate <- mod2.fish.mort.est / (mod2.fish.mort.est + result2$par[2])

# prop.at.age.sample <- nb.at.age / outer(rowSums(nb.at.age), rep(1,ncol(nb.at.age)))


# #biomass.est <- resample.results.x[1,grep("Biomass", names(resample.results.x))] * 1e3
# biomass.est <- apply(resample.results.x,2, mean)[,grep("Biomass", names(resample.results.x))] * 1e3

# est.in.pop <- Estimate.NbOfFishInCatch(biomass.est, nb.at.age, weight.at.age)
# rowSums(outer(as.numeric(est.in.pop), rep(1, ncol(prop.at.age.sample))) * prop.at.age.sample * expl.rate * weight.at.age)

# plot(seq(1,11), rowSums(outer(as.numeric(biomass.est), rep(1, ncol(prop.at.age.sample))) * prop.at.age.sample * expl.rate), type = "b", ylim = c(0, 15e4))
# points(seq(1,11), catch[,1], type = "b")


# ### test
# rand.par <- as.numeric(resample.results.x[1, grep("par", names(resample.results.x))])

# prop.at.age.from.agesample <- nb.at.age / outer(rowSums(nb.at.age), rep(1, ncol(nb.at.age)))
# catch.at.age <- outer(estimated.nb.in.catch, rep(1, ncol(nb.at.age))) * prop.at.age.from.agesample

# F <- rand.par[1] * csf * (effort * s.at.age.model2)
# M <- rand.par[2]
# mu <-  F/(F+M) * (1-exp(-(F+M)))# Quinn and Deriso (1999) (Eq. 8.58)
# N.at.age <- catch.at.age / mu

# biomass.est <- resample.results.x[1,grep("Biomass", names(resample.results.x))] * 1e3

# est.in.pop <- Estimate.NbOfFishInCatch(biomass.est, nb.at.age, weight.at.age)

# rowSums(outer(as.numeric(biomass.est), rep(1, ncol(prop.at.age.from.agesample))) * prop.at.age.from.agesample * mu)
