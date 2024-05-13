///ARCHIVO DE INTERPOLACIÓN DE FKMT
//SEGUNDO ARCHIVO DE PROCESAMIENTO


clear all

cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4 - repaso Jorge (feb 2022) y nuevas estimaciones (finales 2023)\interpolation"

use "nestab"

merge m:1 cfips using "1925" //MERGE CON AQUELLOS CFIPS QUE PERTENECN A LOS 1925
drop _merge


merge 1:1 cfips year using "mkt"
drop _merge

merge 1:1 cfips year using "fmkt"
drop _merge

merge 1:1 cfips year using "ks"
drop _merge

drop index
keep if D1925==1 & year > 1889 //SOLO CONSERVAR LOS 1925 Y DEPSUÉS DE 1890


//INTERPOLACIÓN
by cfips: ipolate nestab year, gen(nestab_i) epolate
by cfips: ipolate mkt year, gen(mkt_i) epolate
by cfips: ipolate fmkt year, gen(fmkt_i) epolate
by cfips: ipolate ks_tot year, gen(ks_i) epolate

sort cfips year

//SHARES

bysort year: egen nestab_i_sum = sum(nestab_i)
gen nestab_d = (nestab_i / nestab_i_sum)

bysort year: egen mkt_i_sum = sum(mkt_i)
gen mkt_d = (mkt_i / mkt_i_sum)

bysort year: egen fmkt_i_sum = sum(fmkt_i)
gen fmkt_d = (fmkt_i / fmkt_i_sum)

bysort year: egen ks_i_sum = sum(ks_i)
gen ks_d = (ks_i / ks_i_sum)

//SOLO CONSERVAR SHARES
keep cfips year nestab_d ks_d mkt_d fmkt_d D1925
keep if D1925==1 & year > 1894


save "shares_VF"


//ALGUNAS GRÁFICAS IMPORTANTES

tsset cfips year, yearly

label variable year "year"

foreach x of numlist 36061 17031 26163{
	twoway ///
	(tsline mkt_d, yaxis(1) lcolor(blue)  ) ///
	(tsline nestab_d, yaxis(1) lcolor(red) lpattern(vshortdash)) ///
	(tsline ks_d, yaxis(1) lcolor(purple) lpattern(vshortdash)) ///
	if cfips==`x', ///
	graphregion(color(white)) title(SHARES: `x')
	
	graph export "TS_shares_`x'.png", as(png) name("Graph") replace
	
}

twoway ///
(tsline fmkt_d if cfips==36061, legend(label(1 "NYC")) yaxis(1) lcolor(green) lpattern(vshortdash)) ///
(tsline fmkt_d if cfips==26163, legend(label(2 "Wayne"))  yaxis(1) lcolor(blue) lpattern(vshortdash)) ///
(tsline fmkt_d if cfips==17031, legend(label(3 "Cook"))  yaxis(1) lcolor(red) lpattern(vshortdash)), ///
graphregion(color(white)) title(SHARES fmkt) 
	
graph export "TS_shares_fmkt.png", as(png) name("Graph") replace




	
	
/* GUIDE
 cname="New York"      cfips==36061
 cname="Suffolk"       cfips==25025
 cname="Philadelphia"  cfips==42101
 cname="Cook"          cfips==17031
 cname="Hamilton"      cfips==39061
 cname="Cuyahoga"      cfips==39035
 cname="Wayne"         cfips==26163  
 cname="St Joseph"     cfips==18141  
 cname="Champaigne"    cfips==17019 */