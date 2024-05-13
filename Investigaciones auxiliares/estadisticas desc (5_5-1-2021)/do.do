clear all
foreach x of numlist 1(1)10 { 
	di "REPLICACIÓN `x'"
	di "                                           "
	use "D:\MC\MC`x'\MC_outputdata_random_PLC.dta"  
	merge m:1 smithcompanycode using "D:\MC\estado_company.dta"
	drop _merge
// 	keep if repid==1
	sum cfipsfirmsid agerandom if sname=="Illinois"
	sum cfipsfirmsid agerandom if sname=="Indiana"
	sum cfipsfirmsid agerandom if sname=="Michigan"
	sum cfipsfirmsid agerandom if sname=="Wisconsin"
	clear all
	di "                                           "
	di "                                           "
}





