clear all

cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v5\graphs\Kernel"
use "1"
rename copB2_3 ks_d1
drop _merge

merge 1:1 year cfips using "1_n"
drop _merge
rename copB2_3 ks_d2

keep if ks_d1 == 0

twoway (histogram ks_d2, color(red%50) width(5)) (kdensity ks_d2, lcolor(red)), graphregion(color(white))  legend(off)


graph export "ks_d2.png", as(png) name("Graph") replace

save "base_ceros"