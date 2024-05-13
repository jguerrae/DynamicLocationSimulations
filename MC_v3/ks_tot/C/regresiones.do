clear all

//ks_tot

cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\ks_tot\C"

//preprocessing

use "B_copB2.dta"
keep year cfips a copB2_3 survivalB2p90
merge m:1 cfips using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\county_city_size_quartile.dta"
drop _merge

merge m:1 cfips using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\c_activity.dta"
gen activity = 0
replace activity = 1 if _merge == 3
drop _merge
 
//create duummies

foreach x of numlist 0 1 3 4 {
	gen ccq5_`x' = 0
	replace ccq5_`x' = 1 if county_city_quartile5 == `x'
}


foreach x of numlist 1 3 4 {
	gen ccq4_`x' = 0
	replace ccq4_`x' = 1 if county_city_quartile4 == `x'
}


gen Cp90 = 0
replace Cp90  = 1 if copB2_3 > 90

//regressions
reg copB2_3 ccq5_0 ccq5_1 ccq5_3 ccq5_4 i.year 
reg copB2_3 ccq5_0 ccq5_1 ccq5_3 ccq5_4 i.year  if a > 0 
reg copB2_3 ccq5_0 ccq5_1 ccq5_3 ccq5_4 i.year  if activity == 1

logit Cp90  ccq5_0 ccq5_1 ccq5_3 ccq5_4 i.year 
logit Cp90  ccq5_0 ccq5_1 ccq5_3 ccq5_4 i.year  if a > 0 
logit Cp90  ccq5_0 ccq5_1 ccq5_3 ccq5_4 i.year  if activity == 1


reg copB2_3 ccq5_1 ccq4_3 ccq4_4 i.year
reg copB2_3 ccq5_1 ccq4_3 ccq4_4 i.year if a > 0
reg copB2_3 ccq5_1 ccq4_3 ccq4_4 i.year if activity == 1

logit Cp90 ccq5_1 ccq4_3 ccq4_4 i.year
logit Cp90 ccq5_1 ccq4_3 ccq4_4 i.year if a > 0
logit Cp90 ccq5_1 ccq4_3 ccq4_4 i.year if activity == 1


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//mktaccess1890

clear all

cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\mktaccess1890\C"

//preprocessing

use "B_copB2.dta"
keep year cfips a copB2_3 survivalB2p90
merge m:1 cfips using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\county_city_size_quartile.dta"
drop _merge

merge m:1 cfips using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\c_activity.dta"
gen activity = 0
replace activity = 1 if _merge == 3
drop _merge
 
//create duummies

foreach x of numlist 0 1 3 4 {
	gen ccq5_`x' = 0
	replace ccq5_`x' = 1 if county_city_quartile5 == `x'
}


foreach x of numlist 1 3 4 {
	gen ccq4_`x' = 0
	replace ccq4_`x' = 1 if county_city_quartile4 == `x'
}


gen Cp90 = 0
replace Cp90  = 1 if copB2_3 > 90

//regressions
reg copB2_3 ccq5_0 ccq5_1 ccq5_3 ccq5_4 i.year 
reg copB2_3 ccq5_0 ccq5_1 ccq5_3 ccq5_4 i.year  if a > 0 
reg copB2_3 ccq5_0 ccq5_1 ccq5_3 ccq5_4 i.year  if activity == 1

logit Cp90  ccq5_0 ccq5_1 ccq5_3 ccq5_4 i.year 
logit Cp90  ccq5_0 ccq5_1 ccq5_3 ccq5_4 i.year  if a > 0 
logit Cp90  ccq5_0 ccq5_1 ccq5_3 ccq5_4 i.year  if activity == 1


reg copB2_3 ccq5_1 ccq4_3 ccq4_4 i.year
reg copB2_3 ccq5_1 ccq4_3 ccq4_4 i.year if a > 0
reg copB2_3 ccq5_1 ccq4_3 ccq4_4 i.year if activity == 1

logit Cp90 ccq5_1 ccq4_3 ccq4_4 i.year
logit Cp90 ccq5_1 ccq4_3 ccq4_4 i.year if a > 0
logit Cp90 ccq5_1 ccq4_3 ccq4_4 i.year if activity == 1


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//nestab90

clear all

cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\mktaccess1890\C"

//preprocessing

use "B_copB2.dta"
keep year cfips a copB2_3 survivalB2p90
merge m:1 cfips using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\county_city_size_quartile.dta"
drop _merge

merge m:1 cfips using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\c_activity.dta"
gen activity = 0
replace activity = 1 if _merge == 3
drop _merge
 
//create duummies

foreach x of numlist 0 1 3 4 {
	gen ccq5_`x' = 0
	replace ccq5_`x' = 1 if county_city_quartile5 == `x'
}


foreach x of numlist 1 3 4 {
	gen ccq4_`x' = 0
	replace ccq4_`x' = 1 if county_city_quartile4 == `x'
}


gen Cp90 = 0
replace Cp90  = 1 if copB2_3 > 90

//regressions
reg copB2_3 ccq5_0 ccq5_1 ccq5_3 ccq5_4 i.year 
reg copB2_3 ccq5_0 ccq5_1 ccq5_3 ccq5_4 i.year  if a > 0 
reg copB2_3 ccq5_0 ccq5_1 ccq5_3 ccq5_4 i.year  if activity == 1

logit Cp90  ccq5_0 ccq5_1 ccq5_3 ccq5_4 i.year 
logit Cp90  ccq5_0 ccq5_1 ccq5_3 ccq5_4 i.year  if a > 0 
logit Cp90  ccq5_0 ccq5_1 ccq5_3 ccq5_4 i.year  if activity == 1


reg copB2_3 ccq5_1 ccq4_3 ccq4_4 i.year
reg copB2_3 ccq5_1 ccq4_3 ccq4_4 i.year if a > 0
reg copB2_3 ccq5_1 ccq4_3 ccq4_4 i.year if activity == 1

logit Cp90 ccq5_1 ccq4_3 ccq4_4 i.year
logit Cp90 ccq5_1 ccq4_3 ccq4_4 i.year if a > 0
logit Cp90 ccq5_1 ccq4_3 ccq4_4 i.year if activity == 1