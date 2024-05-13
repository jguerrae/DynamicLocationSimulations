


**MAPS COPB_3

foreach x of numlist 1{
	clear all
	
	cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v5\graphs\"
	
	use "`x'"
	keep if year == 1908
	merge 1:m cfips using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v5\graphs\maps\3233"
	keep cfips copB2_3
	replace copB2_3 = 0 if copB2_3 == .
	
	gen C=0

	*** COLOR CODE: WHITE, BLUE, GREEN, YELLOW, ORANGE, RED

	replace C=0 if copB2_3 == 0 
	replace C=1 if copB2_3 > 0  & copB2_3 <=10 
	replace C=2 if copB2_3 >10  & copB2_3 <=90 
	replace C=3 if copB2_3 >90  & copB2_3 <=100
	replace C=4 if copB2_3 >100 & copB2_3 <=200 
	replace C=5 if copB2_3 >200
	
	rename C C`x'
	cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v5\graphs\maps"
	
	save "C`x'", replace
}

clear all
cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v5\graphs\maps"

use "C1"

export excel using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v5\graphs\maps\mapas_indicadores_1908.xls", firstrow(variables) replace




**maps30 COPB_3

foreach x of numlist 1 {
	clear all
	
	cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v5\graphs\"
	
	use "`x'"
	keep if year == 1930
	merge 1:m cfips using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v5\graphs\maps30\3233"
	keep cfips copB2_3
	replace copB2_3 = 0 if copB2_3 == .
	
	gen C=0

	*** COLOR CODE: WHITE, BLUE, GREEN, YELLOW, ORANGE, RED

	replace C=0 if copB2_3 == 0 
	replace C=1 if copB2_3 > 0  & copB2_3 <=10 
	replace C=2 if copB2_3 >10  & copB2_3 <=90 
	replace C=3 if copB2_3 >90  & copB2_3 <=100
	replace C=4 if copB2_3 >100 & copB2_3 <=200 
	replace C=5 if copB2_3 >200
	
	rename C C`x'
	cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v5\graphs\maps30"
	
	save "C`x'", replace
}

clear all
cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v5\graphs\maps30"

use "C1"
export excel using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v5\graphs\maps30\mapas_indicadores_1930.xls", firstrow(variables) replace