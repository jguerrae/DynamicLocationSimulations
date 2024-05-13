****************************************************************
****************************************************************
****************************************************************
*** RANDOM PLC FOR EARLY AUTO ASSEMBLER INDUSTRY USING MONTE CARLO EXPERIMENT
***
*** GENERAL COMMENTS ON APPROACH TO SIMULATION
***
*** I USE OBSERVED TO DESCRIBE AN EVENT THAT DID HAPPEN 1895-1930 - USUALLY A SET OF OBSERVATIONS THAT MAY BE INTERPRETED AS A PROBABILITY DISTRIBUTION OR A LIST OF ASSEMBLERS ...
***
*** I USE ALL POSSIBLE OUTCOME TO DESCRIBE A MATRIX OF ALL POSSIBLE OUTCOMES, A DATASET THAT CAN ENCOMPASS ANY POSSIBLE OUTCOME IN THE PROBLEM AT HAND 
***
*** I USE REALIZED TO DESCRIBE A PSEUDO-RANDOMLY PRODUCED OUTCOME (AS OPPOSED TO AN OBSERVED OUTCOME THAT IS A HISTORICAL OUTCOME) 
*** 
*** THE MOST STRAIGHT FORWARD RANDOM PLC USING MONTE CARLO EXPERIMENT I CAN THINK OF IMPLIES FIRST BUILDING A DATASET WITH OF ALL POSSIBLE OUTCOMES AS OBSERVATIONS AND NEXT ALLOCATING PSEUDO-RANDOMLY ALL REALIZED OUTCOMES. THE DATASET OF ALL POSSIBLE OUTCOMES IS APROX. 67.3 BILLION OBSERVATIONS (971 FIRMS X 36 POSSIBLE SURVIVAL YEARS X 1,925 POSSIBLE LOCATIONS (COUNTIES) X 1,000 MONTE CARLO EXPERIMENT REPLICATIONS)
*** 
*** MY COMPUTER DOES NOT ALLOW WORKING WITH SUCH A DATASET (AND I UNDERSTAND STATA DOES NOT ALLOW EITHER, STATA/MP PRACTICAL LIMIT ALLOWS TO HANDLE APROX 24.4 BILLION). HENCE, I BROKE THE PROBLEM INTO 2 STEPS
***
***
***
*** GENERAL STEPS I AND II
***
*** STEP I. CREATING DATASET WITH ONLY RANDOM REALIZED FIRM-COUNTY-YEAR OUTCOMES (IMPLIES PERFORMING ALL PSEUDO RANDOM ALLOCATIONS AND CALCULATIONS) = 971 FIRMS X 4,572 FIRM YEARS ALIVE X 1,000 REPLICATIONS
*** = 4,439,412,000 OBSERVATIONS
***
*** STEP II. COLLAPSE DATASET WITH RANDOM REALIZED FIRM-COUNTY-YEAR OUTCOMES TO REALIZED COUNTY-YEAR OUTCOMES. NEXT, MERGE RANDOM REALIZED COUNTY-YEAR OUTCOMES DATASET TO DATASET OF SKELETON OF ALL POSSIBLE COUNTY-YEAR OUTCOMES AND THEN FILL REST WITH 0s (1,925 COUNTIES X 36 YEARS X 1,000 REPLICATIONS = 69.3 MILLION OBSERVATIONS)
***
***
***
*** DETAILED STEPS I AND II
***
*** STEP I. CREATE FIRM-COUNTY-YEAR RANDOM REALIZED OUTCOMES DATASET
***
*** 1. CREATE DATASET SKELETON = 971 FIRMS (ASSEMBLERS THAT ENTERED DURING AUTO PLC 1895-1930) X 1,000 REPLICATIONS = 971,000 OBSERVATIONS
*** 2. ALLOCATE TO EACH OF THE 971,000 FIRMS PSEUDO-RANDOMLY AN ENTRY YEAR FROM OBSERVED ENTRY YEAR DISTRIBUTION AND A SMITHCOMPANYCODE FROM SMITHCOMAPANYCODE ASSEMBLER ID LIST (SMITH'S WHEELS ON WHEELS LIST OF ASSEMBLERS)
*** 3. ALLOCATE TO EACH OF THE 971,000 FIRMS PSEUDO-RANDONLY A LOCATION WITHIN THE SET OF 1,925 POSSIBLE COUNTIES, WITH A GIVEN COUNTY PROBABILITY OF ALLOCATION EQUAL TO THE 1890 CROSS COUNTY SHARE OF MANUFACTURING VARIABLES (ESTABLISHMENTS, INCOME MARKETS ACCESS, INCOME FOREIGN MARKET ACCESS, OR KNOWLEDGE STOCK)  
*** 4. ALLOCATE TO EACH OF THE 971,000 FIRMS PSEUDO-RANDOMLY A SURVIVAL AGE, WITH SURVIVAL AGE THE RESULT OF A PSEUDO-RANDOM YEAR BY YEAR SURVIVAL ALLOCATION PROCESS
***
*** STEP II. CREATE FULL DATASET
*** 
*** 1. COLLAPSE FIRM-COUNTY-YEAR RANDOM REALIZED OUTCOMES DATASET INTO COUNTY-YEAR RANDOM REALIZED OUTCOMES DATASET
*** 2. MERGE REALIZED RANDOM COUNTY-YEAR OUTCOMES DATASET WITH DATASET OF ALL POSSIBLE COUNTY-YEAR OUTCOMES 
***
****************************************************************
****************************************************************
****************************************************************


****************************************************************
****************************************************************
****************************************************************
*** STEP I. CREATE DATASET WITH REALIZED RANDOM OUTCOMES
****************************************************************
****************************************************************
****************************************************************

*** INPUT DATASETS FROM OBSERVED DATASET

*** MC_inputdata_year_entry.dta = OBSERVED NUMBER OF ENTRANTS PER PLC YEAR, 1895-1930

*** MC_inputdata_smith.dta = SMITHCOMPANYCODE OF 971 ASSEMBLERS

*** MC_inputdata_crosscounty.dta = COUNTY CFIPS OF 1,925 POSSIBLE LOCATIONS (WITH FULL INFO FOR ANALYSIS) AND CROSS COUNTY SHARES FOR ALL 1890 VARIABLES

*** (1) 36 OBSERVATIONS OF OBSERVED NUMBER OF ENTRANTS PER PLC YEAR EXPANDED INTO 971,000 OBSERVATIONS, EACH OBSERVATION IS FIRM-ENTRY YEAR-REPLICATION

clear all

cd "D:\MCs\MC"

use "MC_inputdata_year_entry.dta"

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

*** (3) ALLOCATE RANDONMLY AN OBSERVED ASSEMBLER LOCATION IDENTITY TO EACH FIRM-ENTRY YEAR-ASSEMBLER ID-REPLICATION OBSERVATION (RANDOM ALLOCATION OF 1 OF 10,000 POSSIBLE FIRM-LOCATIONS FOR ESTABLISHMENTS, INCOME MARKET ACCESS, INCOME FOREIGN MARKET ACCESS AND KNOWLEDGE STOCK IN 1890 (CROSS-COUNTY SHARE OF APROX 10,000 OBSERVATIONS FOR EACH VARIABLE) TO EACH 971,000 FIRM OBSERVATIONS, WITH REPLACEMENT WITHIN A GIVEN REPLICATION SUCH THAT AGGLOMERATION MAY BE OBSERVED)

*** I CHECKED RESULTS OF CODE FOR ESTABLISMENTS (RANDOM ALLOCATION OF 1 OF 337,902 POSSIBLE FIRM-LOCATION TO EACH 971,000 FIRM OBSERVATIONS, WITH REPLACEMENT WITHIN A GIVEN REPLICATION SUCH THAT AGGLOMERATION MAY BE OBSERVED) - I HAVE CHECKED THIS, CORRECT WITH REPLACEMENT: CFIPS WITH LOW ENTRY HAS FREQUENCY 1 (AUGUSTA, FL) OUT OF 971,000 REPLICATIONS, WHILE CFIPS WITH HIGH ENTRY (NEW YORK, NY) HAS 72,849 OUT OF 971,000 REPLICATIONS

set obs 971000
set seed 3219
gen cfipsfirmsid = floor(( XXXX USE NOBS -1 CORRECT FILE XXX +1)*runiform() + 1)

*** (4) ALLOCATE RANDOMLY A SURVIVAL AGE (RESULTING FROM THE PROBABILITY TO SURVIVE ONE MORE YEAR AT EACH AGE ESTIMATED FROM OBSERVED PLC DATA) TO EACH FIRM-ENTRY YEAR-ASSEMBLER ID-LOCATION-REPLICATION OBSERVATION - SURVIVAL GIVEN BY PROBABILITY OF SURVIVAL ONE MORE YEAR FROM LOGIT ESTIMATE OF OBSERVED SURVIVAL ON OBSERVED AGE IN T-1 WITHOUT FIXED COUNTY AND YEAR EFFECTS + INTERPOLATING MISSING ESTIMATED VALUES (SEE FILE ONE MORE YEAR SURVIVAL)

set obs 21205000
set seed 8631
gen psurvival2 = runiform()
gen s=0

replace s=1 if psurvival<0.876 & yearid==2
replace s=1 if psurvival<0.728 & yearid==3
replace s=1 if psurvival<0.692 & yearid==4
replace s=1 if psurvival<0.78 & yearid==5
replace s=1 if psurvival<0.736 & yearid==6
replace s=1 if psurvival<0.802 & yearid==7
replace s=1 if psurvival<0.8 & yearid==8
replace s=1 if psurvival<0.763 & yearid==9
replace s=1 if psurvival<0.832 & yearid==10
replace s=1 if psurvival<0.835 & yearid==11
replace s=1 if psurvival<0.85 & yearid==12
replace s=1 if psurvival<0.91 & yearid==13
replace s=1 if psurvival<0.869 & yearid==14
replace s=1 if psurvival<0.906 & yearid==15
replace s=1 if psurvival<0.889 & yearid==16
replace s=1 if psurvival<0.872 & yearid==17
replace s=1 if psurvival<0.853 & yearid==18
replace s=1 if psurvival<0.897 & yearid==19
replace s=1 if psurvival<0.885 & yearid==20
replace s=1 if psurvival<0.857 & yearid==21
replace s=1 if psurvival<0.941 & yearid==22
replace s=1 if psurvival<0.857 & yearid==23
replace s=1 if psurvival<0.878500052574522 & yearid==24
replace s=1 if psurvival<0.900000105149044 & yearid==25
replace s=1 if psurvival<0.886918780149044 & yearid==26
replace s=1 if psurvival<0.873837455149044 & yearid==27
replace s=1 if psurvival<0.860756130149044 & yearid==28
replace s=1 if psurvival<0.75 & yearid==29
replace s=1 if psurvival<0.74 & yearid==30
replace s=1 if psurvival<0.73 & yearid==31
replace s=1 if psurvival<0.72 & yearid==32
replace s=1 if psurvival<0.71 & yearid==33
replace s=1 if psurvival<0.7 & yearid==34
replace s=1 if psurvival<0.69 & yearid==35
replace s=1 if psurvival<0.68 & yearid==36

*** PROBABILITY OF SURVIVAL INCLUDED IN PREVIOUS CODE LINES 88-126 IS LOGIT WITHOUT FIXED EFFECT (APROXIMATELY KAPLAN MEIER). NOW DO WITH PROBABILITY OF SURVIVAL INCLUDING FIXED COUNTY AND YEAR EFFECTS -> DO 1 MC EXPERIMENT WITH THESE PROBABILITY ESTIMATES JUST TO SEE MAGNITUDE OF DIFFERENCE IN SIMULATED AGE DISTRIBUTION AND COMPARE AGAINST LOGIT ESTIMATE WITHOUT FIXED EFFECTS AND OBSERVED *** 
*******************************************************************************************************

gen survival2=0

replace survival2=1 if year==entryyear
replace survival2=1 if survival2[_n-1]==1 & s==1 & year>entryyear
bysort repid firmid: egen agedraw2=sum(survival2)

*** VARIABLES HELPFUL TO CHECK THAT RANDOM DRAWS WITHOUT REPLACEMENT INDEED WORKED THAT WAY

bysort repid firmid: gen agecountsurvival1=_n if survival1==1

replace agecountsurvival1=0 if survival1==0

bysort repid firmid: gen agecountsurvival2=_n if survival2==1

replace agecountsurvival2=0 if survival2==0

save "MC_outputdata_random_PLC.dta", replace

*** TABLES TO COMPARE RANDOM AND OBSERVED PLC AGE DISTRIBUTION OF FIRMS

*** (A) OBSERVED PLC - AGE DISTRIBUTION OF FIRMS

use "MC_inputdata_age.dta" 

tab aa 

*** (B) RANDOM PLC - AGE DISTRIBUTION OF FIRMS ALLOCATED AT BIRTH AND AT ONE MORE YEARS

use "MC_outputdata_random_PLC.dta"

tab agedraw2 if year==1930


****************************************************************
****************************************************************
****************************************************************
*** STEP II. CREATE FULL DATASET, ALL POSSIBLE OUTCOMES - 1,925 COUNTIES X 36 YEARS X 1,000 REPLICATIONS = 69.3 MILLION OBSERVATIONS
****************************************************************
****************************************************************
****************************************************************

*** STEP 1. PRODUCE DATASET WITH REALIZED RANDOM OUTCOMES AT COUNTY LEVEL - COUNTY X NUMBER OF YEAR-REPLICACTIONS IN WHICH RANDOM OUTCOME OCCURRED (DATASET WITH REALIZED RANDOM OUTCOMES AT COUNTY LEVEL IS 21,205,000 OBSERVATIONS BECAUSE FIRST YEARS ONLY HAVE SOME OBS AS ONLY FEW FIRMS ENTER WHILE FINAL YEARS HAVE ALL OBS BECAUSE FIRMS ARE EITHER ALIVE OR HAVE ENTERED AND DIED AND HAVE 0)

*** STEP 2. MERGE DATASET WITH REALIZED RANDOM OUTCOMES AND DATASET WITH ALL POSSIBLE OUTCOMES FOR 1,925 COUNTIES X 36 YEAR X 1,000 REPLICATIONS = 69,300,000 OBSERVATIONS. NOTE THIS STEP IS REQUIRED BECAUSE RANDOM PLC WAS CONSTRUCTED BY PRODUCING ONLY REALIZED OUTCOMES. THUS, FOR SOME COUNTY-YEARS REPLICATIONS WITH NO ACTIVITY DO NOT APPEAR IN REALIZED RANDOM OUTCOME DATASET AS AN OBSERVATION IN RANDOM PLC. BUT WE NEED TO INCLUDE ALL REPLICATIONS TO CALCULATE PERCENTILES CORRECTLY. 

*** STEP 3. USE OBSERVED PLC AND RANDOM PLC TO PRODUCE NUMBER OF FIRMS ACTIVE COUNTY-YEAR RAW DATA (INCLUDING RANDOM PLC PERCENTILE 10, P25, P50, P75, P90, MAX ACROSS 1,000 REPLICATIONS) 



****************************************************************
****************************************************************
****************************************************************
*** AGGLOMERATION ANALYSIS EXAMINES AGGLOMERATION INDICES AT COUNTY LEVEL FOR PLC PERIOD (1,925 COUNTIS (WITH FULL ANALYSIS INFO) X 36 PLC YEARS = 69,300)

*** PRODUCE RAW DATA TO CALCULATE AGGLOEMRATION INDICES 

*** STEP 1. PRODUCE DATASET WITH REALIZED RANDOM OUTCOMES AT COUNTY LEVEL - COUNTY X NUMBER OF YEAR-REPLICACTIONS IN WHICH RANDOM OUTCOME OCCURRED (DATASET WITH REALIZED RANDOM OUTCOMES AT COUNTY LEVEL IS 21,205,000 OBSERVATIONS BECAUSE FIRST YEARS ONLY HAVE SOME OBS AS ONLY FEW FIRMS ENTER WHILE FINAL YEARS HAVE ALL OBS BECAUSE FIRMS ARE EITHER ALIVE OR HAVE ENTERED AND DIED AND HAVE 0)

*** STEP 2. MERGE DATASET WITH REALIZED RANDOM OUTCOMES AND DATASET WITH ALL POSSIBLE OUTCOMES FOR 1,925 COUNTIES X 36 YEAR X 1,000 REPLICATIONS = 69,300,000 OBSERVATIONS. NOTE THIS STEP IS REQUIRED BECAUSE RANDOM PLC WAS CONSTRUCTED BY PRODUCING ONLY REALIZED OUTCOMES. THUS, FOR SOME COUNTY-YEARS REPLICATIONS WITH NO ACTIVITY DO NOT APPEAR IN REALIZED RANDOM OUTCOME DATASET AS AN OBSERVATION IN RANDOM PLC. BUT WE NEED TO INCLUDE ALL REPLICATIONS TO CALCULATE PERCENTILES CORRECTLY. 

*** STEP 3. USE OBSERVED PLC AND RANDOM PLC TO PRODUCE NUMBER OF FIRMS ACTIVE COUNTY-YEAR RAW DATA (INCLUDING RANDOM PLC PERCENTILE 10, P25, P50, P75, P90, MAX ACROSS 1,000 REPLICATIONS) 

*** STEP 4. PRODUCE "AGGLOMERATION INDICES" DATASET INCLUDING 1) OBSERVED PLC NUMBER OF FIRMS ALIVE, 2) RANDOM PLC NUMBER OF FIRMS ALIVE BY SCENARIO AA, AB, BA, BB ALL RELEVANT PERCENTILES, 3) NUMBER OF FIRMS ALIVE BY SCENARIO A1, A2, B1, B2 AS PERCENTILE OF OF RANDOM NUMBER OF FIRMS ALIVE, 4) LOCATION QUOTIENT + MERGE FILES STEP 3 + STEP 4

