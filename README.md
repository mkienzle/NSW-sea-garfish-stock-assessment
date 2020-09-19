# Stock assessment of sea garfish in New South Wales (Australia)

## Introduction

This repository provides data, methods, scripts and results used to estimate the status of the sea garfish fishery in New South Wales (Australia). A complete description of this work is available from [Fisheries Research](https://doi.org/10.1016/j.fishres.2017.10.016).

## Data

The data consist of measurements of [age from a sample of commercial catches](Data/GarfishAgeData.csv), [weights from individual fish in specific intervals of age](Data/GarfishWeightAtAge.csv), [total catch](Data/GarfishCatchData.csv) and [effort](Data/GarfishEffortData.csv).

Catches in this fishery have been relatively stable, in average 43 +- 18 tonnes. Catches in 2009/10 were reported to be 100 tonnes, an un-usually large figure in the time series of data. Fishing effort declined sharply since 2004/05, and have been stable since 2015/16 at around 150 boat-days. Catch per unit effort (CPUE), right-hand panel, were approx. 50 kg/boat-day at the beginning of the time series when effort was very large. After the sharp decline in effort, CPUE fluctuated around 200 kg/boat-day without showing any trend.

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/CatchAndEffortVariations.png)

## Methods

Several models describing how mortality rates varied by age-group through time (depending on fishing effort, catchability and age-specific gear selectivity) were developed. All models assume a constant rate of mortality due to natural causes which was estimated. These mortality models have been expressed using hazard functions and converted into probabilities of dying at age from fishing using a method developed in the field of statistics called [survival analysis](https://link.springer.com/article/10.1007%2Fs13253-015-0237-y). These age-specific probabilities of dying from fishing were combined with age data sampled from commercial catches into a likelihood function. A range of hypotheses regarding gear selectivity and natural mortality expressed into the mortality models were compared with Akaike Information Criteria (AIC). 

### Mortality models for sea garfish

So far, three mortality models have been estimated from the data. All models assume constant natural mortality; full selection by the gear for age group 1-2 years old and older.

- Model 1 estimates [selectivity of age-group 0-1 year old](Script/Results/Models/Mod1-GearSelectivity.csv) to have remained constant throughout the entire time series. 
- Model 2 estimates [selectivity](Script/Results/Models/Mod2-GearSelectivity.csv) of age-group 0-1 year old to have change in 2010/11 as a result of a management decision to increase the minimum legal mesh size. 
- Model 3 estimates selectivity in 1 block like model 1 and has natural mortality fixed at 0.7 per year according to estimates found in the scientific literature.

[A Bayesian Approach to assess this stock](A_Bayesian_Approach.md)

### Maximum Sustainable Yield (MSY)

An estimate of MSY was obtained by simulating the exploitation of this stock, using the best fishery model calibrated to the data, 200 years into the future using various constant level of fishing effort. This approach produced the typical dome shaped curve between catch and fishing effort from which we derived MSY and effort at MSY. 

## Results

Model 2 is most supported by the data according to [AIC](Script/Results/Data/ModelComparisonTable.csv). [This diagnostic plot](Script/Results/Graphics/NbAtAgeOverlayedWithModel.png) shows discrepancies between model 2 and age data. [Profiles](Script/Results/Graphics/Model2-ProfileLikelihood.png) of its negative log-likelihood function are smooth around the minimum for each parameter and allow to visualise parameter estimates uncertainties. The sections below describe the dynamics of this fishery based on this model 2 parameter estimates.

### Trends in populations quantities

#### Mortality rates

Fishing mortality rates have declined below natural mortality from 2009/10 onward. The decrease in age-group 0-1 retention, induced by the increased mesh size regulation initiated in 2006 and fully adopted in 2009/10, reduced fishing mortality on the youngest age-group to a negligible level.

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Mod2-MortalityEstimates.png)

#### Biomass estimates

Sea garfish biomass estimates have been trending upward since 2008/09: they remained above 100 tonnes since 2009/10. Biomass increased in the last 3 years and stayed above 200 tonnes in the last 2 years.

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/EstimateOfBiomass.png)

#### Recruitment estimates

Recruitment was estimated to have varied between 1 and 5 millions fish each year until the most recent fishing season (2018/19) for which recruitment has been the largest estimated so far (approx. 7 millions fish). Such large estimate is the result of a combination of a large number of age-group 0-1 observed and the low probability of dying from fishing for that age-group in that year. This large estimate of recruitment relies on the observation of a single age-group of the youngest cohort in the fishery and will undoubtedly be revised by the observations of fish aged 1-2 year old in 2019/20. 2008/9 had the largest recruitment estimate prior to this year, presumably leading to the increase in biomass estimated in 2009/10. 2013/14 was estimated to be the fourth largest recruitment but did not translate into an increase in biomass in 2014/15. The most recent estimate of recruitment (2017/18) is the second largest and follows two very low recruitment in 2015/16 and 2016/17.

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/EstimateOfRecruitment.png)


There start to be enough recruitment estimates (14) to begin looking at the relationship between stock and recruitment. We assumed that seagarfish age 1+ are sexually mature. The plot of recruitment estimates against spawning stock biomass (SSB) estimates, fitted with a Ricker stock-recruitment function, suggests that the Ricker model might provide useful information about the level of SSB that produces the largest amount of recruits.

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/RickerSRROnNaturalScale.png)

### Maximum Sustainable Yield (MSY)

The simulation study that projected this stock into the future using constant level of effort produced the result shown below. From this graphics, we estimated that this stock can produce, in average, a maximum of 78 tonnes per year when a constant effort of 700 boat-days is applied.

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Model2-MSYcomputations-Plot-Aug132020-07-32-39.png)

The average spawning stock biomass (SSB) at the level of effort, SSB at MSY, is 62 tonnes.

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Model2-MSYcomputations-SSB-Plot-Sep122020-07-46-50.png)

The average stock biomass when fishing mortality is zero is 235 tonnes (according to model 2):

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Model2-MSYcomputations-Biomass-Plot-Sep192020-08-01-34.png)