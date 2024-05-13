clear all

cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions"

//HISTOGRAMAS
use "1"
rename copB2_3 Cop1

merge 1:1 cfips year using "2"
drop _merge
rename copB2_3 Cop2

merge 1:1 cfips year using "3"
drop _merge
rename copB2_3 Cop3


// keep copB2_3 year a activity

twoway kdensity Cop1, kernel(gaussian) || kdensity Cop2, kernel(gaussian) || kdensity Cop3 ,  legend(label(1 "KS") label(2 "MKT") label(3 "nestab")) title(all) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\mapas\kernel_all.png", as(png) name("Graph") replace


twoway kdensity Cop1 if a>0, kernel(gaussian) || kdensity Cop2 if a>0, kernel(gaussian) || kdensity Cop3 if a>0 ,  legend(label(1 "KS") label(2 "MKT") label(3 "nestab")) title(observed) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\mapas\kernel_observed.png", as(png) name("Graph") replace

twoway kdensity Cop1 if activity==1, kernel(gaussian) || kdensity Cop2 if activity==1, kernel(gaussian) || kdensity Cop3 if activity==1,  legend(label(1 "KS") label(2 "MKT") label(3 "nestab")) title(activity) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\mapas\kernel_activity.png", as(png) name("Graph") replace


//1908

twoway kdensity Cop1 if year==1908, kernel(gaussian) || kdensity Cop2 if year==1908, kernel(gaussian) || kdensity Cop3 if year==1908 ,  legend(label(1 "KS") label(2 "MKT") label(3 "nestab")) title(all) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\mapas\kernel_all_1908.png", as(png) name("Graph") replace


twoway kdensity Cop1 if a>0 & year==1908, kernel(gaussian) || kdensity Cop2 if a>0 & year==1908, kernel(gaussian) || kdensity Cop3 if a>0 & year==1908 ,  legend(label(1 "KS") label(2 "MKT") label(3 "nestab")) title(observed) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\mapas\kernel_observed_1908.png", as(png) name("Graph") replace

twoway kdensity Cop1 if activity==1 & year==1908, kernel(gaussian) || kdensity Cop2 if activity==1 & year==1908, kernel(gaussian) || kdensity Cop3 if activity==1 & year==1908,  legend(label(1 "KS") label(2 "MKT") label(3 "nestab")) title(activity) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\mapas\kernel_activity_1908.png", as(png) name("Graph") replace