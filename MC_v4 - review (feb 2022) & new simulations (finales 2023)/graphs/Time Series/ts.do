cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\graphs\Time Series"

///ks
clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\ks\C\B_copB2"
tsset cfips year, yearly

foreach x of numlist 36061 25025 42101 17031 39061 39035 26163 18141 17019 {
	twoway (tsline a, yaxis(1) lcolor(blue)) (tsline survivalB2p10, yaxis(1) lcolor(black) lpattern(vshortdash)) ///
	(tsline survivalB2p90, yaxis(1) lcolor(black) lpattern(vshortdash)) ///
	(tsline copB2_3, yaxis(2) lcolor(red)) if cfips==`x', ///
	title(kt_survivalB2 & observed: `x') graphregion(color(white))
	graph export "ks_TS_copB2_`x'.png", as(png) name("Graph") replace
}


///mkt
clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\mkt\C\B_copB2"
tsset cfips year, yearly

foreach x of numlist 36061 25025 42101 17031 39061 39035 26163 18141 17019 {
	twoway (tsline a, yaxis(1) lcolor(blue)) (tsline survivalB2p10, yaxis(1) lcolor(black) lpattern(vshortdash)) ///
	(tsline survivalB2p90, yaxis(1) lcolor(black) lpattern(vshortdash)) ///
	(tsline copB2_3, yaxis(2) lcolor(red)) if cfips==`x', ///
	title(mkt_survivalB2 & observed: `x') graphregion(color(white))
	graph export "mkt_TS_copB2_`x'.png", as(png) name("Graph") replace
}



///nestab
clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\nestab\C\B_copB2"
tsset cfips year, yearly

foreach x of numlist 36061 25025 42101 17031 39061 39035 26163 18141 17019 {
	twoway (tsline a, yaxis(1) lcolor(blue)) (tsline survivalB2p10, yaxis(1) lcolor(black) lpattern(vshortdash)) ///
	(tsline survivalB2p90, yaxis(1) lcolor(black) lpattern(vshortdash)) ///
	(tsline copB2_3, yaxis(2) lcolor(red)) if cfips==`x', ///
	title(nestab_survivalB2 & observed: `x') graphregion(color(white))
	graph export "nestab_TS_copB2_`x'.png", as(png) name("Graph") replace
}


///fmkt
clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\fmkt\C\B_copB2"
tsset cfips year, yearly

foreach x of numlist 36061 25025 42101 17031 39061 39035 26163 18141 17019 {
	twoway (tsline a, yaxis(1) lcolor(blue)) (tsline survivalB2p10, yaxis(1) lcolor(black) lpattern(vshortdash)) ///
	(tsline survivalB2p90, yaxis(1) lcolor(black) lpattern(vshortdash)) ///
	(tsline copB2_3, yaxis(2) lcolor(red)) if cfips==`x', ///
	title(fmkt_survivalB2 & observed: `x') graphregion(color(white))
	graph export "fmkt_TS_copB2_`x'.png", as(png) name("Graph") replace
}
