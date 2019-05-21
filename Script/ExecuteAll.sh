#!/bin/bash

# CREATED   4 June 2018
# MODIFIED 19 May  2019

# PURPOSE summarise all analyses performed for NSW sea garfish stock assessment

### Plot the data
Rscript FisheriesStatistics.R

### Estimate mortality rates
Rscript FitModels.R


### Calculate abundance and recruitment (with uncertainties) using the model that best fit the age data
Rscript CalculatePopulationTrendsWithUncertainties.R # The outputs of this scripts ( ProfileLikelihoodOfRecruitmentEstimatesXXX)
                                                     # has to be edited in PlotResults.R 
Rscript DiagnosticPlots.R # requested by reviewers

# plot timeseries of abundance, recruitment, ... with uncertainties
Rscript PlotResults.R


### Create the profile likelihood of all parameters
# Model 1
#Rscript ProfileLikelihoodOfCatchability.R
#Rscript ProfileLikelihoodOfNaturalMortality.R
#Rscript ProfileLikelihoodOfS1.R
#Rscript ProfileLikelihoodOfS2.R
#Rscript ProfileLikelihoodOfS3.R
#Rscript ProfileLikelihoodOfS4.R
#Rscript ProfileLikelihoodOfS5.R
#Rscript ProfileLikelihoodOfS6.R

## Model 2
Rscript Model2-ProfileLikelihoodOfCatchability.R
Rscript Model2-ProfileLikelihoodOfNaturalMortality.R
Rscript Model2-ProfileLikelihoodOfS1.R
Rscript Model2-ProfileLikelihoodOfS2.R

# The output of the 4 scripts above have to be edited in Model2ConfidenceInterval.R to produces the graphs
Rscript Model2ConfidenceInterval.R

# Model 3
#Rscript Model3-ProfileLikelihoodOfCatchability.R
#Rscript Model3-ProfileLikelihoodOfNaturalMortality.R
#Rscript Model3-ProfileLikelihoodOfAlpha.R
#Rscript Model3-ProfileLikelihoodOfBeta.R
#Rscript Model3-ProfileLikelihoodOfGamma.R

