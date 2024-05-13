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

cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\ks"

use "MC_inputdata_year_entry.dta" 

expand entry 
gen firmid= _n 
order firmid 
gen rep=1000 
expand rep 
bysort firmid: gen repid= _n 
order repid 
set obs 971000
set seed 3219


//Loop para obtener datasets recortados
{
preserve 
gen cfipsfirmsid = floor(( 100063 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1895.dta" 
keep if year == 1895 
gen n = _n
keep if n<=4000  
save "MC\2_MC_1895", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100021 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1896.dta" 
keep if year == 1896 
gen n = _n
keep if n<=3000  
save "MC\2_MC_1896", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100046 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1897.dta" 
keep if year == 1897 
gen n = _n
keep if n<=3000  
save "MC\2_MC_1897", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100022 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1898.dta" 
keep if year == 1898 
gen n = _n
keep if n<=6000  
save "MC\2_MC_1898", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100021 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1899.dta" 
keep if year == 1899 
gen n = _n
keep if n<=23000  
save "MC\2_MC_1899", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100029 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1900.dta" 
keep if year == 1900 
gen n = _n
keep if n<=39000  
save "MC\2_MC_1900", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100033 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1901.dta" 
keep if year == 1901 
gen n = _n
keep if n<=29000  
save "MC\2_MC_1901", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100036 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1902.dta" 
keep if year == 1902 
gen n = _n
keep if n<=47000  
save "MC\2_MC_1902", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100025 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1903.dta" 
keep if year == 1903 
gen n = _n
keep if n<=59000  
save "MC\2_MC_1903", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100021 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1904.dta" 
keep if year == 1904 
gen n = _n
keep if n<=37000  
save "MC\2_MC_1904", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100039 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1905.dta" 
keep if year == 1905 
gen n = _n
keep if n<=47000  
save "MC\2_MC_1905", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100034 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1906.dta" 
keep if year == 1906 
gen n = _n
keep if n<=49000  
save "MC\2_MC_1906", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100049 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1907.dta" 
keep if year == 1907 
gen n = _n
keep if n<=91000  
save "MC\2_MC_1907", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100052 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1908.dta" 
keep if year == 1908 
gen n = _n
keep if n<=75000  
save "MC\2_MC_1908", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100036 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1909.dta" 
keep if year == 1909 
gen n = _n
keep if n<=69000  
save "MC\2_MC_1909", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100046 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1910.dta" 
keep if year == 1910 
gen n = _n
keep if n<=55000  
save "MC\2_MC_1910", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100032 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1911.dta" 
keep if year == 1911 
gen n = _n
keep if n<=26000  
save "MC\2_MC_1911", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100051 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1912.dta" 
keep if year == 1912 
gen n = _n
keep if n<=25000  
save "MC\2_MC_1912", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100067 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1913.dta" 
keep if year == 1913 
gen n = _n
keep if n<=38000  
save "MC\2_MC_1913", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100043 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1914.dta" 
keep if year == 1914 
gen n = _n
keep if n<=20000  
save "MC\2_MC_1914", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100064 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1915.dta" 
keep if year == 1915 
gen n = _n
keep if n<=38000  
save "MC\2_MC_1915", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100082 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1916.dta" 
keep if year == 1916 
gen n = _n
keep if n<=39000  
save "MC\2_MC_1916", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100084 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1917.dta" 
keep if year == 1917 
gen n = _n
keep if n<=24000  
save "MC\2_MC_1917", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100068 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1918.dta" 
keep if year == 1918 
gen n = _n
keep if n<=17000  
save "MC\2_MC_1918", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100098 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1919.dta" 
keep if year == 1919 
gen n = _n
keep if n<=20000  
save "MC\2_MC_1919", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100088 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1920.dta" 
keep if year == 1920 
gen n = _n
keep if n<=24000  
save "MC\2_MC_1920", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100106 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1921.dta" 
keep if year == 1921 
gen n = _n
keep if n<=27000  
save "MC\2_MC_1921", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100093 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1922.dta" 
keep if year == 1922 
gen n = _n
keep if n<=10000  
save "MC\2_MC_1922", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100125 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1923.dta" 
keep if year == 1923 
gen n = _n
keep if n<=7000  
save "MC\2_MC_1923", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100132 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1924.dta" 
keep if year == 1924 
gen n = _n
keep if n<=8000  
save "MC\2_MC_1924", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100155 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1925.dta" 
keep if year == 1925 
gen n = _n
keep if n<=5000  
save "MC\2_MC_1925", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100161 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1926.dta" 
keep if year == 1926 
gen n = _n
keep if n<=2000  
save "MC\2_MC_1926", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100198 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1927.dta" 
keep if year == 1927 
gen n = _n
keep if n<=1000  
save "MC\2_MC_1927", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100209 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1928.dta" 
keep if year == 1928 
gen n = _n
keep if n<=2000  
save "MC\2_MC_1928", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100231 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1929.dta" 
keep if year == 1929 
gen n = _n
keep if n<=1000  
save "MC\2_MC_1929", replace 
restore 

preserve 
gen cfipsfirmsid = floor(( 100231 +1)*runiform() + 1)
merge m:m cfipsfirmsid using "MC\MCY_1930.dta" 
keep if year == 1930 
gen n = _n
keep if n<=1000  
save "MC\2_MC_1930", replace 
restore 
}

clear all
use "MC\2_MC_1895"

foreach x of numlist 1896 1897 1898 1899 1900 1901 1902 1903 1904 1905 1906 1907 1908 1909 1910 1911 1912 1913 1914 1915 1916 1917 1918 1919 1920 1921 1922 1923 1924 1925 1926 1927 1928 1929 1930 {

append using "MC\2_MC_`x'"
sum repid

}

//código de aquí en adelante sigue igual

drop _merge 


gen maxage=1930-year+1 
expand maxage

bysort repid firmid: gen yearid= _n 
rename year entryyear 
gen year=entryyear+yearid-1 
order year, before (entryyear) 



set obs 21205001
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


forval i = 12(1)99{
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


















