# Stock assessment of sea garfish in New South Wales (Australia)

## Introduction

This repository provides data, methods, scripts and results used to estimates the status of the sea garfish fishery in New South Wales (Australia).

## Data
The data consists of measurements of [age from a sample of commercial catches](Data/GarfishAgeData.csv), [weights from individual fish in specific intervals of age](Data/GarfishWeightAtAge.csv), [total catch](Data/GarfishCatchData.csv) and [effort](Data/GarfishEffortData.csv).

## Methods

Several models describing how mortality rates varied by age-group through time (depending on fishing effort, catchability and age-specific gear selectivity) were developed. All models presented assumed a constant rate of mortality due to natural causes that was estimated. These mortality models have been expressed using hazard functions and converted into probability of dying from fishing using methods developed in field of statistics called survival analysis (https://link.springer.com/article/10.1007%2Fs13253-015-0237-y). The age-specific probabilities of dying from fishing were combined with age data from commercial catches into a likelihood function. The range hypotheses about the effect of fishing expressed in the mortality models were compared with Akaike Information Criteria (AIC). The model best supported by the data was used to derive quantities describing trends in the sea garfish stock.

### Trends in populations quantities

#### Mortality rates
![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Mod2-MortalityEstimates.png)

#### Biomass estimates
![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/EstimateOfBiomass.png)

#### Recruitment estimates
![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/EstimateOfRecruitment.png)

