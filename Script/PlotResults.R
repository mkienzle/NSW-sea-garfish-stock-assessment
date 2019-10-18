# CREATED  16 Dec 2016
# MODIFIED 19 Oct 2019

# PURPOSE plot results on various analysis

# Fit models to the data
#source("FitModels.R")
source("DeriveQuantitiesFromModels.R")

# Load data from profiling the likelihood (created by CalculatePopulationTrendsWithUncertainties.R)

#resample.results.x <- read.csv(file = "Results/Data/ProfileLikelihoodOfRecruitmentEstimates-Jul062017-22-11-45.csv")
#resample.results.x <- read.csv(file = "Results/Data/ProfileLikelihoodOfRecruitmentEstimates-Jul062017-23-30-48.csv")
#resample.results.x <- read.csv(file = "Results/Data/ProfileLikelihoodOfRecruitmentEstimates-May312018-17-43-11.csv")
#resample.results.x <- read.csv(file = "Results/Data/ProfileLikelihoodOfRecruitmentEstimates-Jun022018-07-17-17.csv")
#resample.results.x <- read.csv(file = "Results/Data/ProfileLikelihoodOfRecruitmentEstimates-Aug022017-19-20-16.csv")
#resample.results.x <- read.csv(file = "Results/Data/ProfileLikelihoodOfRecruitmentEstimates-May192019-17-35-57.csv")
resample.results.x <- read.csv(file = "Results/Data/ProfileLikelihoodOfRecruitmentEstimates.csv")

# Some useful parameters
year.seq <- as.numeric(substr(dimnames(nb.at.age.tmp)[[1]],1,4))


### Recruitment estimates (plot recruitment + uncertainty generates using a profile likelihood approach -- see CalculateRecruitmentUncertainty.R)

#pdf("Results/Graphics/EstimateOfRecruitment.pdf")
png("Results/Graphics/EstimateOfRecruitment.png")
#postscript("Results/Graphics/EstimateOfRecruitment.ps")
par(cex.lab = 1.8, cex.main = 2, mai = c(1.02, 1.2, 0.82, 0.42), cex.axis = 1.4) # For presentation
#par(cex.lab = 1.8, cex.main = 2) # For presentation
indices <- seq(ncol(nb.at.age.tmp), ncol(nb.at.age.tmp) + nrow(nb.at.age.tmp) - 1)
plot(year.seq, est.rec[indices], type = "n", xlab = "", ylab = "", main = "Recruitment estimates", ylim = c(0, 1.2e7), axes = FALSE)
axis(1, at = year.seq, label = dimnames(nb.at.age.tmp)[[1]])
axis(2, las = 1)
box()
abline(h = seq(0,12) * 1e6, col = "lightgrey")
legend(2004, 1.2e7, lty = c(NA, 1), pch = c(19, NA), legend = c("ML estimate", "95% CI"), bg = "white")
points(year.seq, est.rec[indices], pch = 19, type = "b", lty = 1)

idx.rec.col <- grep("rec", names(resample.results.x))

lower.bound <- apply(resample.results.x, 2, min)[idx.rec.col[ncol(nb.at.age.tmp):length(idx.rec.col)]]
upper.bound <- apply(resample.results.x, 2, max)[idx.rec.col[ncol(nb.at.age.tmp):length(idx.rec.col)]]

segments(year.seq, lower.bound,
         year.seq, upper.bound)


dev.off()

# save results
df <- data.frame("Year" = year.seq, "EstRec" = est.rec[indices], "X95CI.LowBound" = lower.bound,"X95CI.HighBound" = upper.bound)
write.csv(df, file = paste("../Data/NSW-Garfish-RecEstimates", year.seq[1],"-", substr(year.seq[length(year.seq)],3,4), ".csv", sep=""))
write.csv(df, file = "../Data/NSW-Garfish-RecEstimates.csv")

# Plot the variability of recruitment estimate from profile likelihood
boxplot(resample.results.x[, 12:23], names = 2004:2015, las = 1, main = "Recruitment estimate variability")

# Compare recruitment estimates with previous year's estimate
#pdf("Results/Graphics/EstimateOfRecruitment.pdf")
png("Results/Graphics/CompareVariousRecruitmentEstimates.png")
#postscript("Results/Graphics/CompareVariousRecruitmentEstimates.ps")
indices <- seq(ncol(nb.at.age.tmp), ncol(nb.at.age.tmp) + nrow(nb.at.age.tmp) - 1)
plot(year.seq, est.rec[indices], type = "n", xlab = "", ylab = "", main = "Recruitment estimates", ylim = c(0, 1.2e7), axes = FALSE)
axis(1, at = year.seq, label = dimnames(nb.at.age.tmp)[[1]])
axis(2, las = 1)
box()
abline(h = seq(0,15) * 1e6, col = "lightgrey")
legend(2004, 1.2e7, lty = c(NA, 1,NA), pch = c(19, NA,19), col = c("black", "black", "red"), legend = c("ML estimate", "95% CI", "last year estimates"), bg = "white")
points(year.seq, est.rec[indices], pch = 19, type = "b", lty = 1)

