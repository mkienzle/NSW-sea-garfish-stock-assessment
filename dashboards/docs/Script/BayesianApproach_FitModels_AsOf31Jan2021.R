# CREATED   9 Sep 2020
# MODIFIED 31 Jan 2021

# PURPOSE estimate parameters using a Bayesian approach with MCMC

# Load usefull libraries
library(SAFR)
source("UsefulFunctions.R")

# Load data available for analysis
source("LoadTheData.R")

#########################################################

# Model 1
# same Maximum likelihood fit as done in FitModels.R
lower.bound <- c(5e-3,1e-2, 1e-2);upper.bound <- c(15,2,1)
result1 <- optim(par = c(1.0, 0.2, 0.1), fn = ll.model1, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf, method = c("L-BFGS-B"),
       lower = lower.bound, upper = upper.bound, hessian = TRUE)
print(result1)

# Bayesian fit
library(BayesianTools)
new.ll.model1 = function(par) -ll.model1(par, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf)
setUp1 <- createBayesianSetup(new.ll.model1, lower = lower.bound, upper = upper.bound)
settings = list(iterations = 25000,  message = FALSE)
out1 <- runMCMC(bayesianSetup = setUp1, sampler = "Metropolis", settings = settings)
tracePlot(out1, start = 5000)

# Model 2
lower.bound <- c(5e-2,1e-2, 1e-2, 1e-4);upper.bound <- c(15,2,1,1)

csf <- 1e-3 # catchability scaling factor

# Maximum likelihood fit done by FitModels.R
result2 <- optim(par = c(1.0, 0.2, 0.1, 0.1), fn = ll.model2, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf, method = c("L-BFGS-B"),
       lower = lower.bound, upper = upper.bound, hessian = TRUE)

#print(result2)
#errors2 <- sqrt(diag(solve(result2$hessian)))
#print(errors2)
#save(result2, file = "Results/Models/model2.R")


# express the likelihood function for the Bayesian estimation
new.ll.model2 = function(par) -ll.model2(par, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf)

setUp2 <- createBayesianSetup(new.ll.model2, lower = lower.bound, upper = upper.bound)
settings = list(iterations = 25000,  message = FALSE)
out2 <- runMCMC(bayesianSetup = setUp2, sampler = "Metropolis", settings = settings)

png("Results/Graphics/Bayesian_Trace_model2.png", height = 1000, width = 1000)
tracePlot(out2, start = 1)
dev.off()

save(out2, file = "Results/Models/Bayesian_model2.RData")

# compare errors with those estimated using likelihood fit
BurnIn = seq(1, 11e3)
load(file = "Results/Models/model2.R")
errors2 <- sqrt(diag(solve(result2$hessian)))

rbind(result2$par - 2* errors2, result2$par, result2$par + 2* errors2)
apply(out2$chain[-BurnIn, 1:4], 2, quantile, c(0.025, 0.5, 0.975))

# Are the posterior distribution of the parameters Gaussian?
png("Results/Graphics/Bayesian_ParametersPosteriorDistributions_model2.png")
par(mfrow = c(2,2));

for(i in 1:4) {
      tmp = hist(out2$chain[-BurnIn,i], freq = FALSE, main = paste("par", i), xlab = "", las = 1);
      points(tmp$mids, dnorm(tmp$mids, mean = mean(out2$chain[-BurnIn,i]),
      sd = sd(out2$chain[-BurnIn,i])),  pch = 3, col = "red", type = "b")}
dev.off()

# Plot correlation between variables
par(mfrow = c(1,1))
pairs(out2$chain[-BurnIn, 1:4])

# Model 3 in which we fixed M to 0.7 1/year and estimated only q and s

lower.bound <- c(1e-2,0.01);upper.bound <- c(15,1)

csf <- 1e-3 # catchability scaling factor

result3 <- optim(par = c(2, 0.1), fn = ll.model3, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf, method = c("L-BFGS-B"),
        lower = lower.bound, upper = upper.bound, hessian = TRUE)
print("result model 3")
print(result3)
errors3 <- sqrt(diag(solve(result3$hessian)))
print(errors3)

