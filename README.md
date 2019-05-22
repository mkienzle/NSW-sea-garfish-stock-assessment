# Stock assessment of sea garfish in New South Wales (Australia)

## Introduction

This repository provides data, methods, scripts and results used to estimate the status of the sea garfish fishery in New South Wales (Australia). A complete description of this work is available from [Fisheries Research](https://doi.org/10.1016/j.fishres.2017.10.016).

## Data

The data consist of measurements of [age from a sample of commercial catches](Data/GarfishAgeData.csv), [weights from individual fish in specific intervals of age](Data/GarfishWeightAtAge.csv), [total catch](Data/GarfishCatchData.csv) and [effort](Data/GarfishEffortData.csv).

Up to 2016/17, catches in this fishery were relatively stable, around 45 +- 18 tonnes, with 2009/10 showing a larger than usual yield. 2017/18 showed a substantial decline in catch. Fishing effort declined sharply since 2004/05, as a result catch per unit effort increased over time.

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/CatchAndEffortVariations.png)

## Methods

Several models describing how mortality rates varied by age-group through time (depending on fishing effort, catchability and age-specific gear selectivity) were developed. All models assume a constant rate of mortality due to natural causes which was estimated. These mortality models have been expressed using hazard functions and converted into probabilities of dying at age from fishing using methods developed in the field of statistics called [survival analysis](https://link.springer.com/article/10.1007%2Fs13253-015-0237-y). These age-specific probabilities of dying from fishing were combined with age data sampled from commercial catches into a likelihood function. A range of hypotheses regarding gear selectivity and natural mortality expressed into the mortality models were compared with Akaike Information Criteria (AIC). 

## Mortality models for sea garfish

So far, three mortality models have been estimated from the data. All models assume constant natural mortality; full selection by the gear for age group 1-2 years old and older.

- Model 1 estimates [selectivity of age-group 0-1 year old](Script/Results/Models/Mod1-GearSelectivity.csv) to have remained constant throughout the entire time series. 
- Model 2 estimates [selectivity](Script/Results/Models/Mod2-GearSelectivity.csv) of age-group 0-1 year old to have change in 2010/11 as a result of a management decision to increase the minimum legal mesh size. 
- Model 3 estimates selectivity in 1 block like model 1 and has natural mortality fixed at 0.7 per year according to estimates found in the scientific literature.

## Results

Model 2 is most supported by the data according to [AIC](Script/Results/Data/ModelComparisonTable.csv). [This diagnostic plot](Script/Results/Graphics/NbAtAgeOverlayedWithModel.png) shows discrepancies between model 2 and age data. [Profiles](Script/Results/Graphics/Model2-ProfileLikelihood.png) of its negative log-likelihood function are smooth around the minimum for each parameter and allow to visualise the uncertainty associated with each parameter estimate. Results below report a description of the dynamics of this fishery based on this model's parameter estimates.

### Trends in populations quantities

#### Mortality rates

The mortality model most supported by the data shows a decline of fishing mortality rates to below natural mortality from 2009/10 onward. The decrease in age-group 0-1 retention in the gear combined with decreasing fishing effort reduced fishing mortality on the youngest age-group to a negligible level.

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Mod2-MortalityEstimates.png)

#### Biomass estimates

Model 2 estimates sea garfish biomass biomass remained at or above 100 tonnes since 2009/10. This stock's biomass have been slowly trending upward since 2008/09.

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/EstimateOfBiomass.png)

#### Recruitment estimates

Recruitment was estimated to have varied between 1 and 4 millions fish each year. 2008/9 had the largest recruitment estimate, presumably leading to the increase in biomass estimated in 2009/10. 2013/14 was estimated to be the third largest recruitment but did not translate into an increase in biomass in 2014/15. The most recent estimate of recruitment (2017/18) is the second largest and follows two very low recruitments in 2015/16 and 2016/17.

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/EstimateOfRecruitment.png)

