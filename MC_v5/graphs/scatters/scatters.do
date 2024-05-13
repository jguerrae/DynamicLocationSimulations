clear all

//aqui está toda la muestra
use "lq_ipolate_complete"
rename copB2_3 lq

merge m:1 cfips using "c_name"
drop _merge

merge 1:1 year cfips using "1"
drop _merge

foreach x of numlist 1900 1910 1920 1930 {
	
	twoway (scatter lq copB2_3,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==`x', xtitle(copB2_3 `x') ytitle (LQ) graphregion(color(white))
	graph export "1_LQ_COP_`x'.png", as(png) name("Graph") replace
	
}



//aquí están solo los que tenían valores de LQ - Se dejara esta para poder comparae


cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v5\graphs\scatters"

foreach k of numlist  1 {
	
	clear all

	use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v5\graphs\\`k'" //Los que están acá ubicados son dinámicos

	merge 1:1 cfips year using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v5\graphs\lq_original"
	drop _merge

	rename lqnestab lq

	foreach x of numlist 1900 {
		
		twoway (scatter lq copB2_3,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==`x', xtitle(copB2_3 `x') ytitle (LQ) graphregion(color(white)) xscale(range(0 250)) ///
		title (`k'_`x')
		graph export "`k'_LQ_COP_`x'.png", as(png) name("Graph") replace
		
	}
	
	
}

cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v5\graphs\scatters"

foreach k of numlis  1  {
	
	clear all

	use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v5\graphs\\`k'" //Los que están acá ubicados son dinámicos

	merge 1:1 cfips year using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v5\graphs\lq_original"
	drop _merge

	rename lqnestab lq

	foreach x of numlist  1910 1920 1930 {
		
		twoway (scatter lq copB2_3,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==`x', xtitle(copB2_3 `x') ytitle (LQ) graphregion(color(white)) xscale(range(0 500)) ///
		title (`k'_`x')
		graph export "`k'_LQ_COP_`x'.png", as(png) name("Graph") replace
		
	}
	
	
}