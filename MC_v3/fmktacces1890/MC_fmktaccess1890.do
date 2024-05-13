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
*** STEP II. COLLAPSE RANDOM REALIZED FIRM-COUNTY-YEAR OUTCOMES TO REALIZED COUNTY-YEAR OUTCOMES -> MERGE RANDOM REALIZED COUNTY-YEAR OUTCOMES DATASET TO DATASET OF SKELETON OF ALL POSSIBLE COUNTY-YEAR OUTCOMES AND THEN FILL REST WITH 0s (1,925 COUNTIES X 36 YEARS X 1,000 REPLICATIONS = 69.3 MILLION OBSERVATIONS)
***
*** STEP I. CREATE FIRM-COUNTY-YEAR RANDOM REALIZED OUTCOMES DATASET
***
*** 1. CREATE DATASET SKELETON = 971 FIRMS (ASSEMBLERS THAT ENTERED DURING PLC 1895-1930) X 1,000 REPLICATIONS = 971,000 OBSERVATIONS
*** 2. ALLOCATE TO EACH OF THE 971,000 FIRMS PSEUDO-RANDOMLY A PAIR OF MATCHED ENTRY YEAR AND SMITHCOMAPANYCODE ASSEMBLER ID
*** 3. ALLOCATE TO EACH OF THE 971,000 FIRMS PSEUDO-RANDONLY A LOCATION WITHIN THE SET OF 1,925 POSSIBLE COUNTIES, FOLLOWING THE 1890 CROSS COUNTY SHARE OF MANUFACTURING VARIABLES (ESTABLISHMENTS, INCOME MARKETS ACCESS, INCOME FOREIGN MARKET ACCESS, OR KNOWLEDGE STOCK)  
*** 4. ALLOCATE TO EACH OF THE 971,000 FIRMS PSEUDO-RANDOMLY A SURVIVAL AGE, WITH SURVIVAL ONE MORE YEAR=1 IF RANDOM SHOCK IS LOWER THAN ESTIMATED PROBABILITY OF SURVIVAL ONE MORE YEAR, GIVEN ASSEMBLER AGE
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

cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\fmktacces1890\"

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
gen cfipsfirmsid = floor(( 100016 +1)*runiform() + 1)



*** (3.1) MERGE DATASET TO SMITHCOMPANYCODE CFIPS CFIPSFIRMS

sort smithid
merge m:m smithid using "MC_inputdata_smith.dta"
drop _merge

sort cfipsfirmsid
merge m:m cfipsfirmsid using "MC_inputdata_cfips_bi_fmktaccess1890.dta"
drop _merge
drop in 971001/971004


order smithcompanycode, after (smithid)
order cfips_firms, after (cfipsfirmsid)

*** (3.2) EXPAND DATASET
gen maxage=1930-year+1
expand maxage

***
bysort repid firmid: gen yearid= _n
rename year entryyear
gen year=entryyear+yearid-1
order year, before (entryyear)

*** (4) ALLOCATE RANDOMLY A SURVIVAL AGE (RESULTING FROM THE PROBABILITY TO SURVIVE ONE MORE YEAR AT EACH AGE ESTIMATED FROM OBSERVED PLC DATA) TO EACH FIRM-ENTRY YEAR-ASSEMBLER ID-LOCATION-REPLICATION OBSERVATION - SURVIVAL GIVEN BY PROBABILITY OF SURVIVAL ONE MORE YEAR FROM LOGIT ESTIMATE OF OBSERVED SURVIVAL ON OBSERVED AGE IN T-1 WITHOUT FIXED COUNTY AND YEAR EFFECTS + INTERPOLATING MISSING ESTIMATED VALUES (SEE FILE ONE MORE YEAR SURVIVAL)

set obs 21205000
set seed 8631
gen psurvival2 = runiform()
gen s=0

replace s=1 if yearid==1
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

bysort repid firmid: gen agecountsurvival2=_n if survival2==1

replace agecountsurvival2=0 if survival2==0

*** SELECT YEARS OF INTEREST


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

collapse (sum) survival2, by (repid year cfips_firms)
save "MC_outputdata_random_PLC_collapse_rep_year_cfipsfirms.dta", replace

