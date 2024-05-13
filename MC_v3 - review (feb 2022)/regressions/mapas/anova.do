///////////////////////////////////////////
clear all

cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions"
use "1"
gen ks = 1 

append using  "2"
gen mkt = 0
replace mkt = 1 if ks == .

append  using "3"
gen nestab = 0
replace nestab = 1 if mkt == .

// D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\interpolation\lq1
// D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\interpolation\lq2

append using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\regressions\interpolation\lq1"
gen lq = 0
replace lq = 1 if nestab == .

replace mkt = 0 if mkt==.
replace ks = 0 if ks==.
replace nestab = 0 if nestab==.

gen group = ""
replace group = "nestab" if nestab == 1
replace group = "ks" if  ks == 1
replace group = "mkt" if mkt == 1
replace group = "lq" if lq == 1

keep year cfips a copB2_3 activity ks mkt nestab lq group

save "KW-test-dta"

////////ANOVA

//all

anova copB2_3 nestab##ks if ks == 1 | nestab == 1
anova copB2_3 nestab##mkt if mkt == 1 | nestab == 1
anova copB2_3 ks##mkt if ks == 1 | mkt == 1
anova copB2_3 nestab##lq if lq == 1 | nestab == 1
anova copB2_3 ks##lq if ks == 1 | lq == 1
anova copB2_3 mkt##lq if mkt == 1 | lq == 1

anova copB2_3 nestab##ks if  year < 1909  &  (ks == 1 | nestab == 1)
anova copB2_3 nestab##mkt if  year < 1909 & (mkt == 1 | nestab == 1)
anova copB2_3 ks##mkt if  year < 1909 & (ks == 1 | mkt == 1)
anova copB2_3 nestab##lq if  year < 1909 & (lq == 1 | nestab == 1)
anova copB2_3 ks##lq if  year < 1909 & (ks == 1 | lq == 1)
anova copB2_3 mkt##lq if  year < 1909 & (mkt == 1 | lq == 1)

anova copB2_3 nestab##ks if  year >= 1909 & (ks == 1 | nestab == 1)
anova copB2_3 nestab##mkt if  year >= 1909 & (mkt == 1 | nestab == 1) 
anova copB2_3 ks##mkt if  year >= 1909 & (ks == 1 | mkt == 1)
anova copB2_3 nestab##lq if  year >= 1909 & (lq == 1 | nestab == 1)
anova copB2_3 ks##lq if  year >= 1909 & (ks == 1 | lq == 1)
anova copB2_3 mkt##lq if  year >= 1909 & (mkt == 1 | lq == 1)

//observed

anova copB2_3 nestab##ks if a>=1 & (ks == 1 | nestab == 1)
anova copB2_3 nestab##mkt if a>=1 & (mkt == 1 | nestab == 1)
anova copB2_3 ks##mkt if a>=1 & (ks == 1 | mkt == 1)
anova copB2_3 nestab##lq if a>=1 & (lq == 1 | nestab == 1)
anova copB2_3 ks##lq if a>=1 & (ks == 1 | lq == 1)
anova copB2_3 mkt##lq if a>=1 & (mkt == 1 | lq == 1)

anova copB2_3 nestab##ks if a>=1 & year < 1909  & (ks == 1 | nestab == 1)
anova copB2_3 nestab##mkt if a>=1 & year < 1909 & (mkt == 1 | nestab == 1) 
anova copB2_3 ks##mkt if a>=1 & year < 1909 & (ks == 1 | mkt == 1)
anova copB2_3 nestab##lq if a>=1 & year < 1909 & (lq == 1 | nestab == 1)
anova copB2_3 ks##lq if a>=1 & year < 1909 & (ks == 1 | lq == 1)
anova copB2_3 mkt##lq if a>=1 & year < 1909 & (mkt == 1 | lq == 1)

