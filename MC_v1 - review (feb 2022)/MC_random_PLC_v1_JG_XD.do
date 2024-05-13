****************************************************************
****************************************************************
****************************************************************
*** RANDOM PLC USING MONTE CARLO EXPERIMENT
***
*** RANDOM PLC USING MONTE CARLO EXPERIMENT WITHOUT SHORTCUTS IMPLIES WORKING WITH DATASET OF 67 BILLION OBSERVATIONS
*** 
*** MY COMPUTER DOES NOT ALLOW WORKING WITH SUCH A DATASET, SO I BROKE THE PROBLEM INTO 2 STEPS
***
*** STEP I. CREATING DATASET WITH ONLY RANDOM REALIZED OUTCOMES (IMPLIES PERFORMING ALL PSEUDO RANDOM ALLOCATIONS AND CALCULATIONS) = 971 FIRMS X 4,572 FIRM YEARS ALIVE X 1,000 REPLICATIONS
*** = 4,439,412,000 OBSERVATIONS
***
*** STEP II. MERGING DATASET OF REALIZED OUTCOMES TO DATASET OF SKELETON OF ALL POSSIBLE OUTCOMES AND THEN FILL REST WITH 0s = 971 FIRMS i X 36 YEARS POTENTIALLY ALIVE BY EACH FIRM i X
*** 1,925 LOCATIONS POTENTIALLY ENTERED BY EACH FIRM i X 1,000 REPLICATIONS = 67,290,300,000 OBSERVATIONS 
***
*** STEP I. CREATING DATASET WITH RANDOM REALIZED OUTCOMES
***
*** 1. CREATE DATASET SKELETON = 971 FIRMS (ASSEMBLERS THAT ENTERED DURING PLC 1895-1930) X 1,000 REPLICATIONS = 971,000 OBSERVATIONS
*** 2. ALLOCATE TO EACH OF THE 971,000 FIRMS PSEUDO-RANDOMLY A PAIR OF MATCHED ENTRY YEAR AND SMITHCOMAPANYCODE ASSEMBLER ID
*** 3A. ALLOCATE TO EACH OF THE 971,000 FIRMS PSEUDO-RANDOMLY A LOCATION WITHIN THE SET 1,925 POSSIBLE CFIPS COUNTY CODES (1,925 COUNTIES HAVE FULL INFO FOR ANALYSIS)
*** 3B. ALLOCATE TO EACH OF THE 971,000 FIRMS PSEUDO-RANDONLY A LOCATION WITHIN THE SET OF 337,902 POSSIBLE FIRM-CFIPS COUNTY CODES (337,902 FIRM-COUNTY )
*** 4A. ALLOCATE TO EACH OF THE 971,000 FIRMS PSEUDO-RANDOMLY A SURVIVAL AGE 1, SURVIVAL AGE DRAWN FROM THE DISTRIBUTION OF OBSERVED SURVIVAL AGES  
*** 4B. ALLOCATE TO EACH OF THE 971,000 FIRMS PSEUDO-RANDOMLY A SURVIVAL AGE 2, SURVIVAL=1 IF RANDOM SHOCK IS LOWER THAN ESTIMATED PROBABILITY OF SURVIVAL ONE MORE YEAR, GIVEN ASSEMBLER AGE
***
*** WE HAVE CREATED 4 SCENARIOS OF RANDOM PLC INDUSTRY EVOLUTION
*** SCENARIO 1 (1A): RANDOM ENTRY ACROSS LOCATIONS AND SURVIVAL AGE DRAWN FROM OBSERVED DISTRIBUTION AT BIRTH
*** SCENARIO 2 (2A): RANDOM ENTRY ACROSS LOCATIONS AND SURVIVAL AGE DRAWN FROM ESTIMATED PROBABILITY OF SURVIVAL ONE MORE YEAR GIVEN FIRM IS ALIVE AT TIME T
*** SCENARIO 3 (1B): RANDOM ENTRY ACROSS LOCATIONS WEIGHTED BY MANUFACTURING BASE AND SURVIVAL AGE DRAWN FROM OBSERVED DISTRIBUTION AT BIRTH
*** SCENARIO 4 (2B): RANDOM ENTRY ACROSS LOCATIONS WEIGHTED BY MANUFACTURING BASE AND SURVIVAL AGE DRAWN FROM ESTIMATED PROBABILITY OF SURVIVAL ONE MORE YEAR GIVEN FIRM IS ALIVE AT TIME T
***
*** SCENARIOS 1A AND 1B GIVE RANDOM PLC INDUSTRY EVOLUTION IS LOWER BOUND ESTIMATE OF RANDOM LOCATION FOR COUNTIES WITH LARGE MANUFACTURING BASE
*** SCENARIOS 2A AND 2B GIVE RANDOM PLC INDUSTRY EVOLUTION IS UPPER BOUND ESTIMATE OF RANDOM LOCATION FOR COUNTIES WITH LARGE MANUFACTURING BASE, AND IN LINE WITH CONVENTIONAL ASSUMPTION THAT *** WE EXPECT ENTRY TO BE MORE LIKELY WHERE MANUFACTURING IS ALREADY LOCATED
***
*** STEP II. CREATING FULL DATASET
*** 
*** MERGE REALIZED RANDOM OUTCOMES DATASET WITH DATASET OF ALL POSSIBLE OUTCOMES (971 X 1,925 X 36 X 1,000 = 67,290,300,000) 
***
*** NOTE THAT IF WORKING AT COUNTY LEVEL, AS WE ARE AT THIS STAGE, THIS MERGE CAN BE DONE WITH LESS OBSERVATIONS BY COLLAPSING STEP I INTO COUNTIES FIRST AND THEN MERGING WITH DATASET OF ALL POSSIBLE OUTCOMES AT COUNTY LEVEL (1,925 X 36 X 1,000 = 69,300,000) AND REDUCE COMPUTATIONAL BURDEN
****************************************************************
****************************************************************
****************************************************************


****************************************************************
****************************************************************
****************************************************************
*** STEP I. CREATING DATASET WITH ONLY REALIZED RANDOM OUTCOMES
****************************************************************
****************************************************************
****************************************************************

*** INPUT DATASETS FROM OBSERVED DATASET

*** MC_inputdata_year_entry.dta = OBSERVED NUMBER OF ENTRANTS PER PLC YEAR, 1895-1930

*** MC_inputdata_smith.dta = SMITHCOMPANYCODE OF 971 ASSEMBLERS

*** MC_inputdata_cfips.dta = COUNTY CFIPS OF 1,925 POSSIBLE LOCATIONS (WITH FULL INFO FOR ANALYSIS)

*** MC_inputdata_cfipsfirms.dta = COUNTY CFIPS OF 337,902 POSSIBLE FIRM-LOCATION (WITH FULL INFO FOR ANALYSIS)

*** MC_inputdata_age.dta = OBSERVED SURVIVAL AGE OF 971 ASSEMBLERS  


*** (1) 36 OBSERVATIONS OF OBSERVED NUMBER OF ENTRANTS PER PLC YEAR EXPANDED INTO 971,000 OBSERVATIONS, EACH OBSERVATION IS FIRM-ENTRY YEAR-REPLICATION

