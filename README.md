# Stock assessment of sea garfish in New South Wales (Australia)

## Introduction

This repository provides data, methods and results used to estimate the status of the sea garfish fishery in New South Wales (Australia). This stock assessment was originally developed using a maximum likelihood approach ([Broadhurst et al., 2018](https://doi.org/10.1016/j.fishres.2017.10.016)) and later expanded with a Bayesian approach ([Kienzle et al., 2021](https://doi.org/10.1016/j.fishres.2021.106066)). Nowadays, the Bayesian approach is regarded as providing a more complete picture of the parameter estimates as well as quantities of interest to manage this fishery.

## Data

The [data dashboard](https://mkienzle.github.io/NSW-sea-garfish-stock-assessment/docs/data_dashboard.html) shows the four types of data used to produce this stock assessment. They consist of measurements of [age from a sample of commercial catches](Data/GarfishAgeData.csv), [weights from individual fish in specific intervals of age](Data/GarfishWeightAtAge.csv), [total catch](Data/GarfishCatchData.csv) and [effort](Data/GarfishEffortData.csv).

Age data displayed into the [data dashboard](https://mkienzle.github.io/NSW-sea-garfish-stock-assessment/docs/data_dashboard.html) show only the three youngest age-groups were present in the catch in 2004/05. The fourth age-group, age-group 3, become ever more frequent in the catch over the years. 

Catches in this fishery have been relatively stable, in average 42 +- 18 tonnes. Catches in 2009/10 were reported to be 100 tonnes, an un-usually large figure in the time series of data. Fishing effort declined sharply since 2004/05, and have been stable since 2015/16 at around 150 boat-days. Catch per unit effort (CPUE), right-hand panel, were approx. 50 kg/boat-day at the beginning of the time series when effort was very large. After the sharp decline in effort, CPUE fluctuated around 200 kg/boat-day without showing any trend.

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/CatchAndEffortVariations.png)

## Methods

Several models describing how mortality rates varied by age-group through time (depending on fishing effort, catchability and age-specific gear selectivity) were developed. All models assume a constant rate of mortality due to natural causes which was estimated. These mortality models have been expressed using hazard functions and converted into probabilities of dying at age from fishing using a method developed in the field of statistics called [survival analysis](https://link.springer.com/article/10.1007%2Fs13253-015-0237-y). These age-specific probabilities of dying from fishing were combined with age data sampled from commercial catches into a likelihood function. A range of hypotheses regarding gear selectivity and natural mortality expressed into the mortality models were compared using Akaike Information Criteria (AIC) and the Bayesian Information Criteria (BIC).

The method used to analyse the data is fully described into 2 refereed articles ([Broadhurst et al., 2018](https://doi.org/10.1016/j.fishres.2017.10.016) and [Kienzle et al., 2021](https://doi.org/10.1016/j.fishres.2021.106066)).

### Mortality models for sea garfish

So far, three mortality models have been estimated from the data. All models assume constant natural mortality and full selection by the fishing gear of sea garfish age-group 1 (i.e. fish between 1 and 2 years of age) and older. None of those model include catchability varying through time.

- Model 1 estimates [selectivity of age-group 0-1 year old](Script/Results/Models/Mod1-GearSelectivity.csv) to have remained constant throughout the entire time series. 
- Model 2 estimates [selectivity](Script/Results/Models/Mod2-GearSelectivity.csv) of age-group 0-1 year old to have change in 2010/11 as a result of a management decision to increase the minimum legal mesh size. 
- Model 3 estimates selectivity in 1 block like model 1 and has natural mortality fixed at 0.7 per year according to estimates found in the scientific literature.

<!--- [A Bayesian Approach to assess this stock](A_Bayesian_Approach.md)) --->

### Maximum Sustainable Yield (MSY)

An estimate of MSY was obtained by simulating the exploitation of this stock, using the best fishery model calibrated to the data, 200 years into the future using various constant level of fishing effort. This approach produced the typical dome shaped curve between catch and fishing effort from which we derived MSY and effort at MSY. 

## Results

Model 2 is most supported by the data according to [BIC](Script/Results/Data/Bayesian_ModelComparisonTable.csv). Four Monte Carlo Markov Chains (MCMCs) converged after about 20,000 iterations.

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Bayesian_Trace_model2.png)

The posterior distributions of the parameters of model 2 were compared to Gaussian distributions with the same mean and standard distributions: the empirical and theoretical distributions are in good agreement.

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Bayesian_ParametersPosteriorDistributions_model2.png)

<!--- [This diagnostic plot](Script/Results/Graphics/NbAtAgeOverlayedWithModel.png) shows discrepancies between model 2 and age data. [Profiles](Script/Results/Graphics/Model2-ProfileLikelihood.png) of its negative log-likelihood function are smooth around the minimum for each parameter and allow to visualise parameter estimates uncertainties. The sections below describe the dynamics of this fishery based on this model 2 parameter estimates. --->

### Trends in populations quantities

#### Mortality rates

Fishing mortality rates have declined below natural mortality from 2009/10 onward. The decrease in age-group 0-1 retention, induced by the increased mesh size regulation initiated in 2006 and fully adopted in 2009/10, reduced fishing mortality on the youngest age-group to a negligible level.

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Mod2-MortalityEstimates.png)

#### Biomass estimates

Sea garfish biomass estimates have been trending upward since 2008/09: they remained above 100 tonnes since 2009/10. Biomass increased in the last 3 years and stayed above 200 tonnes in the last 2 years.

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Bayesian_BiomassTrend.png)

#### Recruitment estimates

Recruitment was estimated to have varied approximately between 1 and 5 millions fish each year throughout the time series. 2008/9 had the largest recruitment estimate, presumably leading to the increase in biomass estimated in 2009/10. 2013/14 was estimated to be one of the largest recruitment but did not translate into an increase in biomass in 2014/15. Recent years has had several strong recruitments.

<!--- ![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Bayesian_RecruitmentTrend.png) --->
<a href="url"><img src="https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Bayesian_RecruitmentTrend.png" align="left" height="600" width="600" ></a>



There start to be enough recruitment estimates (14) to begin looking at the relationship between stock and recruitment. We assumed that seagarfish age 1+ are sexually mature. The plot of recruitment estimates against spawning stock biomass (SSB) estimates, fitted with a Ricker stock-recruitment function, suggests that the Ricker model might provide useful information about the level of SSB that produces the largest amount of recruits.

<!--- ![](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/RickerSRROnNaturalScale.png =400x400) --->
<a href="url"><img src="https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/RickerSRROnNaturalScale.png" align="left" height="600" width="600" ></a>

### Maximum Sustainable Yield (MSY)

The simulation study that projected this stock into the future using constant level of effort produced the result shown below. From this graphics, we estimated that this stock can produce, in average, a maximum of 78 tonnes per year when a constant effort of 700 boat-days is applied.

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Model2-MSYcomputations-Plot-Aug132020-07-32-39.png)

The average spawning stock biomass (SSB) at the level of effort, SSB at MSY, is 62 tonnes.

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Model2-MSYcomputations-SSB-Plot-Sep122020-07-46-50.png)

The average stock biomass when fishing mortality is zero is 235 tonnes (according to model 2):

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Model2-MSYcomputations-Biomass-Plot-Sep192020-08-01-34.png)

## Discussion

As of 2021, models seem to be affected by the [drifting M syndrome](https://mkienzle.github.io/NSW-sea-garfish-stock-assessment/docs/The_drifting_M_issue.html).
