****************************************************************
****************************************************************
****************************************************************
*** RANDOM PLC USING MONTE CARLO EXPERIMENT
***
*** RANDOM PLC USING MONTE CARLO EXPERIMENT WITHOUT SHORTCUTS IMPLIES WORKING WITH DATASET OF 67 BILLION OBSERVATIONS
*** 
*** MY COMPUTER DOES NOT ALLOW WORKING WITH SUCH A DATASET, SO I BROKE THE PROBLEM INTO 2 STEPS
***


clear all

cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4 - repaso Jorge (feb 2022)\nestab"

// use "MC_inputdata_year_entry.dta" 

import excel "entrada.xlsx", sheet("Hoja1") firstrow

// keep year entry_positive
// rename entry_positive entry

// keep year entry_negative
// rename entry_negative entry

keep year entry_constant
rename entry_constant entry

keep year entry

expand entry 
gen firmid= _n 
order firmid 
gen rep=1000 
expand rep 
bysort firmid: gen repid= _n 
order repid 
set obs 981000
set seed 3219

// Definir localmente las entradas para cada año
// local entries 50000 49000 48000 47000 46000 45000 44000 43000 42000 41000 40000 39000 38000 37000 36000 35000 34000 33000 32000 31000 30000 29000 28000 27000 26000 21000 0 0 0 0 0 0 0 0 0 0

// local entries 0 0 0 0 0 0 0 0 0 0 21000 26000 27000 28000 29000 30000 31000 32000 33000 34000 35000 36000 37000 38000 39000 40000 41000 42000 43000 44000 45000 46000 47000 48000 49000 50000

local entries 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000 27000



