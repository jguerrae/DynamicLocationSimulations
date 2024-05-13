********************************************************
*** FROM ALL VARIABLES FILE TO MC_INPUT FILE
*******************************************************

*** SELECT VARIABLES TO INCLUDE IN MC ANALYSIS

use "C:\Users\chiqu\Desktop\HBS_May_2020\PLC\Dependent variable MC experiment\All_input_variables_cross-county_1890.dta"

keep cfips nestab90 bi_mktaccess1890 bi_fmktaccess1890 ks_auto1 ks_auto2 ks_auto3 ks_tot popsharenortherneuborn totalbankspc cirecpinv ciiautospecialization ciiautodiversity mp1 mp2

*** CALCULATE SHARE FOR MASS PRODUCTION VARIABLES MP1 AND MP2

gen mp1s=mp1/3
gen mp2s=mp2/4

*** CALCULATE CROSS COUNTY SHARES

egen total_nestab90 = total(nestab90)
egen total_bi_mktaccess1890=total(bi_mktaccess1890)
egen total_bi_fmktaccess1890=total(bi_fmktaccess1890)
egen total_ks_auto1=total(ks_auto1)
egen total_ks_auto2=total(ks_auto2)
egen total_ks_auto3=total(ks_auto3)
egen total_ks_tot=total(ks_tot)

gen share_nestab90 = (nestab90/total_nestab90)
gen share_bi_mktaccess1890=(bi_mktaccess1890/total_bi_mktaccess1890)
gen share_bi_fmktaccess1890=(bi_fmktaccess1890/total_bi_fmktaccess1890)
gen share_ks_auto1=(ks_auto1/total_ks_auto1)
gen share_ks_auto2=(ks_auto2/total_ks_auto2)
gen share_ks_auto3=(ks_auto3/total_ks_auto3)
gen share_ks_tot=(ks_tot/total_ks_tot)

*** TRANSFORM VARIABLES TO MIMIC SELECTION PROCEDURE LIKE MC SELECTION PROCEDURE FOR ESTABLISHMENTS -> CREATE LISTOF FIRMS IN COUNTY AND MC NEXT SELECTS BETWEEN FIRMS IN COUNTY FOLLOWING RANDOM SHOCK -> FROM SHARES INTO X 100,000 FIRMS

gen MC_nestab90=round(share_nestab90*100000)
gen MC_bi_mktaccess1890=round(share_bi_mktaccess1890*100000)
gen MC_bi_fmktaccess1890=round(share_bi_fmktaccess1890*100000)
gen MC_ks_auto1=round(share_ks_auto1*100000)
gen MC_ks_auto2=round(share_ks_auto2*100000)
gen MC_ks_auto3=round(share_ks_auto3*100000)
gen MC_ks_tot=round(share_ks_tot*100000)

gen MC_popsharenortherneuborn=round(popsharenortherneuborn*100000)
gen MC_totalbankspc=round(totalbankspc*100000)
gen MC_cirecpinv=round(cirecpinv*100000)
gen MC_ciiautospecialization=round(ciiautospecialization*100000)
gen MC_ciiautodiversity=round(ciiautodiversity*100000)
gen MC_mp1=round(mp1s*100000)
gen MC_mp2=round(mp2s*100000)

save "C:\Users\chiqu\Desktop\HBS_May_2020\PLC\Dependent variable MC experiment\All_input_variables_cross-county_1890_transformed_step1.dta", replace

use "C:\Users\chiqu\Desktop\HBS_May_2020\PLC\Dependent variable MC experiment\All_input_variables_cross-county_1890_transformed_step1.dta", replace
keep cfips MC_nestab90
drop if MC_nestab90==0
expand MC_nestab90
sort cfips
egen cfipsid=group(cfips)
gen cfipsfirmsid=_n
save "C:\Users\chiqu\Desktop\HBS_May_2020\PLC\Dependent variable MC experiment\MC_inputdata_cfips_nestab90.dta", replace

use "C:\Users\chiqu\Desktop\HBS_May_2020\PLC\Dependent variable MC experiment\All_input_variables_cross-county_1890_transformed_step1.dta", replace
keep cfips MC_bi_mktaccess1890
drop if MC_bi_mktaccess1890==0
expand MC_bi_mktaccess1890
sort cfips
egen cfipsid=group(cfips)
gen cfipsfirmsid=_n
save "C:\Users\chiqu\Desktop\HBS_May_2020\PLC\Dependent variable MC experiment\MC_inputdata_cfips_bi_mktaccess1890.dta", replace

use "C:\Users\chiqu\Desktop\HBS_May_2020\PLC\Dependent variable MC experiment\All_input_variables_cross-county_1890_transformed_step1.dta", replace
keep cfips MC_bi_fmktaccess1890
drop if MC_bi_fmktaccess1890==0
expand MC_bi_fmktaccess1890
sort cfips
egen cfipsid=group(cfips)
gen cfipsfirmsid=_n
save "C:\Users\chiqu\Desktop\HBS_May_2020\PLC\Dependent variable MC experiment\MC_inputdata_cfips_bi_fmktaccess1890.dta", replace

use "C:\Users\chiqu\Desktop\HBS_May_2020\PLC\Dependent variable MC experiment\All_input_variables_cross-county_1890_transformed_step1.dta", replace
keep cfips MC_ks_tot
drop if MC_ks_tot==0
expand MC_ks_tot
sort cfips
egen cfipsid=group(cfips)
gen cfipsfirmsid=_n
save "C:\Users\chiqu\Desktop\HBS_May_2020\PLC\Dependent variable MC experiment\MC_inputdata_cfips_ks_tot.dta", replace











