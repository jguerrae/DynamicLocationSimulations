// REPLACE DE A

foreach x of numlist 10 25 50 75 90 { 
	clear all
	use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Ap`x'.dta"
	rename survival1Ap`x'  survivalA1p`x' 
	rename survival2Ap`x'  survivalA2p`x'
	save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Ap`x'.dta", replace
}


clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Apmax.dta"
rename survival1Apmax survivalA1pmax
rename survival2Apmax survivalA2pmax
save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Apmax.dta", replace


clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Apall.dta"

foreach x of numlist 10 25 50 75 90 { 
	rename survival1Ap`x'  survivalA1p`x' 
	rename survival2Ap`x'  survivalA2p`x'
}

rename survival1Apmax survivalA1pmax
rename survival2Apmax survivalA2pmax

save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Apall.dta", replace


// REPLACE DE B

foreach x of numlist 10 25 50 75 90 { 
	clear all
	use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Bp`x'.dta"
	rename survival1Bp`x'  survivalB1p`x' 
	rename survival2Bp`x'  survivalB2p`x'
	save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Bp`x'.dta", replace
}


clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Bpmax.dta"
rename survival1Bpmax survivalB1pmax
rename survival2Bpmax survivalB2pmax
save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Bpmax.dta", replace


clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Bpall.dta"

foreach x of numlist 10 25 50 75 90 { 
	rename survival1Bp`x'  survivalB1p`x' 
	rename survival2Bp`x'  survivalB2p`x'
}

rename survival1Bpmax survivalB1pmax
rename survival2Bpmax survivalB2pmax

save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Bpall.dta", replace

//REPLACE EN 3233 CFIPS

clear all

use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\MC_outputdata_random_PLC_skeleton_cfips_years_3233cfips.dta" 


foreach x of numlist 10 25 50 75 90 { 
	rename survival1Ap`x'  survivalA1p`x' 
	rename survival2Ap`x'  survivalA2p`x'
}

rename survival1Apmax survivalA1pmax
rename survival2Apmax survivalA2pmax

foreach x of numlist 10 25 50 75 90 { 
	rename survival1Bp`x'  survivalB1p`x' 
	rename survival2Bp`x'  survivalB2p`x'
}

rename survival1Bpmax survivalB1pmax
rename survival2Bpmax survivalB2pmax



save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\MC_outputdata_random_PLC_skeleton_cfips_years_3233cfips.dta" , replace



//CONTINUOUS

forval i = 1(1)100{
	clear all
	use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\A\p`i'.dta"
	rename survival1 survivalA1p`i'
	rename survival2 survivalA2p`i'
	save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\A\p`i'.dta", replace
}

forval i = 1(1)100{
	clear all
	use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\B\p`i'.dta"
	rename survival1 survivalB1p`i'
	rename survival2 survivalB2p`i'
	save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\B\p`i'.dta", replace
}