// Iniciar el bucle desde 1895 hasta 1930
forvalues year = 1895/1930 {
    // Calcular el índice para la lista de entradas
    local index = `year' - 1894
    // Obtener el número de entradas de la lista para el año correspondiente
    local nobs = word("`entries'", `index')
    
    preserve
    // Generar un ID único para cada observación usando el número de entradas
    gen cfipsfirmsid = floor((`nobs' +1)*runiform() + 1)
    // Fusionar con el archivo de datos anual
    merge m:m cfipsfirmsid using "MC\MCY_`year'.dta"
    // Mantener solo las observaciones del año actual
    keep if year == `year'
    // Generar una variable n para identificar cada observación
    gen n = _n
    // Mantener solo hasta el número de entradas especificado para ese año
    keep if n <= `nobs'
    // Guardar el archivo con el nuevo nombre
    save "MC\2_MC_`year'", replace
    restore
}



clear all //APPEND
use "MC\2_MC_1895"

foreach x of numlist 1896 1897 1898 1899 1900 1901 1902 1903 1904 1905 1906 1907 1908 1909 1910 1911 1912 1913 1914 1915 1916 1917 1918 1919 1920 1921 1922 1923 1924 1925 1926 1927 1928 1929 1930 {

append using "MC\2_MC_`x'"
sum repid

}

//código de aquí en adelante sigue igual

// drop _merge 

// drop in 971000
// drop in 622088/622088
// drop in 545085/545085

gen maxage=1930-year+1 
expand maxage

bysort repid firmid: gen yearid= _n 
rename year entryyear 
gen year=entryyear+yearid-1 
order year, before (entryyear) 



set obs 24331000
set seed 8631
gen psurvival2 = runiform()
gen s=0

{
replace s=1 if yearid==1
replace s=1 if psurvival<0.876 & yearid==2
replace s=1 if psurvival<0.728 & yearid==3
replace s=1 if psurvival<0.692 & yearid==4
replace s=1 if psurvival<0.78 & yearid==5
replace s=1 if psurvival<0.736 & yearid==6
replace s=1 if psurvival<0.802 & yearid==7
replace s=1 if psurvival<0.8 & yearid==8
replace s=1 if psurvival<0.763 & yearid==9
replace s=1 if psurvival<0.832 & yearid==10
replace s=1 if psurvival<0.835 & yearid==11
replace s=1 if psurvival<0.85 & yearid==12
replace s=1 if psurvival<0.91 & yearid==13
replace s=1 if psurvival<0.869 & yearid==14
replace s=1 if psurvival<0.906 & yearid==15
replace s=1 if psurvival<0.889 & yearid==16
replace s=1 if psurvival<0.872 & yearid==17
replace s=1 if psurvival<0.853 & yearid==18
replace s=1 if psurvival<0.897 & yearid==19
replace s=1 if psurvival<0.885 & yearid==20
replace s=1 if psurvival<0.857 & yearid==21
replace s=1 if psurvival<0.941 & yearid==22
replace s=1 if psurvival<0.857 & yearid==23
replace s=1 if psurvival<0.878500052574522 & yearid==24
replace s=1 if psurvival<0.900000105149044 & yearid==25
replace s=1 if psurvival<0.886918780149044 & yearid==26
replace s=1 if psurvival<0.873837455149044 & yearid==27
replace s=1 if psurvival<0.860756130149044 & yearid==28
replace s=1 if psurvival<0.75 & yearid==29
replace s=1 if psurvival<0.74 & yearid==30
replace s=1 if psurvival<0.73 & yearid==31
replace s=1 if psurvival<0.72 & yearid==32
replace s=1 if psurvival<0.71 & yearid==33
replace s=1 if psurvival<0.7 & yearid==34
replace s=1 if psurvival<0.69 & yearid==35
replace s=1 if psurvival<0.68 & yearid==36
}


gen survival2=0

replace survival2=1 if year==entryyear
replace survival2=1 if survival2[_n-1]==1 & s==1 & year>entryyear
bysort repid firmid: egen agedraw2=sum(survival2)
bysort repid firmid: gen agecountsurvival2=_n if survival2==1
replace agecountsurvival2=0 if survival2==0


save "MC_outputdata_random_PLC.dta", replace


///CREACIÓN DE DATASET DE 63MILLONES
clear all
use "MC_outputdata_random_PLC.dta"

rename cfips cfips_firms

collapse (sum) survival2, by (repid year cfips_firms)
save "MC_outputdata_random_PLC_collapse_rep_year_cfipsfirms.dta", replace

clear all

use "MC_all_possible_outcomes_year_cfipsfirms.dta" 
merge 1:1 repid year cfips_firms using "MC_outputdata_random_PLC_collapse_rep_year_cfipsfirms.dta"
drop _merge
replace survival2=0 if survival2==.
keep if cfipsid!=.

save "MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfipsfirms.dta", replace
///



///CREACIÓN DEL INDICE
clear all
use "MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfipsfirms.dta"
save "C\cfips_firms.dta", replace


// forval i = 1(1)99{
forval i = 50(1)51{	
	clear all
	use "C\cfips_firms.dta"
	collapse (p`i') survival*, by (year cfips_firms)
	rename survival2 survivalB2p`i'
	save "C\p`i'.dta", replace
}

use "C\cfips_firms.dta"
collapse (max) survival*, by (year cfips_firms)
rename survival2 survivalB2p100
save "C\p100.dta", replace



* MERGE: PERCENTILS - OBSERVED - LQ
clear all
use "C\p1.dta"
forval i = 2(1)100{
	merge 1:1 year cfips_firms using "C\p`i'.dta"
	drop _merge
}
rename cfips_firms cfips

merge 1:1 year cfips using "MC_inputdata_observed_PLC_maps.dta"
drop _merge

// merge 1:1 year cfips using "lqmap.dta"
// drop if _merge!=3
// drop gisjoin gisjoin1 year1 ansicode _merge


replace a=0 if a==.

save "C\B_p1-100.dta", replace

* GENERATE OBSERVED AS PERCENTAGE OF RANDOM PLC PERCENTILE VARIABLE

clear all
use "C\B_p1-100.dta"

*MAX

gen copB2_1=.


//LOOP MAX
forval i= 1(1)100{
	replace copB2_1=`i' if a==survivalB2p`i' & a>0
}

//NO TIENEN HISTORIA
replace copB2_1=0 if a<=0 

//OBERVADO < P1
replace copB2_1=0 if a<survivalB2p1

//OBSERVED > P100
replace copB2_1 = ((a/survivalB2p100)*100) if a > survivalB2p100 & a>0

//OBSERVED < P100 & OBSERVED < P100
replace copB2_1 = 99.5 if a > survivalB2p99 & a < survivalB2p100

sort copB2_1

///////////////////////////////////////////////////////////////////////////////

*MIN

gen copB2_2=copB2_1

forval i= 100(-1)1{
	replace copB2_2=`i' if a==survivalB2p`i' & a>0
}

///////////////////////////////////////////////////////////////////////////////

*MEDIAN

gen copB2_3=copB2_1
replace copB2_3=(copB2_1+copB2_2)/2

save "C\B_copB2.dta", replace


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////



*** (6) STEP 4 GENERATE copB2_1: OBSERVED AS PERCENTAGE OF RANDOM PLC

* GENERATE PERCENTILE AND MAINTAIN ONLY YEARS OF INTEREST FOR GREATER COMPUTER EFFICIENCY
clear all
use "MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfipsfirms.dta"
save "C\cfips_firms.dta", replace


forval i = 1(1)82{
	clear all
	use "C\cfips_firms.dta"
	collapse (p`i') survival*, by (year cfips_firms)
	rename survival2 survivalB2p`i'
	save "C\p`i'.dta", replace
}

use "C\cfips_firms.dta"
collapse (max) survival*, by (year cfips_firms)
rename survival2 survivalB2p100
save "C\p100.dta", replace



* MERGE: PERCENTILS - OBSERVED - LQ
clear all
use "C\p1.dta"
forval i = 2(1)100{
	merge 1:1 year cfips_firms using "C\p`i'.dta"
	drop _merge
}
rename cfips_firms cfips

merge 1:1 year cfips using "MC_inputdata_observed_PLC_maps.dta"
drop _merge

// merge 1:1 year cfips using "lqmap.dta"
// drop if _merge!=3
// drop gisjoin gisjoin1 year1 ansicode _merge


replace a=0 if a==.

save "C\B_p1-100.dta", replace

* GENERATE OBSERVED AS PERCENTAGE OF RANDOM PLC PERCENTILE VARIABLE

clear all
use "C\B_p1-100.dta"

*MAX

gen copB2_1=.


//LOOP MAX
forval i= 1(1)100{
	replace copB2_1=`i' if a==survivalB2p`i' & a>0
}

//NO TIENEN HISTORIA
replace copB2_1=0 if a<=0 

//OBERVADO < P1
replace copB2_1=0 if a<survivalB2p1

//OBSERVED > P100
replace copB2_1 = ((a/survivalB2p100)*100) if a > survivalB2p100 & a>0

//OBSERVED < P100 & OBSERVED < P100
replace copB2_1 = 99.5 if a > survivalB2p99 & a < survivalB2p100

sort copB2_1

///////////////////////////////////////////////////////////////////////////////

*MIN

gen copB2_2=copB2_1

forval i= 100(-1)1{
	replace copB2_2=`i' if a==survivalB2p`i' & a>0
}

///////////////////////////////////////////////////////////////////////////////

*MEDIAN

gen copB2_3=copB2_1
replace copB2_3=(copB2_1+copB2_2)/2

save "C\B_copB2.dta", replace


********************************************************************************
********************************************************************************
********************************************************************************


clear all
use "C\B_copB2_decreciente.dta"
tsset cfips year, yearly

foreach x of numlist 36061 25025 42101 17031 39061 39035 26163 18141 17019 {
	twoway (tsline a, yaxis(1) lcolor(blue)) (tsline survivalB2p10, yaxis(1) lcolor(black) lpattern(vshortdash)) ///
	(tsline survivalB2p90, yaxis(1) lcolor(black) lpattern(vshortdash)) ///
	(tsline copB2_3, yaxis(2) lcolor(red)) if cfips==`x', ///
	title(nestab90_survivalB2 & observed: `x') graphregion(color(white))
	graph export "C\TS_copB2s_`x'.png", as(png) name("Graph") replace
}


















