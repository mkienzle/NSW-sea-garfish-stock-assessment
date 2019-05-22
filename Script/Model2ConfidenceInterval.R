# CREATED  18 April 2017
# MODIFIED 22 May   2019

# PURPOSE calculate 95% Confidence intervals for parameters of model 1
#         using the values from the profile likelihood

source("FitModels.R")

# Range of log-likelihood for model 1
max.boundary <- result2$value + 0.5 * qchisq(0.95, df = length(result2$par) )

png(file = "Results/Graphics/Model2-ProfileLikelihood.png")
#postscript(file = "Results/Graphics/Model2-ProfileLikelihood.ps")
par(mfrow = c(2,2))

### Catchability
print("Catchability (q)")
#mod2.prof.q <- read.csv("Results/Data/Model2-ProfileLikelihoodOfCatchability-Apr182017-16-28-05.csv")
#mod2.prof.q <- read.csv("Results/Data/Model2-ProfileLikelihoodOfCatchability-May102017-09-20-35.csv")
#mod2.prof.q <- read.csv("Results/Data/Model2-ProfileLikelihoodOfCatchability-Jul132017-06-57-41.csv")
#mod2.prof.q <- read.csv("Results/Data/Model2-ProfileLikelihoodOfCatchability-Jun012018-07-56-47.csv")
mod2.prof.q <- read.csv("Results/Data/Model2-ProfileLikelihoodOfCatchability-May212019-21-21-51.csv")
tmp <- with(subset(mod2.prof.q, log.lik <= max.boundary), range(q))
print(tmp)

# plot
with(mod2.prof.q, plot(q, log.lik, type = "l", xlab = "Catchility (q) x 1e-3", ylab = "Negative log-likelihood",
		  ylim = c(min(mod2.prof.q$log.lik) - 2, max.boundary + 5), main = "Model 2"))
abline(h = max.boundary, lty = 3)

# ### Natural mortality
print("Natural mortality")
#mod2.prof.M <- read.csv("Results/Data/Model2-ProfileLikelihoodOfNaturalMortality-Apr182017-16-42-44.csv")
#mod2.prof.M <- read.csv("Results/Data/Model2-ProfileLikelihoodOfNaturalMortality-May102017-09-36-02.csv")
#mod2.prof.M <- read.csv("Results/Data/Model2-ProfileLikelihoodOfNaturalMortality-Jul132017-07-02-49.csv")
#mod2.prof.M <- read.csv("Results/Data/Model2-ProfileLikelihoodOfNaturalMortality-Jun012018-08-03-43.csv")
mod2.prof.M <- read.csv("Results/Data/Model2-ProfileLikelihoodOfNaturalMortality-May212019-21-26-06.csv")
tmp <- with(subset(mod2.prof.M, log.lik <= max.boundary), range(M))
print(tmp)
# Plot
with(mod2.prof.M, plot(M, log.lik, type = "l", xlab = "Natural mortality (M)", ylab = "Negative log-likelihood",
 		  ylim = c(min(mod2.prof.M$log.lik) - 2, max.boundary + 5)))
abline(h = max.boundary, lty = 3)

#selectivity age-group 1 block 1
print("S1")
#mod2.prof.s1 <- read.csv("Results/Data/Model2-ProfileLikelihoodOfS1-Apr182017-17-01-56.csv")
#mod2.prof.s1 <- read.csv("Results/Data/Model2-ProfileLikelihoodOfS1-May102017-09-57-09.csv")
#mod2.prof.s1 <- read.csv("Results/Data/Model2-ProfileLikelihoodOfS1-Jul132017-07-08-49.csv")
#mod2.prof.s1 <- read.csv("Results/Data/Model2-ProfileLikelihoodOfS1-Jun012018-08-12-01.csv")
mod2.prof.s1 <- read.csv("Results/Data/Model2-ProfileLikelihoodOfS1-May212019-21-30-36.csv")
tmp <- with(subset(mod2.prof.s1, log.lik <= max.boundary), range(s1))
print(tmp)

# plot
with(mod2.prof.s1, plot(s1, log.lik, type = "l", xlab = "selectivity age-group 1, block 1", ylab = "Negative log-likelihood", ylim = c(min(mod2.prof.s1$log.lik), max.boundary + 5)))
abline(h = max.boundary, lty = 3)

### Beta parameter of the logistic function
print("s2")
#mod2.prof.s2 <- read.csv("Results/Data/Model2-ProfileLikelihoodOfS2-Apr182017-17-15-37.csv")
#mod2.prof.s2 <- read.csv("Results/Data/Model2-ProfileLikelihoodOfS2-May102017-10-14-24.csv")
#mod2.prof.s2 <- read.csv("Results/Data/Model2-ProfileLikelihoodOfS2-Jul132017-07-14-10.csv")
#mod2.prof.s2 <- read.csv("Results/Data/Model2-ProfileLikelihoodOfS2-Jun012018-16-04-37.csv")
mod2.prof.s2 <- read.csv("Results/Data/Model2-ProfileLikelihoodOfS2-May212019-21-34-42.csv")
tmp <- with(subset(mod2.prof.s2, log.lik <= max.boundary), range(s2))
print(tmp)

# plot
with(mod2.prof.s2, plot(s2, log.lik, type = "l", xlab = "selectivity age-group 1, block 2", ylab = "Negative log-likelihood", ylim = c(min(mod2.prof.s2$log.lik), max.boundary + 5)))
abline(h = max.boundary, lty = 3)

dev.off()

### Is min(log.lik) consistent across all data.set ?

print(paste("Min log-likelihood when varying q =", with(mod2.prof.q, min(log.lik))))
print(paste("Min log-likelihood when varying M =", with(mod2.prof.M, min(log.lik))))
print(paste("Min log-likelihood when varying s1 =", with(mod2.prof.s1, min(log.lik))))
print(paste("Min log-likelihood when varying s2 =", with(mod2.prof.s2, min(log.lik))))
