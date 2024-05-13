*** IDENTIFY CENSUS 1890 IMPORTANT CITY SIZE QUARTILES TO USE IN OBSERVED AS PERCENTAGE REGRESSION AND EXAMINE CITY SIZE EFFECT 

use "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MCs\MC_v3\bilateral_county_data_workingfile.dta" 

* county size 1890 population descriptives for counties including at least 1 census 1890 important city

summarize pop90 if censuscity==1, detail

*              Population 1890 (IPUMS)
*-------------------------------------------------------------
*      Percentiles      Smallest
* 1%        14017           7146
* 5%        29458          14017
*10%        39938          15233       Obs                 132
*25%        50146          19568       Sum of Wgt.         132
*
*50%      78928.5                      Mean             146012
*                        Largest       Std. Dev.      209386.8
*75%       146976         838547
*90%       298997        1046964       Variance       4.38e+10
*95%       451770        1191922       Skewness       4.115553
*99%      1191922        1515301       Kurtosis       22.71743

* create county size quartile classification variable - county size quartile given census 1890 important city = 1 -> 1 lower quartile, 4 highest quartile

egen county_city_quartile=xtile(pop90) if censuscity==1, n(4)

* create county size quartile classification variable 4 levels, all counties - county size quartile given census 1890 important city = 1 -> 1 lower quartile, 4 highest quartile + all counties not including a census 1890 important city = 1 are included in lower quartile

gen county_city_quartile4=county_city_quartile
replace county_city_quartile4=1 if county_city_quartile==.

* create county size quartile classification variable 5 levels, all counties - county size quartile given census 1890 important city = 1 -> 1 lower quartile, 4 highest quartile + all counties not including a census 1890 important city = 1 are included in 5th group = 0

gen county_city_quartile5=county_city_quartile
replace county_city_quartile5=0 if county_city_quartile==.

keep cfips county_city_quartile county_city_quartile4 county_city_quartile5

 save "C:\Users\chiqu\Desktop\HBS_May_2020\PLC\Dependent variable MC experiment\county_city_size_quartile.dta", replace




