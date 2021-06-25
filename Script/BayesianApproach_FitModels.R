# CREATED   9 Sep 2020
# MODIFIED 16 Jun 2021

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
new.ll.model1 = function(par, sum = FALSE){ 
  return(if (sum == TRUE) sum(-ll.model1(par, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf)) 
         else -ll.model1(par, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf))
#  -ll.model1(par, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf)
}
setUp1 <- createBayesianSetup(new.ll.model1, lower = lower.bound, upper = upper.bound)
settings = list(iterations = 25000,  message = FALSE, nrChains=4)
out1 <- runMCMC(bayesianSetup = setUp1, sampler = "Metropolis", settings = settings)
tracePlot(out1, start = 1, thin = FALSE)
WAIC(out1)

# Model 2
lower.bound <- c(5e-2,1e-2, 1e-2, 1e-4);upper.bound <- c(15,2,1,1)

csf <- 1e-3 # catchability scaling factor

# Maximum likelihood fit done by FitModels.R
result2 <- optim(par = c(1.0, 0.2, 0.1, 0.1), fn = ll.model2, catch = nb.at.age.wgt, 
                 effort = effort, catchability.scaling.factor = csf, method = c("L-BFGS-B"),
       lower = lower.bound, upper = upper.bound, hessian = TRUE)

#print(result2)
#errors2 <- sqrt(diag(solve(result2$hessian)))
#print(errors2)
#save(result2, file = "Results/Models/model2.R")

# express the likelihood function for the Bayesian estimation
new.ll.model2 = function(par, sum = FALSE){ 
  return(if (sum == TRUE) sum(-ll.model2(par, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf))
         else -ll.model2(par, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf))
}
setUp2 <- createBayesianSetup(new.ll.model2, lower = lower.bound, upper = upper.bound)
settings = list(iterations = 25000,  message = FALSE, nrChains=4)
out2 <- runMCMC(bayesianSetup = setUp2, sampler = "Metropolis", settings = settings)
WAIC(out2)

#png("Results/Graphics/Bayesian_Trace_model2.png")
pdf("Results/Graphics/Bayesian_Trace_model2.pdf", width = 7, height = 10)
tracePlot(out2, start = 1, thin = FALSE)
dev.off()

save(out2, file = "Results/Models/Bayesian_model2.RData")
load(file = "Results/Models/Bayesian_model2.RData")

# compare errors with those estimated using likelihood fit
BurnIn = seq(1, 20e3)
load(file = "Results/Models/model2.R")
errors2 <- sqrt(diag(solve(result2$hessian)))

rbind(result2$par - 2* errors2, result2$par, result2$par + 2* errors2)
apply(rbind(out2[[1]]$chain[-BurnIn, 1:4],
            out2[[2]]$chain[-BurnIn, 1:4],
            out2[[3]]$chain[-BurnIn, 1:4],
            out2[[4]]$chain[-BurnIn, 1:4]),
            2, quantile, c(0.025, 0.5, 0.975))

# Traces without the burn in period
pdf("Results/Graphics/Sup Fig 1 Marco.pdf", width = 7, height = 10)
tracePlot(out2, start = max(BurnIn), thin = FALSE)
dev.off()

# Are the posterior distribution of the parameters Gaussian?
pdf("Results/Graphics/Bayesian_ParametersPosteriorDistributions_model2.pdf")
#png("Results/Graphics/Bayesian_ParametersPosteriorDistributions_model2.png")
par(mfrow = c(2,2), mai = c(0.8, 0.7, 0.8, 0.35));

for(i in 1:4) {
      tmp = hist(rbind(out2[[1]]$chain[-BurnIn, i],
                       out2[[2]]$chain[-BurnIn, i],
                       out2[[3]]$chain[-BurnIn, i],
                       out2[[4]]$chain[-BurnIn, i]), 
                       plot = FALSE);
      plot(tmp, freq = FALSE, main = paste("par", i), xlab = "", las = 1, ylim = c(0, 1.1 * max(tmp$density)),
           col = "lightgrey");
      points(tmp$mids, dnorm(tmp$mids, mean = mean(rbind(out2[[1]]$chain[-BurnIn, i],
                                                         out2[[2]]$chain[-BurnIn, i],
                                                         out2[[3]]$chain[-BurnIn, i],
                                                         out2[[4]]$chain[-BurnIn, i])),
      sd = sd(rbind(out2[[1]]$chain[-BurnIn, i],
                    out2[[2]]$chain[-BurnIn, i],
                    out2[[3]]$chain[-BurnIn, i],
                    out2[[4]]$chain[-BurnIn, i]))),  pch = 3, col = "red", type = "b")}
