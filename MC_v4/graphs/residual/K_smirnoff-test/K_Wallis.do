cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4\graphs"
clear all

use "lq_ipolate_complete"
gen lq=1
drop activity

append using "1"
gen ks = 0
replace ks = 1 if lq==.

append using "2"
gen mkt = 0
replace mkt = 1 if ks == .

append using "3"
gen nestab = 0
replace nestab = 1 if mkt == .

append using "4"
gen fmkt = 0
replace fmkt = 1 if nestab == .

merge m:1 cfips using "c_activity"
drop _merge

replace mkt = 0 if mkt==.
replace fmkt = 0 if fmkt==.
replace nestab = 0 if nestab==.
replace ks = 0 if ks==.
replace lq = 0 if lq==.
replace activity = 0 if activity==.

gen group = ""
replace group = "ks" if ks == 1
replace group = "nestab" if nestab == 1
replace group = "mkt" if mkt == 1
replace group = "fmkt" if fmkt == 1
replace group = "lq" if lq == 1

gen P1 = 0
replace P1=1 if year <1909


//ALL SAMPLE
kwallis copB2_3 if (ks == 1 | nestab == 1), by(group) 
kwallis copB2_3 if (ks == 1 | mkt == 1), by(group) 
kwallis copB2_3 if (ks == 1 | fmkt == 1), by(group)
kwallis copB2_3 if (ks == 1 | lq == 1), by(group)

kwallis copB2_3 if (mkt == 1 | nestab == 1), by(group)
kwallis copB2_3 if (mkt == 1 | fmkt == 1), by(group)
kwallis copB2_3 if (mkt == 1 | lq == 1), by(group)

kwallis copB2_3 if (nestab == 1 | fmkt == 1), by(group)
kwallis copB2_3 if (nestab == 1 | lq == 1), by(group)

kwallis copB2_3 if (fmkt == 1 | lq == 1), by(group)

//p1
kwallis copB2_3 if (ks == 1 | nestab == 1) & P1 == 1, by(group) 
kwallis copB2_3 if (ks == 1 | mkt == 1) & P1 == 1, by(group) 
kwallis copB2_3 if (ks == 1 | fmkt == 1), by(group)
kwallis copB2_3 if (ks == 1 | lq == 1) & P1 == 1, by(group)

kwallis copB2_3 if (mkt == 1 | nestab == 1) & P1 == 1, by(group)
kwallis copB2_3 if (mkt == 1 | fmkt == 1) & P1 == 1, by(group)
kwallis copB2_3 if (mkt == 1 | lq == 1) & P1 == 1, by(group)

kwallis copB2_3 if (nestab == 1 | fmkt == 1) & P1 == 1, by(group)
kwallis copB2_3 if (nestab == 1 | lq == 1) & P1 == 1, by(group)

kwallis copB2_3 if (fmkt == 1 | lq == 1) & P1 == 1, by(group)


//p1
kwallis copB2_3 if (ks == 1 | nestab == 1) & P1 == 0, by(group) 
kwallis copB2_3 if (ks == 1 | mkt == 1) & P1 == 0, by(group) 
kwallis copB2_3 if (ks == 1 | fmkt == 1), by(group)
kwallis copB2_3 if (ks == 1 | lq == 1) & P1 == 0, by(group)

kwallis copB2_3 if (mkt == 1 | nestab == 1) & P1 == 0, by(group)
kwallis copB2_3 if (mkt == 1 | fmkt == 1) & P1 == 0, by(group)
kwallis copB2_3 if (mkt == 1 | lq == 1) & P1 == 0, by(group)

kwallis copB2_3 if (nestab == 1 | fmkt == 1) & P1 == 0, by(group)
kwallis copB2_3 if (nestab == 1 | lq == 1) & P1 == 0, by(group)

kwallis copB2_3 if (fmkt == 1 | lq == 1) & P1 == 0, by(group)



/////////////////////////////////////////////////////////////////////
//ACTIVITY
kwallis copB2_3 if (ks == 1 | nestab == 1) & activity == 1, by(group) 
kwallis copB2_3 if (ks == 1 | mkt == 1) & activity == 1, by(group) 
kwallis copB2_3 if (ks == 1 | fmkt == 1) & activity == 1, by(group) //
kwallis copB2_3 if (ks == 1 | lq == 1) & activity == 1, by(group)

kwallis copB2_3 if (mkt == 1 | nestab == 1) & activity == 1, by(group)
kwallis copB2_3 if (mkt == 1 | fmkt == 1) & activity == 1, by(group)
kwallis copB2_3 if (mkt == 1 | lq == 1) & activity == 1, by(group)

kwallis copB2_3 if (nestab == 1 | fmkt == 1) & activity == 1, by(group)
kwallis copB2_3 if (nestab == 1 | lq == 1) & activity == 1, by(group)

kwallis copB2_3 if (fmkt == 1 | lq == 1) & activity == 1, by(group)

//p1
kwallis copB2_3 if (ks == 1 | nestab == 1) & activity == 1 & P1 == 1, by(group) 
kwallis copB2_3 if (ks == 1 | mkt == 1) & activity == 1 & P1 == 1, by(group) 
kwallis copB2_3 if (ks == 1 | fmkt == 1) & activity == 1, by(group)
kwallis copB2_3 if (ks == 1 | lq == 1) & activity == 1 & P1 == 1, by(group)