use "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_inputdata_year_entry.dta"

expand entry
gen firmid= _n
order firmid
gen rep=1000
expand rep
bysort firmid: gen repid= _n
order repid

*** (2) ALLOCATING RANDOMLY AN OBSERVED ASSEMBLER IDENTITY TO EACH FIRM-ENTRY YEAR-REPLICATION OBSERVATION (RANDOM ALLOCATION OF 1 OUT OF 971 SMITHCOMPANY IDs TO EACH 971,000 FIRM OBSERVATION WITHOUT REPLACEMENT SUCH THAT A FIRM THAT ENTERS WITHIN A GIVEN REPLICATION CANNOT ENTER AGAIN) - I HAVE CHECKED THIS, CORRECT, WITHOUT REPLACEMENT
 
set obs 971000
set seed 4540
gen smithrandom = floor((970+1)*runiform() + 1)
bysort repid: egen smithid=rank(smithrandom), unique

*** (3A) ALLOCATING RANDONMLY AN OBSERVED ASSEMBLER LOCATION IDENTITY TO EACH FIRM-ENTRY YEAR-ASSEMBLER ID-REPLICATION OBSERVATION (RANDOM ALLOCATION OF 1 OUT OF 1,925 POSSIBLE LOCATIONS TO EACH 971,000 FIRM OBSERVATION, WITH REPLACEMENT WITHIN A GIVEN REPLICATION SUCH THAT RANDOM AGGLOMERATION MAY BE OBSERVED) - I HAVE CHECKED THIS, CORRECT WITH REPLACEMENT: CFIPS WITH LOW ENTRY HAS FREQUENCY 437 (AUGUSTA, VA) OUT OF 971,000 REPLICATIONS, WHILE CFIPS WITH HIGH ENTRY HAS 577 (ROCKINGHAM, NC) OUT OF 971,000 REPLICATIONS

set obs 971000
set seed 1883
gen cfipsid = floor((1924+1)*runiform() + 1)


*** (3B) ALLOCATING RANDONMLY AN OBSERVED ASSEMBLER LOCATION IDENTITY TO EACH FIRM-ENTRY YEAR-ASSEMBLER ID-REPLICATION OBSERVATION (RANDOM ALLOCATION OF 1 OF 337,902 POSSIBLE FIRM-LOCATION TO EACH 971,000 FIRM OBSERVATIONS, WITH REPLACEMENT WITHIN A GIVEN REPLICATION SUCH THAT AGGLOMERATION MAY BE OBSERVED) (IN 1890 CENSUS INDICATES A TOTAL OF 337,902 MANUFACTURING ESTABLISHMENTS) - I HAVE CHECKED THIS, CORRECT WITH REPLACEMENT: CFIPS WITH LOW ENTRY HAS FREQUENCY 1 (AUGUSTA, FL) OUT OF 971,000 REPLICATIONS, WHILE CFIPS WITH HIGH ENTRY (NEW YORK, NY) HAS 72,849 OUT OF 971,000 REPLICATIONS

set obs 971000
set seed 3219
gen cfipsfirmsid = floor((337901+1)*runiform() + 1)


*** (4A) ALLOCATE RANDOMLY AN OBSERVED SURVIVAL AGE TO EACH FIRM-ENTRY YEAR-ASSEMBLER ID-LOCATION-REPLICATION OBSERVATION

*** (4A.1) ALLOCATING RANDONMLY AN OBSERVED ASSEMBLER SURVIVAL AGE TO EACH FIRM-ENTRY YEAR-ASSEMBLER ID-LOCATION-REPLICATION OBSERVATION (RANDOM ALLOCATION OF 1 OF 971 FIRM SURVIVAL AGE TO EACH 971,000 FIRM OBSERVATIONS, WITHOUT REPLACEMENT SUCH THAT A SURVIVAL AGE WITHIN A GIVEN REPLICATION ALLOCATED AT BIRTH CANNOT BE ALLOCATED AGAIN) - I HAVE CHECKED THIS, CORRECT, WITHOUT REPLACEMENT
 
set obs 971000
set seed 3219
gen agerandom = floor((970+1)*runiform() + 1)
bysort repid: egen ageid=rank(agerandom), unique


*** (4A.2) CHECK OBSERVATIONS FOR VARIABLES IS 971,000 AND RANGE FOR SMITHID IS 1,971, FOR CFIPSID IS 1,1925, FOR CFIPSFIRMSID IS 1,337902, FOR AGEID 1,971

summarize smithid cfipsid cfipsfirmsid ageid

*** (4A.3) MERGE DATASET TO SMITHCOMPANYCODE CFIPS CFIPSFIRMS AGE

sort smithid
merge m:m smithid using "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_inputdata_smith.dta"
drop _merge

sort cfipsid
merge m:m cfipsid using "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_inputdata_cfips.dta"
drop _merge

sort cfipsfirmsid
merge m:m cfipsfirmsid using "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_inputdata_cfipsfirms.dta"
drop _merge
drop in 971001/989952

sort ageid
merge m:m ageid using "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_inputdata_age.dta"
drop _merge

order smithcompanycode, after (smithid)
order cfips, after (cfipsid)
order cfips_firms, after (cfipsfirmsid)
order aa, after (ageid)
rename aa age1

*** (4A.4) CREATE AGE1 VARIABLE: AGE ALLOCATED IN STEP 4A.1 SUBJECT NOT TO BE GREATER THAN MAXIMUM AGE GIVEN 1930-ENTRY YEAR

gen maxage=1930-year+1
gen agedraw1=age1
replace agedraw1=maxage if age1>maxage

*** (4A.5) EXPAND DATASET

expand maxage

*** (4A.6) CREATE SURVIVAL1: SURVIVAL AGE ALLOCATED AT BIRTH

bysort repid firmid: gen yearid= _n
rename year entryyear
gen year=entryyear+yearid-1
order year, before (entryyear)
gen survival1=0
replace survival1=1 if entryyear+age1-1>=year 

*** 4B. ALLOCATE RANDOMLY A SURVIVAL AGE (RESULTING FROM THE PROBABILITY TO SURVIVE ONE MORE YEAR AT EACH AGE ESTIMATED FROM OBSERVED PLC DATA) TO EACH FIRM-ENTRY YEAR-ASSEMBLER ID-LOCATION-REPLICATION OBSERVATION

*** (4B.1) CREATE SURVIVAL2: SURVIVAL GIVEN BY PROBABILITY OF SURVIVAL ONE MORE YEAR FROM LOGIT ESTIMATE OF OBSERVED SURVIVAL ON OBSERVED AGE WITH FIXED COUNTY AND YEAR EFFECTS + ASSUMING SAME PROBABILITY OF SURVIVAL ONE YEAR FOR YEARS 32-36 THAT ARE POSSIBLE GIVEN RANDOM ENTRY BUT NOT OBSERVED IN AUTO PLC

set obs 21205000
set seed 8631
gen psurvival2 = runiform()
gen s=0