dev.off()

# Plot correlation between variables
pdf("Results/Graphics/Bayesian_Model2_CorrelationBetweenParameters.pdf")
library(psych)
pairs.panels(rbind(out2[[1]]$chain[-BurnIn, 1:4],
                   out2[[2]]$chain[-BurnIn, 1:4],
                   out2[[3]]$chain[-BurnIn, 1:4],
                   out2[[4]]$chain[-BurnIn, 1:4]))
dev.off()

# Model 3 in which we fixed M to 0.7 1/year and estimated only q and s
lower.bound <- c(1e-2,0.01);upper.bound <- c(15,1)

csf <- 1e-3 # catchability scaling factor

result3 <- optim(par = c(2, 0.1), fn = ll.model3, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf, method = c("L-BFGS-B"),
        lower = lower.bound, upper = upper.bound, hessian = TRUE)
print("result model 3")
print(result3)
errors3 <- sqrt(diag(solve(result3$hessian)))
print(errors3)

# express the likelihood function for the Bayesian estimation
new.ll.model3 = function(par, sum = FALSE) {
  return(if (sum == TRUE) sum(-ll.model3(par, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf))
         else -ll.model3(par, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf))
}
setUp3 <- createBayesianSetup(new.ll.model3, lower = lower.bound, upper = upper.bound)
settings = list(iterations = 25000,  message = FALSE, nrChains=4)
out3 <- runMCMC(bayesianSetup = setUp3, sampler = "Metropolis", settings = settings)

tracePlot(out3, start = 1, thin = FALSE)

WAIC(out3)
## ## Model 4 -- this is the model that improves the likelihood substantially and bring M estimate closer to 0.5
## lower.bound <- c(5e-3,1e-2, 1e-2, 1e-2);upper.bound <- c(15,2,1,1)
## result2.trial <- optim(par = c(1.0, 0.2, 0.1, 0.1), fn = ll.model2.trial, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf, method = c("L-BFGS-B"),
##        lower = lower.bound, upper = upper.bound, hessian = TRUE)
## print(result2.trial)

## lower.bound <- c(5e-3,1e-2, 1e-2, 1e-2, 1e-2);upper.bound <- c(15,2,1,1,1)
## result2.trial2 <- optim(par = c(1.0, 0.2, 0.1, 0.1, 0.8), fn = ll.model2.trial2, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf, method = c("L-BFGS-B"),
##        lower = lower.bound, upper = upper.bound, hessian = TRUE)
## print(result2.trial2)

## # In this version of model 4, we are trying to estimate the maximum value of selectivity
## new.ll.model2.trial2 = function(par) -ll.model2.trial2(par, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf)

## lower.bound <- c(5e-3,0.4, 1e-2, 1e-2, 1e-2);upper.bound <- c(15,0.6,1,1,1)
## setUp2.2 <- createBayesianSetup(new.ll.model2.trial2, lower = lower.bound, upper = upper.bound)
## settings = list(iterations = 25000,  message = FALSE)
## out2.2 <- runMCMC(bayesianSetup = setUp2.2, sampler = "Metropolis", settings = settings)
## tracePlot(out2.2, start = 1)

#######################################################################################################################################################################################################
## Compare results in table
#######################################################################################################################################################################################################


res.comparison <- data.frame(matrix(NA, nrow = 3, ncol = 9))
dimnames(res.comparison)[[2]] <- c("Model", "p", "n", "-log(L)", "BIC", "Catchability", "Natural mortality", "s1", "s2")

# To calculate BIC
# we evaluated the log-likelihood function at the mean value of each parameters
# we set the number of data (N) to the number of otoliths read
N = sum(nb.at.age.tmp)