*** (2) STEP 2. MERGE DATASET WITH REALIZED RANDOM OUTCOMES AND DATASET WITH ALL POSSIBLE OUTCOMES FOR 1,925 COUNTIES X 36 YEAR X 1,000 REPLICATIONS = 69,300,000 OBSERVATIONS

*** (2.1) MERGE DATASET WITH REALIZED RANDOM OUTCOMES BA & BB AND DATASET WITH ALL POSSIBLE OUTCOMES

clear all

use "MC_all_possible_outcomes_year_cfipsfirms.dta" 
merge 1:1 repid year cfips_firms using "MC_outputdata_random_PLC_collapse_rep_year_cfipsfirms.dta"
drop _merge
replace survival2=0 if survival2==.

save "MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfipsfirms.dta", replace


*** (3) STEP 3. USE RANDOM PLC TO PRODUCE DATASET INCLUDING NUMBER OF FIRMS ACTIVE COUNTY-YEAR BY PERCENTILE (PERCENTILE 10, P25, P50, P75, P90, MAX ACROSS 1,000 REPLICATIONS FOR RANDOM PLC) 

*** (3.1) RANDOM PLC: CALCULATE REALIZED OUTCOMES BA AND BB - PERCENTILE X NUMBER OF FIRMS ALIVE BY YEAR-CFIPS, P10 P25 P50 P75 P90 MAX

*YEAR-CFIPS P10-P90 LOOP

foreach x of numlist 10 25 50 75 90 { 
	clear all
	use "MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfipsfirms.dta"
	collapse (p`x') survival*, by (year cfips_firms)
	rename survival2 survivalB2p`x'
	save "MC_outputdata_random_PLC_collapse_map_cfips_Bp`x'.dta", replace
}

*YEAR-CFIPS PMAX
clear all
use "MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfipsfirms.dta"
collapse (max) survival*, by (year cfips_firms)
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


*** (3.2) MERGE LOCATION QUOTIENT WITH DATASET SKELETON FOR MAPS (ALL 3,233 CFIPS X 36 YEARS = 116,388) TO PRODUCE DATASET TO PROJECT THE VARIABLES INNTO MAPS

clear all
use "MC_inputdata_random_PLC_skeleton_3233cfips.dta"

merge 1:1 year cfips using "MC_outputdata_random_PLC_collapse_map_cfips_Bpall.dta"
drop _merge

merge 1:1 year cfips using "MC_inputdata_observed_PLC_maps.dta"
drop _merge

merge 1:1 cfips year using "MC_inputdata_lqmap.dta"
drop _merge

foreach i of numlist 10 25 50 75 90 { 
	replace survivalB2p`i'=0 if survivalB2p`i'==.
}

replace survivalB2pmax=0 if survivalB2pmax==.
replace a=0 if a==.
replace lqnestab=0 if lqnestab==.

drop gisjoin gisjoin1 year1 ansicode 

save "MC_outputdata_random_PLC_3233cfips.dta" , replace




*** (3.3) TRANSFORM VARIABLES INTO VARIABLES WITH RANGES TO PROJECT INTO MAPS 1910  1930
clear all
use "MC_outputdata_random_PLC_3233cfips.dta"

*** (3.3.1) GENERATE PLQ = LOCATION QUOTIENT IN RANGES SET FOR MAPPING

gen plq=0

*** COLOR CODE: WHITE, BLUE, GREEN, YELLOW, ORANGE, RED

replace plq=0 if lqnestab == 0 
replace plq=1 if lqnestab >  0  & lqnestab <1 
replace plq=2 if lqnestab >= 1  & lqnestab <5 
replace plq=3 if lqnestab >= 5  & lqnestab <10
replace plq=4 if lqnestab >= 10 & lqnestab <20 
replace plq=5 if lqnestab >= 20


*** (3.3.2) GENERATE OPB2 = OBSERVED AS RANGE OF RANDOM PLC

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




********************************************************************************
********************************************************************************
********************************************************************************

*** (4) STEP 4 GENERATE DATABASE TO MAP P90 PLQ OPB2 IN 1910 & 1930 

clear all
forval i= 1910(20)1930 {
	clear all
	use "MC_outputdata_random_PLC_skeleton_cfips_years_3233cfips_maps.dta"
	keep year a cfips survivalB2p90 plq opB2
	keep if year == `i'
	rename year year_`i'
	rename a a_`i'
	rename opB2 opB2_`i'
	rename plq plq_`i'
	rename survivalB2p90 survivalB2p90_`i'
	save "map`i'.dta", replace
}


*** LOPP TO CREATE ONLY DATABASE AND DROP BEFORE DATABASES
clear all
use "map1910.dta"

	forval i= 1930(1)1930 {
	merge 1:1 cfips using "map`i'.dta"
	drop _merge
	}

erase "map1910.dta"
erase "map1930.dta"
	
export excel using "maps.xls", firstrow(variables) replace


********************************************************************************
********************************************************************************
********************************************************************************

*** (5) STEP 5 TIME SERIES


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
	twoway (tsline a, lcolor(blue)) (tsline survivalB2p10, lcolor(black) lpattern(vshortdash)) (tsline survivalB2p90, lcolor(black) lpattern(vshortdash)) if cfips==`x', title(fkmtaccess_survivalB2 & observed: `x') graphregion(color(white))
	graph export "TSB1&2_`x'.png", as(png) name("Graph") replace
}

