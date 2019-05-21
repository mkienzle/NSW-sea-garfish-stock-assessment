# CREATED  18 Dec 2016
# MODIFIED  8 Jun 2018

# PURPOSE once models are fitted to the data, certain quantities can be calculated using parameters estimates
#         using the best model

# REFERENCES Dupont, 1983 "A stochastic catch-effort method for estimating animal abundance". Biometrics 39, 1021-1033

# Fit models to the data
source("FitModels.R")

### Model 1
s.at.age.mod1 <- outer(rep(1, nrow(effort)), c(result$par[3], rep(1,5)))

s.at.age.mod1 <- formating(s.at.age.mod1)
dimnames(s.at.age.mod1)[[1]] <- dimnames(catch)[[1]]
write.csv(file = "Results/Models/Mod1-GearSelectivity.csv", round(s.at.age.mod1,3))

### Model 2

## Calculate the probabilities associated with each observation using model 2
prob <- prob.for.ll.model2(result2$par, effort = effort, catchability.scaling.factor = csf)

## Estimate recruitment for each cohort using the ratio of sum of catch over sum of probability of catching (Dupont, 1983)
est.nb.at.age.in.catch <- outer(estimated.nb.in.catch, rep(1, 6)) * nb.at.age / outer(rowSums(nb.at.age), rep(1, 6))

est.rec <- rowSums(Caaa2Coaa(est.nb.at.age.in.catch), na.rm = T) / rowSums(prob, na.rm = T)

## Calculate fishing mortality at age
s.at.age.model2 <-rbind( outer(rep(1,6), c(result2$par[3], rep(1,5))),
    		                outer(rep(1,nrow(effort)-6), c(result2$par[4], rep(1,5))))

s.at.age.model2 <- formating(s.at.age.model2)
dimnames(s.at.age.model2)[[1]] <- dimnames(catch)[[1]]
write.csv(file = "Results/Models/Mod2-GearSelectivity.csv", round(s.at.age.model2,3))

mod2.fish.mort.est <- result2$par[1] * csf * (effort * s.at.age.model2)
dimnames(mod2.fish.mort.est) <- dimnames(nb.at.age.tmp)

# Number of individual in the population
N.at.age <- est.nb.at.age.in.catch / mod2.fish.mort.est

print(file = "Results/Models/Mod2-FishingMortality.tex", xtable(formating(mod2.fish.mort.est), digits = 2, caption = "Estimates of fishing mortality faced by each age-group in every year according to model 2.", label="tab:Mod2-FishingMortality"))

# output all in a file
cat(file = "Results/Data/StockSummary.txt", "# NSW sea garfish stock summary\n\n")

cat("# Catch (in kg)\n", file = "Results/Data/StockSummary.txt", append = TRUE)
write.table(catch, file = "Results/Data/StockSummary.txt", append = TRUE, quote = FALSE, col.names = FALSE)
cat("\n", file = "Results/Data/StockSummary.txt", append = TRUE)

cat("# Effort (in days)\n", file = "Results/Data/StockSummary.txt", append = TRUE)
write.table(effort.tmp, file = "Results/Data/StockSummary.txt", append = TRUE, quote = FALSE, col.names = FALSE)
cat("\n", file = "Results/Data/StockSummary.txt", append = TRUE)

cat("# Sample of number at age\n", file = "Results/Data/StockSummary.txt", append = TRUE)
write.table(nb.at.age.tmp, file = "Results/Data/StockSummary.txt", append = TRUE, quote = FALSE, col.names = FALSE)
cat("\n", file = "Results/Data/StockSummary.txt", append = TRUE)

cat("# Weight at age (in kg)\n", file = "Results/Data/StockSummary.txt", append = TRUE)
write.table(round(weight.at.age,3), file = "Results/Data/StockSummary.txt", append = TRUE, quote = FALSE, col.names = FALSE)
cat("\n", file = "Results/Data/StockSummary.txt", append = TRUE)

cat("# Estimated number of fish in the catch\n", file = "Results/Data/StockSummary.txt", append = TRUE)
write.table(round(est.nb.at.age.in.catch, 0), file = "Results/Data/StockSummary.txt", append = TRUE, quote = FALSE, col.names = FALSE)
cat("\n", file = "Results/Data/StockSummary.txt", append = TRUE)

cat("# Estimated number of fish in the population\n", file = "Results/Data/StockSummary.txt", append = TRUE)
write.table(round(N.at.age,0), file = "Results/Data/StockSummary.txt", append = TRUE, quote = FALSE, col.names = FALSE)
cat("\n", file = "Results/Data/StockSummary.txt", append = TRUE)

cat("# Estimated biomass of fish at age in the population in tonnes\n", file = "Results/Data/StockSummary.txt", append = TRUE)
write.table(round(N.at.age * weight.at.age * 1e-3,0), file = "Results/Data/StockSummary.txt", append = TRUE, quote = FALSE, col.names = FALSE)
cat("\n", file = "Results/Data/StockSummary.txt", append = TRUE)

cat("# Estimated recruitment (in millions of fish)\n", file = "Results/Data/StockSummary.txt", append = TRUE)
output.tmp <- cbind(dimnames(nb.at.age.tmp)[[1]], round( 1e-6 * est.rec[seq(ncol(nb.at.age), ncol(nb.at.age) + nrow(nb.at.age) - 1)],3))
write.table(output.tmp, file = "Results/Data/StockSummary.txt", append = TRUE, quote = FALSE, col.names = FALSE, row.names = FALSE)
cat("\n", file = "Results/Data/StockSummary.txt", append = TRUE)
