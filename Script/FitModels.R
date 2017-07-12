# CREATED    1 Sep 2016
# MODIFIED   2 May 2017

# PURPOSE fit several mortality model to NSW sea garfish age data
#         using hazard functions

# Load usefull libraries
library(SAFR)
source("UsefulFunctions.R")

# Load data available for analysis
source("LoadTheData.R")

#########################################################
### Fit models
#########################################################

## First model 

# boundaries for parameters
lower.bound <- c(5e-2,1e-2,1e-3); upper.bound <- c(15,1,1)

csf <- 1e-3 # catchability scaling factor

result <- optim(par = c(0.2, 0.2, 0.05), fn = ll.model1, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf, method = c("L-BFGS-B"),
       lower = lower.bound, upper = upper.bound, hessian = TRUE)

print(result)
errors <- sqrt(diag(solve(result$hessian)))
print(errors)

## Second model 

lower.bound <- c(5e-2,1e-2, 1e-2, 1e-4);upper.bound <- c(15,2,1,1)

csf <- 1e-3 # catchability scaling factor

result2 <- optim(par = c(1.0, 0.2, 0.1, 0.1), fn = ll.model2, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf, method = c("L-BFGS-B"),
       lower = lower.bound, upper = upper.bound, hessian = TRUE)

print(result2)
errors2 <- sqrt(diag(solve(result2$hessian)))
print(errors2)
save(result2, file = "Results/Models/model2.R")

## Slighlty modified second model: the selectivity block divide was shifted 1 year earlier 

lower.bound <- c(5e-2,1e-2, 1e-2, 1e-4);upper.bound <- c(15,2,1,1)

csf <- 1e-3 # catchability scaling factor

result2.1 <- optim(par = c(1.0, 0.2, 0.1, 0.1), fn = ll.model2.1, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf, method = c("L-BFGS-B"),
       lower = lower.bound, upper = upper.bound, hessian = TRUE)

print(result2.1)
errors2.1 <- sqrt(diag(solve(result2.1$hessian)))
print(errors2.1)
save(result2.1, file = "Results/Models/model2_1.R")

## Third model in which we fixed M to 0.7 1/year and estimated only q and s

lower.bound <- c(1e-2,0.01);upper.bound <- c(15,1)

csf <- 1e-3 # catchability scaling factor

result3 <- optim(par = c(2, 0.1), fn = ll.model3, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf, method = c("L-BFGS-B"),
        lower = lower.bound, upper = upper.bound, hessian = TRUE)
print("result model 3")
print(result3)
errors3 <- sqrt(diag(solve(result3$hessian)))
print(errors3)

# ## A fourth model: assume 2% fishing power increase per year

# fp.rate <- 1.02
# fp.mat <- outer(fp.rate^seq(0, nrow(effort)-1), rep(1, ncol(effort)))


# lower.bound <- c(5e-2,1e-2, 1e-2, 1e-4);upper.bound <- c(15,2,1,1)

# csf <- 1e-3 # catchability scaling factor

# result4 <- optim(par = c(1.0, 0.2, 0.1, 0.1), fn = ll.model2, catch = nb.at.age.wgt, effort = fp.mat * effort, catchability.scaling.factor = csf, method = c("L-BFGS-B"),
#        lower = lower.bound, upper = upper.bound, hessian = TRUE)

# print(result4)
# errors4 <- sqrt(diag(solve(result4$hessian)))
# print(errors4)
# save(result4, file = "Results/Models/model4.R")

# ### A fifth model assuming logistic gear selectivity

# lower.bound <- c(5e-2, 0.2, 0, 0, 0); upper.bound <- c(15, 2, 10, 20, 10)

# csf <- 1e-3 # catchability scaling factor

# result5 <- optim(par = c(1.0, 0.5, 1, 8, 0.5), fn = ll.model5, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf, method = c("L-BFGS-B"),
#        lower = lower.bound, upper = upper.bound, hessian = TRUE)

# print(result5)
# errors5 <- sqrt(diag(solve(result5$hessian)))
# print(errors5)
# save(result5, file = "Results/Models/model5.R")

# ### A variation of the fifth model assuming dome-shaped gear selectivity using logistic functions

# lower.bound <- c("q" = 5e-2, "M" = 1e-3, "alpha.logis1" = 0, "beta.logis1" = 0, "gamma.logis" = 1, "alpha.logis2" = 0);
# upper.bound <- c(15, 2, 10, 20, 6, 10)

# csf <- 1e-3 # catchability scaling factor

# result5.1 <- optim(par = c(1.0, 0.5, 1, 8, 1, 0.5), fn = ll.model5.1, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf, method = c("L-BFGS-B"),
#        lower = lower.bound, upper = upper.bound, hessian = TRUE)

