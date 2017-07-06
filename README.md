# Stock assessment of sea garfish in New South Wales (Australia)

## Introduction

This repository provides the methods, scripts, data and results that are used to estimates the status of the sea garfish fishery in New South Wales (Australia).

## Data
The data consists of measurements of age from a sample of commercial catches (https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Data/GarfishAgeData.csv), measurements of weights of individual fish at age (https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Data/GarfishWeightAtAge.csv), total catch (https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Data/GarfishCatchData.csv) and effort (https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Data/GarfishEffortData.csv).

## Methods

Mortality rates were estimated by maximimum likelihood applying methods taken from survival analysis (https://link.springer.com/article/10.1007%2Fs13253-015-0237-y). A model describing how natural causes and fishing affects the survival of fish is specified using a hazard function. Various hypotheses about the effect of fishing were investigated by looking at which is most supported by the data using Akaike Information Criteria (AIC). The best model was then used to derive quantities describing trends in the sea garfish stock.

### Trends in populations quantities

#### Mortality rates
![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Mod2-MortalityEstimates.png)

#### Biomass estimates
![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/EstimateOfBiomass.png)

#### Recruitment estimates
![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/EstimateOfRecruitment.png)

