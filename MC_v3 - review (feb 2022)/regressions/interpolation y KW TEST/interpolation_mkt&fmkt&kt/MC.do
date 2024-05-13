clear all

cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\interpolation y KW TEST\interpolation_mkt&fmkt&kt"
clear all

use "data_ipolate"


//GENERAR LOOP DE VARIABLES CON ESCENARIOS
gen n_esc = .

replace n_esc = 4000 if year ==1895
replace n_esc = 3000 if year ==1896
replace n_esc = 3000 if year ==1897
replace n_esc = 6000 if year ==1898
replace n_esc = 23000 if year ==1899
replace n_esc = 39000 if year ==1900
replace n_esc = 29000 if year ==1901
replace n_esc = 47000 if year ==1902
replace n_esc = 59000 if year ==1903
replace n_esc = 37000 if year ==1904
replace n_esc = 47000 if year ==1905
replace n_esc = 49000 if year ==1906
replace n_esc = 91000 if year ==1907
replace n_esc = 75000 if year ==1908
replace n_esc = 69000 if year ==1909
replace n_esc = 55000 if year ==1910
replace n_esc = 26000 if year ==1911
replace n_esc = 25000 if year ==1912
replace n_esc = 38000 if year ==1913
replace n_esc = 20000 if year ==1914
replace n_esc = 38000 if year ==1915
replace n_esc = 39000 if year ==1916
replace n_esc = 24000 if year ==1917
replace n_esc = 17000 if year ==1918
replace n_esc = 20000 if year ==1919
replace n_esc = 24000 if year ==1920
replace n_esc = 27000 if year ==1921
replace n_esc = 10000 if year ==1922
replace n_esc = 7000 if year ==1923
replace n_esc = 8000 if year ==1924
replace n_esc = 5000 if year ==1925
replace n_esc = 2000 if year ==1926
replace n_esc = 1000 if year ==1927
replace n_esc = 2000 if year ==1928
replace n_esc = 1000 if year ==1929
replace n_esc = 1000 if year ==1930

gen nnestab = round(n_esc*nestab_d)
expand nnestab
gen nnestab_ = - nnestab
sort year nnestab_ 
bysort year: gen nobs = _n


drop if nobs > 4000 & year == 1895
drop if nobs > 3000 & year == 1896
drop if nobs > 3000 & year == 1897
drop if nobs > 6000 & year == 1898
drop if nobs > 23000 & year == 1899
drop if nobs > 39000 & year == 1900
drop if nobs > 29000 & year == 1901
drop if nobs > 47000 & year == 1902
drop if nobs > 59000 & year == 1903
drop if nobs > 37000 & year == 1904
drop if nobs > 47000 & year == 1905
drop if nobs > 49000 & year == 1906
drop if nobs > 91000 & year == 1907
drop if nobs > 75000 & year == 1908
drop if nobs > 69000 & year == 1909
drop if nobs > 55000 & year == 1910
drop if nobs > 26000 & year == 1911
drop if nobs > 25000 & year == 1912
drop if nobs > 38000 & year == 1913
drop if nobs > 20000 & year == 1914
drop if nobs > 38000 & year == 1915
drop if nobs > 39000 & year == 1916
drop if nobs > 24000 & year == 1917
drop if nobs > 17000 & year == 1918
drop if nobs > 20000 & year == 1919
drop if nobs > 24000 & year == 1920
drop if nobs > 27000 & year == 1921
drop if nobs > 10000 & year == 1922
drop if nobs > 7000 & year == 1923
drop if nobs > 8000 & year == 1924
drop if nobs > 5000 & year == 1925
drop if nobs > 2000 & year == 1926
drop if nobs > 1000 & year == 1927
drop if nobs > 2000 & year == 1928
drop if nobs > 1000 & year == 1929
drop if nobs > 1000 & year == 1930


gen share = nnestab / n_esc 

preserve
keep if




