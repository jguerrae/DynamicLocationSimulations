******************************************************************************************************************
******************************************************************************************************************
**********************************************REGRESIONES*********************************************************
******************************************************************************************************************
******************************************************************************************************************



***** Specification 4: Quadratic Efffects of county size * median county size & median county size *****

cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions"
	
foreach x of numlist  1 {

	clear all
	use "`x'"
	
	gen V = `x'
	
	merge m:1 cfips using "pop90"

	gen pop90_2 = pop90*pop90

	gen ccq2_1 = 0  //debajo del p90
	replace ccq2_1 = 1 if pop90 < 78929 

	gen ccq2_2 = 0  //debajo del p90
	replace ccq2_2 = 1 if pop90 >= 78929

	gen ccq2_1_pop90 = ccq2_1 * pop90
	gen ccq2_1_pop90_2 = ccq2_1 * pop90_2
	
	gen ccq2_2_pop90 = ccq2_2 * pop90
	gen ccq2_2_pop90_2 = ccq2_2 * pop90_2
	
	//////////////////////////////////////////////////////////////////////////// Dv =  B0 + pop90 + pop90^2
	
	
	
	reg copB2_3 pop90 pop90_2 i.year i.state  
	outreg2 using VF_regresion_`x'_2.xls, replace ctitle(ALL) keep(pop90 pop90_2) addtext(FE, YS)
	predict y1_1_pop
	twoway (scatter y1_1_pop pop90) (qfit y1_1_pop pop90), title(`x'_y1_1_pop) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\VF_scatters_`x'\pop_y1_1.png", as(png) name("Graph") replace

	reg copB2_3 pop90 pop90_2 i.year i.state if a > 0
	outreg2 using VF_regresion_`x'_2.xls, append ctitle(OBSERVED) keep(pop90 pop90_2) addtext(FE, YS)
	predict y1_2_pop
	twoway (scatter y1_2_pop pop90) (qfit y1_2_pop pop90), title(`x'_y1_2_pop) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\VF_scatters_`x'\pop_y1_2.png", as(png) name("Graph") replace

	reg copB2_3 pop90 pop90_2 i.year i.state if activity==1 
	outreg2 using VF_regresion_`x'_2.xls, append ctitle(ACTIVITY) keep(pop90 pop90_2) addtext(FE, YS)
	predict y1_3_pop
	twoway (scatter y1_3_pop pop90) (qfit y1_3_pop pop90), title(`x'_y1_3_pop) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\VF_scatters_`x'\pop_y1_3.png", as(png) name("Graph") replace
	
	//////////////////////////////////////////////////////////////////////////// Dv =  B0 + ccq2_2
	
	reg copB2_3 ccq2_2 i.year i.state
	outreg2 using VF_regresion_`x'_2.xls, append ctitle(E1_All) keep(ccq2_1 ccq2_2) addtext(FE, YS)
// 	predict y1_1
// 	scatter y1_1 pop90, title(`x'_y1_1) graphregion(color(white))
// 	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\VF_scatters_`x'\y1_1.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq2_2 i.year i.state if a > 0
	outreg2 using VF_regresion_`x'_2.xls, append ctitle(E1_Obseverved) keep(ccq2_1 ccq2_2) addtext(FE, YS)
// 	predict y1_2 
// 	scatter y1_2 pop90 if a > 0, title(`x'_y1_2) graphregion(color(white))
// 	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\VF_scatters_`x'\y1_2.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq2_2 i.year i.state if activity == 1
	outreg2 using VF_regresion_`x'_2.xls, append ctitle(E1_Activity) keep(ccq2_1 ccq2_2) addtext(FE, YS)
// 	predict y1_3
// 	scatter y1_3 pop90 if activity==1, title(`x'_y1_3) graphregion(color(white))
// 	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\VF_scatters_`x'\y1_3.png", as(png) name("Graph") replace
	
	
	//////////////////////////////////////////////////////////////////////////// Dv= d2*pop90 + d2*pop90^2
	
	
	reg copB2_3 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state
	outreg2 using VF_regresion_`x'_2.xls, append ctitle(E2_All) keep(ccq2_1  ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict y2_1
	twoway (scatter y2_1 pop90) (qfit y2_1 pop90), title(`x'_y2_1) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\VF_scatters_`x'\y2_1.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state if a > 0
	outreg2 using VF_regresion_`x'_2.xls, append ctitle(E2_Observed) keep(ccq2_1  ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict y2_2
	twoway (scatter y2_2 pop90) (qfit y2_2 pop90), title(`x'_y2_2) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\VF_scatters_`x'\y2_2.png", as(png) name("Graph") replace
	
	reg copB2_3  ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state if activity == 1
	outreg2 using VF_regresion_`x'_2.xls, append ctitle(E2_Activity) keep(ccq2_1  ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict y2_3
	twoway (scatter y2_3 pop90) (qfit y2_3 pop90), title(`x'_y2_1) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\VF_scatters_`x'\y2_3.png", as(png) name("Graph") replace
	
	
	//////////////////////////////////////////////////////////////////////////// Dv= d1*pop90 + d1*pop90^2 + d2*pop90 + d2*pop90^2
	
	reg copB2_3 ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state
	outreg2 using VF_regresion_`x'_2.xls, append ctitle(E3_All) keep(ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict y3_1
	twoway (scatter y3_1 pop90) (qfit y3_1 pop90), title(`x'_y3_1) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\VF_scatters_`x'\y3_1.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state if a > 0
	outreg2 using VF_regresion_`x'_2.xls, append ctitle(E3_Observed) keep(ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict y3_2
	twoway (scatter y3_2 pop90) (qfit y3_2 pop90), title(`x'_y3_2) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\VF_scatters_`x'\y3_2.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state if activity == 1
	outreg2 using VF_regresion_`x'_2.xls, append ctitle(E3_Activity) keep(ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict y3_3
	twoway (scatter y3_3 pop90) (qfit y3_3 pop90), title(`x'_y3_3) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\VF_scatters_`x'\y3_3.png", as(png) name("Graph") replace


	
	////////////////////////////////////////////////////////////////////////////
	
	erase VF_regresion_`x'_2.txt

}



***** Specification 4: Quadratic Efffects of county size * median county size & median county size ***** 1895

cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions"
	
foreach x of numlist  1 {

	clear all
	use "`x'"
	
	gen V = `x'
	
	merge m:1 cfips using "pop90"

	gen pop90_2 = pop90*pop90

	gen ccq2_1 = 0  //debajo del p90
	replace ccq2_1 = 1 if pop90 < 78929 

	gen ccq2_2 = 0  //debajo del p90
	replace ccq2_2 = 1 if pop90 >= 78929

	gen ccq2_1_pop90 = ccq2_1 * pop90
	gen ccq2_1_pop90_2 = ccq2_1 * pop90_2
	
	gen ccq2_2_pop90 = ccq2_2 * pop90
	gen ccq2_2_pop90_2 = ccq2_2 * pop90_2
	
	drop if year >= 1909
	
	//////////////////////////////////////////////////////////////////////////// Dv =  B0 + pop90 + pop90^2
	
	
	reg copB2_3 pop90 pop90_2 i.year i.state  
	outreg2 using 85_VF_regresion_`x'_2.xls, replace ctitle(ALL) keep(pop90 pop90_2) addtext(FE, YS)
	predict y1_1_pop
	twoway (scatter y1_1_pop pop90) (qfit y1_1_pop pop90), title(`x'_y1_1_pop) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\85_VF_scatters_`x'\pop_y1_1.png", as(png) name("Graph") replace

	reg copB2_3 pop90 pop90_2 i.year i.state if a > 0
	outreg2 using 85_VF_regresion_`x'_2.xls, append ctitle(OBSERVED) keep(pop90 pop90_2) addtext(FE, YS)
	predict y1_2_pop
	twoway (scatter y1_2_pop pop90) (qfit y1_2_pop pop90), title(`x'_y1_2_pop) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\85_VF_scatters_`x'\pop_y1_2.png", as(png) name("Graph") replace

	reg copB2_3 pop90 pop90_2 i.year i.state if activity==1 
	outreg2 using 85_VF_regresion_`x'_2.xls, append ctitle(ACTIVITY) keep(pop90 pop90_2) addtext(FE, YS)
	predict y1_3_pop
	twoway (scatter y1_3_pop pop90) (qfit y1_3_pop pop90), title(`x'_y1_3_pop) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\85_VF_scatters_`x'\pop_y1_3.png", as(png) name("Graph") replace
	
	//////////////////////////////////////////////////////////////////////////// Dv =  B0 + ccq2_2
	
	reg copB2_3 ccq2_2 i.year i.state
	outreg2 using 85_VF_regresion_`x'_2.xls, append ctitle(E1_All) keep(ccq2_1 ccq2_2) addtext(FE, YS)
// 	predict y1_1
// 	scatter y1_1 pop90, title(`x'_y1_1) graphregion(color(white))
// 	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\85_VF_scatters_`x'\y1_1.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq2_2 i.year i.state if a > 0
	outreg2 using 85_VF_regresion_`x'_2.xls, append ctitle(E1_Obseverved) keep(ccq2_1 ccq2_2) addtext(FE, YS)
// 	predict y1_2 
// 	scatter y1_2 pop90 if a > 0, title(`x'_y1_2) graphregion(color(white))
// 	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\85_VF_scatters_`x'\y1_2.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq2_2 i.year i.state if activity == 1
	outreg2 using 85_VF_regresion_`x'_2.xls, append ctitle(E1_Activity) keep(ccq2_1 ccq2_2) addtext(FE, YS)
// 	predict y1_3
// 	scatter y1_3 pop90 if activity==1, title(`x'_y1_3) graphregion(color(white))
// 	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\85_VF_scatters_`x'\y1_3.png", as(png) name("Graph") replace
	
	
	//////////////////////////////////////////////////////////////////////////// Dv= d2*pop90 + d2*pop90^2
	
	
	reg copB2_3 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state
	outreg2 using 85_VF_regresion_`x'_2.xls, append ctitle(E2_All) keep(ccq2_1  ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict y2_1
	twoway (scatter y2_1 pop90) (qfit y2_1 pop90), title(`x'_y2_1) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\85_VF_scatters_`x'\y2_1.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state if a > 0
	outreg2 using 85_VF_regresion_`x'_2.xls, append ctitle(E2_Observed) keep(ccq2_1  ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict y2_2
	twoway (scatter y2_2 pop90) (qfit y2_2 pop90), title(`x'_y2_2) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\85_VF_scatters_`x'\y2_2.png", as(png) name("Graph") replace
	
	reg copB2_3  ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state if activity == 1
	outreg2 using 85_VF_regresion_`x'_2.xls, append ctitle(E2_Activity) keep(ccq2_1  ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict y2_3
	twoway (scatter y2_3 pop90) (qfit y2_3 pop90), title(`x'_y2_1) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\85_VF_scatters_`x'\y2_3.png", as(png) name("Graph") replace
	
	
	//////////////////////////////////////////////////////////////////////////// Dv= d1*pop90 + d1*pop90^2 + d2*pop90 + d2*pop90^2
	
	reg copB2_3 ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state
	outreg2 using 85_VF_regresion_`x'_2.xls, append ctitle(E3_All) keep(ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict y3_1
	twoway (scatter y3_1 pop90) (qfit y3_1 pop90), title(`x'_y3_1) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\85_VF_scatters_`x'\y3_1.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state if a > 0
	outreg2 using 85_VF_regresion_`x'_2.xls, append ctitle(E3_Observed) keep(ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict y3_2
	twoway (scatter y3_2 pop90) (qfit y3_2 pop90), title(`x'_y3_2) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\85_VF_scatters_`x'\y3_2.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state if activity == 1
	outreg2 using 85_VF_regresion_`x'_2.xls, append ctitle(E3_Activity) keep(ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict y3_3
	twoway (scatter y3_3 pop90) (qfit y3_3 pop90), title(`x'_y3_3) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\85_VF_scatters_`x'\y3_3.png", as(png) name("Graph") replace


	////////////////////////////////////////////////////////////////////////////
	
	erase 85_VF_regresion_`x'_2.txt

}



***** Specification 4: Quadratic Efffects of county size * median county size & median county size ***** 1909

cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions"
	
foreach x of numlist  1 {

	clear all
	use "`x'"
	
	gen V = `x'
	
	merge m:1 cfips using "pop90"

	gen pop90_2 = pop90*pop90

	gen ccq2_1 = 0  //debajo del p90
	replace ccq2_1 = 1 if pop90 < 78929 

	gen ccq2_2 = 0  //debajo del p90
	replace ccq2_2 = 1 if pop90 >= 78929

	gen ccq2_1_pop90 = ccq2_1 * pop90
	gen ccq2_1_pop90_2 = ccq2_1 * pop90_2
	
	gen ccq2_2_pop90 = ccq2_2 * pop90
	gen ccq2_2_pop90_2 = ccq2_2 * pop90_2
	
	drop if year < 1909
	
	//////////////////////////////////////////////////////////////////////////// Dv =  B0 + pop90 + pop90^2
	
	
	reg copB2_3 pop90 pop90_2 i.year i.state  
	outreg2 using 09_VF_regresion_`x'_2.xls, replace ctitle(ALL) keep(pop90 pop90_2) addtext(FE, YS)
	predict y1_1_pop
	twoway (scatter y1_1_pop pop90) (qfit y1_1_pop pop90), title(`x'_y1_1_pop) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\09_VF_scatters_`x'\pop_y1_1.png", as(png) name("Graph") replace

	reg copB2_3 pop90 pop90_2 i.year i.state if a > 0
	outreg2 using 09_VF_regresion_`x'_2.xls, append ctitle(OBSERVED) keep(pop90 pop90_2) addtext(FE, YS)
	predict y1_2_pop
	twoway (scatter y1_2_pop pop90) (qfit y1_2_pop pop90), title(`x'_y1_2_pop) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\09_VF_scatters_`x'\pop_y1_2.png", as(png) name("Graph") replace

	reg copB2_3 pop90 pop90_2 i.year i.state if activity==1 
	outreg2 using 09_VF_regresion_`x'_2.xls, append ctitle(ACTIVITY) keep(pop90 pop90_2) addtext(FE, YS)
	predict y1_3_pop
	twoway (scatter y1_3_pop pop90) (qfit y1_3_pop pop90), title(`x'_y1_3_pop) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\09_VF_scatters_`x'\pop_y1_3.png", as(png) name("Graph") replace
	
	//////////////////////////////////////////////////////////////////////////// Dv =  B0 + ccq2_2
	
	reg copB2_3 ccq2_2 i.year i.state
	outreg2 using 09_VF_regresion_`x'_2.xls, append ctitle(E1_All) keep(ccq2_1 ccq2_2) addtext(FE, YS)
// 	predict y1_1
// 	scatter y1_1 pop90, title(`x'_y1_1) graphregion(color(white))
// 	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\09_VF_scatters_`x'\y1_1.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq2_2 i.year i.state if a > 0
	outreg2 using 09_VF_regresion_`x'_2.xls, append ctitle(E1_Obseverved) keep(ccq2_1 ccq2_2) addtext(FE, YS)
// 	predict y1_2 
// 	scatter y1_2 pop90 if a > 0, title(`x'_y1_2) graphregion(color(white))
// 	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\09_VF_scatters_`x'\y1_2.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq2_2 i.year i.state if activity == 1
	outreg2 using 09_VF_regresion_`x'_2.xls, append ctitle(E1_Activity) keep(ccq2_1 ccq2_2) addtext(FE, YS)
// 	predict y1_3
// 	scatter y1_3 pop90 if activity==1, title(`x'_y1_3) graphregion(color(white))
// 	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\09_VF_scatters_`x'\y1_3.png", as(png) name("Graph") replace
	
	
	//////////////////////////////////////////////////////////////////////////// Dv= d2*pop90 + d2*pop90^2
	
	
	reg copB2_3 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state
	outreg2 using 09_VF_regresion_`x'_2.xls, append ctitle(E2_All) keep(ccq2_1  ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict y2_1
	twoway (scatter y2_1 pop90) (qfit y2_1 pop90), title(`x'_y2_1) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\09_VF_scatters_`x'\y2_1.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state if a > 0
	outreg2 using 09_VF_regresion_`x'_2.xls, append ctitle(E2_Observed) keep(ccq2_1  ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict y2_2
	twoway (scatter y2_2 pop90) (qfit y2_2 pop90), title(`x'_y2_2) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\09_VF_scatters_`x'\y2_2.png", as(png) name("Graph") replace
	
	reg copB2_3  ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state if activity == 1
	outreg2 using 09_VF_regresion_`x'_2.xls, append ctitle(E2_Activity) keep(ccq2_1  ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict y2_3
	twoway (scatter y2_3 pop90) (qfit y2_3 pop90), title(`x'_y2_1) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\09_VF_scatters_`x'\y2_3.png", as(png) name("Graph") replace
	
	
	//////////////////////////////////////////////////////////////////////////// Dv= d1*pop90 + d1*pop90^2 + d2*pop90 + d2*pop90^2
	
	reg copB2_3 ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state
	outreg2 using 09_VF_regresion_`x'_2.xls, append ctitle(E3_All) keep(ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict y3_1
	twoway (scatter y3_1 pop90) (qfit y3_1 pop90), title(`x'_y3_1) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\09_VF_scatters_`x'\y3_1.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state if a > 0
	outreg2 using 09_VF_regresion_`x'_2.xls, append ctitle(E3_Observed) keep(ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict y3_2
	twoway (scatter y3_2 pop90) (qfit y3_2 pop90), title(`x'_y3_2) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\09_VF_scatters_`x'\y3_2.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state if activity == 1
	outreg2 using 09_VF_regresion_`x'_2.xls, append ctitle(E3_Activity) keep(ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict y3_3
	twoway (scatter y3_3 pop90) (qfit y3_3 pop90), title(`x'_y3_3) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\09_VF_scatters_`x'\y3_3.png", as(png) name("Graph") replace


	////////////////////////////////////////////////////////////////////////////
	
	erase 09_VF_regresion_`x'_2.txt

}