*** STEP 5. TRANSFORM VARIABLES INTO VARIABLES WITH RANGES TO PROJECT INTO MAPS, 1900 1910 1920 1930

*** STEP 6. USE "AGGLOMERATION INDICES" DATASET TO PRODUCE DESCRIPTIVE STATISTICS

*** STEP 7. USE "AGGLOMERATION INDICES" DATASET TO PRODUCE DESCRIPTIVE STATISTICS

****************************************************************


***************************************************************
*** (1) STEP 1. PRODUCE DATASET WITH REALIZED RANDOM OUTCOMES AT COUNTY LEVEL - COUNTY WHERE RANDOM ENTRY ALLOCATED X NUMBER OF YEARS FIRMS ALIVE X REPLICACTIONS WITH OUTCOME REALIZED



*** (1) RANDOM PLC - NUMBER OF FIRMS ALIVE BY YEAR & CFIPS ACROSS REPLICATIONS - CFIPS: RANDOMLY ALLOCATED CFIPS WEIGTHED BY NUMBER OF ALL MANUFACTURING FIRMS AT CFIPS

clear all
use "MC_outputdata_random_PLC.dta"

//sort repid year cfips_firms
collapse (sum) survival1 survival2, by (repid year cfips_firms)
save "MC_outputdata_random_PLC_collapse_rep_year_cfipsfirms.dta", replace

