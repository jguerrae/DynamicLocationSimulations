******************************************************************************************************************
******************************************************************************************************************
**********************************************REGRESIONES*********************************************************
******************************************************************************************************************
******************************************************************************************************************


*1: KS; 2:MKT; 3:NESTAB

***** Specification 1: Lineal Efffects of county size *****

foreach x of numlist 1 2 3 {

	clear all

	cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions"

	use "`x'"
	
	gen ccq5_2 =0 
	
	replace ccq5_2 = 1 if ccq5_0==1 & ccq5_1==0 & ccq5_3==0 & ccq5_4==0 

	*MCO
	
	*All sample
	reg copB2_3 ccq5_1 ccq5_2 ccq5_3 ccq5_4 i.year i.state 
	outreg2 using 1_regresion_`x'_5.xls, replace ctitle(ALL) keep(ccq5_1 ccq5_2 ccq5_3 ccq5_4) addtext(FE, YS, observed, ALL, activity, ALL)
	
	*Observed > 1 sample
	reg copB2_3 ccq5_1 ccq5_2 ccq5_3 ccq5_4 i.year i.state if a > 0
	outreg2 using 1_regresion_`x'_5.xls, append ctitle(OBSERVED) keep(ccq5_1 ccq5_2 ccq5_3 ccq5_4) addtext(FE, YS, observed, >0, activity, ALL)
	
	*Activity Sample
	reg copB2_3 ccq5_1 ccq5_2 ccq5_3 ccq5_4 i.year  i.state if activity == 1
	outreg2 using 1_regresion_`x'_5.xls, append ctitle(ACTIVITY) keep(ccq5_1 ccq5_2 ccq5_3 ccq5_4) addtext(FE, YS, observed, ALL, activity, >0)
	

	*LOGIT
	logit Cp90  ccq5_1 ccq5_2 ccq5_3 ccq5_4 i.year i.state 
	margins , dydx(ccq5_1 ccq5_2 ccq5_3 ccq5_4) atmeans
	outreg2 using 1_regresion_`x'_5.xls, append ctitle(L_ALL) keep(ccq5_1 ccq5_2 ccq5_3 ccq5_4) addtext(FE, YS, observed, ALL, activity, ALL)

	logit Cp90  ccq5_1 ccq5_2 ccq5_3 ccq5_4 i.year i.state if a > 0 
	outreg2 using 1_regresion_`x'_5.xls, append ctitle(L_OBSERVED) keep(ccq5_1 ccq5_2 ccq5_3 ccq5_4) addtext(FE, YS, observed, >0, activity, ALL)

	logit Cp90  ccq5_1 ccq5_2 ccq5_3 ccq5_4 i.year  i.state if activity == 1
	outreg2 using 1_regresion_`x'_5.xls, append ctitle(L_ACTIVITY) keep(ccq5_1 ccq5_2 ccq5_3 ccq5_4) addtext(FE, YS, observed, ALL, activity, >0)

	erase 1_regresion_`x'_5.txt
	
}



***** Specification Pop: Quadratic Efffects of county size *****

foreach x of numlist  1 {

	clear all
	cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions"
	use "`x'"
	
	merge m:1 cfips using "pop90"
	
	gen pop90_2 = pop90*pop90
	
	gen V = `x'
	
	*MCO

	
// 	*LOGIT (1 backed up)
// 	capture logit Cp90 pop90 pop90_2 if V!=1
// 	outreg2 using pop_regresion_`x'.xls, append ctitle(L_ALL) keep(pop90 pop90_2) addtext(FE, YS, observed, ALL, activity, ALL)
//
// 	logit Cp90 pop90 pop90_2 i.year i.state if a > 0 
// 	outreg2 using pop_regresion_`x'.xls, append ctitle(L_OBSERVED) keep(pop90 pop90_2) addtext(FE, YS, observed, >0, activity, ALL)
//
// 	logit Cp90 pop90 pop90_2 i.year i.state if activity == 1 
// 	outreg2 using pop_regresion_`x'.xls, append ctitle(L_ACTIVITY) keep(pop90 pop90_2) addtext(FE, YS, observed, ALL, activity, >0)
//
// 	erase pop_regresion_`x'.txt

}
	
	
	
	

	
	
***** Specification 2: Quadratic Efffects of county size * quintiles county size & quintiles county size *****
	
cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions"
	
foreach x of numlist  1 2 3 {

	clear all
	use "`x'"
	
	merge m:1 cfips using "pop90"
	
	gen pop90_2 = pop90*pop90
	
	gen ccq5_4_pop90 = ccq5_4 * pop90
	gen ccq5_4_pop90_2 = ccq5_4 * pop90_2
	
	gen ccq5_3_pop90 = ccq5_3 * pop90
	gen ccq5_3_pop90_2 = ccq5_3 * pop90_2
	
	gen ccq5_2 =0 
	replace ccq5_2 = 1 if ccq5_0==1 & ccq5_1==0 & ccq5_3==0 & ccq5_4==0
	
	//////////////////////////////////////////////////////////////////////////// Dv = d1 + d2 + d3 + d4
	
	
	reg copB2_3 ccq5_1 ccq5_2 ccq5_3 ccq5_4 i.year i.state
	outreg2 using 2_regresion_`x'_5.xls, replace ctitle(E1_All) keep(ccq5_1 ccq5_2 ccq5_3 ccq5_4) addtext(FE, YS)
	predict y1_1
	scatter y1_1 pop90, title(`x'_y1_1)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\2_scatters_`x'\y1_1.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq5_1 ccq5_2 ccq5_3 ccq5_4 i.year i.state if a > 0
	outreg2 using 2_regresion_`x'_5.xls, append ctitle(E1_Obseverved) keep(ccq5_1 ccq5_2 ccq5_3 ccq5_4) addtext(FE, YS)
	predict y1_2 
	scatter y1_2 pop90 if a > 0, title(`x'_y1_2)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\2_scatters_`x'\y1_2.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq5_1 ccq5_2 ccq5_3 ccq5_4 i.year i.state if activity == 1
	outreg2 using 2_regresion_`x'_5.xls, append ctitle(E1_Activity) keep(ccq5_1 ccq5_2 ccq5_3 ccq5_4) addtext(FE, YS)
	predict y1_3 if activity == 1
	scatter y1_3 pop90 if activity==1, title(`x'_y1_3)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\2_scatters_`x'\y1_3.png", as(png) name("Graph") replace
	
	
	
	logit Cp90  ccq5_1 ccq5_2 ccq5_3 ccq5_4 i.year i.state
	outreg2 using 2_regresion_`x'_5.xls, append ctitle(LE1_All) keep(ccq5_1 ccq5_2 ccq5_3 ccq5_4) addtext(FE, YS)
	predict l1_1
	scatter l1_1 pop90, title(`x'_l1_1)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\2_scatters_`x'\l1_1.png", as(png) name("Graph") replace
	
	logit Cp90  ccq5_1 ccq5_2 ccq5_3 ccq5_4 i.year i.state if a > 0
	outreg2 using 2_regresion_`x'_5.xls, append ctitle(LE1_Obseverved) keep(ccq5_1 ccq5_2 ccq5_3 ccq5_4) addtext(FE, YS)
	predict l1_2
	scatter l1_2 pop90 if a > 0, title(`x'_l1_2)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\2_scatters_`x'\l1_2.png", as(png) name("Graph") replace
	
	logit Cp90  ccq5_1 ccq5_2 ccq5_3 ccq5_4 i.year i.state if activity == 1
	outreg2 using 2_regresion_`x'_5.xls, append ctitle(LE1_Activity) keep(ccq5_1 ccq5_2 ccq5_3 ccq5_4) addtext(FE, YS)
	predict l1_3
	scatter l1_3 pop90 if activity==1, title(`x'_l1_3)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\2_scatters_`x'\l1_3.png", as(png) name("Graph") replace
	
	
	//////////////////////////////////////////////////////////////////////////// Dv= d1 + d2 + d3 + d4*pop90 + d4*pop90^2
	
	
	reg copB2_3 ccq5_1 ccq5_2 ccq5_3 ccq5_4_pop90 ccq5_4_pop90_2 i.year i.state
	outreg2 using 2_regresion_`x'_5.xls, append ctitle(E2_All) keep(ccq5_1 ccq5_2 ccq5_3 ccq5_4_pop90 ccq5_4_pop90_2) addtext(FE, YS)
	predict y2_1
	scatter y2_1 pop90, title(`x'_y2_1)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\2_scatters_`x'\y2_1.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq5_1 ccq5_2 ccq5_3 ccq5_4_pop90 ccq5_4_pop90_2 i.year i.state if a > 0
	outreg2 using 2_regresion_`x'_5.xls, append ctitle(E2_Observed) keep(ccq5_1 ccq5_2 ccq5_3 ccq5_4_pop90 ccq5_4_pop90_2) addtext(FE, YS)
	predict y2_2
	scatter y2_2 pop90 if a > 0, title(`x'_y2_2)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\2_scatters_`x'\y2_2.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq5_1 ccq5_2 ccq5_3 ccq5_4_pop90 ccq5_4_pop90_2 i.year i.state if activity == 1
	outreg2 using 2_regresion_`x'_5.xls, append ctitle(E2_Activity) keep(ccq5_1 ccq5_2 ccq5_3 ccq5_4_pop90 ccq5_4_pop90_2) addtext(FE, YS)
	predict y2_3
	scatter y2_3 pop90 if activity==1, title(`x'_y2_3)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\2_scatters_`x'\y2_3.png", as(png) name("Graph") replace
	
	
	logit Cp90 ccq5_1 ccq5_2 ccq5_3 ccq5_4_pop90 ccq5_4_pop90_2 i.year i.state
	outreg2 using 2_regresion_`x'_5.xls, append ctitle(LE2_All) keep(ccq5_1 ccq5_2 ccq5_3 ccq5_4_pop90 ccq5_4_pop90_2) addtext(FE, YS)
	predict l2_1
	scatter l2_1 pop90, title(`x'_l2_3)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\2_scatters_`x'\l2_1.png", as(png) name("Graph") replace
	
	logit Cp90 ccq5_1 ccq5_2 ccq5_3 ccq5_4_pop90 ccq5_4_pop90_2 i.year i.state if a > 0
	outreg2 using 2_regresion_`x'_5.xls, append ctitle(LE2_Observed) keep(ccq5_1 ccq5_2 ccq5_3 ccq5_4_pop90 ccq5_4_pop90_2) addtext(FE, YS)
	predict l2_2
	scatter l2_2 pop90 if a > 0, title(`x'_l2_3)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\2_scatters_`x'\l2_2.png", as(png) name("Graph") replace
	
	logit Cp90 ccq5_1 ccq5_2 ccq5_3 ccq5_4_pop90 ccq5_4_pop90_2 i.year i.state if activity == 1
	outreg2 using 2_regresion_`x'_5.xls, append ctitle(LE2_Activity) keep(ccq5_1 ccq5_2 ccq5_3 ccq5_4_pop90 ccq5_4_pop90_2) addtext(FE, YS)
	predict l2_3
	scatter l2_3 pop90 if activity==1, title(`x'_l2_3)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\2_scatters_`x'\l2_3.png", as(png) name("Graph") replace
	
	//////////////////////////////////////////////////////////////////////////// Dv=d1 + d2 + d3*pop90 + d3*pop90^2 + d4*pop90 + d4*pop90^2
	
	reg copB2_3 ccq5_1 ccq5_2 ccq5_3_pop90 ccq5_3_pop90_2 ccq5_4_pop90 ccq5_4_pop90_2 i.year i.state
	outreg2 using 2_regresion_`x'_5.xls, append ctitle(E3_All) keep(ccq5_1 ccq5_2 ccq5_3_pop90 ccq5_3_pop90_2 ccq5_4_pop90 ccq5_4_pop90_2) addtext(FE, YS)
	predict y3_1
	scatter y3_1 pop90, title(`x'_y3_1)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\2_scatters_`x'\y3_1.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq5_1 ccq5_2 ccq5_3_pop90 ccq5_3_pop90_2 ccq5_4_pop90 ccq5_4_pop90_2 i.year i.state if a > 0
	outreg2 using 2_regresion_`x'_5.xls, append ctitle(E3_All) keep(ccq5_1 ccq5_2 ccq5_3_pop90 ccq5_3_pop90_2 ccq5_4_pop90 ccq5_4_pop90_2) addtext(FE, YS)
	predict y3_2
	scatter y3_2 pop90 if a > 0, title(`x'_y3_2)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\2_scatters_`x'\y3_2.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq5_1 ccq5_2 ccq5_3_pop90 ccq5_3_pop90_2 ccq5_4_pop90 ccq5_4_pop90_2 i.year i.state if activity == 1
	outreg2 using 2_regresion_`x'_5.xls, append ctitle(E3_All) keep(ccq5_1 ccq5_2 ccq5_3_pop90 ccq5_3_pop90_2 ccq5_4_pop90 ccq5_4_pop90_2) addtext(FE, YS)
	predict y3_3
	scatter y3_3 pop90 if activity==1, title(`x'_y3_3)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\2_scatters_`x'\y3_3.png", as(png) name("Graph") replace

	
	logit Cp90 ccq5_1 ccq5_2 ccq5_3_pop90 ccq5_3_pop90_2 ccq5_4_pop90 ccq5_4_pop90_2 i.year i.state
	outreg2 using 2_regresion_`x'_5.xls, append ctitle(LE3_All) keep(ccq5_1 ccq5_2 ccq5_3_pop90 ccq5_3_pop90_2 ccq5_4_pop90 ccq5_4_pop90_2) addtext(FE, YS)
	predict l3_1
	scatter l3_1 pop90, title(`x'_l3_3)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\2_scatters_`x'\l3_1.png", as(png) name("Graph") replace
	
	logit Cp90 ccq5_1 ccq5_2 ccq5_3_pop90 ccq5_3_pop90_2 ccq5_4_pop90 ccq5_4_pop90_2 i.year i.state if a > 0
	outreg2 using 2_regresion_`x'_5.xls, append ctitle(LE3_All) keep(ccq5_1 ccq5_2 ccq5_3_pop90 ccq5_3_pop90_2 ccq5_4_pop90 ccq5_4_pop90_2) addtext(FE, YS)
	predict l3_2
	scatter l3_2 pop90 if a > 0, title(`x'_l3_3)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\2_scatters_`x'\l3_2.png", as(png) name("Graph") replace
	
	logit Cp90 ccq5_1 ccq5_2 ccq5_3_pop90 ccq5_3_pop90_2 ccq5_4_pop90 ccq5_4_pop90_2 i.year i.state if activity == 1
	outreg2 using 2_regresion_`x'_5.xls, append ctitle(LE3_All) keep(ccq5_1 ccq5_2 ccq5_3_pop90 ccq5_3_pop90_2 ccq5_4_pop90 ccq5_4_pop90_2) addtext(FE, YS)
	predict l3_3
	scatter l3_3 pop90 if activity==1, title(`x'_l3_3)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\2_scatters_`x'\l3_3.png", as(png) name("Graph") replace

	
	////////////////////////////////////////////////////////////////////////////
	
	erase 2_regresion_`x'_5.txt
}



***** Specification 3: Only Quadratic Efffects of county size * quintile county size *****

cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions"
	
foreach x of numlist  1 2 3 {

	clear all
	use "`x'"
	
	gen V = `x'
	
	merge m:1 cfips using "pop90"
	
	gen pop90_2 = pop90*pop90
	
	gen ccq5_4_pop90 = ccq5_4 * pop90
	gen ccq5_4_pop90_2 = ccq5_4 * pop90_2
	
	gen ccq5_3_pop90 = ccq5_3 * pop90
	gen ccq5_3_pop90_2 = ccq5_3 * pop90_2
	
	gen ccq5_2 =0 
	replace ccq5_2 = 1 if ccq5_0==1 & ccq5_1==0 & ccq5_3==0 & ccq5_4==0
	
	
	//////////////////////////////////////////////////////////////////////////// Dv = d1 + d2 + d3 + d4
	//YA NO SE HARÁN
	
	//////////////////////////////////////////////////////////////////////////// Dv= d1 + d2 + d3 + d4*pop90 + d4*pop90^2 
	//SE HARÁN SIN LAS DUMMIES
	
	
	reg copB2_3 ccq5_4_pop90 ccq5_4_pop90_2 i.year i.state
	outreg2 using 3_regresion_`x'_5.xls, append ctitle(E2_All) keep(ccq5_4_pop90 ccq5_4_pop90_2) addtext(FE, YS)
	predict y2_1
	scatter y2_1 pop90, title(`x'_y2_1)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\3_scatters_`x'\y2_1.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq5_4_pop90 ccq5_4_pop90_2 i.year i.state if a > 0
	outreg2 using 3_regresion_`x'_5.xls, append ctitle(E2_Observed) keep(ccq5_4_pop90 ccq5_4_pop90_2) addtext(FE, YS)
	predict y2_2
	scatter y2_2 pop90 if a > 0, title(`x'_y2_2)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\3_scatters_`x'\y2_2.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq5_4_pop90 ccq5_4_pop90_2 i.year i.state if activity == 1
	outreg2 using 3_regresion_`x'_5.xls, append ctitle(E2_Activity) keep(ccq5_4_pop90 ccq5_4_pop90_2) addtext(FE, YS)
	predict y2_3
	scatter y2_3 pop90 if activity==1, title(`x'_y2_3)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\3_scatters_`x'\y2_3.png", as(png) name("Graph") replace
	
	logit Cp90 ccq5_4_pop90 ccq5_4_pop90_2 i.year i.state
	outreg2 using 3_regresion_`x'_5.xls, append ctitle(LE2_All) keep(ccq5_4_pop90 ccq5_4_pop90_2) addtext(FE, YS)
	predict l2_1
	scatter l2_1 pop90, title(`x'_l2_3)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\3_scatters_`x'\l2_1.png", as(png) name("Graph") replace
	
	logit Cp90 ccq5_4_pop90 ccq5_4_pop90_2 i.year i.state if a > 0
	outreg2 using 3_regresion_`x'_5.xls, append ctitle(LE2_Observed) keep(ccq5_4_pop90 ccq5_4_pop90_2) addtext(FE, YS)
	predict l2_2
	scatter l2_2 pop90 if a > 0, title(`x'_l2_3)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\3_scatters_`x'\l2_2.png", as(png) name("Graph") replace
	
	logit Cp90 ccq5_4_pop90 ccq5_4_pop90_2 i.year i.state if activity == 1
	outreg2 using 3_regresion_`x'_5.xls, append ctitle(LE2_Activity) keep(ccq5_4_pop90 ccq5_4_pop90_2) addtext(FE, YS)
	predict l2_3
	scatter l2_3 pop90 if activity==1, title(`x'_l2_3)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\3_scatters_`x'\l2_3.png", as(png) name("Graph") replace
	
	//////////////////////////////////////////////////////////////////////////// Dv=d1 + d2 + d3*pop90 + d3*pop90^2 + d4*pop90 + d4*pop90^2
	
	reg copB2_3 ccq5_3_pop90 ccq5_3_pop90_2 ccq5_4_pop90 ccq5_4_pop90_2 i.year i.state
	outreg2 using 3_regresion_`x'_5.xls, append ctitle(E3_All) keep(ccq5_3_pop90 ccq5_3_pop90_2 ccq5_4_pop90 ccq5_4_pop90_2) addtext(FE, YS)
	predict y3_1
	scatter y3_1 pop90, title(`x'_y3_1)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\3_scatters_`x'\y3_1.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq5_3_pop90 ccq5_3_pop90_2 ccq5_4_pop90 ccq5_4_pop90_2 i.year i.state if a > 0
	outreg2 using 3_regresion_`x'_5.xls, append ctitle(E3_Observed) keep(ccq5_3_pop90 ccq5_3_pop90_2 ccq5_4_pop90 ccq5_4_pop90_2) addtext(FE, YS)
	predict y3_2
	scatter y3_2 pop90 if a > 0, title(`x'_y3_2)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\3_scatters_`x'\y3_2.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq5_3_pop90 ccq5_3_pop90_2 ccq5_4_pop90 ccq5_4_pop90_2 i.year i.state if activity == 1
	outreg2 using 3_regresion_`x'_5.xls, append ctitle(E3_Activity) keep(ccq5_3_pop90 ccq5_3_pop90_2 ccq5_4_pop90 ccq5_4_pop90_2) addtext(FE, YS)
	predict y3_3
	scatter y3_3 pop90 if activity==1, title(`x'_y3_3)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\3_scatters_`x'\y3_3.png", as(png) name("Graph") replace
	
	capture logit Cp90 ccq5_3_pop90 ccq5_3_pop90_2 ccq5_4_pop90 ccq5_4_pop90_2 i.year i.state if 
	outreg2 using 3_regresion_`x'_5.xls, append ctitle(LE3_Observed) keep(ccq5_3_pop90 ccq5_3_pop90_2 ccq5_4_pop90 ccq5_4_pop90_2) addtext(FE, YS)
	predict l3_1
	scatter l3_1 pop90, title(`x'_l3_3)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\3_scatters_`x'\l3_1.png", as(png) name("Graph") replace
	
	logit Cp90 ccq5_3_pop90 ccq5_3_pop90_2 ccq5_4_pop90 ccq5_4_pop90_2 i.year i.state if a > 0
	outreg2 using 3_regresion_`x'_5.xls, append ctitle(LE3_Activity) keep(ccq5_3_pop90 ccq5_3_pop90_2 ccq5_4_pop90 ccq5_4_pop90_2) addtext(FE, YS)
	predict l3_2
	scatter l3_2 pop90 if a > 0, title(`x'_l3_3)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\3_scatters_`x'\l3_2.png", as(png) name("Graph") replace
	
	logit Cp90 ccq5_3_pop90 ccq5_3_pop90_2 ccq5_4_pop90 ccq5_4_pop90_2 i.year i.state if activity == 1
	outreg2 using 3_regresion_`x'_5.xls, append ctitle(LE3_All) keep(ccq5_3_pop90 ccq5_3_pop90_2 ccq5_4_pop90 ccq5_4_pop90_2) addtext(FE, YS)
	predict l3_3
	scatter l3_3 pop90 if activity==1, title(`x'_l3_3)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\3_scatters_`x'\l3_3.png", as(png) name("Graph") replace

	
	////////////////////////////////////////////////////////////////////////////
	
	erase 3_regresion_`x'_5.txt
}




***** Specification 4: Quadratic Efffects of county size * median county size & median county size *****

cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions"
	
foreach x of numlist  1{

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
	
	//////////////////////////////////////////////////////////////////////////// Dv =  d2 
	
	
	reg copB2_3 ccq2_2 i.year i.state
	outreg2 using 4_regresion_`x'_2.xls, replace ctitle(E1_All) keep(ccq2_1 ccq2_2) addtext(FE, YS)
	predict y1_1
	scatter y1_1 pop90, title(`x'_y1_1)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\4_scatters_`x'\y1_1.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq2_2 i.year i.state if a > 0
	outreg2 using 4_regresion_`x'_2.xls, append ctitle(E1_Obseverved) keep(ccq2_1 ccq2_2) addtext(FE, YS)
	predict y1_2 
	scatter y1_2 pop90 if a > 0, title(`x'_y1_2)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\4_scatters_`x'\y1_2.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq2_2 i.year i.state if activity == 1
	outreg2 using 4_regresion_`x'_2.xls, append ctitle(E1_Activity) keep(ccq2_1 ccq2_2) addtext(FE, YS)
	predict y1_3 if activity == 1
	scatter y1_3 pop90 if activity==1, title(`x'_y1_3)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\4_scatters_`x'\y1_3.png", as(png) name("Graph") replace
	
	
	logit Cp90  ccq2_2 i.year i.state
	outreg2 using 4_regresion_`x'_2.xls, append ctitle(LE1_All) keep(ccq2_1 ccq2_2) addtext(FE, YS)
	predict l1_1
	scatter l1_1 pop90, title(`x'_l1_1)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\4_scatters_`x'\l1_1.png", as(png) name("Graph") replace
	
	logit Cp90  ccq2_2 i.year i.state if a > 0
	outreg2 using 4_regresion_`x'_2.xls, append ctitle(LE1_Obseverved) keep(ccq2_1 ccq2_2) addtext(FE, YS)
	predict l1_2
	scatter l1_2 pop90 if a > 0, title(`x'_l1_2)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\4_scatters_`x'\l1_2.png", as(png) name("Graph") replace
	
	logit Cp90  ccq2_2 i.year i.state if activity == 1
	outreg2 using 4_regresion_`x'_2.xls, append ctitle(LE1_Activity) keep(ccq2_1 ccq2_2) addtext(FE, YS)
	predict l1_3
	scatter l1_3 pop90 if activity==1, title(`x'_l1_3)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\4_scatters_`x'\l1_3.png", as(png) name("Graph") replace
//	
	
	//////////////////////////////////////////////////////////////////////////// Dv= d1 + d2*pop90 + d2*pop90^2
	
	
	reg copB2_3 ccq2_1 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state
	outreg2 using 4_regresion_`x'_2.xls, append ctitle(E2_All) keep(ccq2_1  ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict y2_1
	twoway (scatter y2_1 pop90) (qfit y2_1 pop90), title(`x'_y2_1) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\4_scatters_`x'\y2_1.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq2_1 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state if a > 0
	outreg2 using 4_regresion_`x'_2.xls, append ctitle(E2_Observed) keep(ccq2_1  ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict y2_2
	twoway (scatter y2_2 pop90) (qfit y2_2 pop90), title(`x'_y2_2) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\4_scatters_`x'\y2_2.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq2_1 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state if activity == 1
	outreg2 using 4_regresion_`x'_2.xls, append ctitle(E2_Activity) keep(ccq2_1  ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict y2_3
	twoway (scatter y2_3 pop90) (qfit y2_3 pop90), title(`x'_y2_1) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\4_scatters_`x'\y2_3.png", as(png) name("Graph") replace
	
	
	capture logit Cp90 ccq2_1 ccq2_2_pop90 ccq2_2_pop90_2 i.year i.state
	outreg2 using 4_regresion_`x'_2.xls, append ctitle(LE2_All) keep(ccq2_1  ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict l2_1
	scatter l2_1 pop90, title(`x'_l2_3)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\4_scatters_`x'\l2_1.png", as(png) name("Graph") replace
	
	logit Cp90 ccq2_1 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state if a > 0
	outreg2 using 4_regresion_`x'_2.xls, append ctitle(LE2_Observed) keep(ccq2_1  ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict l2_2
	scatter l2_2 pop90 if a > 0, title(`x'_l2_3)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\4_scatters_`x'\l2_2.png", as(png) name("Graph") replace
	
	logit Cp90 ccq2_1  ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state if activity == 1
	outreg2 using 4_regresion_`x'_2.xls, append ctitle(LE2_Activity) keep(ccq2_1  ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict l2_3
	scatter l2_3 pop90 if activity==1, title(`x'_l2_3)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\4_scatters_`x'\l2_3.png", as(png) name("Graph") replace
	
	//////////////////////////////////////////////////////////////////////////// Dv= d1*pop90 + d1*pop90^2 + d2*pop90 + d2*pop90^2
	
	reg copB2_3 ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state
	outreg2 using 4_regresion_`x'_2.xls, append ctitle(E3_All) keep(ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict y3_1
	twoway (scatter y3_1 pop90) (qfit y3_1 pop90), title(`x'_y3_1) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\4_scatters_`x'\y3_1.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state if a > 0
	outreg2 using 4_regresion_`x'_2.xls, append ctitle(E3_Observed) keep(ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict y3_2
	twoway (scatter y3_2 pop90) (qfit y3_2 pop90), title(`x'_y3_2) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\4_scatters_`x'\y3_2.png", as(png) name("Graph") replace
	
	reg copB2_3 ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state if activity == 1
	outreg2 using 4_regresion_`x'_2.xls, append ctitle(E3_Activity) keep(ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict y3_3
	twoway (scatter y3_3 pop90) (qfit y3_3 pop90), title(`x'_y3_3) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\4_scatters_`x'\y3_3.png", as(png) name("Graph") replace

	
	capture ogit Cp90 ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state if V!=1
	outreg2 using 4_regresion_`x'_2.xls, append ctitle(LE3_All) keep(ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict l3_1
	scatter l3_1 pop90, title(`x'_l3_1)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\4_scatters_`x'\l3_1.png", as(png) name("Graph") replace
	
	logit Cp90 ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state if a > 0
	outreg2 using 4_regresion_`x'_2.xls, append ctitle(LE3_Observed) keep(ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict l3_2
	scatter l3_2 pop90 if a > 0, title(`x'_l3_2)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\4_scatters_`x'\l3_2.png", as(png) name("Graph") replace
	
	logit Cp90 ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2 i.year i.state if activity == 1
	outreg2 using 4_regresion_`x'_2.xls, append ctitle(LE3_Activity) keep(ccq2_1_pop90 ccq2_1_pop90_2 ccq2_2_pop90  ccq2_2_pop90_2) addtext(FE, YS)
	predict l3_3
	scatter l3_3 pop90 if activity==1, title(`x'_l3_3)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\4_scatters_`x'\l3_3.png", as(png) name("Graph") replace

	
	////////////////////////////////////////////////////////////////////////////
	
	erase 4_regresion_`x'_2.txt

}


