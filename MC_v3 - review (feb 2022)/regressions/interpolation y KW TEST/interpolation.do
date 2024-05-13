//OPCIÓN 1

clear all

cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\interpolation"

use "nestab"

// 1 MERGE CON DUMMY DE AQUELLOS COUNTYS QUE ESTUVIERON EN LA SIMULACIÓN
merge m:1 cfips using "1925"
drop _merge

//2 ASUMO QUE MISSIG VALUES EN a (AQUELLOS QUE NO APARECEN EN LOS 214 ) son 0
merge 1:1 cfips year using "a"
drop _merge
replace a = 0 if a == .
keep if D1925==1 & year > 1894

//3 HAGO INTERPOLACIÓN DEL DEL NESTAB (HAY 3200 POR AÑO)
by cfips: ipolate nestab year, gen(nestab_i) epolate

//4 NUMERADOR SOBRE TODOS LOS a's (incluyendo paso 2)
bysort year: egen a_sum = sum(a)
gen a_n = a / a_sum

//5 DENOMINADOR SOBRE EL NESTAB, INCLUYEN LOS 3200 (PUEDE NO HACERSE DESCOMENTANDO LA LINEA 10)
bysort year: egen nestab_i_sum = sum(nestab_i)
gen nestab_d = nestab_i / nestab_i_sum

//6. GENERAR LQ
gen lqnestab = a_n / nestab_d

// ¿SE DEBEN SACAR TODOS LOS ANTERIORES? // CON ESTA METODOLOGÍA CAMBIAN LOS LQ

rename lqnestab copB2_3
merge m:1 cfips using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\c_activity.dta"
drop _merge
keep cfips year a copB2_3 activity
replace copB2_3 = 0 if copB2_3 == .
replace activity = 0 if activity == .

//¿Pueden no coincidir exactamente? por ejemplo, 1930 cfips == 48625 no tiene nestab y fue interpolado con 4. Esto hace que el denominador para aquellos que si tenian nestab cambié.


//VERIFFICACIÓN en conjunto con lqmap

//36061

save "lq1.dta", replace





//OPCIÓN 2

// clear all
// use "nestab"
//
// merge m:1 year cfips using "lq_anova"
// drop _merge a
//
// merge m:1 cfips using "1925"
// drop _merge
// keep if D1925==1 & year > 1894
//
// bysort cfips: ipolate copB2_3 year, gen(copB2_3_i) epolate
// drop copB2_3
// rename copB2_3_i copB2_3
//
// merge m:1 cfips using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\c_activity.dta"
// drop _merge
//
// keep cfips year a copB2_3 activity
// replace activity = 0 if activity == .
// save "lq2.dta", replace







