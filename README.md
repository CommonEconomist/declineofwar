Replication material: *"The decline of war since 1950: New evidence"*     
URL: https://link.springer.com/content/pdf/10.1007%2F978-3-030-31589-4_11.pdf

Data and code to replicate results as reported in the paper. 
Data processing and analysis were carried out in R.
For issues replicating the results contact me via email: vanweezel (at) pm.me.

#### Description
`code` contains all the code used for preparing the data and producing the analysis and figures in the chapter. 
Sub-folder `data-processing` contains the code used for processing the data in preparation of the analysis:
1. `dataCOW.R`: cleans the Correlates of War data; rescaling war-related fatalities for population;
2. `dataEWD.R`: cleans the Expanded War Data; rescaling war-related fatalities for population;
3. `interpolationPopulation.R`: Annual interpolation of the population data.

The figures in the chapter (11.1,...,11.5) can be replicated using the corresponding R code. 

`data` contains the processed data used for the analysis.
* `cow.Rda`
* `gleditsch.Rda`
* `population.Rda`  

The original data files of the the Expanded War Data are also included: 

* `exp_iwpart.asc`
* `exp_cwpart.asc`


#### BibTeX
```
@incollection{spagat2020decline,
  title={The decline of war since 1950: New evidence},
  author={Spagat, Michael and van Weezel, Stijn},
  booktitle={Lewis Fry Richardson: His Intellectual Legacy and Influence in the Social Sciences},
  pages={129--142},
  year={2020},
  publisher={Springer}
}
```