*** (2) STEP 2. MERGE DATASET WITH REALIZED RANDOM OUTCOMES AND DATASET WITH ALL POSSIBLE OUTCOMES FOR 1,925 COUNTIES X 36 YEAR X 1,000 REPLICATIONS = 69,300,000 OBSERVATIONS

*** (2.1) CREATE DATASET WITH ALL POSSIBLE OUTCOMES - 1,925 COUNTIES X 36 YEAR X 1,000 REPLICATIONS

use "MC_inputdata_cfips.dta"

cross using "MC_inputdata_year_entry.dta"

gen rep=1000
expand rep

save "MC_all_possible_outcomes_year_cfips.dta", replace

sort cfipsid year

bysort cfipsid year: gen repid=_n

sort repid cfipsid year

order repid year cfipsid cfips

drop entry rep 

save "MC_all_possible_outcomes_year_cfips.dta", replace

use "MC_all_possible_outcomes_year_cfips.dta" 
rename cfips cfips_firms
save "MC_all_possible_outcomes_year_cfipsfirms.dta", replace


*** (2.2.1) MERGE DATASET WITH REALIZED RANDOM OUTCOMES AA & AB AND DATASET WITH ALL POSSIBLE OUTCOMES

clear all

use "MC_all_possible_outcomes_year_cfips.dta" 

merge 1:1 repid year cfips using "MC_outputdata_random_PLC_collapse_rep_year_cfips.dta"

drop _merge

replace survival1=0 if survival1==.
replace survival2=0 if survival2==.

save "MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfips.dta", replace


*** (2.2.2) MERGE DATASET WITH REALIZED RANDOM OUTCOMES BA & BB AND DATASET WITH ALL POSSIBLE OUTCOMES

clear all

use "MC_all_possible_outcomes_year_cfipsfirms.dta" 

merge 1:1 repid year cfips_firms using "MC_outputdata_random_PLC_collapse_rep_year_cfipsfirms.dta"

drop _merge

replace survival1=0 if survival1==.
replace survival2=0 if survival2==.

save "MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfipsfirms.dta", replace


*** (3) STEP 3. USE OBSERVED PLC AND RANDOM PLC TO PRODUCE DATASET INCLUDING NUMBER OF FIRMS ACTIVE COUNTY-YEAR BY PERCENTILE (PERCENTILE 10, P25, P50, P75, P90, MAX ACROSS 1,000 REPLICATIONS FOR RANDOM PLC) 

*** (3.1) RANDOM PLC: CALCULATE REALIZED OUTCOMES AA AND AB PERCENTILE X NUMBER OF FIRMS ALIVE BY YEAR-CFIPS, P10 P25 P50 P75 P90 MAX

*YEAR-CFIPS P10-P90 LOOP

