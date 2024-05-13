*******************************************************************************
*********************************MAPS******************************************
*******************************************************************************

**MAPS PERCENTILE POP

clear all


cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\mapas"

use "3233"

merge 1:1 cfips using "bilateral_county_data_workingfile"

keep cfips pop90

gen D1 = 0
replace D1 = 1 if pop90>146976 & pop90<500000
gen D2 = 0
replace D2 = 1 if pop90>146976 & pop90<750000

//mediana y menor a 750mil
gen D3 = 0
replace D3 = 1 if pop90>78929 & pop90<750000

//mediana >
gen D4 = 0
replace D4 = 1 if pop90>78929 & pop90!=.


export excel using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\mapas\maps.xls", firstrow(variables) replace

// regresiones / scatters observados y fitted values

**MAPS COPB_3

foreach x of numlist 1 2 3 {
	clear all
	
	cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\"
	
	use "`x'"
	keep if year == 1908
	merge 1:m cfips using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\mapas\3233"
	keep cfips copB2_3
	replace copB2_3 = 0 if copB2_3 == .
	
	gen C=0

	*** COLOR CODE: WHITE, BLUE, GREEN, YELLOW, ORANGE, RED

	replace C=0 if copB2_3 == 0 
	replace C=1 if copB2_3 > 0  & copB2_3 <=10 
	replace C=2 if copB2_3 >10  & copB2_3 <=90 
	replace C=3 if copB2_3 >90  & copB2_3 <=100
	replace C=4 if copB2_3 >100 & copB2_3 <=200 
	replace C=5 if copB2_3 >200
	
	rename C C`x'
	cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\mapas"
	
	save "C`x'", replace
}

clear all
cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\mapas"

use "C1"
merge 1:1 cfips using "C2"
drop _merge

merge 1:1 cfips using "C3"
drop _merge

export excel using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\mapas\mapas_indicadores_1908.xls", firstrow(variables) replace



**MAPS COPB_3

foreach x of numlist 1 2 3 {
	clear all
	
	cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\"
	
	use "`x'"
	keep if year == 1930
	merge 1:m cfips using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\mapas\3233"
	keep cfips copB2_3
	replace copB2_3 = 0 if copB2_3 == .
	
	gen C=0

	*** COLOR CODE: WHITE, BLUE, GREEN, YELLOW, ORANGE, RED

	replace C=0 if copB2_3 == 0 
	replace C=1 if copB2_3 > 0  & copB2_3 <=10 
	replace C=2 if copB2_3 >10  & copB2_3 <=90 
	replace C=3 if copB2_3 >90  & copB2_3 <=100
	replace C=4 if copB2_3 >100 & copB2_3 <=200 
	replace C=5 if copB2_3 >200
	
	rename C C`x'
	cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\mapas"
	
	save "C`x'", replace
}

clear all
cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\mapas"

use "C1"
merge 1:1 cfips using "C2"
drop _merge

merge 1:1 cfips using "C3"
drop _merge

export excel using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\mapas\mapas_indicadores_1930.xls", firstrow(variables) replace



*******************************************************************************
**************************SCATTERS AND CORRELATIONS****************************
*******************************************************************************


foreach x of numlist 1 2 3  {
	clear all
	
	cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\"
	
	use "`x'"
	keep if year == 1900 | year == 1910 | year == 1920 | year == 1930 
	
	merge 1:1 cfips year using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\mapas\lq"
	
	cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\mapas"
	
	forval i = 1900(10)1930 {
	
	display "`i'"
	pwcorr lqnestab copB2_3 if year==`i'
	asdoc pwcorr lqnestab copB2_3 if year==`i' , title(pearson correlation lqnestab vs copB2_3 `i') save(`x'_pwcorr.doc)
	
// 	spearman lqnestab copB2_3  if year==`i'
// 	asdoc spearman lqnestab copB2_3 if year==`i' , title(spearman correlation lqnestab vs copB2_3 `i') save(`x'_spcorr.doc)
	
	}
	
	twoway (scatter lqnestab copB2_3,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1900 , xtitle(copB2_3 1900) ytitle (LQ) xmtick(0(100)200) graphregion(color(white))
	graph export "`x'_S_lqnestab_v_copB2_3_1900.png", as(png) name("Graph") replace

	twoway (scatter lqnestab copB2_3,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1910 , xtitle(copB2_3 1910) ytitle (LQ) xmtick(0(100)400) graphregion(color(white))
	graph export "`x'_S_lqnestab_v_copB2_3_1910.png", as(png) name("Graph") replace

	twoway (scatter lqnestab copB2_3,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1920 , xtitle(copB2_3 1920) ytitle (LQ) xmtick(0(100)400) graphregion(color(white))
	graph export "`x'_S_lqnestab_v_copB2_3_1920.png", as(png) name("Graph") replace

	twoway (scatter lqnestab copB2_3,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1930 , xtitle(copB2_3 1930) ytitle (LQ) xmtick(0(100)500) graphregion(color(white))
	graph export "`x'_S_lqnestab_v_copB2_3_1930.png", as(png) name("Graph") replace

}


*******************************************************************************
**************************HISTOGRAMS****************************
*******************************************************************************
clear all

use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\ks_tot\MC_outputdata_random_PLC"
gen id = _n

merge m:1 id using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\mapas\aa"

foreach x of numlist 200 400 600 800 1000 {
	twoway (histogram agedraw2 if repid == `x' , color(blue%50) lcolor(blue)) (histogram aa), graphregion(color(white)) title(agredraw2 `y' repid `x' ) legend(label(1 "MC") label(2 "aa"))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\mapas\hist_agedraw2__repid_`x''.png", as(png) name("Graph") replace
}