idx.rec.col <- grep("rec", names(resample.results.x))

segments(year.seq, apply(resample.results.x, 2, min)[idx.rec.col[ncol(nb.at.age.tmp):length(idx.rec.col)]],
         year.seq, apply(resample.results.x, 2, max)[idx.rec.col[ncol(nb.at.age.tmp):length(idx.rec.col)]], lwd = 3.5)


old.rec.est <- read.csv(paste("../Data/NSW-Garfish-RecEstimates2004-", as.numeric(substr(year.seq[length(year.seq)],3,4))-1,".csv", sep=""))
with(old.rec.est, points(Year, EstRec, pch = 19, type = "b", col = "red", lty = 2))
with(old.rec.est, segments(Year, X95CI.LowBound, Year, X95CI.HighBound, col = "red", lwd = 2))

dev.off()

### Plot biomasses

# Variability of resamples estimates
boxplot(resample.results.x[, grep("Biomass", names(resample.results.x))], names = year.seq, las = 1, main = "Biomass estimates (in tonnes) variability")

# Estimated number in the catch (at age)

prop.at.age.from.agesample <- nb.at.age / outer(rowSums(nb.at.age), rep(1, ncol(nb.at.age)))
catch.at.age <- outer(estimated.nb.in.catch, rep(1, ncol(nb.at.age))) * prop.at.age.from.agesample

# Calculate number at age in the population using best model for mortality
F <- mod2.fish.mort.est
M <- result2$par[2]
#mu <-  F/(F+M) #* (1-exp(-(F+M)))# Quinn and Deriso (1999) (Eq. 8.58)
#N.at.age <- catch.at.age / mu
N.at.age <- catch.at.age / F

#pdf("Results/Graphics/EstimateOfBiomass.pdf")
png("Results/Graphics/EstimateOfBiomass.png")
#postscript("Results/Graphics/EstimateOfBiomass.ps")
par(cex.lab = 1.8, cex.main = 2, mai = c(1.02, 1.0, 0.82, 0.42), cex.axis = 1.4) # For presentation
#print(par()$mai)

plot(year.seq,  rowSums(N.at.age * weight.at.age * 1e-3),
type = "n", axes = FALSE, xlab = "", ylab = "Biomass (tonnes)", main = "", ylim = c(0, 500))
axis(1, at = year.seq, label = dimnames(nb.at.age.tmp)[[1]])
axis(2, las = 1)
box()

abline(h = seq(0,600, 50), col = "lightgrey")
abline(h = c(100,200), col = "darkgrey")

#abline(h = seq(100,400, 50), col = "lightgrey")

points(year.seq,  rowSums(N.at.age * weight.at.age * 1e-3), pch = 19, type = "b", lty = 2)

legend(2004, 500, lty = c(NA, 1), pch = c(19, NA), legend = c("ML estimate", "95% CI"), bg = "white")

lower.bound <- apply(resample.results.x[, grep("Biomass", names(resample.results.x))],2, min)
upper.bound <- apply(resample.results.x[, grep("Biomass", names(resample.results.x))],2, max)

segments(year.seq, lower.bound,
         year.seq, upper.bound)

dev.off()

# save results
df <- data.frame("Year" = year.seq, "EstBiomass" = rowSums(N.at.age * weight.at.age * 1e-3), "X95CI.LowBound" = lower.bound,"X95CI.HighBound" = upper.bound)
write.csv(df, file = paste("../Data/NSW-Garfish-BiomassEstimates", year.seq[1],"-", substr(year.seq[length(year.seq)],3,4), ".csv", sep=""))
write.csv(df, file = "../Data/NSW-Garfish-BiomassEstimates.csv")


df2 <- data.frame("Year" = year.seq, "EstSSB" = rowSums( (N.at.age * weight.at.age * 1e-3)[,-1]))
write.csv(df2, file = paste("../Data/NSW-Garfish-SSBEstimates", year.seq[1],"-", substr(year.seq[length(year.seq)],3,4), ".csv", sep=""))
write.csv(df2, file = "../Data/NSW-Garfish-SSBEstimates.csv")


# Compare with previous years results
#pdf("Results/Graphics/EstimateOfBiomass.pdf")
png("Results/Graphics/CompareVariousBiomassEstimates.png")

plot(year.seq,  rowSums(N.at.age * weight.at.age * 1e-3),
type = "n", axes = FALSE, xlab = "", ylab = "Biomass (tonnes)", main = "", ylim = c(0, 550))
axis(1, at = year.seq, label = dimnames(nb.at.age.tmp)[[1]])
axis(2, las = 1)
box()

