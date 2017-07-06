#CREATED  16 Dec 2016
#MODIFIED  9 May 2017

# PURPOSE load and format data for analysis. Save them for publication

source("UsefulFunctions.R")

# Age data were rounded
nb.at.age.tmp <- round(read.csv("../Data/GarfishAgeData.csv", row.names = 1, colClasses = c("character", rep("numeric",6))))
nb.at.age <- matrix(NA, nrow = nrow(nb.at.age.tmp), ncol = ncol(nb.at.age.tmp))
for(i in 1:ncol(nb.at.age)) nb.at.age[,i] <- nb.at.age.tmp[,i]

library(xtable)
dimnames(nb.at.age.tmp)[[2]] <- seq(0,ncol(nb.at.age.tmp) - 1)
print(file = "../Writing/Tables/GarfishAgeData.tex", xtable(formating(round(nb.at.age.tmp,1)), digits = 1))

# Catch data
catch <- read.csv("../Data/GarfishCatchData.csv", row.names = 1)

# Weight at age
weight.at.age <- read.csv("../Data/GarfishWeightAtAge.csv", row.names = 1)
we.tmp <- weight.at.age
dimnames(we.tmp)[[1]] <- dimnames(catch)[[1]]
dimnames(we.tmp)[[2]] <- seq(0, ncol(we.tmp)-1)

print(file = "../Writing/Tables/GarfishWeightAtAge.tex", xtable(formating(we.tmp), digits = 3))

# Estimate the number of fish in the catch
estimated.nb.in.catch <- Estimate.NbOfFishInCatch(catch[,1], nb.at.age, weight.at.age)

# Correct age sample by the estimated number of fish in the catch
nb.at.age.wgt <- weighted.sample2(nb.at.age, estimated.nb.in.catch)

nb.at.age.wgt.printout <- nb.at.age.wgt
dimnames(nb.at.age.wgt.printout) <- dimnames(nb.at.age.tmp)
print(file = "../Writing/Tables/WeightedGarfishAgeData.tex", xtable(formating(round(nb.at.age.wgt.printout,1)), digits = 1))


# Load effort data
effort.tmp <- read.csv("../Data/GarfishEffortData.csv", row.names = 1)
effort <- outer(effort.tmp[,1], rep(1, ncol(nb.at.age.tmp)))

ce.tmp <- cbind("Catch" = catch[,1], "Effort" = effort.tmp[,1])
dimnames(ce.tmp)[[1]] <- dimnames(effort.tmp)[[1]]

print(file = "../Writing/Tables/GarfishCatchAndEffort.tex", xtable(formating(ce.tmp), digits = 0))
