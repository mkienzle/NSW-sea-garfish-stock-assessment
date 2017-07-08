# CREATED  18 Dec 2016
# MODIFIED 21 Dec 2016

# PURPOSE once models are fitted to the data, certain quantities can be calculated using parameters estimates
#         Using the best model

# REFERENCES Dupont, 1983 "A stochastic catch-effort method for estimating animal abundance". Biometrics 39, 1021-1033

# Fit models to the data
source("FitModels.R")

## Calculate the probabilities associated with each observation using model 2
prob <- prob.for.ll.model2(result2$par, effort = effort, catchability.scaling.factor = csf)

## Estimate recruitment for each cohort using the ratio of sum of catch over sum of probability of catching (Dupont, 1983)
est.nb.at.age.in.catch <- outer(estimated.nb.in.catch, rep(1, 6)) * nb.at.age / outer(rowSums(nb.at.age), rep(1, 6))
est.rec <- rowSums(Caaa2Coaa(est.nb.at.age.in.catch), na.rm = T) / rowSums(prob, na.rm = T)

## Calculate fishing mortality at age

s.at.age.model2 <-rbind( outer(rep(1,6), c(result2$par[3], rep(1,5))),
    		                outer(rep(1,nrow(effort)-6), c(result2$par[4], rep(1,5))))

write.csv(file = "Results/Models/Mod2-GearSelectivity.csv", s.at.age.model2)

mod2.fish.mort.est <- result2$par[1] * csf * (effort * s.at.age.model2)
dimnames(mod2.fish.mort.est) <- dimnames(nb.at.age.tmp)

print(file = "Results/Models/Mod2-FishingMortality.tex", xtable(formating(mod2.fish.mort.est), digits = 2, caption = "Estimates of fishing mortality faced by each age-group in every year according to model 2.", label="tab:Mod2-FishingMortality"))