res.comparison[1,] <- c("1",
		        3,
			N,
			round(ll.model1(apply(rbind(out1[[1]]$chain[-BurnIn, 1:3], 
			                            out1[[2]]$chain[-BurnIn, 1:3], 
			                            out1[[3]]$chain[-BurnIn, 1:3],
			                            out1[[4]]$chain[-BurnIn, 1:3]), 2, mean), catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf),1),
                        round(2 * ll.model1(apply(rbind(out1[[1]]$chain[-BurnIn, 1:3], 
                                                        out1[[2]]$chain[-BurnIn, 1:3], 
                                                        out1[[3]]$chain[-BurnIn, 1:3],
                                                        out1[[4]]$chain[-BurnIn, 1:3]), 2, mean), 
                                            catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf) + 3 * log(N),1),
			paste("(", paste(round(apply(rbind(out1[[1]]$chain[-BurnIn, 1:3], 
			                                   out1[[2]]$chain[-BurnIn, 1:3], 
			                                   out1[[3]]$chain[-BurnIn, 1:3],
			                                   out1[[4]]$chain[-BurnIn, 1:3]), 2, mean)[1],2), 
			                 round(apply(rbind(out1[[1]]$chain[-BurnIn, 1:3], 
			                                   out1[[2]]$chain[-BurnIn, 1:3], 
			                                   out1[[3]]$chain[-BurnIn, 1:3],
			                                   out1[[4]]$chain[-BurnIn, 1:3]), 2, sd)[1],2), sep = " +- " ), ") x 1e-3"),
		        paste(round(apply(rbind(out1[[1]]$chain[-BurnIn, 1:3], 
		                                out1[[2]]$chain[-BurnIn, 1:3], 
		                                out1[[3]]$chain[-BurnIn, 1:3],
		                                out1[[4]]$chain[-BurnIn, 1:3]), 2, mean)[2],2), 
		              round(apply(rbind(out1[[1]]$chain[-BurnIn, 1:3], 
		                                out1[[2]]$chain[-BurnIn, 1:3], 
		                                out1[[3]]$chain[-BurnIn, 1:3],
		                                out1[[4]]$chain[-BurnIn, 1:3]), 2, sd)[2],2), sep = " +- " ),
		        paste(round(apply(rbind(out1[[1]]$chain[-BurnIn, 1:3], 
		                                out1[[2]]$chain[-BurnIn, 1:3], 
		                                out1[[3]]$chain[-BurnIn, 1:3],
		                                out1[[4]]$chain[-BurnIn, 1:3]), 2, mean)[3],3), 
		              round(apply(rbind(out1[[1]]$chain[-BurnIn, 1:3], 
		                                out1[[2]]$chain[-BurnIn, 1:3], 
		                                out1[[3]]$chain[-BurnIn, 1:3],
		                                out1[[4]]$chain[-BurnIn, 1:3]), 2, sd)[3],3), sep = " +- " ),
			NA)