replace s=1 if yearid==1
replace s=1 if psurvival<0.7325367 & yearid==2
replace s=1 if psurvival<0.5600508 & yearid==3
replace s=1 if psurvival<0.5174274 & yearid==4
replace s=1 if psurvival<0.6053022 & yearid==5
replace s=1 if psurvival<0.5634336 & yearid==6
replace s=1 if psurvival<0.6289087 & yearid==7
replace s=1 if psurvival<0.6280293 & yearid==8
replace s=1 if psurvival<0.6105528 & yearid==9
replace s=1 if psurvival<0.6975590 & yearid==10
replace s=1 if psurvival<0.6915230 & yearid==11
replace s=1 if psurvival<0.7082481 & yearid==12
replace s=1 if psurvival<0.7934895 & yearid==13
replace s=1 if psurvival<0.7653560 & yearid==14
replace s=1 if psurvival<0.8187475 & yearid==15
replace s=1 if psurvival<0.7907970 & yearid==16
replace s=1 if psurvival<0.7804873 & yearid==17
replace s=1 if psurvival<0.7681558 & yearid==18
replace s=1 if psurvival<0.8191530 & yearid==19
replace s=1 if psurvival<0.8226613 & yearid==20
replace s=1 if psurvival<0.7968106 & yearid==21
replace s=1 if psurvival<0.8788727 & yearid==22
replace s=1 if psurvival<0.7903375 & yearid==23
replace s=1 if psurvival<0.9199288 & yearid==24
replace s=1 if psurvival<0.8507945 & yearid==25
replace s=1 if psurvival<0.8863749 & yearid==26
replace s=1 if psurvival<0.9219553 & yearid==27
replace s=1 if psurvival<0.8899413 & yearid==28
replace s=1 if psurvival<0.7756506 & yearid==29
replace s=1 if psurvival<0.8716903 & yearid==30
replace s=1 if psurvival<0.8673042 & yearid==31
replace s=1 if psurvival<0.8673042 & yearid==32
replace s=1 if psurvival<0.8673042 & yearid==33
replace s=1 if psurvival<0.8673042 & yearid==34
replace s=1 if psurvival<0.8673042 & yearid==35
replace s=1 if psurvival<0.8673042 & yearid==36

gen survival2=0

replace survival2=1 if year==entryyear
replace survival2=1 if survival2[_n-1]==1 & s==1 & year>entryyear
bysort repid firmid: egen agedraw2=sum(survival2)

*** VARIABLES HELPFUL TO CHECK THAT RANDOM DRAWS WITHOUT REPLACEMENT INDEED WORKED THAT WAY

bysort repid firmid: gen agecountsurvival1=_n if survival1==1

replace agecountsurvival1=0 if survival1==0

bysort repid firmid: gen agecountsurvival2=_n if survival2==1

replace agecountsurvival2=0 if survival2==0

save "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC.dta", replace


****************************************************************
****************************************************************
****************************************************************
*** STEP II. CREATING DATASET WITH ALL POSSIBLE OUTCOMES - 971 FIRMS X 1,925 LOCATIONS X 36 YEARS X 1,000 REPLICATIONS = 67,290,300,000 OBSERVATIONS
****************************************************************
****************************************************************
****************************************************************

*** use "D:\Git-Hub\Assemblers-Project\Data\Input\MC_inputdata_smith.dta" 

*** cross using "D:\Git-Hub\Assemblers-Project\Data\Input\MC_inputdata_cfips.dta"

*** cross using "D:\Git-Hub\Assemblers-Project\Data\Input\MC_inputdata_year_entry.dta"

***gen rep=1000
***expand rep


****************************************************************
****************************************************************
****************************************************************
*** CREATING RANDOM AND OBSERVED PLC DESCRIPTIVE TABLES & FIGURES FOR AGGLOMERATION ANALYSIS AND MAPS
****************************************************************
****************************************************************
****************************************************************


****************************************************************
****************************************************************
****************************************************************

*** (1) TABLE 1. AGE DISTRIBUTION OF ASSEMBLERS, OBSERVED, RANDOM PLC AGE1 AND AGE2
 
*** (1.1) OBSERVED PLC - AGE DISTRIBUTION OF FIRMS

use "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_inputdata_age.dta" 

tab aa 

*** (1.2) RANDOM PLC - AGE DISTRIBUTION OF FIRMS ALLOCATED AT BIRTH AND AT ONE MORE YEARS

use "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC.dta"

tab agedraw1 if year==1930

tab agedraw2 if year==1930


****************************************************************
****************************************************************
****************************************************************
*** AGGLOMERATION ANALYSIS EXAMINES AGGLOMERATION INDICES AT COUNTY LEVEL FOR PLC PERIOD (1,925 COUNTIS (WITH FULL ANALYSIS INFO) X 36 PLC YEARS = 69,300)

*** PRODUCE RAW DATA TO CALCULATE AGGLOEMRATION INDICES 

*** STEP 1. PRODUCE DATASET WITH REALIZED RANDOM OUTCOMES AT COUNTY LEVEL - COUNTY X NUMBER OF YEAR-REPLICACTIONS IN WHICH RANDOM OUTCOME OCCURRED (DATASET WITH REALIZED RANDOM OUTCOMES AT COUNTY LEVEL IS 21,205,000 OBSERVATIONS BECAUSE FIRST YEARS ONLY HAVE SOME OBS AS ONLY FEW FIRMS ENTER WHILE FINAL YEARS HAVE ALL OBS BECAUSE FIRMS ARE EITHER ALIVE OR HAVE ENTERED AND DIED AND HAVE 0)

*** STEP 2. MERGE DATASET WITH REALIZED RANDOM OUTCOMES AND DATASET WITH ALL POSSIBLE OUTCOMES FOR 1,925 COUNTIES X 36 YEAR X 1,000 REPLICATIONS = 69,300,000 OBSERVATIONS. NOTE THIS STEP IS REQUIRED BECAUSE RANDOM PLC WAS CONSTRUCTED BY PRODUCING ONLY REALIZED OUTCOMES. THUS, FOR SOME COUNTY-YEARS REPLICATIONS WITH NO ACTIVITY DO NOT APPEAR IN REALIZED RANDOM OUTCOME DATASET AS AN OBSERVATION IN RANDOM PLC. BUT WE NEED TO INCLUDE ALL REPLICATIONS TO CALCULATE PERCENTILES CORRECTLY. 

*** STEP 3. USE OBSERVED PLC AND RANDOM PLC TO PRODUCE NUMBER OF FIRMS ACTIVE COUNTY-YEAR RAW DATA (INCLUDING RANDOM PLC PERCENTILE 10, P25, P50, P75, P90, MAX ACROSS 1,000 REPLICATIONS) 

*** STEP 4. PRODUCE "AGGLOMERATION INDICES" DATASET INCLUDING 1) OBSERVED PLC NUMBER OF FIRMS ALIVE, 2) RANDOM PLC NUMBER OF FIRMS ALIVE BY SCENARIO AA, AB, BA, BB ALL RELEVANT PERCENTILES, 3) NUMBER OF FIRMS ALIVE BY SCENARIO 1A, 2A, 1B, 2B AS PERCENTILE OF OF RANDOM NUMBER OF FIRMS ALIVE, 4) LOCATION QUOTIENT + MERGE FILES STEP 3 + STEP 4