********************************************************************************
********************************************************************************
********************************************************************************



*** (6) STEP 4 GENERATE COPB2: OBSERVED AS PERCENTAGE OF RANDOM PLC

* GENERATE PERCENTILE AND MAINTAIN ONLY YEARS OF INTEREST FOR GREATER COMPUTER EFFICIENCY
clear all
use "MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfipsfirms.dta"
keep if year == 1895 | year == 1900 | year == 1905 | year == 1910 | year == 1915 | year == 1920 | year == 1925 | year == 1930
save "B\cfips_firms.dta", replace


forval i = 1(1)99{
	clear all
	use "B\cfips_firms.dta"
	collapse (p`i') survival*, by (year cfips_firms)
	rename survival2 survivalB2p`i'
	save "B\p`i'.dta", replace
}

use "B\cfips_firms.dta"
collapse (max) survival*, by (year cfips_firms)
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

merge 1:1 year cfips using "MC_inputdata_observed_PLC_maps.dta"
drop _merge

merge 1:1 year cfips using "lqmap.dta"
drop if _merge!=3
drop gisjoin gisjoin1 year1 ansicode _merge

keep if year == 1895 | year == 1900 | year == 1905 | year == 1910 | year == 1915 | year == 1920 | year == 1925 | year == 1930

replace a=0 if a==.

save "B\B_p1-100.dta", replace

* GENERATE OBSERVED AS PERCENTAGE OF RANDOM PLC PERCENTILE VARIABLE

clear all
use "B\B_p1-100.dta"
gen copB2=.

// IF a=5  & p100=6 & p99=4 THEN COPB2=99

forval i= 1(1)100{
	replace copB2=`i' if a>=survivalB2p`i' 
}

replace copB2=0 if a<survivalB2p1
replace copB2=50 if a==survivalB2p1 & a==survivalB2p100
replace copB2 = ((a/survivalB2p100)*100) if a > survivalB2p100
list copB2 if copB2==.


save "B\B_copB2.dta", replace


********************************************************************************
********************************************************************************
********************************************************************************

//(7) STEP X GENERATE DESCRIPTIVE STATISTICS
clear all

// ssc install estout

use "B\B_copB2.dta"

estpost tabstat copB2 if year == 1910 , statistics(min p10 p50 mean p90 max iqr sd)
esttab using dc.csv, cells("min p10 p50 mean p90 max iqr sd") replace

estpost tabstat copB2 if year == 1930 , statistics(min p10 p50 mean p90 max iqr sd)
esttab using dc.csv, append cells("min p10 p50 mean p90 max iqr sd") 



********************************************************************************
********************************************************************************
********************************************************************************

//(8) KERNEL DISTRIBUTION
clear all

use "B\B_copB2.dta"

foreach x of numlist 1900 1910 1920 1930{
	twoway (histogram copB2, fcolor(black) lcolor(black)) (kdensity copB2) if year==`x', title(Kernel fkmtaccess1890 `x' ) graphregion(color(white)) xscale(range(0 5))
	graph export "KD_`x'.png", as(png) name("Graph") replace
}

**CHANGE NAME