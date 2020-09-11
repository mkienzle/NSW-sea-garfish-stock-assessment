# A Bayesian Approach to assess NSW sea garfish

## Method

The parameter of the best model, model 2, are estimated using Monte Carlo Markov Chain (MCMC) using the R package BayesianTools.

## Results

The traces of the MCMC show that the MCMC converged very quickly

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Bayesian_Trace_model2.png)

The output of the MCMC looks like this:


                1         2          3          4        LP        LL       LPr
...
[24995,] 1.887681 0.6138710 0.09350496 0.03949688 -5105.513 -5102.130 -3.382696
[24996,] 1.887681 0.6138710 0.09350496 0.03949688 -5105.513 -5102.130 -3.382696
[24997,] 1.756774 0.6628479 0.08916212 0.03342936 -5104.266 -5100.884 -3.382696
[24998,] 1.756774 0.6628479 0.08916212 0.03342936 -5104.266 -5100.884 -3.382696
[24999,] 1.767096 0.6709789 0.08355531 0.03477346 -5106.581 -5103.198 -3.382696
[25000,] 1.946513 0.5850070 0.09001404 0.03847048 -5104.875 -5101.492 -3.382696


The posterior distributions of the parameters are unimodal and symetric. They were compared to Guaussian distributions with the same mean and standard distributions: the empirical and theoretical distributions are in good agreement.

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Bayesian_ParametersPosteriorDistributions_model2.png)

Those samples from the posterior distribution were used to calculate the distribution of the stock biomass and spawning stock biomass. Those data look like

      par1      par2       par3       par4   log.lik rec1 rec2 rec3     rec4
1 1.582301 0.6822409 0.08536556 0.03436937 -5101.415    0    0    0 51876.79
2 1.582301 0.6822409 0.08536556 0.03436937 -5101.415    0    0    0 51876.79
3 1.582301 0.6822409 0.08536556 0.03436937 -5101.415    0    0    0 51876.79
4 1.723482 0.6332424 0.08708028 0.03938038 -5101.302    0    0    0 49372.36
5 1.723482 0.6332424 0.08708028 0.03938038 -5101.302    0    0    0 49372.36
6 1.723482 0.6332424 0.08708028 0.03938038 -5101.302    0    0    0 49372.36
      rec5    rec6    rec7    rec8    rec9   rec10   rec11   rec12   rec13
1 942969.5 2151690 1606584 1519344 2575502 5068420 3652790 3469817 2724337
2 942969.5 2151690 1606584 1519344 2575502 5068420 3652790 3469817 2724337
3 942969.5 2151690 1606584 1519344 2575502 5068420 3652790 3469817 2724337
4 897497.7 1958160 1454550 1364195 2294326 4446068 3170434 2978055 2334480
5 897497.7 1958160 1454550 1364195 2294326 4446068 3170434 2978055 2334480
6 897497.7 1958160 1454550 1364195 2294326 4446068 3170434 2978055 2334480
    rec14   rec15   rec16   rec17   rec18   rec19   rec20 Biomass1 Biomass2
1 3293877 4466441 3406995 1826319 3029519 3765319 7575271 125.9936 86.17279
2 3293877 4466441 3406995 1826319 3029519 3765319 7575271 125.9936 86.17279
3 3293877 4466441 3406995 1826319 3029519 3765319 7575271 125.9936 86.17279
4 2819025 3816542 2895193 1552425 2587540 3240658 5944767 113.9433 78.06261
5 2819025 3816542 2895193 1552425 2587540 3240658 5944767 113.9433 78.06261
6 2819025 3816542 2895193 1552425 2587540 3240658 5944767 113.9433 78.06261
...
 Biomass11 Biomass12 Biomass13 Biomass14 Biomass15     SSB1     SSB2    SSB3
1  216.5568  196.6916  187.9461  264.6694  336.3326 30.33500 28.02512 22.9917
2  216.5568  196.6916  187.9461  264.6694  336.3326 30.33500 28.02512 22.9917
3  216.5568  196.6916  187.9461  264.6694  336.3326 30.33500 28.02512 22.9917
4  189.6608  172.8766  167.0109  224.2023  283.3116 27.85006 25.72940 21.1083
5  189.6608  172.8766  167.0109  224.2023  283.3116 27.85006 25.72940 21.1083
6  189.6608  172.8766  167.0109  224.2023  283.3116 27.85006 25.72940 21.1083

The estimated trend in biomass looks like (same as estimate with maximum likelihood)
![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Bayesian_BiomassTrend.png)

The estimated trend in Spawning Stock Biomass looks like
![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Bayesian_SSBTrend.png)

And the estimate distribution of Spawning Stock Biomass in 2018/19 is much larger than SSB at MSY (62 tonnes): the probability that the stock is over-fished (SSB < SSBmsy) is 0

![alt text](https://github.com/mkienzle/NSW-sea-garfish-stock-assessment/blob/master/Script/Results/Graphics/Bayesian_SSB_distribution_in_2018-19.png")