*** STEP 5. TRANSFORM VARIABLES INTO VARIABLES WITH RANGES TO PROJECT INTO MAPS, 1900 1910 1920 1930

*** STEP 6. USE "AGGLOMERATION INDICES" DATASET TO PRODUCE DESCRIPTIVE STATISTICS

*** STEP 7. USE "AGGLOMERATION INDICES" DATASET TO PRODUCE DESCRIPTIVE STATISTICS

****************************************************************


***************************************************************
*** (1) STEP 1. PRODUCE DATASET WITH REALIZED RANDOM OUTCOMES AT COUNTY LEVEL - COUNTY WHERE RANDOM ENTRY ALLOCATED X NUMBER OF YEARS FIRMS ALIVE X REPLICACTIONS WITH OUTCOME REALIZED

*** (1.1) RANDOM PLC - NUMBER OF FIRMS ALIVE BY YEAR & CFIPS ACROSS REPLICATIONS - CFIPS: RANDOMLY ALLOCATED CFIPS

clear all
use "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC.dta"

sort repid year cfips
collapse (sum) survival1 survival2, by (repid year cfips)
save "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_rep_year_cfips.dta", replace

*** (1.2) RANDOM PLC - NUMBER OF FIRMS ALIVE BY YEAR & CFIPS ACROSS REPLICATIONS - CFIPS: RANDOMLY ALLOCATED CFIPS WEIGTHED BY NUMBER OF ALL MANUFACTURING FIRMS AT CFIPS

clear all
use "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC.dta"

sort repid year cfips_firms
collapse (sum) survival1 survival2, by (repid year cfips_firms)
save "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_rep_year_cfipsfirms.dta", replace

*** (2) STEP 2. MERGE DATASET WITH REALIZED RANDOM OUTCOMES AND DATASET WITH ALL POSSIBLE OUTCOMES FOR 1,925 COUNTIES X 36 YEAR X 1,000 REPLICATIONS = 69,300,000 OBSERVATIONS

*** (2.1) CREATE DATASET WITH ALL POSSIBLE OUTCOMES - 1,925 COUNTIES X 36 YEAR X 1,000 REPLICATIONS

use "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_inputdata_cfips.dta"

cross using "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_inputdata_year_entry.dta"

gen rep=1000
expand rep

save "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_all_possible_outcomes_year_cfips.dta", replace

sort cfipsid year

bysort cfipsid year: gen repid=_n

sort repid cfipsid year

order repid year cfipsid cfips

drop entry rep 

save "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_all_possible_outcomes_year_cfips.dta", replace

use "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_all_possible_outcomes_year_cfips.dta" 
rename cfips cfips_firms
save "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_all_possible_outcomes_year_cfipsfirms.dta", replace


*** (2.2.1) MERGE DATASET WITH REALIZED RANDOM OUTCOMES AA & AB AND DATASET WITH ALL POSSIBLE OUTCOMES

clear all

use "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_all_possible_outcomes_year_cfips.dta" 

merge 1:1 repid year cfips using "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_rep_year_cfips.dta"

drop _merge

replace survival1=0 if survival1==.
replace survival2=0 if survival2==.

save "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfips.dta", replace


*** (2.2.2) MERGE DATASET WITH REALIZED RANDOM OUTCOMES BA & BB AND DATASET WITH ALL POSSIBLE OUTCOMES

clear all

use "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_all_possible_outcomes_year_cfipsfirms.dta" 

merge 1:1 repid year cfips_firms using "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_rep_year_cfipsfirms.dta"

drop _merge

replace survival1=0 if survival1==.
replace survival2=0 if survival2==.

save "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfipsfirms.dta", replace


*** (3) STEP 3. USE OBSERVED PLC AND RANDOM PLC TO PRODUCE DATASET INCLUDING NUMBER OF FIRMS ACTIVE COUNTY-YEAR BY PERCENTILE (PERCENTILE 10, P25, P50, P75, P90, MAX ACROSS 1,000 REPLICATIONS FOR RANDOM PLC) 

*** (3.1) RANDOM PLC: CALCULATE REALIZED OUTCOMES AA AND AB PERCENTILE X NUMBER OF FIRMS ALIVE BY YEAR-CFIPS, P10 P25 P50 P75 P90 MAX

*YEAR-CFIPS P10-P90 LOOP

