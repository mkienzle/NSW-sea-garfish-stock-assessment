# Stock assessment of sea garfish in New South Wales (Australia)

## Introduction

This repository provides data, methods, scripts and results used to estimates the status of the sea garfish fishery in New South Wales (Australia).

## Data
The data consists of measurements of [age from a sample of commercial catches](Data/GarfishAgeData.csv), [weights from individual fish in specific intervals of age](Data/GarfishWeightAtAge.csv), [total catch](Data/GarfishCatchData.csv) and [effort](Data/GarfishEffortData.csv).

## Methods

Several models describing how mortality rates varied by age-group through time (depending on fishing effort, catchability and age-specific gear selectivity) were developed. All models presented assumed a constant rate of mortality due to natural causes that was estimated. These mortality models have been expressed using hazard functions and converted into probability of dying from fishing using methods developed in the field of statistics called survival analysis (https://link.springer.com/article/10.1007%2Fs13253-015-0237-y). The age-specific probabilities of dying from fishing through time were combined with age data from commercial catches into a likelihood function. The range of hypotheses about the effect of fishing expressed in the mortality models were compared with Akaike Information Criteria (AIC). The model best supported by the data was used to describe trends in the sea garfish stock relevant to its management.

## Mortality models for sea garfish

So far, three mortality models have been estimated from the data. All models assume constant natural mortality; age group 1-2 years old and older fully selected by the gear.

- Model 1 estimates [selectivity of age-group 0-1 year old](Script/Results/Models/Mod1-GearSelectivity.csv) to have stayed the same throughout the time series. 
- Model 2 estimates [selectivity](Script/Results/Models/Mod2-GearSelectivity.csv) of age-group 0-1 year old to have change in 2010/11. 
- Model 3 estimates selectivity in 1 block like model 1 and has natural mortality fixed at 0.7 per year. 

## Results

Model 2 is most supported by the data according to [AIC](Script/Results/Data/ModelComparisonTable.csv).

### Trends in populations quantities

#### Mortality rates
![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Mod2-MortalityEstimates.png)

#### Biomass estimates
![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/EstimateOfBiomass.png)

#### Recruitment estimates
![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/EstimateOfRecruitment.png)

