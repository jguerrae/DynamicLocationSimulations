clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\nestab2\C\B_copB2"
keep cfips year copB2_3
rename copB2_3 copB2_3_J

merge 1:1 year cfips using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\nestab\C\B_copB2"
keep cfips year copB2_3_J copB2_3 
rename copB2_3 copB2_3_X

keep if year == 1908


merge 1:1 cfips year using  "a_activity"
drop _merge
replace a = 0 if a ==.
replace activity = 0 if activity == .


merge 1:m cfips using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\mapas\3233"
	keep cfips year copB2_3_J copB2_3_X a activity
	
	replace copB2_3_J = 0 if copB2_3_J == .
	
	gen CJ=0

	*** COLOR CODE: WHITE, BLUE, GREEN, YELLOW, ORANGE, RED

	replace CJ=0 if copB2_3_J == 0 
	replace CJ=1 if copB2_3_J > 0  & copB2_3_J <=10 
	replace CJ=2 if copB2_3_J >10  & copB2_3_J <=90 
	replace CJ=3 if copB2_3_J >90  & copB2_3_J <=100
	replace CJ=4 if copB2_3_J >100 & copB2_3_J <=200 
	replace CJ=5 if copB2_3_J >200
	
	
	
	replace copB2_3_X = 0 if copB2_3_X == .
	
	gen CX=0

	*** COLOR CODE: WHITE, BLUE, GREEN, YELLOW, ORANGE, RED

	replace CX=0 if copB2_3_X == 0 
	replace CX=1 if copB2_3_X > 0  & copB2_3_X <=10 
	replace CX=2 if copB2_3_X >10  & copB2_3_X <=90 
	replace CX=3 if copB2_3_X >90  & copB2_3_X <=100
	replace CX=4 if copB2_3_X >100 & copB2_3_X <=200 
	replace CX=5 if copB2_3_X >200
	

export excel using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\mapas\1908.xls", replace firstrow(variables)

save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\mapas\1908"




//1908

twoway kdensity copB2_3_J if year==1908, kernel(gaussian) || kdensity copB2_3_X if year==1908, kernel(gaussian) legend(label(1 "J") label(2 "X"))  title(all) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\mapas\kernel_1908.png", as(png) name("Graph") replace

twoway kdensity copB2_3_J if year==1908 & a>0, kernel(gaussian) || kdensity copB2_3_X if year==1908 & a>0, kernel(gaussian) legend(label(1 "J") label(2 "X"))  title(obs) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\mapas\kernel_a_1908.png", as(png) name("Graph") replace

twoway kdensity copB2_3_J if year==1908 & activity==1, kernel(gaussian) || kdensity copB2_3_X if year==1908 & activity==1, kernel(gaussian) legend(label(1 "J") label(2 "X"))  title(act) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\mapas\kernel_act_1908.png", as(png) name("Graph") replace

//hacerle la pregunta de Python



clear all

use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\mapas\1908"

merge 1:1 cfips using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\mapas\1925"
keep if D1925 == 1

preserve
// keep if a > 0
keep if activity == 1
keep CJ
rename CJ C
gen A = 1
save "J", replace
restore

preserve
// keep if a > 0
keep if activity == 1
keep CX
rename CX C
gen A = 0
save "X", replace
restore

clear all

use "J"
append using "X"

ksmirnov C, by(A) exact

restore