res.comparison[2,] <- c("2",
			4,
			N,
		        round(ll.model2(apply(rbind(out2[[1]]$chain[-BurnIn, 1:4], 
		                                    out2[[2]]$chain[-BurnIn, 1:4], 
		                                    out2[[3]]$chain[-BurnIn, 1:4],
		                                    out2[[4]]$chain[-BurnIn, 1:4]), 2, mean), catch = nb.at.age.wgt, 
		                        effort = effort, catchability.scaling.factor = csf), 1),
                        round(2 * ll.model2(apply(rbind(out2[[1]]$chain[-BurnIn, 1:4], 
                                                        out2[[2]]$chain[-BurnIn, 1:4], 
                                                        out2[[3]]$chain[-BurnIn, 1:4],
                                                        out2[[4]]$chain[-BurnIn, 1:4]), 2, mean), 
                                            catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf) + 4 * log(N),1),
			paste("(", paste(round(apply(rbind(out2[[1]]$chain[-BurnIn, 1:3], 
			                                   out2[[2]]$chain[-BurnIn, 1:3], 
			                                   out2[[3]]$chain[-BurnIn, 1:3],
			                                   out2[[4]]$chain[-BurnIn, 1:3]), 2, mean)[1],2), 
			                 round(apply(rbind(out2[[1]]$chain[-BurnIn, 1:3], 
			                                   out2[[2]]$chain[-BurnIn, 1:3], 
			                                   out2[[3]]$chain[-BurnIn, 1:3],
			                                   out2[[4]]$chain[-BurnIn, 1:3]), 2, sd)[1],2), sep = " +- " ), ") x 1e-3"),
		        paste(round(apply(rbind(out2[[1]]$chain[-BurnIn, 1:4], 
		                                out2[[2]]$chain[-BurnIn, 1:4], 
		                                out2[[3]]$chain[-BurnIn, 1:4],
		                                out2[[4]]$chain[-BurnIn, 1:4]), 2, mean)[2],2), 
		              round(apply(rbind(out2[[1]]$chain[-BurnIn, 1:4], 
		                                out2[[2]]$chain[-BurnIn, 1:4], 
		                                out2[[3]]$chain[-BurnIn, 1:4],
		                                out2[[4]]$chain[-BurnIn, 1:4]), 2, sd)[2],2), sep = " +- " ),
		        paste(round(apply(rbind(out2[[1]]$chain[-BurnIn, 1:4], 
		                                out2[[2]]$chain[-BurnIn, 1:4], 
		                                out2[[3]]$chain[-BurnIn, 1:4],
		                                out2[[4]]$chain[-BurnIn, 1:4]), 2, mean)[3],3), 
		              round(apply(rbind(out2[[1]]$chain[-BurnIn, 1:4], 
		                                out2[[2]]$chain[-BurnIn, 1:4], 
		                                out2[[3]]$chain[-BurnIn, 1:4],
		                                out2[[4]]$chain[-BurnIn, 1:4]), 2, sd)[3],3), sep = " +- " ),
			paste(round(apply(rbind(out2[[1]]$chain[-BurnIn, 1:4], 
			                        out2[[2]]$chain[-BurnIn, 1:4], 
			                        out2[[3]]$chain[-BurnIn, 1:4],
			                        out2[[4]]$chain[-BurnIn, 1:4]), 2, mean)[4],3), 
			      round(apply(rbind(out2[[1]]$chain[-BurnIn, 1:4], 
			                        out2[[2]]$chain[-BurnIn, 1:4], 
			                        out2[[3]]$chain[-BurnIn, 1:4],
			                        out2[[4]]$chain[-BurnIn, 1:4]), 2, sd)[4],3), sep = " +- " ))

res.comparison[3,] <- c("3",
			2,
			N,
		        round(ll.model3(apply(rbind(out3[[1]]$chain[-BurnIn, 1:2], 
		                                    out3[[2]]$chain[-BurnIn, 1:2], 
		                                    out3[[3]]$chain[-BurnIn, 1:2],
		                                    out3[[4]]$chain[-BurnIn, 1:2]), 2, mean), 
		                        catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf),1),
                        round(2 * ll.model3(apply(rbind(out3[[1]]$chain[-BurnIn, 1:2], 
                                                        out3[[2]]$chain[-BurnIn, 1:2], 
                                                        out3[[3]]$chain[-BurnIn, 1:2],
                                                        out3[[4]]$chain[-BurnIn, 1:2]), 2, mean), 
                                            catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf) + 2 * log(N),1),
			paste("(", paste(round(apply(rbind(out3[[1]]$chain[-BurnIn, 1:2], 
			                                   out3[[2]]$chain[-BurnIn, 1:2], 
			                                   out3[[3]]$chain[-BurnIn, 1:2],
			                                   out3[[4]]$chain[-BurnIn, 1:2]), 2, mean)[1],2), 
			                 round(apply(rbind(out3[[1]]$chain[-BurnIn, 1:2], 
			                                   out3[[2]]$chain[-BurnIn, 1:2], 
			                                   out3[[3]]$chain[-BurnIn, 1:2],
			                                   out3[[4]]$chain[-BurnIn, 1:2]), 2, sd)[1],2), sep = " +- " ), ") x 1e-3"),
		        paste(0.7, "NA", sep = " +- " ),
			paste(round(apply(rbind(out3[[1]]$chain[-BurnIn, 1:2], 
			                        out3[[2]]$chain[-BurnIn, 1:2], 
			                        out3[[3]]$chain[-BurnIn, 1:2],
			                        out3[[4]]$chain[-BurnIn, 1:2]), 2, mean)[2],3), 
			      round(apply(rbind(out3[[1]]$chain[-BurnIn, 1:2], 
			                        out3[[2]]$chain[-BurnIn, 1:2], 
			                        out3[[3]]$chain[-BurnIn, 1:2],
			                        out3[[4]]$chain[-BurnIn, 1:2]), 2, sd)[2],3), sep = " +- " ),
		        NA)
			

write.csv(res.comparison[order(res.comparison$BIC),], file = "Results/Data/Bayesian_ModelComparisonTable.csv", row.names = FALSE)





