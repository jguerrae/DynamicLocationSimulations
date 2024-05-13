use "D:\mapas blanco negro (3_5-1-2021)\MC_inputdata_cfipsfirms.dta" 

duplicates drop cfips_firms , force

foreach x of numlist 158 408 840 1488 1648 {
	gen D_`x'=0
	replace D_`x'=1 if firms90>=`x'
}

export excel using "D:\mapas blanco negro (3_5-1-2021)\b&w.xls", firstrow(variables)