# print(result5.1)
# errors5.1 <- sqrt(diag(solve(result5.1$hessian)))
# print(errors5.1)
# save(result5.1, file = "Results/Models/model5_1.R")

# ### A second variation of the fifth model assuming dome-shaped gear selectivity with age-groups 1-2 and 2-3 fixed to 1 and 5-6 fixed to 0

# lower.bound <- c("q" = 5e-2, "M" = 1e-2, "s1" = 0, "s4" = 0, "s5" = 0, "s1.2" = 0);
# upper.bound <- c(15, 2, 1, 1, 1, 1)

# csf <- 1e-3 # catchability scaling factor

# result5.2 <- optim(par = c(1.0, 0.5, 0.5, 0.8, 0.3, 0.1), fn = ll.model5.2, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf, method = c("L-BFGS-B"),
#        lower = lower.bound, upper = upper.bound, hessian = TRUE)

# print(result5.2)
# errors5.2 <- sqrt(diag(solve(result5.2$hessian)))
# print(errors5.2)
# save(result5.2, file = "Results/Models/model5_2.R")

# ### A sixth model
# lower.bound <- c(5e-2, 0.2, 0, 0, 0); upper.bound <- c(50, 2, 10, 20, 10)

# csf <- 1e-3 # catchability scaling factor

# result6 <- optim(par = c(10, 0.7, 3, 4, 3, 4), fn = ll.model6, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf, method = c("L-BFGS-B"),
#        lower = lower.bound, upper = upper.bound, hessian = TRUE)

# print("Model 6")
# print(result6)
# errors6 <- sqrt(diag(solve(result6$hessian)))
# print(errors6)
# save(result6, file = "Results/Models/model6.R")


# ### A seventh model

# lower.bound <- c(1e-2, 0.3, 0, 0, 0.5, 0, 0.1, 0.5); upper.bound <- c(10, 1.5, 0.1, 0.8, 1, 0.1, 0.5, 1)

# csf <- 1e-3 # catchability scaling factor

# result7 <- optim(par = c(1.0, 0.5, 0.0, 0.4, 0.5, 0.03, 0.24, 0.8), fn = ll.model7, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf, method = c("L-BFGS-B"),
#        lower = lower.bound, upper = upper.bound, hessian = TRUE)

# print(result7)
# errors7 <- sqrt(diag(solve(result7$hessian)))
# print(errors7)
# save(result7, file = "Results/Models/model7.R")

# ### A eighth model

# lower.bound <- c(1, 1e-2, 0.4, 0, 0, 0, 1); upper.bound <- c(20, 20, 2.0, 20, 10, 100, 10)

# csf <- 1e-3 # catchability scaling factor

# result8 <- optim(par = c(10, 10, 0.5, 1, 4, 3, 3), fn = ll.model8, catch = nb.at.age.wgt, effort = effort, catchability.scaling.factor = csf, method = c("L-BFGS-B"),
#        lower = lower.bound, upper = upper.bound, hessian = TRUE, control = list(maxit = 1e3))

# print(result8)
# errors8 <- sqrt(diag(solve(result8$hessian)))
# print(errors8)
# save(result8, file = "Results/Models/model8.R")

# Compare results in table

res.comparison <- data.frame(matrix(NA, nrow = 3, ncol = 6))
dimnames(res.comparison)[[2]] <- c("Model", "AIC", "Catchability", "Natural mortality", "s1", "s2")

res.comparison[1,] <- c("1",
                        round(2 * result$value + 2 * length(result$par),1),
			paste(round(result$par[1],2), round(errors[1],2), sep = " +- " ),
		        paste(round(result$par[2],2), round(errors[2],3), sep = " +- " ),
		        paste(round(result$par[3],2), round(errors[3],3), sep = " +- " ),
			NA)
			
res.comparison[2,] <- c("2",
                        round(2 * result2$value + 2 * length(result2$par),1),
			paste(round(result2$par[1],2), round(errors2[1],2), sep = " +- " ),
		        paste(round(result2$par[2],2), round(errors2[2],3), sep = " +- " ),
		        paste(round(result2$par[3],2), round(errors2[3],3), sep = " +- " ),
		        paste(round(result2$par[4],2), round(errors2[4],3), sep = " +- " ))
			
res.comparison[3,] <- c("3",
                        round(2 * result3$value + 2 * length(result3$par),1),
			paste(round(result3$par[1],2), round(errors3[1],2), sep = " +- " ),
		        paste(0.7, "NA", sep = " +- " ),
		        paste(round(result2$par[2],2), round(errors2[2],3), sep = " +- " ),
		        NA)
			

write.csv(res.comparison[order(res.comparison$AIC),], file = "Results/Data/ModelComparisonTable.csv", row.names = FALSE)