foreach x of numlist 10 25 50 75 90 { 
	clear all
	use "MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfips.dta"
	collapse (p`x') survival*, by (year cfips)
	rename survival1 survivalA1p`x'
	rename survival2 survivalA2p`x'
	save "MC_outputdata_random_PLC_collapse_map_cfips_Ap`x'.dta", replace
}

*YEAR-CFIPS PMAX
clear all
use "MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfips.dta"
collapse (max) survival*, by (year cfips)
rename survival1 survivalA1pmax
rename survival2 survivalA2pmax
save "MC_outputdata_random_PLC_collapse_map_cfips_Apmax.dta", replace


*MERGE P10 P25 P50 P75 P90 & MAX
clear all

use "MC_outputdata_random_PLC_collapse_map_cfips_Ap10.dta"

foreach x of numlist 25 50 75 90 { 
	merge 1:1 year cfips using "MC_outputdata_random_PLC_collapse_map_cfips_Ap`x'.dta"
	drop _merge	
}

merge 1:1 year cfips using "MC_outputdata_random_PLC_collapse_map_cfips_Apmax.dta"
drop _merge

save "MC_outputdata_random_PLC_collapse_map_cfips_Apall.dta", replace


*** (4) STEP 4. USE RANDOM PLC TO PRODUCE DATASET INCLUDING NUMBER OF FIRMS ACTIVE COUNTY-YEAR BY PERCENTILE (PERCENTILE 10, P25, P50, P75, P90, MAX ACROSS 1,000 REPLICATIONS FOR RANDOM PLC) 

*** (4.1) RANDOM PLC: CALCULATE REALIZED OUTCOMES BA AND BB - PERCENTILE X NUMBER OF FIRMS ALIVE BY YEAR-CFIPS, P10 P25 P50 P75 P90 MAX

*YEAR-CFIPS P10-P90 LOOP

foreach x of numlist 10 25 50 75 90 { 
	clear all
	use "MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfipsfirms.dta"
	collapse (p`x') survival*, by (year cfips_firms)
	rename survival1 survivalB1p`x'
	rename survival2 survivalB2p`x'
	save "MC_outputdata_random_PLC_collapse_map_cfips_Bp`x'.dta", replace
}

*YEAR-CFIPS PMAX
clear all
use "MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfipsfirms.dta"
collapse (max) survival*, by (year cfips_firms)
rename survival1 survivalB1pmax
rename survival2 survivalB2pmax
save "MC_outputdata_random_PLC_collapse_map_cfips_Bpmax.dta" , replace

*MERGE P10 P25 P50 P75 P90 & MAX OF BEFORE STEP
clear all

use "MC_outputdata_random_PLC_collapse_map_cfips_Bp10.dta"

foreach x of numlist 25 50 75 90 { 
	merge 1:1 year cfips_firms using "MC_outputdata_random_PLC_collapse_map_cfips_Bp`x'.dta"
	drop _merge	
}

merge 1:1 year cfips_firms using "MC_outputdata_random_PLC_collapse_map_cfips_Bpmax.dta"
drop _merge

rename cfips_firms cfips

save "MC_outputdata_random_PLC_collapse_map_cfips_Bpall.dta", replace


*** (4.2) OBSERVED ALIVE BY YEAR-CFIPS FOR MAPS

clear all

* OBSERVED ALIVE BY YEAR-CFIPS

use "demography_company4_time_series_inc_county_ids_data_long_exc_missing_vpreliminary.dta" 
sort year cfips
collapse (sum) a, by (year cfips)
save "observed_PLC_cfips_maps.dta" , replace

* OBSERVED ALIVE BY YEAR-CFIPS_FIRMS

use "demography_company4_time_series_inc_county_ids_data_long_exc_missing_vpreliminary.dta" 
sort year cfips
collapse (sum) a, by (year cfips)
save "observed_PLC_cfipsfirms_maps.dta" , replace


*** (4.3) MERGE STEPS 3 + 4.1 + 4.2 + LOCATION QUOTIENT WITH DATASET SKELETON FOR MAPS (ALL 3,233 CFIPS X 36 YEARS = 116,388) TO PRODUCE DATASET TO PROJECT THE VARIABLES INNTO MAPS

clear all

use "MC_outputdata_random_PLC_skeleton_cfips_years_3233cfips.dta"

merge 1:1 year cfips using "MC_outputdata_random_PLC_collapse_map_cfips_Apall.dta"
drop _merge

merge 1:1 year cfips using "MC_outputdata_random_PLC_collapse_map_cfips_Bpall.dta"
drop _merge

merge 1:1 year cfips using "observed_PLC_maps.dta"
drop _merge

merge 1:1 cfips year using "lqmap.dta"
drop _merge

gen observed_entry=0
replace observed_entry=1 if a!= . 

sort year a cfips
order year a cfips


foreach i of numlist 10 25 50 75 90 { 
	replace survivalA1p`i'=0 if survivalA1p`i'==.
	replace survivalA2p`i'=0 if survivalA2p`i'==.
	replace survivalB1p`i'=0 if survivalB1p`i'==.
	replace survivalB2p`i'=0 if survivalB2p`i'==.
}

replace survivalA1pmax=0 if survivalA1pmax==.
replace survivalA2pmax=0 if survivalA2pmax==.
replace survivalB1pmax=0 if survivalB1pmax==.
replace survivalB2pmax=0 if survivalB2pmax==.
replace a=0 if a==.
replace lqnestab=0 if lqnestab==.

save "MC_outputdata_random_PLC_skeleton_cfips_years_3233cfips.dta" , replace


*** (5) TRANSFORM VARIABLES INTO VARIABLES WITH RANGES TO PROJECT INTO MAPS, 1900 1910 1920 1930
clear all
use "MC_outputdata_random_PLC_skeleton_cfips_years_3233cfips.dta"

*** (5.1) GENERATE PLQ = LOCATION QUOTIENT IN RANGES SET FOR MAPPING

gen plq=0

*** blanco, azul, verde, amrillo, naranja, rojo

replace plq=0 if lqnestab == 0 
replace plq=1 if lqnestab > 0  & lqnestab <1 
replace plq=2 if lqnestab >= 1  & lqnestab <5 
replace plq=3 if lqnestab >= 5  & lqnestab <10
replace plq=4 if lqnestab >= 10 & lqnestab <20 
replace plq=5 if lqnestab >= 20

*** (5.2) GENERATE P90A = VALUE OF NUMBER OF ASSEMBLERS ALIVE IN P90 IN SCENARIO A1 AND A2 (PURELY RANDOM ENTRY)

gen p90A1=0

replace p90A1=1 if survivalA1p90==0.5
replace p90A1=2 if survivalA1p90==1

gen p90A2=0

replace p90A2=1 if survivalA2p90==0.5
replace p90A2=2 if survivalA2p90==1


*** (5.3) GENERATE P90B = VALUE OF NUMBER OF ASSEMBLERS ALIVE IN P90 IN SCENARIO A1 AND A2 (RANDOM ENTRY WEIGHTED BY SHARE OF MANUFACTURING ESTABLISHMENTS)

gen p90B1=0

replace p90B1=0 if survivalB1p90 >  0  & survivalB1p90 <1
replace p90B1=1 if survivalB1p90 >= 1  & survivalB1p90 <5
replace p90B1=2 if survivalB1p90 >= 5  & survivalB1p90 <10
replace p90B1=3 if survivalB1p90 >= 10 & survivalB1p90 <20
replace p90B1=4 if survivalB1p90 >= 20

gen p90B2=0

replace p90B2=0 if survivalB2p90 >  0  & survivalB2p90 <1
replace p90B2=1 if survivalB2p90 >= 1  & survivalB2p90 <5
replace p90B2=2 if survivalB2p90 >= 5  & survivalB2p90 <10
replace p90B2=3 if survivalB2p90 >= 10 & survivalB2p90 <20
replace p90B2=4 if survivalB2p90 >= 20


*** (5.4) GENERATE OPA = OBSERVED AS PERCENTAGE OF PERCENTILE VALUES IN SCENARIO A1 AND A2 (PURELY RANDOM ENTRY)

gen opA1 = 0 

replace opA1 = 0 if a==0
replace opA1 = 1 if a>=survivalA1p10 & a>0
replace opA1 = 2 if a>=survivalA1p10 & a<survivalA1p25 & a>0
replace opA1 = 2 if a>=survivalA1p25 & a<survivalA1p50 & a>0
replace opA1 = 2 if a>=survivalA1p50 & a<survivalA1p75 & a>0
replace opA1 = 2 if a>=survivalA1p75 & a<survivalA1p90 & a>0
replace opA1 = 3 if a>=survivalA1p90 & a<survivalA1pmax & a>0
replace opA1 = 4 if a>=survivalA1pmax & a<survivalA1pmax*2 & a>0
replace opA1 = 5 if a>=survivalA1pmax*2 & a>0

gen opA2 = 0 

replace opA2 = 0 if a==0
replace opA2 = 1 if a>=survivalA2p10 & a>0 
replace opA2 = 2 if a>=survivalA2p10 & a<survivalA2p25 & a>0
replace opA2 = 2 if a>=survivalA2p25 & a<survivalA2p50 & a>0
replace opA2 = 2 if a>=survivalA2p50 & a<survivalA2p75 & a>0
replace opA2 = 2 if a>=survivalA2p75 & a<survivalA2p90 & a>0
replace opA2 = 3 if a>=survivalA2p90 & a<survivalA2pmax & a>0
replace opA2 = 4 if a>=survivalA2pmax & a<survivalA2pmax*2 & a>0
replace opA2 = 5 if a>=survivalA2pmax*2 & a>0

*** (5.5) GENERATE OPB = OBSERVED AS PERCENTAGE OF PERCENTILE VALUES IN SCENARIO B1 AND B2 (RANDOM ENTRY WEIGHTED BY SHARE OF MANUFACTURING ESTABLISHMENTS)

***5.5.1
gen opB1 = 0 

replace opB1 = 0 if a==0
replace opB1 = 1 if a>=survivalB1p10 & a>0
replace opB1 = 2 if a>=survivalB1p10 & a<survivalB1p25 & a>0
replace opB1 = 2 if a>=survivalB1p25 & a<survivalB1p50 & a>0
replace opB1 = 2 if a>=survivalB1p50 & a<survivalB1p75 & a>0
replace opB1 = 2 if a>=survivalB1p75 & a<survivalB1p90 & a>0
replace opB1 = 3 if a>=survivalB1p90 & a<survivalB1pmax & a>0
replace opB1 = 4 if a>=survivalB1pmax & a<survivalB1pmax*2 & a>0
replace opB1 = 5 if a>=survivalB1pmax*2 & a>0

***5.5.2


gen opB2 = 0 

replace opB2 = 0 if a==0
replace opB2 = 1 if a>=survivalB2p10 & a>0
replace opB2 = 2 if a>=survivalB2p10 & a<survivalB2p25 & a>0
replace opB2 = 2 if a>=survivalB2p25 & a<survivalB2p50 & a>0
replace opB2 = 2 if a>=survivalB2p50 & a<survivalB2p75 & a>0
replace opB2 = 2 if a>=survivalB2p75 & a<survivalB2p90 & a>0
replace opB2 = 3 if a>=survivalB2p90 & a<survivalB2pmax & a>0
replace opB2 = 4 if a>=survivalB2pmax & a<survivalB2pmax*2 & a>0
replace opB2 = 5 if a>=survivalB2pmax*2 & a>0

save "MC_outputdata_random_PLC_skeleton_cfips_years_3233cfips_maps.dta" , replace

////////////////////

*** (6) FIGURES FOR ANALYSIS

clear all
use "MC_outputdata_random_PLC_skeleton_cfips_years_3233cfips_maps.dta"

*** (6.1) HISTOGRAMS FOR OBSERVED VALUES V RANDOM PLC P90 VALUES, 1900, 1910, 1920, 1930

* OBSERVED
forval i = 1900(10)1930 {
 	histogram a if a>0 & year==`i', discrete frequency fcolor(gs10) lcolor(black) addlabel xtitle(Observed) title(Observed `i') graphregion(color(white)) 
	graph export "H_Observed_`i'.png", as(png) name("Graph") replace
}

* p90A1
forval i = 1900(10)1930 {
 	histogram p90A1 if year==`i', discrete frequency fcolor(gs10) lcolor(black) addlabel title(p90A1 `i') graphregion(color(white)) barwidth(0.2)
	graph export "H_p90A1_`i'.png", as(png) name("Graph") replace
}

* p90A2
forval i = 1900(10)1930 {
 	histogram p90A2 if year==`i', discrete frequency fcolor(gs10) lcolor(black) addlabel title(p90A2 `i') graphregion(color(white)) barwidth(0.2)
	graph export "H_p90A2_`i'.png", as(png) name("Graph") replace
}

* p90B1 USE BY CFIPS_FIRMS
forval i = 1900(10)1930 {
 	histogram p90B1 if year==`i', discrete frequency fcolor(gs10) lcolor(black) addlabel title(p90B1 `i') graphregion(color(white)) 
	graph export "H_p90B1_`i'.png", as(png) name("Graph") replace
}

* p90B2 USE BY CFIPS_FIRMS
forval i = 1900(10)1930 {
 	histogram p90B2 if year==`i', discrete frequency fcolor(gs10) lcolor(black) addlabel title(p90B2 `i') graphregion(color(white)) 
	graph export "H_p90B2_`i'.png", as(png) name("Graph") replace
}

*** (6.2) HISTOGRAMS FOR LQ (LOCATION QUOTIENT) V OP (OBSERVED AS PERCENTAGE OF RANDOM PLC PERCENTILE VALUE), 1900, 1910, 1920, 1930

* LQ: SE OMITIERON LOS 0'S: CONSULTAR A XAVIER. LO MISMO CON LOS OPB'S Y OPA'S
forval i = 1900(10)1930 {
 	histogram plq if plq>0 & year==`i', discrete frequency fcolor(gs10) lcolor(black) addlabel title(PLQ `i') graphregion(color(white)) 
	graph export "H_plq_`i'.png", as(png) name("Graph") replace
}

* OP - A1
forval i = 1900(10)1930 {
 	histogram opA1 if opA1>0 & year==`i', discrete frequency fcolor(gs10) lcolor(black) addlabel title(opA1 `i') graphregion(color(white)) 
	graph export "H_opA1_`i'.png", as(png) name("Graph") replace
}

* OP - A2
forval i = 1900(10)1930 {
 	histogram opA2 if opA2>0 & year==`i', discrete frequency fcolor(gs10) lcolor(black) addlabel title(opA2 `i') graphregion(color(white)) 
	graph export "H_opA2_`i'.png", as(png) name("Graph") replace
}

* OP - B1 
forval i = 1900(10)1930 {
 	histogram opB1 if opB1>0 & year==`i', discrete frequency fcolor(gs10) lcolor(black) addlabel title(opB1 `i') graphregion(color(white)) 
	graph export "H_opB1_`i'.png", as(png) name("Graph") replace
}

* OP - B2 
forval i = 1900(10)1930 {
 	histogram opB2 if opB2>0 & year==`i', discrete frequency fcolor(gs10) lcolor(black) addlabel title(opB2 `i') graphregion(color(white)) 
	graph export "H_opB2_`i'.png", as(png) name("Graph") replace
}

*SurvivalB2p90
forval i = 1900(10)1920 {
 	histogram survivalB2p90 if year==`i' & survivalB2p90>=1, discrete frequency fcolor(gs10) lcolor(black) addlabel xtitle(survivalB2p90) title(survivalB2p90 `i') graphregion(color(white))
	graph export "H_survivalB2p90_`i'.png", as(png) name("Graph") replace
}

histogram survivalB2p90 if  year==1930 & survivalB2p90>=1, discrete frequency fcolor(gs10) lcolor(black) barwidth(0.2) addlabel xtitle(survivalB2p90) title(survivalB2p90 1930) graphregion(color(white))
graph export "H_survivalB2p90_1930.png", as(png) name("Graph") replace

*SurvivalB1p90
forval i = 1900(10)1920 {
 	histogram survivalB1p90 if year==`i' & survivalB1p90>=1, discrete frequency fcolor(gs10) lcolor(black) addlabel xtitle(survivalB1p90) title(survivalB1p90 `i') graphregion(color(white))
	graph export "H_survivalB1p90_`i'.png", as(png) name("Graph") replace
}

histogram survivalB1p90 if year==1930 & survivalB1p90>=1 , discrete frequency fcolor(gs10) lcolor(black) barwidth(0.2) addlabel xtitle(survivalB1p90) title(survivalB1p90 1930) graphregion(color(white))
graph export "H_survivalB1p90_1930.png", as(png) name("Graph") replace


*** (7) MAPS FOR ANALYSIS


*** (7.1) LOOP PARA CREAR LAS BASES DE DATOS DE VARIABLES POR AÑO


*EN STATA
forval i= 1900(10)1930 {
	clear all
	use "MC_outputdata_random_PLC_skeleton_cfips_years_3233cfips_maps.dta"
	keep year a cfips p90A1 p90A2 p90B1 p90B2 opA1 opA2 opB1 opB2 plq survivalB2p90 survivalB1p90 
	keep if year == `i'
	rename year year_`i'
	rename a a_`i'
	rename p90A1 p90A1_`i'
	rename p90A2 p90A2_`i'
	rename p90B1 p90B1_`i'
	rename p90B2 p90B2_`i'
	rename opA1 opA1_`i'
	rename opA2 opA2_`i'
	rename opB1 opB1_`i'
	rename opB2 opB2_`i'
	rename plq plq_`i'
	rename survivalB1p90 survivalB1p90_`i'
	rename survivalB2p90 survivalB2p90_`i'
	save "map`i'.dta", replace
}


*** (7.2) LOOP PARA CREAR UNA SOLA BASE DE DATOS Y ELIMINAR LAS ANTERIORES (7.1)
clear all
use "map1900.dta"
	forval i= 1910(10)1930 {
	merge 1:1 cfips using "map`i'.dta"
	drop _merge
	erase "map`i'.dta"
	}
save "maps.dta", replace

forval i= 1900(10)1930 {
	drop p90A1_`i'
	drop p90A2_`i'
	drop p90B1_`i'
	drop p90B2_`i'
	drop opA1_`i'
	drop opA2_`i'
	}
	
export excel using "maps.xls", firstrow(variables) replace

*** (7.3) CREAR BASES DE DATOS GEOREFERENCIADAS A PARTIR DEL SHAPEFILE

* INSTALAR PAQUETES NECESARIOS
ssc install spmap
ssc install shp2dta
cd "D:\MCs\MC"

* CONVERTIR SHAPEFILE DE COUNTYS A DTA (COORDENADAS Y LA BASE DE DATOS)
shp2dta using tl_2017_us_county, database(usdb) coordinates(uscoord) genid(id) replace

//database(usdb) specified that we wanted the database file to be named usdb.dta.
//coordinates(uscoord) specified that we wanted the coordinate file to be named uscoord.dta.
//genid(id) specified that we wanted the ID variable created in usdb.dta to be named id


* HACER MERGE ENTRE LA BASE DE DATOS DE 7.2 Y USDB
clear all
use "maps.dta", replace
merge 1:1 cfips using "usdb.dta"
drop _merge

* USAR BASE DE DATOS AUXILIAR PARA ELIMINAR LOS COUNTYS QUE NO SE QUIEREN GRÁFICAR (alaska, hawai etc)
merge 1:1 cfips using "countys_nomap.dta"
drop if _merge==3
drop _merge

save "maps_vf.dta", replace

*** (7.4) MAPS FOR OBSERVED VALUES V RANDOM PLC P90 VALUES, 1900, 1910, 1920, 1930
clear all
use "maps_vf.dta"

* OBSERVED
forval i= 1900(10)1930 {
	spmap a_`i' using uscoord , id(id) fcolor(Heat) clmethod(custom) clbreaks(0 0.99 1.9 5.9 35) title("Observed `i' ") legend(label(2 "0") label(3 "1") label(4 "2-5") label(5 "6>")) legtitle("Legend")
	graph export "M_Observed_`i'.png", as(png) name("Graph") replace
	}

* p90A1: 1900 y 1930 solo tiene 0's por lo que stata no la gráfica
forval i= 1910(10)1920 {
	spmap p90A1_`i' using uscoord , id(id) fcolor(Topological) clmethod(custom) clbreaks(0 0.99 1.9 2.9) title("p90A1 `i'") legend(label(2 "0") label(3 "1") label(4 "2")) legtitle("Legend")
	graph export "M_p90A1_`i'.png", as(png) name("Graph") replace
	}

* p90A2: 1900, 1920 1930 solo tiene 0's por lo que stata no la gráfica
forval i= 1910(10)1910 {
	spmap p90A2_`i' using uscoord , id(id) fcolor(Topological) clmethod(custom) clbreaks(0 0.99 1.9 2.9) title("p90A2 `i'") legend(label(2 "0") label(3 "1") label(4 "2")) legtitle("Legend")
	graph export "M_p90A2_`i'.png", as(png) name("Graph") replace
}

* p90B1
forval i= 1900(10)1930 {
	spmap p90B1_`i' using uscoord , id(id) fcolor(Heat) clmethod(custom) clbreaks(0 0.99 1.9 2.9 3.9 4.9) title("p90B1 `i'") legend(label(2 "0") label(3 "1") label(4 "2") label(5 "3") label(6 "4")) legtitle("Legend") 
	graph export "M_p90B1_`i'.png", as(png) name("Graph") replace
}

* p90B2
forval i= 1900(10)1930 {
	spmap p90B2_`i' using uscoord , id(id) fcolor(Heat) clmethod(custom) clbreaks(0 0.99 1.9 2.9 3.9 4.9)  title("p90B2 `i'") legend(label(2 "0") label(3 "1") label(4 "2") label(5 "3") label(6 "4")) legtitle("Legend") 
	graph export "M_p90B2_`i'.png", as(png) name("Graph") replace
}


*** (7.5) MAPS FOR LQ (LOCATION QUOTIENT) V OP (OBSERVED AS PERCENTAGE OF RANDOM PLC PERCENTILE VALUE), 1900, 1910, 1920, 1930

* LQ
forval i= 1900(10)1930 {
	spmap plq_`i' using uscoord , id(id) fcolor(Heat) clmethod(custom) clbreaks(0 0.99 1.9 2.9 3.9 4.9 5.9)  title("PLQ `i'") legend(label(2 "0") label(3 "1") label(4 "2") label(5 "3") label(6 "4") label(7 "5")) legtitle("Legend") 
	graph export "M_plq_`i'.png", as(png) name("Graph") replace
}

* OP - A1
forval i= 1900(10)1930 {
	spmap opA1_`i' using uscoord , id(id) fcolor(Heat) clmethod(custom) clbreaks(0 0.99 1.9 2.9 3.9 4.9 5.9)  title("opA1 `i'") legend(label(2 "0") label(3 "1") label(4 "2") label(5 "3") label(6 "4") label(7 "5")) legtitle("Legend") 
	graph export "M_opA1_`i'.png", as(png) name("Graph") replace
}

* OP - A2
forval i= 1900(10)1930 {
	spmap opA2_`i' using uscoord , id(id) fcolor(Heat) clmethod(custom) clbreaks(0 0.99 1.9 2.9 3.9 4.9 5.9)  title("opA2 `i'") legend(label(2 "0") label(3 "1") label(4 "2") label(5 "3") label(6 "4") label(7 "5")) legtitle("Legend") 
	graph export "M_opA2_`i'.png", as(png) name("Graph") replace
	}

* OP - B1
forval i= 1900(10)1930 {
	spmap opB1_`i' using uscoord , id(id) fcolor(Heat) clmethod(custom) clbreaks(0 0.99 1.9 2.9 3.9 4.9 5.9)  title("opB1 `i'") legend(label(2 "0") label(3 "1") label(4 "2") label(5 "3") label(6 "4") label(7 "5")) legtitle("Legend") 
	graph export "M_opB1_`i'.png", as(png) name("Graph") replace
}

* OP - B2
forval i= 1900(10)1930 {
	spmap opB2_`i' using uscoord , id(id) fcolor(Heat) clmethod(custom) clbreaks(0 0.99 1.9 2.9 3.9 4.9 5.9)  title("opB2 `i'") legend(label(2 "0") label(3 "1") label(4 "2") label(5 "3") label(6 "4") label(7 "5")) legtitle("Legend") 
	graph export "M_opB2_`i'.png", as(png) name("Graph") replace
}



*** (8) SCATTERS

*** (8.1) CREATE DATASET FOR MAPS

*** (A)
* GENERATE PERCENTILE AND MAINTAIN ONLY YEARS OF INTEREST FOR GREATER COMPUTER EFFICIENCY
clear all
use "MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfips.dta"
keep if year == 1900 | year == 1910 | year == 1920 | year == 1930
save "A\cfips.dta", replace


forval i = 1(1)99{
	clear all
	use "A\cfips.dta"
	collapse (p`i') survival*, by (year cfips)
	rename survival1 survivalA1p`i'
	rename survival2 survivalA2p`i'
	save "A\p`i'.dta", replace
}

use "A\cfips.dta"
collapse (max) survival*, by (year cfips)
rename survival1 survivalA1p100
rename survival2 survivalA2p100
save "A\p100.dta", replace


* MERGE: PERCENTILS - OBSERVED - LQ
clear all
use "A\p1.dta"
forval i = 2(1)100{
	merge 1:1 year cfips using "A\p`i'.dta"
	drop _merge
}


merge 1:1 year cfips using "observed_PLC_maps.dta"
drop _merge

merge 1:1 year cfips using "lqmap.dta"
drop if _merge!=3
drop gisjoin gisjoin1 year1 ansicode _merge

keep if year == 1900 | year == 1910 | year == 1920 | year == 1930

replace a=0 if a==.

save "A\A_p1-100.dta", replace

* GENERATE OBSERVED AS PERCENTAGE OF RANDOM PLC PERCENTILE VARIABLE
clear all

use "A\A_p1-100.dta"

gen copA1=.
gen copA2=.

forval i= 1(1)100{
	replace copA1=`i' if a>=survivalA1p`i'
	replace copA2=`i' if a>=survivalA2p`i'
}

replace copA1=0 if a<survivalA1p1
replace copA2=0 if a<survivalA2p1

replace copA1=50 if a==survivalA1p1 & a==survivalA1p100
replace copA2=50 if a==survivalA2p1 & a==survivalA2p100

replace copA1 = ((a/survivalA1p100)*100) if a > survivalA1p100
replace copA2 = ((a/survivalA2p100)*100) if a > survivalA2p100

replace copA1 = copA1/100
replace copA2 = copA2/100


save "A\A_scatters.dta", replace


*** (B)

* GENERATE PERCENTILE AND MAINTAIN ONLY YEARS OF INTEREST FOR GREATER COMPUTER EFFICIENCY
clear all
use "MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfipsfirms.dta"
keep if year == 1900 | year == 1910 | year == 1920 | year == 1930
save "B\cfips_firms.dta", replace


forval i = 1(1)99{
	clear all
	use "B\cfips_firms.dta"
	collapse (p`i') survival*, by (year cfips_firms)
	rename survival1 survivalB1p`i'
	rename survival2 survivalB2p`i'
	save "B\p`i'.dta", replace
}

use "B\cfips_firms.dta"
collapse (max) survival*, by (year cfips_firms)
rename survival1 survivalB1p100
rename survival2 survivalB2p100
save "B\p100.dta", replace



* MERGE: PERCENTILS - OBSERVED - LQ
clear all
use "B\p1.dta"
forval i = 2(1)100{
	merge 1:1 year cfips_firms using "B\p`i'.dta"
	drop _merge
}
rename cfips_firms cfips

merge 1:1 year cfips using "observed_PLC_maps.dta"
drop _merge

merge 1:1 year cfips using "lqmap.dta"
drop if _merge!=3
drop gisjoin gisjoin1 year1 ansicode _merge

keep if year == 1900 | year == 1910 | year == 1920 | year == 1930

replace a=0 if a==.

save "B\B_p1-100.dta", replace

* GENERATE OBSERVED AS PERCENTAGE OF RANDOM PLC PERCENTILE VARIABLE

clear all
use "B\B_p1-100.dta"

gen copB1=.
gen copB2=.

// si a=5  y p100=6 y p99=4 entonces copb=99
forval i= 1(1)100{
	replace copB1=`i' if a>=survivalB1p`i' 
	replace copB2=`i' if a>=survivalB1p`i' 
}

replace copB1=0 if a<survivalB1p1
replace copB2=0 if a<survivalB2p1

replace copB1=50 if a==survivalB1p1 & a==survivalB1p100
replace copB2=50 if a==survivalB2p1 & a==survivalB2p100

replace copB1 = ((a/survivalB1p100)*100) if a > survivalB1p100
replace copB2 = ((a/survivalB2p100)*100) if a > survivalB2p100

list copB1 if copB1==.
list copB2 if copB2==.

replace copB1 = copB1/100
replace copB2 = copB2/100

// que hacer en el caso cuando survival==0 y a>0?

save "B\B_scatters.dta", replace


*** (8.2) SCATTER LQ (LOCATION QUOTIENT) V OP (OBSERVED AS PERCENTAGE OF RANDOM PLC PERCENTILE VALUE), 1900, 1910, 1920, 1930

* LQ

* OP - A1

clear all
use "A\A_scatters.dta"

twoway (scatter lqnestab copA1,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1900 , xtitle(copA1 1900) ytitle (LQ) graphregion(color(white))
graph export "S_lqnestab_v_copA1_1900.png", as(png) name("Graph") replace

twoway (scatter lqnestab copA1,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1910 , xtitle(copA1 1910) ytitle (LQ) graphregion(color(white))
graph export "S_lqnestab_v_copA1_1910.png", as(png) name("Graph") replace

twoway (scatter lqnestab copA1,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1920 , xtitle(copA1 1920) ytitle (LQ) graphregion(color(white))
graph export "S_lqnestab_v_copA1_1920.png", as(png) name("Graph") replace

twoway (scatter lqnestab copA1,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1930 , xtitle(copA1 1930) ytitle (LQ) graphregion(color(white))
graph export "S_lqnestab_v_copA1_1930.png", as(png) name("Graph") replace

* OP - A2
twoway (scatter lqnestab copA2,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1900 , xtitle(copA2 1900) ytitle (LQ)  graphregion(color(white))
graph export "S_lqnestab_v_copA2_1900.png", as(png) name("Graph") replace

twoway (scatter lqnestab copA2,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1910 , xtitle(copA2 1910) ytitle (LQ) graphregion(color(white))
graph export "S_lqnestab_v_copA2_1910.png", as(png) name("Graph") replace

twoway (scatter lqnestab copA2,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1920 , xtitle(copA2 1920) ytitle (LQ) graphregion(color(white))
graph export "S_lqnestab_v_copA2_1920.png", as(png) name("Graph") replace

twoway (scatter lqnestab copA2,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1930 , xtitle(copA2 1930) ytitle (LQ)  graphregion(color(white))
graph export "S_lqnestab_v_copA2_1930.png", as(png) name("Graph") replace

* OP - B1

clear all
use "B\B_scatters.dta"

twoway (scatter lqnestab copB1,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1900 , xtitle(copB1 1900) ytitle (LQ) xmtick(0(0.5)1.7) graphregion(color(white))
graph export "S_lqnestab_v_copB1_1900.png", as(png) name("Graph") replace

twoway (scatter lqnestab copB1,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1910 , xtitle(copB1 1910) ytitle (LQ) xmtick(0(1)6.5) graphregion(color(white))
graph export "S_lqnestab_v_copB1_1910.png", as(png) name("Graph") replace

twoway (scatter lqnestab copB1,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1920 , xtitle(copB1 1920) ytitle (LQ) xmtick(0(1)8.5) graphregion(color(white))
graph export "S_lqnestab_v_copB1_1920.png", as(png) name("Graph") replace

twoway (scatter lqnestab copB1,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1930 , xtitle(copB1 1930) ytitle (LQ) graphregion(color(white))
graph export "S_lqnestab_v_copB1_1930.png", as(png) name("Graph") replace

* OP - B2 

clear all
use "B\B_scatters.dta"

twoway (scatter lqnestab copB2,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1900 , xtitle(copB2 1900) ytitle (LQ) xmtick(0(0.5)1.7) graphregion(color(white))
graph export "S_lqnestab_v_copB2_1900.png", as(png) name("Graph") replace

twoway (scatter lqnestab copB2,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1910 , xtitle(copB2 1910) ytitle (LQ) xmtick(0(1)6.5) graphregion(color(white))
graph export "S_lqnestab_v_copB2_1910.png", as(png) name("Graph") replace

twoway (scatter lqnestab copB2,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1920 , xtitle(copB2 1920) ytitle (LQ) graphregion(color(white))
graph export "S_lqnestab_v_copB2_1920.png", as(png) name("Graph") replace

twoway (scatter lqnestab copB2,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1930 , xtitle(copB2 1930) ytitle (LQ) graphregion(color(white))
graph export "S_lqnestab_v_copB2_1930.png", as(png) name("Graph") replace


**** (9) CORRELATIONS

***  PEARSON AND SPEARMAN LQ (LOCATION QUOTIENT) V OP (OBSERVED AS PERCENTAGE OF RANDOM PLC PERCENTILE VALUE), 1900, 1910, 1920, 1930

*** (9.1) SPEARMAN 
erase spcorr.doc

*OPA1 
clear all
use "A\A_scatters.dta"

forval i = 1900(10)1930 {
	display "`i'"
	spearman lqnestab copA1 if year==`i'
	asdoc spearman lqnestab copA1 if year==`i' , title(spearman correlation lqnestab vs copA1 `i') save(spcorr.doc)
}

*OPA2 
forval i = 1900(10)1930 {
	display "`i'"
	spearman lqnestab copA2 if year==`i'
	asdoc spearman lqnestab copA2 if year==`i' , title(spearman correlation lqnestab vs copA2 `i') save(spcorr.doc)
}

*OPB1 
clear all
use "B\B_scatters.dta"

forval i = 1900(10)1930 {
	display "`i'"
	spearman lqnestab copB1 if year==`i'
	asdoc spearman lqnestab copB1 if year==`i' , title(spearman correlation lqnestab vs copB1 `i') save(spcorr.doc)
}

*OPB2
forval i = 1900(10)1930 {
	display "`i'"
	spearman lqnestab copB1 if year==`i'
	asdoc spearman lqnestab copB1 if year==`i' , title(spearman correlation lqnestab vs copB2 `i') save(spcorr.doc)
}


*** (9.2) PEARSON
//erase pwcorr.doc

*OPA1 
clear all
use "A\A_scatters.dta"

forval i = 1900(10)1930 {
	display "`i'"
	asdoc pwcorr lqnestab copA1 if year==`i' , sig star(.05) obs title(pearson correlation lqnestab vs cop1 `i') save(pwcorr.doc)
}

*OP2A 
forval i = 1900(10)1930 {
	display "`i'"
	asdoc pwcorr lqnestab copA1 if year==`i' , sig star(.05) obs title(pearson correlation lqnestab vs cop1 `i') save(pwcorr.doc)
}

*OPB1 
clear all
use "B\B_scatters.dta"

forval i = 1900(10)1930 {
	display "`i'"
	asdoc pwcorr lqnestab copB1 if year==`i' , sig star(.05) obs title(pearson correlation lqnestab vs copB1 `i') save(pwcorr.doc)
}

*OPB2
forval i = 1900(10)1930 {
	display "`i'"
	asdoc pwcorr lqnestab copB2 if year==`i' , sig star(.05) obs title(pearson correlation lqnestab vs copB2 `i') save(pwcorr.doc)
}



**** (10) TIME SERIES
clear all
use "MC_outputdata_random_PLC_skeleton_cfips_years_3233cfips_maps.dta"
tsset cfips year, yearly

/* GUIDE
 cname="New York"      cfips==36061
 cname="Suffolk"       cfips==25025
 cname="Philadelphia"  cfips==42101
 cname="Cook"          cfips==17031
 cname="Hamilton"      cfips==39061
 cname="Cuyahoga"      cfips==39035
 cname="Wayne"         cfips==26163  
 cname="St Joseph"     cfips==18141  */



foreach x of numlist 36061 25025 42101 17031 39061 39035 26163 18141 {
	twoway (tsline a, lcolor(blue)) (tsline survivalB1p10, lcolor(black)) (tsline survivalB1p90, lcolor(black)) (tsline survivalB2p10, lcolor(black) lpattern(vshortdash)) (tsline survivalB2p90, lcolor(black) lpattern(vshortdash)) if cfips==`x', title(Random PLC survivalB1 - survivalB2 & observed `x') graphregion(color(white))
	graph export "TSB1&2_`x'.png", as(png) name("Graph") replace
}

