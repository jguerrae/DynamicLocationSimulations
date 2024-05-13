clear all

//GUARDAR UNA BASE QUE SOLO TENGA LAS VARIABLES DEL AÑO DE INTERÉS Y PARA 1930 (CON TODAS LAS FIRMAS)
cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\Investigaciones auxiliares\distribuciones de edades (1_5-01-2021)"
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v2\MC_outputdata_random_PLC.dta"
keep if year==1930
keep agedraw1 agedraw2 repid
save "distribuciones_edades.dta", replace

//GUARDAR UNA BASE CON CADA REPLICACIÓN
foreach x of numlist 100 200 300 400 500 600 700 800 900 1000 { 
	clear all
	use "distribuciones_edades.dta"
	keep if repid==`x' 
	gen N = _n
	rename agedraw1 agedraw1_`x' 
	rename agedraw2 agedraw2_`x'
	save "distribuciones_edades_repid_`x'.dta", replace
}

//UNIR TODAS ESAS BASES EN UNA SOLA
clear all

use "MC_inputdata_age.dta"
foreach x of numlist 100 200 300 400 500 600 700 800 900 1000 { 
	merge 1:1 N using "distribuciones_edades_repid_`x'.dta"
	drop _merge
}
save "distribuciones_edades_MC&observadas", replace


//HACER GRÁFICAS DE LAS DISTRIBUCIONES
foreach x of numlist 100 200 300 400 500 600 700 800 900 1000 { 
	twoway (histogram aa, discrete fcolor(black) lcolor(black) graphregion(color(white))) (histogram agedraw1_`x', discrete fcolor(gray) lcolor(gray) graphregion(color(white))), legend(order(1 "Observerd" 2 "Agedraw1_rep_`x'"))
	graph export "H_Observed_Agedraw1_rep_`x'.png", as(png) name("Graph")
}

//HACER GRÁFICAS DE LAS DISTRIBUCIONES
foreach x of numlist 100 200 300 400 500 600 700 800 900 1000 { 
	twoway (histogram aa, discrete fcolor(black) lcolor(black) graphregion(color(white))) (histogram agedraw2_`x', discrete fcolor(gray) lcolor(gray) graphregion(color(white))), legend(order(1 "Observerd" 2 "Agedraw2_rep_`x'"))
	graph export "H_Observed_Agedraw2_rep_`x'.png", as(png) name("Graph")
}