anova copB2_3 nestab##ks if a>=1 & year >= 1909 & (ks == 1 | nestab == 1)
anova copB2_3 nestab##mkt if a>=1 & year >= 1909 & (mkt == 1 | nestab == 1)
anova copB2_3 ks##mkt if a>=1 & year >= 1909 & (ks == 1 | mkt == 1)
anova copB2_3 nestab##lq if a>=1 & year >= 1909 & (lq == 1 | nestab == 1)
anova copB2_3 ks##lq if a>=1 & year >= 1909 & (ks == 1 | lq == 1)
anova copB2_3 mkt##lq if a>=1 & year >= 1909 & (mkt == 1 | lq == 1)

//activity

anova copB2_3 nestab##ks if activity == 1 & (ks == 1 | nestab == 1)
anova copB2_3 nestab##mkt if activity == 1 & (mkt == 1 | nestab == 1)
anova copB2_3 ks##mkt if activity == 1 & (ks == 1 | mkt == 1)
anova copB2_3 nestab##lq if activity == 1 & (lq == 1 | nestab == 1)
anova copB2_3 ks##lq if activity == 1 & (lq == 1 | ks == 1)
anova copB2_3 mkt##lq if activity == 1 & (lq == 1 | mkt == 1)

anova copB2_3 nestab##ks if activity == 1 & year < 1909  & (ks == 1 | nestab == 1)
anova copB2_3 nestab##mkt if activity == 1 & year < 1909 & (mkt == 1 | nestab == 1)
anova copB2_3 ks##mkt if activity == 1 & year < 1909 & (ks == 1 | mkt == 1)
anova copB2_3 nestab##lq if activity == 1 & year < 1909 & (lq == 1 | nestab == 1)
anova copB2_3 ks##lq if activity == 1 & year < 1909 & (ks == 1 | lq == 1)
anova copB2_3 mkt##lq if activity == 1 & year < 1909 & (mkt == 1 | lq == 1)

anova copB2_3 nestab##ks if activity == 1 & year >= 1909 & (ks == 1 | nestab == 1)
anova copB2_3 nestab##mkt if activity == 1 & year >= 1909 & (mkt == 1 | nestab == 1)
anova copB2_3 ks##mkt if activity == 1 & year >= 1909 & (ks == 1 | mkt == 1)
anova copB2_3 nestab##lq if activity == 1 & year >= 1909 & (lq == 1 | nestab == 1)
anova copB2_3 ks##lq if activity == 1 & year >= 1909 & (ks == 1 | lq == 1)
anova copB2_3 mkt##lq if activity == 1 & year >= 1909 & (mkt == 1 | lq == 1)



////////KW
//all
kwallis copB2_3 if (group == "nestab" | group == "ks"), by(group)
kwallis copB2_3 if (group == "nestab" | group == "mkt"), by(group)
kwallis copB2_3 if (group == "ks" | group == "mkt"), by(group)
kwallis copB2_3 if (group == "nestab" | group == "lq"), by(group)
kwallis copB2_3 if (group == "ks" | group == "lq"), by(group)
kwallis copB2_3 if (group == "mkt" | group == "lq"), by(group)

kwallis copB2_3 if year <1909 & (group == "nestab" | group == "ks"), by(group)
kwallis copB2_3 if year <1909 & (group == "nestab" | group == "mkt"), by(group)
kwallis copB2_3 if year <1909 & (group == "ks" | group == "mkt"), by(group)
kwallis copB2_3 if year <1909 & (group == "nestab" | group == "lq"), by(group)
kwallis copB2_3 if year <1909 & (group == "ks" | group == "lq"), by(group)
kwallis copB2_3 if year <1909 & (group == "mkt" | group == "lq"), by(group)

kwallis copB2_3 if year >=1909 & (group == "nestab" | group == "ks"), by(group)
kwallis copB2_3 if year >=1909 & (group == "nestab" | group == "mkt"), by(group)
kwallis copB2_3 if year >=1909 & (group == "ks" | group == "mkt"), by(group)
kwallis copB2_3 if year >=1909 & (group == "nestab" | group == "lq"), by(group)
kwallis copB2_3 if year >=1909 & (group == "ks" | group == "lq"), by(group)
kwallis copB2_3 if year >=1909 & (group == "mkt" | group == "lq"), by(group)

