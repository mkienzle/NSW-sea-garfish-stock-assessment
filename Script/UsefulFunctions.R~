# CREATED   6 Sep 2016
# MODIFIED  2 May 2017

# PURPOSE function useful for the analysis

# logistic function
logistic <- function(a,b,x){
1 / (1  + exp( a - b * x));
}

# Formating table function
formating <- function(tab, separator = "--"){

dimnames(tab)[[1]] <- sub("/", separator, dimnames(tab)[[1]])
dimnames(tab)[[2]] <- paste(seq(0, ncol(tab) - 1), separator, seq(1, ncol(tab)), sep = "")
return(tab)
}

# Estimate number of fish in catch
Estimate.NbOfFishInCatch <- function(Catch, AgeSample, Weight.at.age){

prop.at.age.sample <- AgeSample / outer(rowSums(AgeSample), rep(1,ncol(AgeSample)))

Catch / rowSums(prop.at.age.sample * Weight.at.age)
}

# Correcting age sample by number of fish in the catch
weighted.sample2 <- function(nb.at.age1, catch1){
# proportion at age in each sample
prop.at.age.sample1 <- nb.at.age1 / outer(rowSums(nb.at.age1), rep(1,ncol(nb.at.age1)))

# estimated total number in the population
raised.number1 <- outer(catch1, rep(1, ncol(nb.at.age1))) * prop.at.age.sample1

# reduce back to sampling number
nb.at.age.sample <- raised.number1 * sum(nb.at.age1) / sum(raised.number1 )
dimnames(nb.at.age.sample) <- dimnames(nb.at.age1)

return(nb.at.age.sample)
}


# log-likelihood function for a catch-at-age matrix

ll.model1 <- function(par, catch, effort, catchability.scaling.factor){
    #print(par)
    if(length(which(par<0)) > 0){ return(1e6)}
    # Re-arrange input data into cohorts
    catch.by.cohort <- Caaa2Coaa(catch)
    effort.by.cohort <- Caaa2Coaa(effort)

    # Allocate param to readable variable names
    q <- par[1] * catchability.scaling.factor
    M <- par[2]
    selectivity.at.age <- c(par[3], rep(1,5))
    
    # matrix of fishing mortality
    F <- q * effort.by.cohort * outer(rep(1, nrow(effort.by.cohort)), selectivity.at.age)

    # total mortality
    Z <- M + F

    # cumulative mortality
    cum.Z <- my.cumsum(Z)

    # Calculate the probability of observation in each interval
    prob1 <- F/Z * (1 - exp(-cum.Z))
    prob2 <- F/Z * (1 - exp(-(cum.Z-Z)))
    P <- prob1-prob2

    # discard zeroes and NA from sum of logs
    index <- which(!is.na(catch.by.cohort) & P!=0)
    if(length(index)<66){ return(1e6) }
    
    # Negative log-likelihood
    -sum(catch.by.cohort[index] * log( P[index] / total.over.lines(P)[index]))
}

