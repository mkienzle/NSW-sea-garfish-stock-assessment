# CREATED  16 Dec 2016
# MODIFIED  6 Jul 2017

# PURPOSE plot results on various analysis

# Fit models to the data
source("FitModels.R")
source("DeriveQuantitiesFromModels.R")

# Load data from profiling the likelihood (created by CalculatePopulationTrendsWithUncertainties.R)

#resample.results.x <- read.csv(file = "Results/Data/ProfileLikelihoodOfRecruitmentEstimates-Jul062017-22-11-45.csv")
resample.results.x <- read.csv(file = "Results/Data/ProfileLikelihoodOfRecruitmentEstimates-Jul062017-23-30-48.csv")

### Recruitment estimates (plot recruitment + uncertainty generates using a profile likelihood approach -- see CalculateRecruitmentUncertainty.R)

#pdf("Results/Graphics/EstimateOfRecruitment.pdf")
png("Results/Graphics/EstimateOfRecruitment.png")
indices <- seq(ncol(nb.at.age.tmp), ncol(nb.at.age.tmp) + nrow(nb.at.age.tmp) - 1)
plot(seq(2004, 2015), est.rec[indices], type = "n", xlab = "", ylab = "", main = "Recruitment estimates", ylim = c(0, 4e6), axes = FALSE)
axis(1, at = seq(2004, 2015), label = dimnames(nb.at.age.tmp)[[1]])
axis(2, las = 1)
box()
abline(h = seq(0,9) * 1e6, col = "lightgrey")
legend(2004, 4e6, lty = c(NA, 1), pch = c(19, NA), legend = c("ML estimate", "95% CI"), bg = "white")
points(seq(2004, 2015), est.rec[indices], pch = 19, type = "b", lty = 2)


segments(seq(2004, 2015), apply(resample.results.x, 2, min)[12:23],
         seq(2004, 2015), apply(resample.results.x, 2, max)[12:23])

dev.off()

# Plot the variability of recruitment estimate from profile likelihood
boxplot(resample.results.x[, 12:23], names = 2004:2015, las = 1, main = "Recruitment estimate variability")

### Plot biomasses

# Variability of resamples estimates
boxplot(resample.results.x[, 24:35], names = 2004:2015, las = 1, main = "Biomass estimates (in tonnes) variability")

# Estimated number in the catch (at age)

prop.at.age.from.agesample <- nb.at.age / outer(rowSums(nb.at.age), rep(1, ncol(nb.at.age)))
catch.at.age <- outer(estimated.nb.in.catch, rep(1, ncol(nb.at.age))) * prop.at.age.from.agesample

# Calculate number at age in the population using best model for mortality
F <- mod2.fish.mort.est
M <- result2$par[2]
mu <-  F/(F+M) * (1-exp(-(F+M)))# Quinn and Deriso (1999) (Eq. 8.58)
#N.at.age <- catch.at.age / mu
N.at.age <- catch.at.age / F



#pdf("Results/Graphics/EstimateOfBiomass.pdf")
png("Results/Graphics/EstimateOfBiomass.png")

plot(seq(2004, 2015),  rowSums(N.at.age * weight.at.age * 1e-3),
type = "n", axes = FALSE, xlab = "", ylab = "", main = "Biomass estimates", ylim = c(0, 400))
axis(1, at = seq(2004, 2015), label = dimnames(nb.at.age.tmp)[[1]])
axis(2, las = 1)
box()

abline(h = seq(0,600, 50), col = "lightgrey")
#abline(h = seq(100,400, 50), col = "lightgrey")

points(seq(2004, 2015),  rowSums(N.at.age * weight.at.age * 1e-3), pch = 19, type = "b", lty = 2)

legend(2004, 400, lty = c(NA, 1), pch = c(19, NA), legend = c("ML estimate", "95% CI"), bg = "white")

segments(seq(2004, 2015), apply(resample.results.x[, 24:35],2, min),
         seq(2004, 2015), apply(resample.results.x[, 24:35],2, max))
	 
dev.off()

### Plot trends in estimated fishery and natural mortality rates from model 2
#pdf(file = "Results/Graphics/Mod2-MortalityEstimates.pdf")
png(file = "Results/Graphics/Mod2-MortalityEstimates.png")
plot( seq(1, nrow(nb.at.age.wgt)), result2$par[1] * csf * (effort * s.at.age.model2)[,2], pch = 19, type = "b",
      axes = FALSE, xlab = "", ylab = "mortality rates (1/year)", ylim = c(0,2.0))
polygon(x=c(0,13, 13, 0), y = c(result2$par[2] - 2 * errors2[2], result2$par[2] - 2 * errors2[2], result2$par[2] + 2 * errors2[2], result2$par[2] + 2 * errors2[2]), col = "lightgrey", border = "transparent")
abline(h = result2$par[2])

CI.mean <- result2$par[1] * csf * (effort * s.at.age.model2)[,2]
CI.upper <- CI.mean + 2 * errors2[1]
CI.lower <- CI.mean - 2 * errors2[1]

segments(seq(1, nrow(nb.at.age.wgt)), CI.upper, seq(1, nrow(nb.at.age.wgt)), CI.lower)
abline(h = seq(0.2, 1.8, 0.2), col = "lightgrey")
axis(1, at = seq(1, nrow(nb.at.age.wgt)), dimnames(nb.at.age.tmp)[[1]])
axis(2, las = 1)
lines( seq(1, nrow(nb.at.age.wgt)), result2$par[1] * csf * (effort * s.at.age.model2)[,2], pch = 19, type = "b")
lines(seq(1, nrow(nb.at.age.wgt)), result2$par[1] * csf * (effort * s.at.age.model2)[,1], pch = 18, type = "b")

CI.mean.AgeGp0 <- result2$par[1] * csf * (effort * s.at.age.model2)[,1]
CI.upper.AgeGp0 <- CI.mean.AgeGp0 + 2 * CI.mean.AgeGp0 * ( errors2[1] / result2$par[1] + errors2[3] / result2$par[3])
CI.lower.AgeGp0 <- CI.mean.AgeGp0 - 2 * CI.mean.AgeGp0 * ( errors2[1] / result2$par[1] + errors2[3] / result2$par[3])

segments(seq(1, nrow(nb.at.age.wgt)), CI.upper.AgeGp0, seq(1, nrow(nb.at.age.wgt)), CI.lower.AgeGp0)

legend(4, 2.0, pch = c(19, 18, NA), lty = rep(1,3), legend = c("Fish. mort. on fully selected age-groups", "Fish. mort. on age-group 0", "Natural mortality"), bg = "white")
box()
dev.off()