foreach x of numlist 10 25 50 75 90 { 
	clear all
	use "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfips.dta"
	collapse (p`x') survival*, by (year cfips)
	rename survival1 survival1Ap`x'
	rename survival2 survival2Ap`x'
	save "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Ap`x'.dta", replace
}

*YEAR-CFIPS PMAX
clear all
use "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfips.dta"
collapse (max) survival*, by (year cfips)
rename survival1 survival1Apmax
rename survival2 survival2Apmax
save "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Apmax.dta", replace


*MERGE P10 P25 P50 P75 P90 & MAX
clear all

use "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Ap10.dta"

foreach x of numlist 25 50 75 90 { 
	merge 1:1 year cfips using "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Ap`x'.dta"
	drop _merge	
}

merge 1:1 year cfips using "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Apmax.dta"
drop _merge

save "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Apall.dta", replace


*** (4) STEP 4. USE RANDOM PLC TO PRODUCE DATASET INCLUDING NUMBER OF FIRMS ACTIVE COUNTY-YEAR BY PERCENTILE (PERCENTILE 10, P25, P50, P75, P90, MAX ACROSS 1,000 REPLICATIONS FOR RANDOM PLC) 

*** (4.1) RANDOM PLC: CALCULATE REALIZED OUTCOMES BA AND BB - PERCENTILE X NUMBER OF FIRMS ALIVE BY YEAR-CFIPS, P10 P25 P50 P75 P90 MAX

*YEAR-CFIPS P10-P90 LOOP

foreach x of numlist 10 25 50 75 90 { 
	clear all
	use "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfipsfirms.dta"
	collapse (p`x') survival*, by (year cfips_firms)
	rename survival1 survival1Bp`x'
	rename survival2 survival2Bp`x'
	save "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Bp`x'.dta", replace
}

*YEAR-CFIPS PMAX
clear all
use "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfipsfirms.dta"
collapse (max) survival*, by (year cfips_firms)
rename survival1 survival1Bpmax
rename survival2 survival2Bpmax
save "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Bpmax.dta" , replace

*MERGE P10 P25 P50 P75 P90 & MAX OF BEFORE STEP
clear all

use "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Bp10.dta"

foreach x of numlist 25 50 75 90 { 
	merge 1:1 year cfips_firms using "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Bp`x'.dta"
	drop _merge	
}

merge 1:1 year cfips_firms using "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Bpmax.dta"
drop _merge

rename cfips_firms cfips

save "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Bpall.dta", replace


*** (4.2) OBSERVED ALIVE BY YEAR-CFIPS FOR MAPS

clear all

* OBSERVED ALIVE BY YEAR-CFIPS

use "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\demography_company4_time_series_inc_county_ids_data_long_exc_missing_vpreliminary.dta" 
sort year cfips
collapse (sum) a, by (year cfips)
save "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\observed_PLC_cfips_maps.dta" , replace

* OBSERVED ALIVE BY YEAR-CFIPS_FIRMS

use "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\demography_company4_time_series_inc_county_ids_data_long_exc_missing_vpreliminary.dta" 
sort year cfips
collapse (sum) a, by (year cfips)
save "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\observed_PLC_cfipsfirms_maps.dta" , replace


*** (4.3) MERGE STEPS 3 + 4.1 + 4.2 + LOCATION QUOTIENT WITH DATASET SKELETON FOR MAPS (ALL 3,233 CFIPS X 36 YEARS = 116,388) TO PRODUCE DATASET TO PROJECT THE VARIABLES INNTO MAPS

clear all

use "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_skeleton_cfips_years_3233cfips.dta"

merge 1:1 year cfips using "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Apall.dta"
drop _merge

merge 1:1 year cfips using "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_collapse_map_cfips_Bpall.dta"
drop _merge

merge 1:1 year cfips using "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\observed_PLC_maps.dta"
drop _merge

merge 1:1 cfips year using "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\lqmap.dta"
drop _merge

gen observed_entry=0
replace observed_entry=1 if a!= . 

sort year a cfips
order year a cfips

replace survival1Ap10=0 if survival1Ap10==.
replace survival2Ap10=0 if survival2Ap10==.
replace survival1Ap25=0 if survival1Ap25==.
replace survival2Ap25=0 if survival2Ap25==.
replace survival1Ap50=0 if survival1Ap50==.
replace survival2Ap50=0 if survival2Ap50==.
replace survival1Ap75=0 if survival1Ap75==.
replace survival2Ap75=0 if survival2Ap75==.
replace survival1Ap90=0 if survival1Ap90==.
replace survival2Ap90=0 if survival2Ap90==.
replace survival1Apmax=0 if survival1Apmax==.
replace survival2Apmax=0 if survival2Apmax==.
replace survival1Bp10=0 if survival1Bp10==.
replace survival2Bp10=0 if survival2Bp10==.
replace survival1Bp25=0 if survival1Bp25==.
replace survival2Bp25=0 if survival2Bp25==.
replace survival1Bp50=0 if survival1Bp50==.
replace survival2Bp50=0 if survival2Bp50==.
replace survival1Bp75=0 if survival1Bp75==.
replace survival2Bp75=0 if survival2Bp75==.
replace survival1Bp90=0 if survival1Bp90==.
replace survival2Bp90=0 if survival2Bp90==.
replace survival1Bpmax=0 if survival1Bpmax==.
replace survival2Bpmax=0 if survival2Bpmax==.
replace a=0 if a==.
replace lqnestab=0 if lqnestab==.

save "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_skeleton_cfips_years_3233cfips.dta" , replace


*** (5) TRANSFORM VARIABLES INTO VARIABLES WITH RANGES TO PROJECT INTO MAPS, 1900 1910 1920 1930

*** (5.1) GENERATE PLQ = LOCATION QUOTIENT IN RANGES SET FOR MAPPING

gen plq=0

replace plq=0 if lqnestab >  0  & lqnestab <1
replace plq=1 if lqnestab >= 1  & lqnestab <5
replace plq=2 if lqnestab >= 5  & lqnestab <10
replace plq=3 if lqnestab >= 10 & lqnestab <20
replace plq=4 if lqnestab >= 20

*** (5.2) GENERATE P90A = VALUE OF NUMBER OF ASSEMBLERS ALIVE IN P90 IN SCENARIO 1A AND 2A (PURELY RANDOM ENTRY)

gen p901a=0

replace p901a=1 if survival1Ap90==0.5
replace p901a=2 if survival1Ap90==1

gen p902a=0

replace p902a=1 if survival2Ap90==0.5
replace p902a=2 if survival2Ap90==1


*** (5.3) GENERATE P90B = VALUE OF NUMBER OF ASSEMBLERS ALIVE IN P90 IN SCENARIO 1A AND 2A (RANDOM ENTRY WEIGHTED BY SHARE OF MANUFACTURING ESTABLISHMENTS)

gen p901b=0

replace p901b=0 if survival1Bp90 >  0  & survival1Bp90 <1
replace p901b=1 if survival1Bp90 >= 1  & survival1Bp90 <5
replace p901b=2 if survival1Bp90 >= 5  & survival1Bp90 <10
replace p901b=3 if survival1Bp90 >= 10 & survival1Bp90 <20
replace p901b=4 if survival1Bp90 >= 20

gen p902b=0

replace p902b=0 if survival2Bp90 >  0  & survival2Bp90 <1
replace p902b=1 if survival2Bp90 >= 1  & survival2Bp90 <5
replace p902b=2 if survival2Bp90 >= 5  & survival2Bp90 <10
replace p902b=3 if survival2Bp90 >= 10 & survival2Bp90 <20
replace p902b=4 if survival2Bp90 >= 20


*** (5.4) GENERATE OPA = OBSERVED AS PERCENTAGE OF PERCENTILE VALUES IN SCENARIO 1A AND 2A (PURELY RANDOM ENTRY)

gen opa1 = 0 

replace opa1 = 0 if a==0
replace opa1 = 1 if a>=survival1Ap10 & a>0
replace opa1 = 2 if a>=survival1Ap10 & a<survival1Ap25 & a>0
replace opa1 = 3 if a>=survival1Ap25 & a<survival1Ap50 & a>0
replace opa1 = 4 if a>=survival1Ap50 & a<survival1Ap75 & a>0
replace opa1 = 5 if a>=survival1Ap75 & a<survival1Ap90 & a>0
replace opa1 = 6 if a>=survival1Ap90 & a<survival1Apmax & a>0
replace opa1 = 7 if a>=survival1Apmax & a<survival1Apmax*2 & a>0
replace opa1 = 8 if a>=survival1Apmax*2 & a>0

gen opa2 = 0 

replace opa2 = 0 if a==0
replace opa2 = 1 if a>=survival2Ap10 & a>0
replace opa2 = 2 if a>=survival2Ap10 & a<survival2Ap25 & a>0
replace opa2 = 3 if a>=survival2Ap25 & a<survival2Ap50 & a>0
replace opa2 = 4 if a>=survival2Ap50 & a<survival2Ap75 & a>0
replace opa2 = 5 if a>=survival2Ap75 & a<survival2Ap90 & a>0
replace opa2 = 6 if a>=survival2Ap90 & a<survival2Apmax & a>0
replace opa2 = 7 if a>=survival2Apmax & a<survival2Apmax*2 & a>0
replace opa2 = 8 if a>=survival2Apmax*2 & a>0

*** (5.5) GENERATE OPB = OBSERVED AS PERCENTAGE OF PERCENTILE VALUES IN SCENARIO 1B AND 2B (RANDOM ENTRY WEIGHTED BY SHARE OF MANUFACTURING ESTABLISHMENTS)

gen opb1 = 0 

replace opb1 = 0 if a==0
replace opb1 = 1 if a>=survival1Bp10 & a>0
replace opb1 = 2 if a>=survival1Bp10 & a<survival1Bp25 & a>0
replace opb1 = 3 if a>=survival1Bp25 & a<survival1Bp50 & a>0
replace opb1 = 4 if a>=survival1Bp50 & a<survival1Bp75 & a>0
replace opb1 = 5 if a>=survival1Bp75 & a<survival1Bp90 & a>0
replace opb1 = 6 if a>=survival1Bp90 & a<survival1Bpmax & a>0
replace opb1 = 7 if a>=survival1Bpmax & a<survival1Bpmax*2 & a>0
replace opb1 = 8 if a>=survival1Bpmax*2 & a>0

gen opb2 = 0 

replace opb2 = 0 if a==0
replace opb2 = 1 if a>=survival2Bp10 & a>0
replace opb2 = 2 if a>=survival2Bp10 & a<survival2Bp25 & a>0
replace opb2 = 3 if a>=survival2Bp25 & a<survival2Bp50 & a>0
replace opb2 = 4 if a>=survival2Bp50 & a<survival2Bp75 & a>0
replace opb2 = 5 if a>=survival2Bp75 & a<survival2Bp90 & a>0
replace opb2 = 6 if a>=survival2Bp90 & a<survival2Bpmax & a>0
replace opb2 = 7 if a>=survival2Bpmax & a<survival2Bpmax*2 & a>0
replace opb2 = 8 if a>=survival2Bpmax*2 & a>0

save "C:\Users\chiqu\OneDrive - Universidad de los Andes\Jorge Guerra\MC experiment\MC_outputdata_random_PLC_skeleton_cfips_years_3233cfips_maps.dta" , replace


*** (6) FIGURES FOR ANALYSIS

*** (6.1) HISTOGRAMS FOR OBSERVED VALUES V RANDOM PLC P90 VALUES, 1900, 1910, 1920, 1930

* OBSERVED

* P901A

* P902A

* P901B USE BY CFIPS_FIRMS

* P902B USE BY CFIPS_FIRMS


*** (6.2) HISTOGRAMS FOR LQ (LOCATION QUOTIENT) V OP (OBSERVED AS PERCENTAGE OF RANDOM PLC PERCENTILE VALUE), 1900, 1910, 1920, 1930

* LQ

* OP - 1A

* OP - 2A

* OP - 1B 

* OP - 2B 


*** (6.3) SCATTER LQ (LOCATION QUOTIENT) V OP (OBSERVED AS PERCENTAGE OF RANDOM PLC PERCENTILE VALUE), 1900, 1910, 1920, 1930

* LQ

* OP - 1A

* OP - 2A

* OP - 1B 

* OP - 2B 


*** (6.4) PEARSON AND SPEARMAN LQ (LOCATION QUOTIENT) V OP (OBSERVED AS PERCENTAGE OF RANDOM PLC PERCENTILE VALUE), 1900, 1910, 1920, 1930

* SPEARMAN OBSERVED LQ OP1A OP2A OP1B OP2B

* PEARSON OBSERVED LQ OP1A OP2A OP1B OP2B


*** (7) MAPS FOR ANALYSIS

*** (7.1) MAPS FOR OBSERVED VALUES V RANDOM PLC P90 VALUES, 1900, 1910, 1920, 1930

* OBSERVED

* P901A

* P902A

* P901B

* P902B


*** (7.2) MAPS FOR LQ (LOCATION QUOTIENT) V OP (OBSERVED AS PERCENTAGE OF RANDOM PLC PERCENTILE VALUE), 1900, 1910, 1920, 1930

* LQ

* OP - 1A

* OP - 2A

* OP - 1B

* OP - 2B


















*SAVE a, survival2B_p90, plq, pb2, pa2 TO PROYECT IN MAPS (ARCMAP)
**SEE maps.txt document to more information about the maps process --> D:\Git-Hub\Assemblers-ProjectC\Figures\Maps\map.txt

forval i= 1900(10)1930 {
	clear all
	use "D:\Git-Hub\Assemblers-ProjectC\Data\Output\MC_outputdata_random_PLC_collapse_map_cfips_observed_&_ABpall.dta"
	keep year a cfips pb2 pa2 survival2Bp90 survival1Bp90 lqnestab  plq
	keep if year == `i'
	replace survival2Bp90=-1 if a==-1
	rename year year_`i'
	rename a a_`i'
	rename survival2Bp90 survival2Bp90_`i'
	rename survival1Bp90 survival1Bp90_`i'
	rename pb2 pb2_`i'
	rename pa2 pa2_`i'
	rename plq plq_`i'
 	rename lqnestab lqnestab_`i'
	export excel using "D:\Git-Hub\Assemblers-ProjectC\Figures\Maps\maps_tables\Map`i'.xls", firstrow(variables) replace
}


*** (10) HISTOGRAMS
********************************************************************************
clear all
use "D:\Git-Hub\Assemblers-ProjectC\Data\Output\MC_outputdata_random_PLC_collapse_map_cfips_observed_&_ABpall.dta"

//if a>=0 & survival2Bp90>=1
//RANDOM PLC 90 WITH WEGHTED ENTRY (B) AND SURVIVAL YEAR-YEAR (2): survival2Bp90
forval i = 1900(10)1920 {
 	histogram survival2Bp90 if year==`i' & survival2Bp90>=1, discrete frequency fcolor(gs10) lcolor(black) addlabel xtitle(Random PLC p90) title(Random PLC p90 `i') graphregion(color(white))
	graph export "D:\Git-Hub\Assemblers-ProjectC\Figures\Histograms\RandomPLC2Bp90_`i'.png", as(png) name("Graph") replace
}

histogram survival2Bp90 if  year==1930 & survival2Bp90>=1, discrete frequency fcolor(gs10) lcolor(black) barwidth(0.2) addlabel xtitle(Random PLC p90) title(Random PLC p90 1930) graphregion(color(white))
graph export "D:\Git-Hub\Assemblers-ProjectC\Figures\Histograms\RandomPLC2Bp90_1930.png", as(png) name("Graph") replace

********************************************************************************
//RANDOM PLC WITH WEGHTED ENTRY (B) AND SURVIVAL DETERMINISTIC (1) (SURVIVAL1B)): survival1Bp90
forval i = 1900(10)1920 {
 	histogram survival1Bp90 if year==`i' & survival1Bp90>=1, discrete frequency fcolor(gs10) lcolor(black) addlabel xtitle(Random PLC p90) title(Random PLC p90 `i') graphregion(color(white))
	graph export "D:\Git-Hub\Assemblers-ProjectC\Figures\Histograms\RandomPLC1Bp90_`i'.png", as(png) name("Graph") replace
}

histogram survival1Bp90 if year==1930 & survival1Bp90>=1 , discrete frequency fcolor(gs10) lcolor(black) barwidth(0.2) addlabel xtitle(Random PLC p90) title(Random PLC p90 1930) graphregion(color(white))
graph export "D:\Git-Hub\Assemblers-ProjectC\Figures\Histograms\RandomPLC1Bp90_1930.png", as(png) name("Graph") replace

********************************************************************************
//OBSERVED
forval i = 1900(10)1930 {
 	histogram a if a>0 & year==`i', discrete frequency fcolor(gs10) lcolor(black) addlabel xtitle(Observed) title(Observed `i') graphregion(color(white))
	graph export "D:\Git-Hub\Assemblers-ProjectC\Figures\Histograms\Observed_`i'.png", as(png) name("Graph")
}

********************************************************************************

//pb2
forval i = 1900(10)1930 {
 	histogram pb2 if pb2>0 & year==`i', discrete frequency fcolor(gs10) lcolor(black) addlabel xtitle(Random PLC percentile) title(Random PLC percentile `i') graphregion(color(white))
	graph export "D:\Git-Hub\Assemblers-ProjectC\Figures\Histograms\pb2_`i'.png", as(png) name("Graph") replace
}

********************************************************************************
//pa2
forval i = 1900(10)1930 {
 	histogram pa2 if pa2>0 & year==`i', discrete frequency fcolor(gs10) lcolor(black) addlabel xtitle(Random PLC percentile) title( Random PLC percentile `i') graphregion(color(white))
	graph export "D:\Git-Hub\Assemblers-ProjectC\Figures\Histograms\pa2_`i'.png", as(png) name("Graph") replace
}

********************************************************************************
//LQ
forval i = 1900(10)1930 {
	histogram lqnestab if lqnestab>0 & year==`i', bin(20) frequency fcolor(gs10) lcolor(black) addlabel xtitle(LQ) title(lqnestab `i') graphregion(color(white))
	graph export "D:\Git-Hub\Assemblers-ProjectC\Figures\Histograms\LQ_`i'.png", as(png) name("Graph") replace
}

********************************************************************************

//hasta aquí todo corre bien









*** SCATERS
clear all
*** (11) SCATTERS  & CORRELATIONS ->: LQ VS OBSERVED AS PERCENTIL OF RANDOM PLC WITH WEGHTED ENTRY (B) AND SURVIVAL YEAR-YEAR (2): survival2Bp90

*GEN THE PERCENTILS FROM 1 TO 100 (MÁX): LOOP

forval i = 87(1)99{
	use "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips_weighted\MC_outputdata_random_weighted_PLC_collapse_rep_year_cfips.dta"
	collapse (p`i') survival2, by (year cfips_firms)
	rename survival2 survival2_p`i'
	save "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips_weighted_1-max_2B\p`i'.dta", replace
}

use "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips_weighted\MC_outputdata_random_weighted_PLC_collapse_rep_year_cfips.dta"
collapse (max) survival2, by (year cfips_firms)
rename survival2 survival2_pmax
save "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips_weighted_1-max_2B\pmax.dta", replace


*PERCENTILES MERGE'S
clear all
use "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips _weighted_1-max_2B\p1.dta"

forval i = 2(1)99{
	merge 1:1 year cfips_firms using "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips _weighted _1-max_2B\p`i'.dta"
	drop _merge
}

merge 1:1 year cfips_firms using "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips _weighted _1-max_2B\pmax.dta"
drop _merge
rename cfips_firms cfips
save "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips _weighted _1-max_2B\MC_outputdata_random_PLC_collapse_map_cfips_firms_2Bp1-max.dta", replace


*CREATE A DATASET WITH PERCENTILS & OBSERVED ENTRY
clear all
use "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips _weighted _1-max_2B\MC_outputdata_random_PLC_collapse_map_cfips_firms_2Bp1-max.dta"
merge 1:1 year cfips using "C:\Users\Jorge Guerra\Dropbox\Jorge Guerra\observed_PLC_maps.dta"
drop _merge

*KEEP ONLY OBSERVATIONES THAT HAVE OBSERVED  ENTRY AND SURVIVAL -> 7645, SOME COUNTYS HAVE OBSERVED (214x36) ENTRY BUT NOT SURVIVAL (1925X36)

drop if a==. 
drop if survival2_p1==.
save "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips _weighted _1-max_2B\MC_outputdata_random_PLC_collapse_map_cfips_firms_2Bp1-max&a.dta", replace



*** (11.1) GEN OBSERVED AS PERCENTIL OF RANDOM PLC VARIABLE: aps_2B
*IF A OBS HAVE THE SAME NUMBER IN A INTERVAL OF PERCENTILS, WE TAKE THE MEDIAN IN THE INTERVAL (**)

use "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips _weighted _1-max_2B\MC_outputdata_random_PLC_collapse_map_cfips_firms_2Bp1-max&a.dta"

// LOOP ASCENDING, aps_2B take the value of max in range when survival2_[i]=survival2_p[i+1]

forval i= 1(1)99{
	replace aps_2B=`i' if a==survival2_p`i'
}

*A < P1
replace aps_2B = 0 if a < survival2_p1

*MAX
replace aps_2B = 100 if a==survival2_pmax & survival2_p1<survival2_pmax

*P1=MAX
replace aps_2B=50 if survival2_p1==a & survival2_pmax==a
*p99 < A < pmax
replace aps_2B=99.5 if survival2_p99<a & a<survival2_pmax

*A>PMAX
replace aps_2B = ((a/survival2_pmax)*100) if a > survival2_pmax

save "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips _weighted _1-max_2B\MC_outputdata_random_PLC_collapse_map_cfips_firms_aps_2B.dta", replace



*** (11.2) SCATERS AND CORRELATIONS
clear all
use "D:\Git-Hub\Assemblers-ProjectC\Data\Input\lqmap.dta"

*MERGE LQ WITH aps_2B
merge 1:1 cfips year using "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips _weighted _1-max_2B\MC_outputdata_random_PLC_collapse_map_cfips_firms_aps_2B.dta"
drop if _merge!=3

keep if year== 1900 | year== 1910 | year== 1920 | year== 1930
drop gisjoin gisjoin1 year1 ansicode _merge

save "D:\Git-Hub\Assemblers-ProjectC\Data\Output\MC_outputdata_random_PLC_collapse_map_cfips_firms_aps_2B&lq.dta", replace

*GRAPHS
twoway (scatter lqnestab aps_2B,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1900 , xtitle(Observed as percentile of random PLC) ytitle (LQ) xmtick(0(50)160)
graph export "D:\Git-Hub\Assemblers-ProjectC\Figures\Scatter\lqnestab_v_aps_2B_1900.png", as(png) name("Graph")

twoway (scatter lqnestab aps_2B,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1910 , xtitle(Observed as percentile of random PLC) ytitle (LQ) xmtick(0(50)650)
graph export "D:\Git-Hub\Assemblers-ProjectC\Figures\Scatter\lqnestab_v_aps_2B_1910.png", as(png) name("Graph")

twoway (scatter lqnestab aps_2B,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1920 , xtitle(Observed as percentile of random PLC) ytitle (LQ) xmtick(0(50)650)
graph export "D:\Git-Hub\Assemblers-ProjectC\Figures\Scatter\lqnestab_v_aps_2B_1920.png", as(png) name("Graph")

twoway (scatter lqnestab aps_2B,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1930 , xtitle(Observed as percentile of random PLC) ytitle (LQ) xmtick(0(50)500)
graph export "D:\Git-Hub\Assemblers-ProjectC\Figures\Scatter\lqnestab_v_aps_2B_1930.png", as(png) name("Graph")


*CORRELATIONS
*pwcprr
ssc install asdoc
cd "D:\Git-Hub\Assemblers-ProjectC\Figures\Correlations"

forval i = 1900(10)1930 {
	display "`i'"
	asdoc pwcorr lqnestab aps_2B if year==`i' , sig star(.05) obs title(correlation qnestab vs aps_2B `i') save(pwcorr_lqnestab_v_aps_2B.doc)
}

*spearman
forval i = 1900(10)1930 {
	display "`i'"
	spearman lqnestab aps_2B if year==`i'
	asdoc spearman lqnestab aps_2B if year==`i' , title(spearman correlation qnestab vs aps_2B `i') save(spcorr_lqnestab_v_aps_2B.doc)







*** (12) SCATTERS  & CORRELATIONS -> LQ VS OBSERVED AS PERCENTIL OF RANDOM PLC WEGHTED ENTRY (B) AND SURVIVAL DETERMINISTIC (1) (SURVIVAL1B)): survival1Bp90
clear all
*GEN THE PERCENTILS FROM 1 TO 100 (MÁX): LOOP

forval i = 1(1)99{
	use "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips_weighted\MC_outputdata_random_weighted_PLC_collapse_rep_year_cfips.dta"
	collapse (p`i') survival1, by (year cfips_firms)
	rename survival1 survival1_p`i'
	save "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips_weighted_1-max_1B\p`i'.dta", replace
}

use "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips_weighted\MC_outputdata_random_weighted_PLC_collapse_rep_year_cfips.dta"
collapse (max) survival1, by (year cfips_firms)
rename survival1 survival1_pmax
save "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips_weighted_1-max_1B\pmax.dta", replace

*PERCENTILES MERGE'S
clear all
use "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips_weighted_1-max_1B\p1.dta"

forval i = 2(1)99{
	merge 1:1 year cfips_firms using "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips_weighted_1-max_1B\p`i'.dta"
	drop _merge
}

merge 1:1 year cfips_firms using "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips_weighted_1-max_1B\pmax.dta"
drop _merge

rename cfips_firms cfips

save "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips_weighted_1-max_1B\MC_outputdata_random_PLC_collapse_map_cfips_firms_1Bp1-max.dta", replace


*CREATE A DATASET WITH PERCENTILS & OBSERVED ENTRY
clear all
use "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips_weighted_1-max_1B\MC_outputdata_random_PLC_collapse_map_cfips_firms_1Bp1-max.dta"

merge 1:1 year cfips using "C:\Users\Jorge Guerra\Dropbox\Jorge Guerra\observed_PLC_maps.dta"
drop _merge

*KEEP ONLY OBSERVATIONES THAT HAVE OBSERVED  ENTRY AND SURVIVAL -> 7645, SOME COUNTYS HAVE OBSERVED (214x36) ENTRY BUT NOT SURVIVAL (1925X36)

drop if a==. 
drop if survival1_p1==.

save "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips_weighted_1-max_1B\MC_outputdata_random_PLC_collapse_map_cfips_firms_1Bp1-max&a.dta", replace

*** (12.1) GEN OBSERVED AS PERCENTIL OF RANDOM PLC VARIABLE: aps_2A
*IF A OBS HAVE THE SAME NUMBER IN A INTERVAL OF PERCENTILS, WE TAKE THE MEDIAN IN THE INTERVAL (**)

gen aps_2A=.

// LOOP ASCENDING, aps_2B take the value of max in range when survival2_[i]=survival2_p[i+1]

forval i= 1(1)99{
	replace aps_2A=`i' if a==survival1_p`i'
}

*MAX
replace aps_2A = 100 if a==survival1_pmax & survival1_p1<survival1_pmax

*P1=MAX
replace aps_2A=50 if survival1_p1==a & survival1_pmax==a

*p99 < A < pmax
replace aps_2A=99.5 if survival1_p99<a & a<survival1_pmax

*A < P1
replace aps_2A = 0 if a < survival1_p1


*A>PMAX
replace aps_2A = ((a/survival1_pmax)*100) if a > survival1_pmax


save "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips_weighted_1-max_1B\MC_outputdata_random_PLC_collapse_map_cfips_firms_aps_2A.dta", replace

*** (12.2) SCATERS AND CORRELATIONS
clear all
use "D:\Git-Hub\Assemblers-ProjectC\Data\Input\lqmap.dta"

*MERGE LQ WITH aps_2B
merge 1:1 cfips year using "D:\Git-Hub\Assemblers-ProjectC\Data\Output\P_cfips_weighted_1-max_1B\MC_outputdata_random_PLC_collapse_map_cfips_firms_aps_2A.dta"
drop if _merge!=3

keep if year== 1900 | year== 1910 | year== 1920 | year== 1930
drop gisjoin gisjoin1 year1 ansicode _merge

save "D:\Git-Hub\Assemblers-ProjectC\Data\Output\MC_outputdata_random_PLC_collapse_map_cfips_firms_aps_2A&lq.dta", replace

*GRAPHS
twoway (scatter lqnestab aps_2A,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1900 , xtitle(Observed as percentile of random PLC) ytitle (LQ) xmtick(0(50)160) graphregion(color(white))
graph export "D:\Git-Hub\Assemblers-ProjectC\Figures\Scatter\lqnestab_v_aps_2A_1900.png", as(png) name("Graph")

twoway (scatter lqnestab aps_2A,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1910 , xtitle(Observed as percentile of random PLC) ytitle (LQ) xmtick(0(50)650) graphregion(color(white))
graph export "D:\Git-Hub\Assemblers-ProjectC\Figures\Scatter\lqnestab_v_aps_2A_1910.png", as(png) name("Graph")

twoway (scatter lqnestab aps_2A,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1920 , xtitle(Observed as percentile of random PLC) ytitle (LQ) xmtick(0(50)650) graphregion(color(white))
graph export "D:\Git-Hub\Assemblers-ProjectC\Figures\Scatter\lqnestab_v_aps_2A_1920.png", as(png) name("Graph")

twoway (scatter lqnestab aps_2A,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1930 , xtitle(Observed as percentile of random PLC) ytitle (LQ) xmtick(0(50)500) graphregion(color(white))
graph export "D:\Git-Hub\Assemblers-ProjectC\Figures\Scatter\lqnestab_v_aps_2A_1930.png", as(png) name("Graph")


*CORRELATIONS
*pwcprr

cd "D:\Git-Hub\Assemblers-ProjectC\Figures\Correlations"

forval i = 1900(10)1930 {
	display "`i'"
	asdoc pwcorr lqnestab aps_2A if year==`i' , sig star(.05) obs title(correlation qnestab vs aps_2A `i') save(pwcorr_lqnestab_v_aps_2A.doc)
}

*spearman
forval i = 1900(10)1930 {
	display "`i'"
	spearman lqnestab aps_2A if year==`i'
	asdoc spearman lqnestab aps_2A if year==`i' , title(spearman correlation qnestab vs aps_2A `i') save(spcorr_lqnestab_v_aps_2A.doc)
}


