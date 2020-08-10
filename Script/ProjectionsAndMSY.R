# CREATED   25 Jun 2020
# MODIFIED   5 Aug 2020

# PURPOSE stock projections with various level of fishing, to determine MSY


## A function to perform the projections with various levels of fishing effort
Projection = function(fishing.effort = 1e3){

# Load necessary library
library(SAFR)

# We need the parameter estimates of the models
#source("FitModels.R")

# And the stock-recruitment relationship to close the cycle (i.e. obtain a recruitment from a spawning stock biomass) 
load("Results/Models/Linear-RickerSRR.RData")

# Project 200 years into using constant effort
nyears = 200

# set the number of age-groups (quite large compare to the maximum 6 years old - so that we don't loose fishes in the simulation)
n.agegroups = 20

# Set a catch matrix (with nb of year in rows and age-groups in columns)
catch.at.year.x.age = matrix(NA, nrow = 200, ncol = n.agegroups)
catch.at.cohort.x.age = Caaa2Coaa(catch.at.year.x.age) # Convert in catch per cohort at age
biomass.caught.at.cohort.x.age = Caaa2Coaa(catch.at.year.x.age) # And biomass caught by cohort and age

# Define also matrices to hold the abundance, biomass and spawning stock biomass in the population 
pop.abundance.at.cohort.x.age = catch.at.cohort.x.age
pop.biomass.at.cohort.x.age = catch.at.cohort.x.age
pop.SSB.at.cohort.x.age = catch.at.cohort.x.age

# A vector to hold recruitment (1 for each cohort)
Recruitment = rep(NA, nrow(catch.at.cohort.x.age))
Recruitment[1:n.agegroups] = 1e6 # Set recruitment for the first cohorts for which we won't have SSB to calculate it

# Load the weight at age
weight.at.age = unlist(c(read.csv("../Data/GarfishWeightAtAge.csv", row.names = 1)[15,], rep(0.163, n.agegroups - 6)))

# Perform the dynamic of the population
for(i in 1:nyears){

  ## Selectivity
  # Fixed selectivity at estimated value for the most recent year
  selectivity.at.age = c(result2$par[4], rep(1, n.agegroups - 1))

  # Stochastic selectivity
  #selectivity.at.age = c(max(0, rnorm(1, mean = result2$par[4], sd = errors2[4]), rep(1, n.agegroups - 1)))

  ## Catchability
  
  # Use a fixed catchability
  q = result2$par[1] * 1e-3
  # Stochastic
  #q = max(0, rnorm(1, mean = result2$par[1], sd = errors2[2]) * 1e-3)
   
  
  # Fix natural mortality
  M = result2$par[2]
  # Stochastic natural mortality  
  #M <- max(0, rnorm(1, mean = result2$par[2], sd = errors2[2]))

# matrix of fishing mortality
F <- q * fishing.effort * selectivity.at.age

# total mortality
Z <- M + F

# cumulative mortality
cum.Z <- cumsum(Z)

# Calculate the probability of dying from fishing in each age interval
prob1 <- F/Z * (1 - exp(-cum.Z))
prob2 <- F/Z * (1 - exp(-(cum.Z-Z)))
P <- prob1-prob2

# Calculate the number of fish dying
n.dying.from.fishing = Recruitment[i] * P
catch.at.cohort.x.age[i,] = n.dying.from.fishing
#print(n.dying.from.fishing) # CHECKS

# Calculate the number in the population from those caught
n.in.pop = n.dying.from.fishing / F
pop.abundance.at.cohort.x.age[i,] = n.in.pop

# Convert number dying from fishing into biomasses
biomass.dying.from.fishing = n.dying.from.fishing * weight.at.age
biomass.caught.at.cohort.x.age[i,] = biomass.dying.from.fishing

#print(biomass.caught.at.cohort.x.age[i,])

# Convert number at age in the population to biomass
pop.biomass = n.in.pop * weight.at.age
pop.biomass.at.cohort.x.age[i,] = pop.biomass

## Calculate the Spawning Stock Biomass (SSB)
# Define the maturity ogive (sea garfish spawning if older than 1 year old)
mat.ogive = c(0, rep(1, n.agegroups - 1))
SSB.at.age = pop.biomass * mat.ogive 

pop.SSB.at.cohort.x.age[i,] = SSB.at.age

pop.SSB.at.year.x.age = Coaa2Caaa(pop.SSB.at.cohort.x.age)


# When we get sufficient simulated data to start generating recruitment from SSB
if(i >= n.agegroups){
  
  # Note that below, I calculate the SSB only with the first 6 age-groups
  SSB = sum(pop.SSB.at.year.x.age[ i - n.agegroups + 1, 1:6]) * 1e-3 # In tonnes
  #print("The vector of pop.SSB.at.year.x.age is") # CHECKS
  #print(pop.SSB.at.year.x.age[i - n.agegroups + 1,]) # CHECKS
  #print(paste("SSB =", SSB, "in tonnes")) # CHECKS
  
  # Recruitment function
  Recruitment[i+1] = 1e6
  #Recruitment[i+1] = 1e2 * SSB # CHECKS
  #test = SSB * exp(predict(lm1, newdata = data.frame(x = SSB), interval = "prediction")[1, "fit"]) # CHECKS
  #print(paste("Recruitment in iteration", i, "is", test)) # CHECKS
  
  # Stochastic recruitment
  Recruitment[i+1] = SSB * exp( max(0, rnorm(1, predict(lm1, newdata = data.frame(x = SSB), interval = "prediction")[1, "fit"], sd = summary(lm1)$sigma))) 
}
}

return(list(final.catch.kg = sum(Coaa2Caaa(biomass.caught.at.cohort.x.age)[180, 1:6]), final.SSB.kg= sum(Coaa2Caaa(pop.SSB.at.cohort.x.age)[180,1:6]) ))
} # End of projection function

#### Project the stock with varying fishing effort

effort = c(1e-4, seq(50,2e3,50))

res = data.frame(Effort = rep(effort, each = 500), Catch = NA, SSB = NA)

for(j in 1:nrow(res)){
  
  my.res = Projection(fishing.effort = res$Effort[j])
  res[j,"Catch"] = my.res$final.catch.kg
  res[j, "SSB"] = my.res$final.SSB.kg
  
  cat(paste("Of", nrow(res), "iterations, completeted", j, "\r"))
}

save(res, file = paste("Results/Data/Model2-MSYcomputations-", format(Sys.time(), "%b%d%Y-%H-%M-%S"), ".RData", sep=""))

png(file = paste("Results/Graphics/Model2-MSYcomputations-Plot-", format(Sys.time(), "%b%d%Y-%H-%M-%S"), ".png", sep=""))
with(res, boxplot(1e-3 * Catch ~ as.factor(round(Effort,1)), xlab = "Effort (boat-days)", ylab = "Catch (tonnes)", las = 1))
dev.off()
