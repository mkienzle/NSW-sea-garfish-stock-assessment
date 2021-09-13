## Background

Over the years, we noticed that estimates of natural mortality (M) increased from 0.52 $\pm$ 0.06 per year ([Broadhurst et al., 2018](https://doi.org/10.1016/j.fishres.2017.10.016)) to 0.64 $\pm$ 0.04 ([Kienzle et al., 2021](https://doi.org/10.1016/j.fishres.2021.106066)). We've been a little concerned about that because we were when we started assessing this stock using hazard functions we were re-assured to find estimates of M consistent with the work of Jones. We think that this phenomena of increasing estimates of M is more likely explained by an increasing of catchability over the years because (a) there is a large amount of reporting of this in the literature, and (b) variation of fishing power and availability are used in other stock assessments.

There has been no data collected in this fishery that documents any variation in fishing power in this fishery. We caution the reader that, hence, the **modelling presented below is highly speculative**. Yet, we think that given the widely documented phenomena that (a) fishing power increases catchability over time and (b) increasing abundance increase catchability, a model that account for this process to happen is useful to give fisheries manager with an overview of what it means to our understand of the dynamics of this stock.

## Method

We modelled time-series of increases of catchability over time using a random walk, where catchability is set to 1 at the first year of the time-series and then increases randomly according to the absolute value of a Gaussian with mean equal to 0 and standard deviation equal to $\sigma$ ($N(0, \sigma)) allowing catchability to increase from year to year (note that no decrease is allowed using this approach). 

**Anchoring the model to $M=0.52 \pm 0.06$**: using a range of $\sigms$ (0, 0.02, 0.04, 0.06, 0.08 and 1) we generated a thousand hypothetical time-series of increase in catchability for each value of $\sigma$, fitted the best model to the data, and derived (a) a distribution of estimates of M and (b) a distribution of values of the negative log-likelihood. With the former, we assessed which value of $\sigma$ provided the most overlapping distribution of M with $M=0.52 \pm 0.06$. With the latter, we assessed how frequently a model allowing for increasing catchability fitted the data better. Finally, using a thousand random walks with parameter $\sigma$ represent increasing catchability over time, we evaluated the effect it has on quantities useful for the management of this fishery.

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Distribution_of_M_for_model_with_increasing_catchability_Simulation_For_various_sigmas.png)

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Distribution_of_logLikelihood_for_model_with_increasing_catchability_Simulation_For_various_sigmas.png)

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Effect_on_F_of_RandomWalkCatchability_sigmaI0.07.png)

A comparison between simulations of various magnitude of random walk ($\sigma$) and reference estimates (M=0.052 $\pm$ 0.06 from Broadhurst et al., 2018) suggests that assuming an increase of catchability of $\sigma=0.06$ leads to natural mortality estimates consistent with the reference. 
![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Distribution_of_M_for_model_with_increasing_catchability_Simulation_For_various_sigmas_ComparisonToBroadhurst2018.png)

## Conclusion/discussion

Given that there are little evidence of technological improvement in this fishery over the years, apart from attrition of the less efficient fishers due to highten competitive environment, it might very well be that the alleged increase in catchability is due in large part to the increase abundance of the stock (a density dependent effect). Future work could try to disantangle factors that could explain an increase in catchability between (1) variations of fishing power; (2) variation of abundance; (3) ...
