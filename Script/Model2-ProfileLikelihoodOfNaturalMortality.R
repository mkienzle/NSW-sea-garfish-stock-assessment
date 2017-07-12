local.prob.for.ll.model2 <- function(par, fixedM, effort, catchability.scaling.factor){

    #print(par)
    if(length(which(par<0)) > 0){ return(1e6)}
    # Re-arrange input data into cohorts
    catch.by.cohort <- Caaa2Coaa(catch)
    effort.by.cohort <- Caaa2Coaa(effort)

    # Allocate param to readable variable names
    q <- par[1] * catchability.scaling.factor
    M <- fixedM
    selectivity.at.age <-rbind( outer(rep(1,6), c(par[2], rep(1,5))),
    		                outer(rep(1,nrow(effort)-6), c(par[3], rep(1,5))))
    
    # matrix of fishing mortality
    #F <- q * effort.by.cohort * outer(rep(1, nrow(effort.by.cohort)), selectivity.at.age)
    F <- q * effort.by.cohort * Caaa2Coaa(selectivity.at.age)

    # total mortality
    Z <- M + F

    # cumulative mortality
    cum.Z <- my.cumsum(Z)

    # Calculate the probability of observation in each interval
    prob1 <- F/Z * (1 - exp(-cum.Z))
    prob2 <- F/Z * (1 - exp(-(cum.Z-Z)))
    P <- prob1-prob2
return(P)
}

local.ll.model2 <- function(par, fixedM, catch, effort, catchability.scaling.factor){

    #print(par)
    if(length(which(par<0)) > 0){ return(1e6)}
    # Re-arrange input data into cohorts
    catch.by.cohort <- Caaa2Coaa(catch)

    P <- local.prob.for.ll.model2(par, fixedM, effort, catchability.scaling.factor)
    
    # discard zeroes and NA from sum of logs
    index <- which(!is.na(catch.by.cohort) & P!=0)

    # Negative log-likelihood
    -sum(catch.by.cohort[index] * log( P[index] / total.over.lines(P)[index]))
}

# Load usefull libraries
library(SAFR)
#source("UsefulFunctions.R")

# Load data available for analysis
source("LoadTheData.R")

#########################################################
### Fit models
#########################################################

## First model 

# boundaries for parameters
lower.bound <- c("q" = 5e-2, "s1" = 1e-3, "s2" = 1e-3); upper.bound <- c("q" = 15, "s1" = 1, "s2" = 1)

my.res <- data.frame("q" = NA, "M" = NA, "s1" = NA, "s2" = NA)
counter <- 1

csf <- 1e-3 # catchability scaling factor

for( M in seq(0.3,0.8, length = 1e3)){
print(paste("Counter=", counter))

result2 <- optim(par = c(1.0, 0.1, 0.1), fn = local.ll.model2, catch = nb.at.age.wgt, effort = effort, fixedM = M,
	catchability.scaling.factor = csf, method = c("L-BFGS-B"),
       	lower = lower.bound, upper = upper.bound, hessian = TRUE)

my.res[counter, "M"] <- M
my.res[counter, "log.lik"] <- result2$value
my.res[counter, c("q","s1", "s2")] <- result2$par
counter <- counter +1;
#print(my.res)
}

write.csv(my.res, paste("Results/Data/Model2-ProfileLikelihoodOfNaturalMortality-", format(Sys.time(), "%b%d%Y-%H-%M-%S"), ".csv", sep=""))

with(my.res, plot(M, log.lik, type = "l"))