abline(h = seq(0,600, 50), col = "lightgrey")
#abline(h = seq(100,400, 50), col = "lightgrey")

points(year.seq,  rowSums(N.at.age * weight.at.age * 1e-3), pch = 19, type = "b", lty = 2)

legend(2004, 550, lty = c(NA, 1, NA), pch = c(19, NA, 19), col = c("black", "black", "red"), legend = c("ML estimate", "95% CI", "last year estimates"), bg = "white")

segments(year.seq, apply(resample.results.x[, grep("Biomass", names(resample.results.x))],2, min),
         year.seq, apply(resample.results.x[, grep("Biomass", names(resample.results.x))],2, max), lwd = 3.5)

old.biomass.est <- read.csv(paste("../Data/NSW-Garfish-BiomassEstimates2004-", as.numeric(substr(year.seq[length(year.seq)],3,4))-1,".csv",sep = ""))
with(old.biomass.est, points(Year, EstBiomass, pch = 19, type = "b", col = "red", lty = 2))
with(old.biomass.est, segments(Year, X95CI.LowBound, Year, X95CI.HighBound, col = "red", lwd = 2))

dev.off()


### Plot trends in estimated fishery and natural mortality rates from model 2
#pdf(file = "Results/Graphics/Mod2-MortalityEstimates.pdf")
png(file = "Results/Graphics/Mod2-MortalityEstimates.png")
#postscript("Results/Graphics/Mod2-MortalityEstimates.ps")
plot( seq(1, nrow(nb.at.age.wgt)), result2$par[1] * csf * (effort * s.at.age.model2)[,2], pch = 19, type = "b",
      axes = FALSE, xlab = "", ylab = "mortality rates (1/year)", ylim = c(0,2.0))
polygon(x=c(0,nrow(nb.at.age.wgt)+1, nrow(nb.at.age.wgt)+1, 0), y = c(result2$par[2] - 2 * errors2[2], result2$par[2] - 2 * errors2[2], result2$par[2] + 2 * errors2[2], result2$par[2] + 2 * errors2[2]), col = "lightgrey", border = "transparent")
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

### Stock recruitment relationship

## Plot recruitment against SSB

# Load the data
ssb <- read.csv("../Data/NSW-Garfish-SSBEstimates.csv")
rec <- read.csv("../Data/NSW-Garfish-RecEstimates.csv")

# Take only the first 10 estimates because we saw that the most recent recruitment estimates (those depending on 1 or 2 age-groups)
# vary substantially as we collect more data
range <- 1:nrow(ssb)

plot(ssb$EstSSB[-nrow(ssb)][range], rec$EstRec[-1][range], pch = 19, ylim = c(0,5e6), xlim = c(0,200))
segments(ssb$EstSSB[-nrow(ssb)][range], rec$X95CI.LowBound[-1][range],
ssb$EstSSB[-nrow(ssb)][range], rec$X95CI.HighBound[-1][range])

x <- ssb$EstSSB[-nrow(ssb)][range]
y <- rec$EstRec[-1][range]

# According to Hilborn and Walters, you can linearize the Ricker function as follow

dataset <- data.frame( Year = rec$Year[-1][range], y = log(y/x), x = x)
lm1 <- lm(y ~ x, dataset)

# on the transformed scale
png(file = "Results/Graphics/LinearizedRickerSRR.png")
with(dataset, plot(x, y, pch = 19, xlab = "Spawning Stock Biomass (S)", ylab = "log(R/S)" ))
abline(lm1)


x.seq <- seq(0, 200, 1)
pred <- predict(lm1, newdata = data.frame(x = x.seq), interval = "prediction")

lines(x.seq, pred[,3], lty = 2)
lines(x.seq, pred[,2], lty = 2)
dev.off()

# on the natural scale
png(file = "Results/Graphics/RickerSRROnNaturalScale.png")
plot(ssb$EstSSB[-nrow(ssb)][range], 1e-6 * rec$EstRec[-1][range], xlab = "Spawning Stock Biomass", ylab = "Number of recruits (in millions)", pch = 19, ylim = c(0,12), xlim = c(0,200), las = 1)
segments(ssb$EstSSB[-nrow(ssb)][range], 1e-6 * rec$X95CI.LowBound[-1][range],
ssb$EstSSB[-nrow(ssb)][range], 1e-6 * rec$X95CI.HighBound[-1][range])

segments(ssb$EstSSB[-nrow(ssb)][range], 1e-6 * rec$X95CI.LowBound[-1][range],
ssb$EstSSB[-nrow(ssb)][range], 1e-6 * rec$X95CI.HighBound[-1][range])

lines(x.seq, 1e-6 * x.seq * exp(pred[,1]))
lines(x.seq, 1e-6 * x.seq * exp(pred[,2]), lty =2)
lines(x.seq, 1e-6 * x.seq * exp(pred[,3]), lty = 2)
dev.off()