## Model 4 -- this is the model that improves the likelihood substantially and bring M estimate closer to 0.5
lower.bound <- c(5e-3,1e-2, 1e-2, 1e-2);upper.bound <- c(15,2,1,1)
result2.trial <- optim(par = c(1.0, 0.2, 0.1, 0.1), fn = ll.model2.trial, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf, method = c("L-BFGS-B"),
       lower = lower.bound, upper = upper.bound, hessian = TRUE)
print(result2.trial)

lower.bound <- c(5e-3,1e-2, 1e-2, 1e-2, 1e-2);upper.bound <- c(15,2,1,1,1)
result2.trial2 <- optim(par = c(1.0, 0.2, 0.1, 0.1, 0.8), fn = ll.model2.trial2, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf, method = c("L-BFGS-B"),
       lower = lower.bound, upper = upper.bound, hessian = TRUE)
print(result2.trial2)

# In this version of model 4, we are trying to estimate the maximum value of selectivity
new.ll.model2.trial2 = function(par) -ll.model2.trial2(par, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf)

lower.bound <- c(5e-3,0.4, 1e-2, 1e-2, 1e-2);upper.bound <- c(15,0.6,1,1,1)
setUp2.2 <- createBayesianSetup(new.ll.model2.trial2, lower = lower.bound, upper = upper.bound)
settings = list(iterations = 25000,  message = FALSE)
out2.2 <- runMCMC(bayesianSetup = setUp2.2, sampler = "Metropolis", settings = settings)
tracePlot(out2.2, start = 1)

## Fit another model with MCMC

# Model 2.2
lower.bound <- c(0.1,0.4, 1e-2, 1e-2, 0.1, 0.1);upper.bound <- c(10, 1, 0.2, 0.2, 1, 1)

csf <- 1e-3 # catchability scaling factor

new.ll.model2.2 = function(par) -ll.model2.2(par, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf)

library(BayesianTools)
setUp2.2 <- createBayesianSetup(new.ll.model2.2, lower = lower.bound, upper = upper.bound)
settings = list(iterations = 25000,  message = FALSE)
out2.2 <- runMCMC(bayesianSetup = setUp2.2, sampler = "Metropolis", settings = settings)
tracePlot(out2.2, start = 1)

# Model 2.3
lower.bound <- c(6,0.3, 1e-2, 1e-2, 0.1, 0.1, 0.4, 0.4);upper.bound <- c(10, 0.7, 0.2, 0.2, 0.5, 0.5, 1, 1)

csf <- 1e-3 # catchability scaling factor

new.ll.model2.3 = function(par) -ll.model2.3(par, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf)

library(BayesianTools)
setUp2.3 <- createBayesianSetup(new.ll.model2.3, lower = lower.bound, upper = upper.bound)
settings = list(iterations = 25000,  message = FALSE)
out2.3 <- runMCMC(bayesianSetup = setUp2.3, sampler = "Metropolis", settings = settings)

# Model 2 with fishing power
lower.bound <- c(0.1,0.4, 1e-2, 1e-3, 0.1, 0.2, 0.2, 0.5, 0.5) ;upper.bound <- c(10, 2, 0.2, 0.2, 10, 0.8, 0.8, 1, 1)

csf <- 1e-3 # catchability scaling factor

new.ll.model2.fp = function(par) -ll.model2.fp(par, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf)

library(BayesianTools)
setUp2.fp <- createBayesianSetup(new.ll.model2.fp, lower = lower.bound, upper = upper.bound)
settings = list(iterations = 25000,  message = FALSE)
out2.fp <- runMCMC(bayesianSetup = setUp2.fp, sampler = "Metropolis", settings = settings)

## model2 with 2q

lower.bound <- c(5e-2,5e-2, 1e-2, 1e-2, 1e-4);upper.bound <- c(15, 15,2,1,1)

csf <- 1e-3 # catchability scaling factor

result2.2q <- optim(par = c(1.0, 1.0, 0.5, 0.1, 0.1), fn = ll.model2.2q, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf, method = c("L-BFGS-B"),
       lower = lower.bound, upper = upper.bound, hessian = TRUE)

print(result2.2q)
errors2.2q <- sqrt(diag(solve(result2.2q$hessian)))