prob.for.ll.model2 <- function(par, effort, catchability.scaling.factor){

    #print(par)
    if(length(which(par<0)) > 0){ return(1e6)}
    # Re-arrange input data into cohorts
    catch.by.cohort <- Caaa2Coaa(catch)
    effort.by.cohort <- Caaa2Coaa(effort)

    # Allocate param to readable variable names
    q <- par[1] * catchability.scaling.factor
    M <- par[2]
    selectivity.at.age <-rbind( outer(rep(1,6), c(par[3], rep(1,5))),
    		                outer(rep(1,5), c(par[4], rep(1,5))))
    
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

ll.model2 <- function(par, catch, effort, catchability.scaling.factor){

    #print(par)
    if(length(which(par<0)) > 0){ return(1e6)}
    # Re-arrange input data into cohorts
    catch.by.cohort <- Caaa2Coaa(catch)

    P <- prob.for.ll.model2(par, effort, catchability.scaling.factor)
    
    # discard zeroes and NA from sum of logs
    index <- which(!is.na(catch.by.cohort) & P!=0)
    #print(length(index))
    if(length(index)<66){ return(1e6) }
    # Negative log-likelihood
    -sum(catch.by.cohort[index] * log( P[index] / total.over.lines(P)[index]))
}

## Here we shift the selectivity block 1 year earlier compared to model2
prob.for.ll.model2.1 <- function(par, effort, catchability.scaling.factor){

    #print(par)
    if(length(which(par<0)) > 0){ return(1e6)}
    # Re-arrange input data into cohorts
    catch.by.cohort <- Caaa2Coaa(catch)
    effort.by.cohort <- Caaa2Coaa(effort)

    # Allocate param to readable variable names
    q <- par[1] * catchability.scaling.factor
    M <- par[2]
    selectivity.at.age <-rbind( outer(rep(1,5), c(par[3], rep(1,5))),
    		                outer(rep(1,6), c(par[4], rep(1,5))))
    
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

ll.model2.1 <- function(par, catch, effort, catchability.scaling.factor){

    #print(par)
    if(length(which(par<0)) > 0){ return(1e6)}
    # Re-arrange input data into cohorts
    catch.by.cohort <- Caaa2Coaa(catch)

    P <- prob.for.ll.model2.1(par, effort, catchability.scaling.factor)
    
    # discard zeroes and NA from sum of logs
    index <- which(!is.na(catch.by.cohort) & P!=0)
    #print(length(index))
    if(length(index)<66){ return(1e6) }
    # Negative log-likelihood
    -sum(catch.by.cohort[index] * log( P[index] / total.over.lines(P)[index]))
}

ll.model3 <- function(par, catch, effort, catchability.scaling.factor){
    #print(par)
    if(length(which(par<0)) > 0){ return(1e6)}
    # Re-arrange input data into cohorts
    catch.by.cohort <- Caaa2Coaa(catch)
    effort.by.cohort <- Caaa2Coaa(effort)

    # Allocate param to readable variable names
    q <- par[1] * catchability.scaling.factor
    M <- 0.7
    selectivity.at.age <-outer(rep(1,11), c(par[2], rep(1,5)))
    
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

    # discard zeroes and NA from sum of logs
    index <- which(!is.na(catch.by.cohort) & P!=0)
    if(length(index)<66){ return(1e6) }
	
    # Negative log-likelihood
    -sum(catch.by.cohort[index] * log( P[index] / total.over.lines(P)[index]))
}

### Model 5: assuming logistic gear selectivity

prob.for.ll.model5 <- function(par, effort, catchability.scaling.factor){

    #print(par)
    if(length(which(par<0)) > 0){ return(1e6)}
    # Re-arrange input data into cohorts
    catch.by.cohort <- Caaa2Coaa(catch)
    effort.by.cohort <- Caaa2Coaa(effort)

    # Allocate param to readable variable names
    q <- par[1] * catchability.scaling.factor
    M <- par[2]
    selectivity.at.age <-rbind( outer(rep(1,6), logistic(par[3], par[4], seq(0,5))),
    		                outer(rep(1,5), logistic(par[5], par[4], seq(0,5))))
    
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

ll.model5 <- function(par, catch, effort, catchability.scaling.factor){

    #print(par)
    if(length(which(par<0)) > 0){ return(1e6)}
    # Re-arrange input data into cohorts
    catch.by.cohort <- Caaa2Coaa(catch)

    P <- prob.for.ll.model5(par, effort, catchability.scaling.factor)
    
    # discard zeroes and NA from sum of logs
    index <- which(!is.na(catch.by.cohort) & P!=0)
#    print(length(index))
    if(length(index)<66){ return(1e6) }
    
    # Negative log-likelihood
    -sum(catch.by.cohort[index] * log( P[index] / total.over.lines(P)[index]))
}

### Model 5.1: assuming a dome-shape gear selectivity based on logistics

prob.for.ll.model5.1 <- function(par, effort, catchability.scaling.factor){

    #print(par)
    if(length(which(par<0)) > 0){ return(1e6)}
    # Re-arrange input data into cohorts
    catch.by.cohort <- Caaa2Coaa(catch)
    effort.by.cohort <- Caaa2Coaa(effort)

    # Allocate param to readable variable names
    q <- par[1] * catchability.scaling.factor
    M <- par[2]

    x <- seq(0,ncol(effort)-1);
    tmp1 <- ifelse(x< par[5], logistic(par[3],par[4], x), logistic(par[3],par[4], par[5] - (x-par[5])))
    tmp1 <- tmp1 / max(tmp1)
    tmp2 <- ifelse(x< par[5], logistic(par[6],par[4], x), logistic(par[6],par[4], par[5] - (x-par[5])))
    tmp2 <- tmp2 / max(tmp2)
    
#    selectivity.at.age <-rbind( outer(rep(1,6), logistic(par[3], par[4], seq(0,5))),
#    		                outer(rep(1,5), logistic(par[6], par[4], seq(0,5))))

    selectivity.at.age <- rbind( outer(rep(1,6), tmp1),
                                 outer(rep(1,5), tmp2))

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

ll.model5.1 <- function(par, catch, effort, catchability.scaling.factor){

    #print(par)
    if(length(which(par<0)) > 0){ return(1e6)}
    # Re-arrange input data into cohorts
    catch.by.cohort <- Caaa2Coaa(catch)

    P <- prob.for.ll.model5.1(par, effort, catchability.scaling.factor)
    
    # discard zeroes and NA from sum of logs
    index <- which(!is.na(catch.by.cohort) & P!=0)
#    print(length(index))
    if(length(index)<66){ return(1e6) }
    
    # Negative log-likelihood
    -sum(catch.by.cohort[index] * log( P[index] / total.over.lines(P)[index]))
}


### Model 5.2: assuming a dome-shape gear selectivity with age-groups 1-2 and 2-3 fixed to 1 and 5-6 fixed to 0

prob.for.ll.model5.2 <- function(par, effort, catchability.scaling.factor){

    #print(par)
    if(length(which(par<0)) > 0){ return(1e6)}
    # Re-arrange input data into cohorts
    catch.by.cohort <- Caaa2Coaa(catch)
    effort.by.cohort <- Caaa2Coaa(effort)

    # Allocate param to readable variable names
    q <- par[1] * catchability.scaling.factor
    M <- par[2]

    selectivity.at.age <-rbind( outer(rep(1,6), c(par[3], 1, 1, par[4], par[5], 0)),
    		                outer(rep(1,5), c(par[6], 1, 1, par[4], par[5], 0)))

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

ll.model5.2 <- function(par, catch, effort, catchability.scaling.factor){

    #print(par)
    if(length(which(par<0)) > 0){ return(1e6)}
    # Re-arrange input data into cohorts
    catch.by.cohort <- Caaa2Coaa(catch)

    P <- prob.for.ll.model5.2(par, effort, catchability.scaling.factor)
    
    # discard zeroes and NA from sum of logs
    index <- which(!is.na(catch.by.cohort) & P!=0)
#    print(length(index))
    if(length(index)<66){ return(1e6) }
    
    # Negative log-likelihood
    -sum(catch.by.cohort[index] * log( P[index] / total.over.lines(P)[index]))
}


### model 6: assuming 2 age-groups with selectivity < 1 and 2 blocks
prob.for.ll.model6 <- function(par, effort, catchability.scaling.factor){

    #print(par)
    if(length(which(par<0)) > 0){ return(1e6)}
    # Re-arrange input data into cohorts
    catch.by.cohort <- Caaa2Coaa(catch)
    effort.by.cohort <- Caaa2Coaa(effort)

    # Allocate param to readable variable names
    q <- par[1] * catchability.scaling.factor
    M <- par[2]
    selectivity.at.age <-rbind( outer(rep(1,6), c(par[3]/100, par[4]/10, rep(1,4))),
    		                outer(rep(1,5), c(par[5]/1000, par[6]/10, rep(1,4))))
    
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

ll.model6 <- function(par, catch, effort, catchability.scaling.factor){

    #print(par)
    if(length(which(par<0)) > 0){ return(1e6)}
    # Re-arrange input data into cohorts
    catch.by.cohort <- Caaa2Coaa(catch)

    P <- prob.for.ll.model6(par, effort, catchability.scaling.factor)
    
    # discard zeroes and NA from sum of logs
    index <- which(!is.na(catch.by.cohort) & P!=0)
    #print(length(index))
    if(length(index)<66){ return(1e6) }
    # Negative log-likelihood
    -sum(catch.by.cohort[index] * log( P[index] / total.over.lines(P)[index]))
}

### model 7: assuming 3 age-groups with selectivity < 1 and 2 blocks
prob.for.ll.model7 <- function(par, effort, catchability.scaling.factor){

    #print(par)
    if(length(which(par<0)) > 0){ return(1e6)}
    # Re-arrange input data into cohorts
    catch.by.cohort <- Caaa2Coaa(catch)
    effort.by.cohort <- Caaa2Coaa(effort)

    # Allocate param to readable variable names
    q <- par[1] * catchability.scaling.factor
    M <- par[2]
    selectivity.at.age <-rbind( outer(rep(1,6), c(par[3], par[4], par[5], rep(1,3))),
    		                outer(rep(1,5), c(par[6], par[7], par[8], rep(1,3))))
    
    # matrix of fishing mortality
    #F <- q * effort.by.cohort * outer(rep(1, nrow(effort.by.cohort)), selectivity.at.age)
    #F <- q * effort.by.cohort * Caaa2Coaa(selectivity.at.age) + 2.5 * 1e-3 * Caaa2Coaa(outer(seq(900, 200, length = 11), rep(1,6))) * Caaa2Coaa(selectivity.at.age)
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

ll.model7 <- function(par, catch, effort, catchability.scaling.factor){

    #print(par)
    if(length(which(par<0)) > 0){ return(1e6)}
    # Re-arrange input data into cohorts
    catch.by.cohort <- Caaa2Coaa(catch)

    P <- prob.for.ll.model7(par, effort, catchability.scaling.factor)
    
    # discard zeroes and NA from sum of logs
    index <- which(!is.na(catch.by.cohort) & P!=0)
    #print(length(index))
    if(length(index)<66){ return(1e6) }
    # Negative log-likelihood
    -sum(catch.by.cohort[index] * log( P[index] / total.over.lines(P)[index]))
}

### model 8: assuming 3 age-groups with selectivity < 1 and 2 blocks. 2 catchability
prob.for.ll.model8 <- function(par, effort, catchability.scaling.factor){

    #print(par)
    if(length(which(par<0)) > 0){ return(1e6)}
    # Re-arrange input data into cohorts
    catch.by.cohort <- Caaa2Coaa(catch)
    effort.by.cohort <- Caaa2Coaa(effort)

    # Allocate param to readable variable names
    q1 <- par[1] * catchability.scaling.factor
    q2 <- par[2] * catchability.scaling.factor

    M <- par[3]
    selectivity.at.age <-rbind( q1 * outer(rep(1,6), c(par[4] / 100, par[5] / 10, rep(1,4))),
    		                q2 * outer(rep(1,5), c(par[6] / 1000, par[7] / 10, rep(1,4))))
    
    # matrix of fishing mortality
    #F <- q * effort.by.cohort * outer(rep(1, nrow(effort.by.cohort)), selectivity.at.age)
    #F <- q * effort.by.cohort * Caaa2Coaa(selectivity.at.age) + 2.5 * 1e-3 * Caaa2Coaa(outer(seq(900, 200, length = 11), rep(1,6))) * Caaa2Coaa(selectivity.at.age)
    F <- effort.by.cohort * Caaa2Coaa(selectivity.at.age)

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

ll.model8 <- function(par, catch, effort, catchability.scaling.factor){

    #print(par)
    if(length(which(par<0)) > 0){ return(1e6)}
    # Re-arrange input data into cohorts
    catch.by.cohort <- Caaa2Coaa(catch)

    P <- prob.for.ll.model8(par, effort, catchability.scaling.factor)
    
    # discard zeroes and NA from sum of logs
    index <- which(!is.na(catch.by.cohort) & P!=0)
    #print(length(index))
    if(length(index)<66){ return(1e6) }
    # Negative log-likelihood
    -sum(catch.by.cohort[index] * log( P[index] / total.over.lines(P)[index]))
}