kwallis copB2_3 if (mkt == 1 | nestab == 1) & activity == 1 & P1 == 1, by(group)
kwallis copB2_3 if (mkt == 1 | fmkt == 1) & activity == 1 & P1 == 1, by(group)
kwallis copB2_3 if (mkt == 1 | lq == 1) & activity == 1 & P1 == 1, by(group)

kwallis copB2_3 if (nestab == 1 | fmkt == 1) & activity == 1 & P1 == 1, by(group)
kwallis copB2_3 if (nestab == 1 | lq == 1) & activity == 1 & P1 == 1, by(group)

kwallis copB2_3 if (fmkt == 1 | lq == 1) & activity == 1 & P1 == 1, by(group)


//p1
kwallis copB2_3 if (ks == 1 | nestab == 1) & activity == 1 & P1 == 0, by(group) 
kwallis copB2_3 if (ks == 1 | mkt == 1) & activity == 1 & P1 == 0, by(group) 
kwallis copB2_3 if (ks == 1 | fmkt == 1) & activity == 1 & P1 == 0 , by(group)
kwallis copB2_3 if (ks == 1 | lq == 1) & activity == 1 & P1 == 0, by(group)

kwallis copB2_3 if (mkt == 1 | nestab == 1) & activity == 1 & P1 == 0, by(group)
kwallis copB2_3 if (mkt == 1 | fmkt == 1) & activity == 1 & P1 == 0, by(group)
kwallis copB2_3 if (mkt == 1 | lq == 1) & activity == 1 & P1 == 0, by(group)

kwallis copB2_3 if (nestab == 1 | fmkt == 1) & activity == 1 & P1 == 0, by(group)
kwallis copB2_3 if (nestab == 1 | lq == 1) & activity == 1 & P1 == 0, by(group)

kwallis copB2_3 if (fmkt == 1 | lq == 1) & activity == 1 & P1 == 0, by(group)


/////////////////////////////////////////////////////////////////////
//OBSERVED
kwallis copB2_3 if (ks == 1 | nestab == 1) & a>0, by(group) 
kwallis copB2_3 if (ks == 1 | mkt == 1) & a>0, by(group) 
kwallis copB2_3 if (ks == 1 | fmkt == 1) & a>0, by(group)
kwallis copB2_3 if (ks == 1 | lq == 1) & a>0, by(group)

kwallis copB2_3 if (mkt == 1 | nestab == 1) & a>0, by(group)
kwallis copB2_3 if (mkt == 1 | fmkt == 1) & a>0, by(group)
kwallis copB2_3 if (mkt == 1 | lq == 1) & a>0, by(group)

kwallis copB2_3 if (nestab == 1 | fmkt == 1) & a>0, by(group)
kwallis copB2_3 if (nestab == 1 | lq == 1) & a>0, by(group)

kwallis copB2_3 if (fmkt == 1 | lq == 1) & a>0, by(group)

//p1
kwallis copB2_3 if (ks == 1 | nestab == 1) & a>0 & P1 == 1, by(group) 
kwallis copB2_3 if (ks == 1 | mkt == 1) & a>0 & P1 == 1, by(group) 
kwallis copB2_3 if (ks == 1 | fmkt == 1) & a>0 & P1 == 1, by(group)
kwallis copB2_3 if (ks == 1 | lq == 1) & a>0 & P1 == 1, by(group)

kwallis copB2_3 if (mkt == 1 | nestab == 1) & a>0 & P1 == 1, by(group)
kwallis copB2_3 if (mkt == 1 | fmkt == 1) & a>0 & P1 == 1, by(group)
kwallis copB2_3 if (mkt == 1 | lq == 1) & a>0 & P1 == 1, by(group)

kwallis copB2_3 if (nestab == 1 | fmkt == 1) & a>0 & P1 == 1, by(group)
kwallis copB2_3 if (nestab == 1 | lq == 1) & a>0 & P1 == 1, by(group)

kwallis copB2_3 if (fmkt == 1 | lq == 1) & a>0 & P1 == 1, by(group)


//p1
kwallis copB2_3 if (ks == 1 | nestab == 1) & a>0 & P1 == 0, by(group) 
kwallis copB2_3 if (ks == 1 | mkt == 1) & a>0 & P1 == 0, by(group) 
kwallis copB2_3 if (ks == 1 | fmkt == 1) & a>0 & P1, by(group)
kwallis copB2_3 if (ks == 1 | lq == 1) & a>0 & P1 == 0, by(group)

kwallis copB2_3 if (mkt == 1 | nestab == 1) & a>0 & P1 == 0, by(group)
kwallis copB2_3 if (mkt == 1 | fmkt == 1) & a>0 & P1 == 0, by(group)
kwallis copB2_3 if (mkt == 1 | lq == 1) & a>0 & P1 == 0, by(group)

kwallis copB2_3 if (nestab == 1 | fmkt == 1) & a>0 & P1 == 0, by(group)
kwallis copB2_3 if (nestab == 1 | lq == 1) & a>0 & P1 == 0, by(group)

kwallis copB2_3 if (fmkt == 1 | lq == 1) & a>0 & P1 == 0, by(group)

   



