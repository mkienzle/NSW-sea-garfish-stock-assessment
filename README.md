# Stock assessment of sea garfish in New South Wales (Australia)

## Introduction

This repository provides data, methods, scripts and results used to estimates the status of the sea garfish fishery in New South Wales (Australia).

## Data
The data consists of measurements of [age from a sample of commercial catches](Data/GarfishAgeData.csv), [weights from individual fish in specific intervals of age](Data/GarfishWeightAtAge.csv), [total catch](Data/GarfishCatchData.csv) and [effort](Data/GarfishEffortData.csv).

## Methods

Various models describing how mortality rates varied by age-group through time (depending on fishing effort, catchability and age-specific gear selectivity) were developed. All models presented here assumed constant rates of mortality due to natural causes. These mortality models were expressed in the form of a hazard function and converted into probability of dying from fishing using methods from the field of survival analysis (https://link.springer.com/article/10.1007%2Fs13253-015-0237-y). Combined with data into a likelihood function, various hypotheses about the effect of fishing were investigated by looking at which was most supported by the data using Akaike Information Criteria (AIC). The best model was then used to derive quantities describing trends in the sea garfish stock.

### Trends in populations quantities

#### Mortality rates
![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Mod2-MortalityEstimates.png)

#### Biomass estimates
![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/EstimateOfBiomass.png)

#### Recruitment estimates
![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/EstimateOfRecruitment.png)

