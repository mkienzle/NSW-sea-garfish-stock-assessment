# CREATED   9 Sep 2020
# MODIFIED  9 Sep 2020

# PURPOSE estimate parameters using a Bayesian approach with MCMC

# Load usefull libraries
library(SAFR)
source("UsefulFunctions.R")

# Load data available for analysis
source("LoadTheData.R")

#########################################################

# Model 1
#library(BayesianTools)
#setUp1 <- createBayesianSetup(new.ll.model1, lower = lower.bound, upper = upper.bound)
#settings = list(iterations = 25000,  message = FALSE)
#out1 <- runMCMC(bayesianSetup = setUp1, sampler = "Metropolis", settings = settings)
#tracePlot(out1, start = 5000)

# Model 2
lower.bound <- c(5e-2,1e-2, 1e-2, 1e-4);upper.bound <- c(15,2,1,1)

csf <- 1e-3 # catchability scaling factor

# Maximum likelihood fit done by FitModels.R
#result2 <- optim(par = c(1.0, 0.2, 0.1, 0.1), fn = ll.model2, catch = nb.at.age.wgt, effort = effort * outer(1. ^ seq(0,14), rep(1,6)), catchability.scaling.factor = csf, method = c("L-BFGS-B"),
#       lower = lower.bound, upper = upper.bound, hessian = TRUE)

#print(result2)
#errors2 <- sqrt(diag(solve(result2$hessian)))
#print(errors2)
#save(result2, file = "Results/Models/model2.R")


new.ll.model2 = function(par) -ll.model2(par, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf)

library(BayesianTools)
setUp2 <- createBayesianSetup(new.ll.model2, lower = lower.bound, upper = upper.bound)
settings = list(iterations = 25000,  message = FALSE)
out2 <- runMCMC(bayesianSetup = setUp2, sampler = "Metropolis", settings = settings)

png("Results/Graphics/Bayesian_Trace_model2.png", height = 1000, width = 1000)
tracePlot(out2, start = 1)
dev.off()

save(out2, file = "Results/Models/Bayesian_model2.RData")

# compare errors with those estimated using likelihood fit
load(file = "Results/Models/model2.R")
errors2 <- sqrt(diag(solve(result2$hessian)))

rbind(result2$par - 2* errors2, result2$par, result2$par + 2* errors2)
apply(out2$chain[-seq(1, 5e3), 1:4], 2, quantile, c(0.025, 0.5, 0.975))

# Are the posterior distribution of the parameters Gaussian?
png("Results/Graphics/Bayesian_ParametersPosteriorDistributions_model2.png")
par(mfrow = c(2,2));

for(i in 1:4) {
      tmp = hist(out2$chain[-(1:5e3),i], freq = FALSE, main = paste("par", i), xlab = "", las = 1);
      points(tmp$mids, dnorm(tmp$mids, mean = mean(out2$chain[-(1:5e3),i]),
      sd = sd(out2$chain[-(1:5e3),i])),  pch = 3, col = "red", type = "b")}
dev.off()

# Plot correlation between variables
par(mfrow = c(1,1))
pairs(out2$chain[-seq(1,1e4), 1:4])