//observed 
kwallis copB2_3 if a>=1 & (group == "nestab" | group == "ks"), by(group)
kwallis copB2_3 if a>=1 & (group == "nestab" | group == "mkt"), by(group)
kwallis copB2_3 if a>=1 & (group == "ks" | group == "mkt"), by(group)
kwallis copB2_3 if a>=1 & (group == "nestab" | group == "lq"), by(group)
kwallis copB2_3 if a>=1 & (group == "ks" | group == "lq"), by(group)
kwallis copB2_3 if a>=1 & (group == "mkt" | group == "lq"), by(group)

kwallis copB2_3 if a>=1 & year <1909 & (group == "nestab" | group == "ks"), by(group)
kwallis copB2_3 if a>=1 & year <1909 & (group == "nestab" | group == "mkt"), by(group)
kwallis copB2_3 if a>=1 & year <1909 & (group == "ks" | group == "mkt"), by(group)
kwallis copB2_3 if a>=1 & year <1909 & (group == "nestab" | group == "lq"), by(group)
kwallis copBN2_3 if a>=1 & year <1909 & (group == "ks" | group == "lq"), by(group)
kwallis copB2_3 if a>=1 & year <1909 & (group == "mkt" | group == "lq"), by(group)

kwallis copB2_3 if a>=1 & year >=1909 & (group == "nestab" | group == "ks"), by(group)
kwallis copB2_3 if a>=1 & year >=1909 & (group == "nestab" | group == "mkt"), by(group)
kwallis copB2_3 if a>=1 & year >=1909 & (group == "ks" | group == "mkt"), by(group)
kwallis copB2_3 if a>=1 & year >=1909 & (group == "nestab" | group == "lq"), by(group)
kwallis copB2_3 if a>=1 & year >=1909 & (group == "ks" | group == "lq"), by(group)
kwallis copB2_3 if a>=1 & year >=1909 & (group == "mkt" | group == "lq"), by(group)


//activity
kwallis copB2_3 if activity == 1 & (group == "nestab" | group == "ks"), by(group)
kwallis copB2_3 if activity == 1 & (group == "nestab" | group == "mkt"), by(group)
kwallis copB2_3 if activity == 1 & (group == "ks" | group == "mkt"), by(group)
kwallis copB2_3 if activity == 1 & (group == "nestab" | group == "lq"), by(group)
kwallis copB2_3 if activity == 1 & (group == "ks" | group == "lq"), by(group)
kwallis copB2_3 if activity == 1 & (group == "mkt" | group == "lq"), by(group)

kwallis copB2_3 if activity == 1 & year <1909 & (group == "nestab" | group == "ks"), by(group)
kwallis copB2_3 if activity == 1 & year <1909 & (group == "nestab" | group == "mkt"), by(group)
kwallis copB2_3 if activity == 1 & year <1909 & (group == "ks" | group == "mkt"), by(group)
kwallis copB2_3 if activity == 1 & year <1909 & (group == "nestab" | group == "lq"), by(group)
kwallis copB2_3 if activity == 1 & year <1909 & (group == "ks" | group == "lq"), by(group)
kwallis copB2_3 if activity == 1 & year <1909 & (group == "mkt" | group == "lq"), by(group)

kwallis copB2_3 if activity == 1 & year >=1909 & (group == "nestab" | group == "ks"), by(group)
kwallis copB2_3 if activity == 1 & year >=1909 & (group == "nestab" | group == "mkt"), by(group)
kwallis copB2_3 if activity == 1 & year >=1909 & (group == "ks" | group == "mkt"), by(group)
kwallis copB2_3 if activity == 1 & year >=1909 & (group == "nestab" | group == "lq"), by(group)
kwallis copB2_3 if activity == 1 & year >=1909 & (group == "ks" | group == "lq"), by(group)
kwallis copB2_3 if activity == 1 & year >=1909 & (group == "mkt" | group == "lq"), by(group)





//construir tablita:
//ALL: NO PODEMOS RECHAZAR; ACTIVITY: NO PODEMSO RECHAZAR QUE LOS 3 INDICADORES TIENEN DIST DIF PERO SI CON LQ // OBSERVED ANTES: NESTAB, MKT SE RECHAZA CON KS PERO DESPUÉS NO, TODAS CON LQ 






