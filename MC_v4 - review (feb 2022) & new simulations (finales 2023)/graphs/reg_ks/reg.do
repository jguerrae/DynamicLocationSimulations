
cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\graphs\reg_ks"



foreach x of numlist 1 2 3 {
	
	
	
	clear all

	use "`x'"
	// rename copB2_3 lq

	merge m:1 cfips using "state"
	drop _merge

	merge m:1 cfips using  "pop90"
	drop _merge

	merge 1:1 year cfips using  "activity"
	drop _merge

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
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\graphs\reg_ks\VF_scatters_`x'\pop_y1_1.png", as(png) name("Graph") replace
	
	
	reg copB2_3 pop90 pop90_2 i.year i.state if a > 0
	outreg2 using VF_regresion_`x'_2.xls, append ctitle(OBSERVED) keep(pop90 pop90_2) addtext(FE, YS)
	predict y1_2_pop
	twoway (scatter y1_2_pop pop90) (qfit y1_1_pop pop90), title(`x'_y1_2_pop) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\graphs\reg_ks\VF_scatters_`x'\pop_y1_2.png", as(png) name("Graph") replace

	reg copB2_3 pop90 pop90_2 i.year i.state if activity==1 
	outreg2 using VF_regresion_`x'_2.xls, append ctitle(ACTIVITY) keep(pop90 pop90_2) addtext(FE, YS)
	predict y1_3_pop
	twoway (scatter y1_3_pop pop90) (qfit y1_3_pop pop90), title(`x'_y1_3_pop) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\graphs\reg_ks\VF_scatters_`x'\pop_y1_3.png", as(png) name("Graph") replace
	
	preserve
	drop y1_1_pop y1_2_pop y1_3_pop
	drop if year >= 1909
	
	reg copB2_3 pop90 pop90_2 i.year i.state  
	outreg2 using VF_85_regresion_`x'_2.xls, replace ctitle(ALL) keep(pop90 pop90_2) addtext(FE, YS)
	predict y1_1_pop
	twoway (scatter y1_1_pop pop90) (qfit y1_1_pop pop90), title(`x'_y1_1_pop) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\graphs\reg_ks\08_VF_scatters_`x'\pop_y1_1.png", as(png) name("Graph") replace

	reg copB2_3 pop90 pop90_2 i.year i.state if a > 0
	outreg2 using VF_85_regresion_`x'_2.xls, append ctitle(OBSERVED) keep(pop90 pop90_2) addtext(FE, YS)
	predict y1_2_pop
	twoway (scatter y1_2_pop pop90) (qfit y1_2_pop pop90), title(`x'_y1_2_pop) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\graphs\reg_ks\08_VF_scatters_`x'\pop_y1_2.png", as(png) name("Graph") replace

	reg copB2_3 pop90 pop90_2 i.year i.state if activity==1 
	outreg2 using VF_85_regresion_`x'_2.xls, append ctitle(ACTIVITY) keep(pop90 pop90_2) addtext(FE, YS)
	predict y1_3_pop
	twoway (scatter y1_3_pop pop90) (qfit y1_3_pop pop90), title(`x'_y1_3_pop) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\graphs\reg_ks\08_VF_scatters_`x'\pop_y1_3.png", as(png) name("Graph") replace
	
	
	restore
	
	preserve
	drop y1_1_pop y1_2_pop y1_3_pop
	drop if year < 1909
	
	reg copB2_3 pop90 pop90_2 i.year i.state  
	outreg2 using VF_09_regresion_`x'_2.xls, replace ctitle(ALL) keep(pop90 pop90_2) addtext(FE, YS)
	predict y1_1_pop
	twoway (scatter y1_1_pop pop90) (qfit y1_1_pop pop90), title(`x'_y1_1_pop) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\graphs\reg_ks\09_VF_scatters_`x'\pop_y1_1.png", as(png) name("Graph") replace

	reg copB2_3 pop90 pop90_2 i.year i.state if a > 0
	outreg2 using VF_09_regresion_`x'_2.xls, append ctitle(OBSERVED) keep(pop90 pop90_2) addtext(FE, YS)
	predict y1_2_pop
	twoway (scatter y1_2_pop pop90) (qfit y1_2_pop pop90), title(`x'_y1_2_pop) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\graphs\reg_ks\09_VF_scatters_`x'\pop_y1_2.png", as(png) name("Graph") replace

	reg copB2_3 pop90 pop90_2 i.year i.state if activity==1 
	outreg2 using VF_09_regresion_`x'_2.xls, append ctitle(ACTIVITY) keep(pop90 pop90_2) addtext(FE, YS)
	predict y1_3_pop
	twoway (scatter y1_3_pop pop90) (qfit y1_3_pop pop90), title(`x'_y1_3_pop) legend(label(1 "predict") label(2 "adjust")) graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\graphs\reg_ks\09_VF_scatters_`x'\pop_y1_3.png", as(png) name("Graph") replace
	
	restore
	
}
