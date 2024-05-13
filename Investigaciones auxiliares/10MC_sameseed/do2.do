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
*** SCENARIO 1 (A1): RANDOM ENTRY ACROSS LOCATIONS AND SURVIVAL AGE DRAWN FROM OBSERVED DISTRIBUTION AT BIRTH
*** SCENARIO 2 (A2): RANDOM ENTRY ACROSS LOCATIONS AND SURVIVAL AGE DRAWN FROM ESTIMATED PROBABILITY OF SURVIVAL ONE MORE YEAR GIVEN FIRM IS ALIVE AT TIME T
*** SCENARIO 3 (B1): RANDOM ENTRY ACROSS LOCATIONS WEIGHTED BY MANUFACTURING BASE AND SURVIVAL AGE DRAWN FROM OBSERVED DISTRIBUTION AT BIRTH
*** SCENARIO 4 (B2): RANDOM ENTRY ACROSS LOCATIONS WEIGHTED BY MANUFACTURING BASE AND SURVIVAL AGE DRAWN FROM ESTIMATED PROBABILITY OF SURVIVAL ONE MORE YEAR GIVEN FIRM IS ALIVE AT TIME T
***
*** SCENARIOS A1 AND B1 GIVE RANDOM PLC INDUSTRY EVOLUTION IS LOWER BOUND ESTIMATE OF RANDOM LOCATION FOR COUNTIES WITH LARGE MANUFACTURING BASE
*** SCENARIOS A2 AND B2 GIVE RANDOM PLC INDUSTRY EVOLUTION IS UPPER BOUND ESTIMATE OF RANDOM LOCATION FOR COUNTIES WITH LARGE MANUFACTURING BASE, AND IN LINE WITH CONVENTIONAL ASSUMPTION THAT *** WE EXPECT ENTRY TO BE MORE LIKELY WHERE MANUFACTURING IS ALREADY LOCATED
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
clear all

cd "D:\MC\MC2"

*** (1) 36 OBSERVATIONS OF OBSERVED NUMBER OF ENTRANTS PER PLC YEAR EXPANDED INTO 971,000 OBSERVATIONS, EACH OBSERVATION IS FIRM-ENTRY YEAR-REPLICATION

*LLOTERIAS: SINUANO NOCHE DESDE EL 28 PARA ATRÁS

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

*** (3A) ALLOCATING RANDONMLY AN OBSERVED ASSEMBLER LOCATION IDENTITY TO EACH FIRM-ENTRY YEAR-ASSEMBLER ID-REPLICATION OBSERVATION (RANDOM ALLOCATION OF 1 OUT OF 1,925 POSSIBLE LOCATIONS TO EACH 971,000 FIRM OBSERVATION, WITH REPLACEMENT WITHIN A GIVEN REPLICATION SUCH THAT RANDOM AGGLOMERATION MAY BE OBSERVED) - I HAVE CHECKED THIS, CORRECT WITH REPLACEMENT: CFIPS WITH LOW ENTRY HAS FREQUENCY 437 (AUGUSTA, VA) OUT OF 971,000 REPLICATIONS, WHILE CFIPS WITH HIGH ENTRY HAS 577 (ROCKINGHAM, NC) OUT OF 971,000 REPLICATIONS

set obs 971000
set seed 1883
gen cfipsid = floor((1924+1)*runiform() + 1)


*** (3B) ALLOCATING RANDONMLY AN OBSERVED ASSEMBLER LOCATION IDENTITY TO EACH FIRM-ENTRY YEAR-ASSEMBLER ID-REPLICATION OBSERVATION (RANDOM ALLOCATION OF 1 OF 337,902 POSSIBLE FIRM-LOCATION TO EACH 971,000 FIRM OBSERVATIONS, WITH REPLACEMENT WITHIN A GIVEN REPLICATION SUCH THAT AGGLOMERATION MAY BE OBSERVED) (IN 1890 CENSUS INDICATES A TOTAL OF 337,902 MANUFACTURING ESTABLISHMENTS) - I HAVE CHECKED THIS, CORRECT WITH REPLACEMENT: CFIPS WITH LOW ENTRY HAS FREQUENCY 1 (AUGUSTA, FL) OUT OF 971,000 REPLICATIONS, WHILE CFIPS WITH HIGH ENTRY (NEW YORK, NY) HAS 72,849 OUT OF 971,000 REPLICATIONS

***SOURCE SEED: https://www.nacionalloteria.com/colombia/loteria-de-risaralda.php?del-dia=2018-10-19

set obs 971000
set seed 6086
gen cfipsfirmsid = floor((337901+1)*runiform() + 1)


*** (4A) ALLOCATE RANDOMLY AN OBSERVED SURVIVAL AGE TO EACH FIRM-ENTRY YEAR-ASSEMBLER ID-LOCATION-REPLICATION OBSERVATION

*** (4A.1) ALLOCATING RANDONMLY AN OBSERVED ASSEMBLER SURVIVAL AGE TO EACH FIRM-ENTRY YEAR-ASSEMBLER ID-LOCATION-REPLICATION OBSERVATION (RANDOM ALLOCATION OF 1 OF 971 FIRM SURVIVAL AGE TO EACH 971,000 FIRM OBSERVATIONS, WITHOUT REPLACEMENT SUCH THAT A SURVIVAL AGE WITHIN A GIVEN REPLICATION ALLOCATED AT BIRTH CANNOT BE ALLOCATED AGAIN) - I HAVE CHECKED THIS, CORRECT, WITHOUT REPLACEMENT
 
set obs 971000
set seed 6086
gen agerandom = floor((970+1)*runiform() + 1)
bysort repid: egen ageid=rank(agerandom), unique


*** (4A.2) CHECK OBSERVATIONS FOR VARIABLES IS 971,000 AND RANGE FOR SMITHID IS 1,971, FOR CFIPSID IS 1,1925, FOR CFIPSFIRMSID IS 1,337902, FOR AGEID 1,971

summarize smithid cfipsid cfipsfirmsid ageid

*** (4A.3) MERGE DATASET TO SMITHCOMPANYCODE CFIPS CFIPSFIRMS AGE

sort smithid
merge m:m smithid using "MC_inputdata_smith.dta"
drop _merge

sort cfipsid
merge m:m cfipsid using "MC_inputdata_cfips.dta"
drop _merge

sort cfipsfirmsid
merge m:m cfipsfirmsid using "MC_inputdata_cfipsfirms.dta"
drop _merge
drop in 971001/989952

sort ageid
merge m:m ageid using "MC_inputdata_age.dta"
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

//ojo aqui***************
set obs 21205262
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

keep if year ==1910

save "MC_outputdata_random_PLC.dta", replace


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

/* use "MC_inputdata_age.dta" 

tab aa  */

*** (1.2) RANDOM PLC - AGE DISTRIBUTION OF FIRMS ALLOCATED AT BIRTH AND AT ONE MORE YEARS

/* use "MC_outputdata_random_PLC.dta"

tab agedraw1 if year==1930

tab agedraw2 if year==1930 */


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

*** (1.1) RANDOM PLC - NUMBER OF FIRMS ALIVE BY YEAR & CFIPS ACROSS REPLICATIONS - CFIPS: RANDOMLY ALLOCATED CFIPS

clear all
use "MC_outputdata_random_PLC.dta"

sort repid year cfips
collapse (sum) survival1 survival2, by (repid year cfips)
save "MC_outputdata_random_PLC_collapse_rep_year_cfips.dta", replace

*** (1.2) RANDOM PLC - NUMBER OF FIRMS ALIVE BY YEAR & CFIPS ACROSS REPLICATIONS - CFIPS: RANDOMLY ALLOCATED CFIPS WEIGTHED BY NUMBER OF ALL MANUFACTURING FIRMS AT CFIPS

**hasta aquí
clear all
use "MC_outputdata_random_PLC.dta"

sort repid year cfips_firms
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

keep if year==1910

save "MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfips.dta", replace


*** (2.2.2) MERGE DATASET WITH REALIZED RANDOM OUTCOMES BA & BB AND DATASET WITH ALL POSSIBLE OUTCOMES

clear all

use "MC_all_possible_outcomes_year_cfipsfirms.dta" 

merge 1:1 repid year cfips_firms using "MC_outputdata_random_PLC_collapse_rep_year_cfipsfirms.dta"

drop _merge

replace survival1=0 if survival1==.
replace survival2=0 if survival2==.

keep if year==1910

save "MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfipsfirms.dta", replace



*** (4) STEP 4. USE RANDOM PLC TO PRODUCE DATASET INCLUDING NUMBER OF FIRMS ACTIVE COUNTY-YEAR BY PERCENTILE (PERCENTILE 10, P25, P50, P75, P90, MAX ACROSS 1,000 REPLICATIONS FOR RANDOM PLC) 

*** (4.1) RANDOM PLC: CALCULATE REALIZED OUTCOMES BA AND BB - PERCENTILE X NUMBER OF FIRMS ALIVE BY YEAR-CFIPS, P10 P25 P50 P75 P90 MAX

*YEAR-CFIPS P10-P90 LOOP

foreach x of numlist 50 90 { 
	clear all
	use "MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfipsfirms.dta"
	collapse (p`x') survival*, by (year cfips_firms)
	rename survival1 survivalB1p`x'
	drop survival2
	save "MC_outputdata_random_PLC_collapse_map_cfips_Bp`x'.dta", replace
}

*YEAR-CFIPS MEAN
clear all
use "MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfipsfirms.dta"
collapse (mean) survival*, by (year cfips_firms)
rename survival1 survivalB1mean
drop survival2 
save "MC_outputdata_random_PLC_collapse_map_cfips_Bpmean.dta" , replace

*MERGE P50 P90 & MEAN
clear all

use "MC_outputdata_random_PLC_collapse_map_cfips_Bp50.dta"
merge 1:1 year cfips_firms using "MC_outputdata_random_PLC_collapse_map_cfips_Bp90.dta"
drop _merge
merge 1:1 year cfips_firms using "MC_outputdata_random_PLC_collapse_map_cfips_Bpmean.dta"
drop _merge

rename cfips_firms cfips

save "MC_outputdata_random_PLC_collapse_map_cfips_Bpall.dta", replace



*** (4.3) MERGE STEPS 3 + 4.1 + 4.2 + LOCATION QUOTIENT WITH DATASET SKELETON FOR MAPS (ALL 3,233 CFIPS X 36 YEARS = 116,388) TO PRODUCE DATASET TO PROJECT THE VARIABLES INNTO MAPS

clear all

use "MC_outputdata_random_PLC_skeleton_cfips_years_3233cfips.dta"


merge 1:1 year cfips using "MC_outputdata_random_PLC_collapse_map_cfips_Bpall.dta"
drop _merge
 

replace survivalB1mean=0 if survivalB1mean==.
replace survivalB1p50=0 if survivalB1p50==.
replace survivalB1p90=0 if survivalB1p90==.


drop if year==.

save "MC_outputdata_random_PLC_skeleton_cfips_years_3233cfips.dta" , replace


*** (5) TRANSFORM VARIABLES INTO VARIABLES WITH RANGES TO PROJECT INTO MAPS, 1900 1910 1920 1930
clear all
use "MC_outputdata_random_PLC_skeleton_cfips_years_3233cfips.dta"

save "MC_outputdata_random_PLC_skeleton_cfips_years_3233cfips_maps.dta" , replace

*EN STATA
forval i= 1900(10)1930 {
	clear all
	use "MC_outputdata_random_PLC_skeleton_cfips_years_3233cfips_maps.dta"
	keep year cfips survivalB1p90 survivalB1p50 survivalB1mean
	save "map`i'.dta", replace
}

export excel using "maps.xls", firstrow(variables)

*** (7.2) LOOP PARA CREAR UNA SOLA BASE DE DATOS Y ELIMINAR LAS ANTERIORES (7.1)
clear all

	forval i= 1900(10)1930 {
	erase "map`i'.dta"
	
	}

	


//////////////////////////////////////////////////////////////////////////////////////////////////////////////



















/* ////////////////////

*** (6) FIGURES FOR ANALYSIS

clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\MC_outputdata_random_PLC_skeleton_cfips_years_3233cfips_maps.dta"

*** (6.1) HISTOGRAMS FOR OBSERVED VALUES V RANDOM PLC P90 VALUES, 1900, 1910, 1920, 1930

* OBSERVED
forval i = 1900(10)1930 {
 	histogram a if a>0 & year==`i', discrete frequency fcolor(gs10) lcolor(black) addlabel xtitle(Observed) title(Observed `i') graphregion(color(white)) 
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\H_Observed_`i'.png", as(png) name("Graph") replace
}

* p90A1
forval i = 1900(10)1930 {
 	histogram p90A1 if year==`i', discrete frequency fcolor(gs10) lcolor(black) addlabel title(p90A1 `i') graphregion(color(white)) barwidth(0.2)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\H_p90A1_`i'.png", as(png) name("Graph") replace
}

* p90A2
forval i = 1900(10)1930 {
 	histogram p90A2 if year==`i', discrete frequency fcolor(gs10) lcolor(black) addlabel title(p90A2 `i') graphregion(color(white)) barwidth(0.2)
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\H_p90A2_`i'.png", as(png) name("Graph") replace
}

* p90B1 USE BY CFIPS_FIRMS
forval i = 1900(10)1930 {
 	histogram p90B1 if year==`i', discrete frequency fcolor(gs10) lcolor(black) addlabel title(p90B1 `i') graphregion(color(white)) 
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\H_p90B1_`i'.png", as(png) name("Graph") replace
}

* p90B2 USE BY CFIPS_FIRMS
forval i = 1900(10)1930 {
 	histogram p90B2 if year==`i', discrete frequency fcolor(gs10) lcolor(black) addlabel title(p90B2 `i') graphregion(color(white)) 
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\H_p90B2_`i'.png", as(png) name("Graph") replace
}

*** (6.2) HISTOGRAMS FOR LQ (LOCATION QUOTIENT) V OP (OBSERVED AS PERCENTAGE OF RANDOM PLC PERCENTILE VALUE), 1900, 1910, 1920, 1930

* LQ: SE OMITIERON LOS 0'S: CONSULTAR A XAVIER. LO MISMO CON LOS OPB'S Y OPA'S
forval i = 1900(10)1930 {
 	histogram plq if plq>0 & year==`i', discrete frequency fcolor(gs10) lcolor(black) addlabel title(PLQ `i') graphregion(color(white)) 
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\H_plq_`i'.png", as(png) name("Graph") replace
}

* OP - A1
forval i = 1900(10)1930 {
 	histogram opA1 if opA1>0 & year==`i', discrete frequency fcolor(gs10) lcolor(black) addlabel title(opA1 `i') graphregion(color(white)) 
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\H_opA1_`i'.png", as(png) name("Graph") replace
}

* OP - A2
forval i = 1900(10)1930 {
 	histogram opA2 if opA2>0 & year==`i', discrete frequency fcolor(gs10) lcolor(black) addlabel title(opA2 `i') graphregion(color(white)) 
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\H_opA2_`i'.png", as(png) name("Graph") replace
}

* OP - B1 
forval i = 1900(10)1930 {
 	histogram opB1 if opB1>0 & year==`i', discrete frequency fcolor(gs10) lcolor(black) addlabel title(opB1 `i') graphregion(color(white)) 
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\H_opB1_`i'.png", as(png) name("Graph") replace
}

* OP - B2 
forval i = 1900(10)1930 {
 	histogram opB2 if opB2>0 & year==`i', discrete frequency fcolor(gs10) lcolor(black) addlabel title(opB2 `i') graphregion(color(white)) 
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\H_opB2_`i'.png", as(png) name("Graph") replace
}

*SurvivalB2p90
forval i = 1900(10)1920 {
 	histogram survivalB2p90 if year==`i' & survivalB2p90>=1, discrete frequency fcolor(gs10) lcolor(black) addlabel xtitle(survivalB2p90) title(survivalB2p90 `i') graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\H_survivalB2p90_`i'.png", as(png) name("Graph") replace
}

histogram survivalB2p90 if  year==1930 & survivalB2p90>=1, discrete frequency fcolor(gs10) lcolor(black) barwidth(0.2) addlabel xtitle(survivalB2p90) title(survivalB2p90 1930) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\H_survivalB2p90_1930.png", as(png) name("Graph") replace

*SurvivalB1p90
forval i = 1900(10)1920 {
 	histogram survivalB1p90 if year==`i' & survivalB1p90>=1, discrete frequency fcolor(gs10) lcolor(black) addlabel xtitle(survivalB1p90) title(survivalB1p90 `i') graphregion(color(white))
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\H_survivalB1p90_`i'.png", as(png) name("Graph") replace
}

histogram survivalB1p90 if year==1930 & survivalB1p90>=1 , discrete frequency fcolor(gs10) lcolor(black) barwidth(0.2) addlabel xtitle(survivalB1p90) title(survivalB1p90 1930) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\H_survivalB1p90_1930.png", as(png) name("Graph") replace


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
cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment"

* CONVERTIR SHAPEFILE DE COUNTYS A DTA (COORDENADAS Y LA BASE DE DATOS)
shp2dta using tl_2017_us_county, database(usdb) coordinates(uscoord) genid(id) replace

//database(usdb) specified that we wanted the database file to be named usdb.dta.
//coordinates(uscoord) specified that we wanted the coordinate file to be named uscoord.dta.
//genid(id) specified that we wanted the ID variable created in usdb.dta to be named id


* HACER MERGE ENTRE LA BASE DE DATOS DE 7.2 Y USDB
clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\maps.dta", replace
merge 1:1 cfips using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\usdb.dta"
drop _merge

* USAR BASE DE DATOS AUXILIAR PARA ELIMINAR LOS COUNTYS QUE NO SE QUIEREN GRÁFICAR (alaska, hawai etc)
merge 1:1 cfips using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\countys_nomap.dta"
drop if _merge==3
drop _merge

save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\maps_vf.dta", replace

*** (7.4) MAPS FOR OBSERVED VALUES V RANDOM PLC P90 VALUES, 1900, 1910, 1920, 1930
clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\maps_vf.dta"

* OBSERVED
forval i= 1900(10)1930 {
	spmap a_`i' using uscoord , id(id) fcolor(Heat) clmethod(custom) clbreaks(0 0.99 1.9 5.9 35) title("Observed `i' ") legend(label(2 "0") label(3 "1") label(4 "2-5") label(5 "6>")) legtitle("Legend")
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\M_Observed_`i'.png", as(png) name("Graph") replace
	}

* p90A1: 1900 y 1930 solo tiene 0's por lo que stata no la gráfica
forval i= 1910(10)1920 {
	spmap p90A1_`i' using uscoord , id(id) fcolor(Topological) clmethod(custom) clbreaks(0 0.99 1.9 2.9) title("p90A1 `i'") legend(label(2 "0") label(3 "1") label(4 "2")) legtitle("Legend")
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\M_p90A1_`i'.png", as(png) name("Graph") replace
	}

* p90A2: 1900, 1920 1930 solo tiene 0's por lo que stata no la gráfica
forval i= 1910(10)1910 {
	spmap p90A2_`i' using uscoord , id(id) fcolor(Topological) clmethod(custom) clbreaks(0 0.99 1.9 2.9) title("p90A2 `i'") legend(label(2 "0") label(3 "1") label(4 "2")) legtitle("Legend")
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\M_p90A2_`i'.png", as(png) name("Graph") replace
}

* p90B1
forval i= 1900(10)1930 {
	spmap p90B1_`i' using uscoord , id(id) fcolor(Heat) clmethod(custom) clbreaks(0 0.99 1.9 2.9 3.9 4.9) title("p90B1 `i'") legend(label(2 "0") label(3 "1") label(4 "2") label(5 "3") label(6 "4")) legtitle("Legend") 
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\M_p90B1_`i'.png", as(png) name("Graph") replace
}

* p90B2
forval i= 1900(10)1930 {
	spmap p90B2_`i' using uscoord , id(id) fcolor(Heat) clmethod(custom) clbreaks(0 0.99 1.9 2.9 3.9 4.9)  title("p90B2 `i'") legend(label(2 "0") label(3 "1") label(4 "2") label(5 "3") label(6 "4")) legtitle("Legend") 
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\M_p90B2_`i'.png", as(png) name("Graph") replace
}


*** (7.5) MAPS FOR LQ (LOCATION QUOTIENT) V OP (OBSERVED AS PERCENTAGE OF RANDOM PLC PERCENTILE VALUE), 1900, 1910, 1920, 1930

* LQ
forval i= 1900(10)1930 {
	spmap plq_`i' using uscoord , id(id) fcolor(Heat) clmethod(custom) clbreaks(0 0.99 1.9 2.9 3.9 4.9 5.9)  title("PLQ `i'") legend(label(2 "0") label(3 "1") label(4 "2") label(5 "3") label(6 "4") label(7 "5")) legtitle("Legend") 
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\M_plq_`i'.png", as(png) name("Graph") replace
}

* OP - A1
forval i= 1900(10)1930 {
	spmap opA1_`i' using uscoord , id(id) fcolor(Heat) clmethod(custom) clbreaks(0 0.99 1.9 2.9 3.9 4.9 5.9)  title("opA1 `i'") legend(label(2 "0") label(3 "1") label(4 "2") label(5 "3") label(6 "4") label(7 "5")) legtitle("Legend") 
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\M_opA1_`i'.png", as(png) name("Graph") replace
}

* OP - A2
forval i= 1900(10)1930 {
	spmap opA2_`i' using uscoord , id(id) fcolor(Heat) clmethod(custom) clbreaks(0 0.99 1.9 2.9 3.9 4.9 5.9)  title("opA2 `i'") legend(label(2 "0") label(3 "1") label(4 "2") label(5 "3") label(6 "4") label(7 "5")) legtitle("Legend") 
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\M_opA2_`i'.png", as(png) name("Graph") replace
	}

* OP - B1
forval i= 1900(10)1930 {
	spmap opB1_`i' using uscoord , id(id) fcolor(Heat) clmethod(custom) clbreaks(0 0.99 1.9 2.9 3.9 4.9 5.9)  title("opB1 `i'") legend(label(2 "0") label(3 "1") label(4 "2") label(5 "3") label(6 "4") label(7 "5")) legtitle("Legend") 
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\M_opB1_`i'.png", as(png) name("Graph") replace
}

* OP - B2
forval i= 1900(10)1930 {
	spmap opB2_`i' using uscoord , id(id) fcolor(Heat) clmethod(custom) clbreaks(0 0.99 1.9 2.9 3.9 4.9 5.9)  title("opB2 `i'") legend(label(2 "0") label(3 "1") label(4 "2") label(5 "3") label(6 "4") label(7 "5")) legtitle("Legend") 
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\M_opB2_`i'.png", as(png) name("Graph") replace
}



*** (8) SCATTERS

*** (8.1) CREATE DATASET FOR MAPS

*** (A)
* GENERATE PERCENTILE AND MAINTAIN ONLY YEARS OF INTEREST FOR GREATER COMPUTER EFFICIENCY
clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfips.dta"
keep if year == 1900 | year == 1910 | year == 1920 | year == 1930
save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\A\cfips.dta"


forval i = 1(1)99{
	clear all
	use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\A\cfips.dta"
	collapse (p`i') survival*, by (year cfips)
	rename survival1 survivalA2p`i'
	rename survival2 survivalA2p`i'
	save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\A\p`i'.dta", replace
}

use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\A\cfips.dta"
collapse (max) survival*, by (year cfips)
rename survival1 survivalA1p100
rename survival2 survivalA2p100
save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\A\p100.dta", replace


* MERGE: PERCENTILS - OBSERVED - LQ
clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\A\p1.dta"
forval i = 2(1)100{
	merge 1:1 year cfips using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\A\p`i'.dta"
	drop _merge
}


merge 1:1 year cfips using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\observed_PLC_maps.dta"
drop _merge

merge 1:1 year cfips using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\lqmap.dta"
drop if _merge!=3
drop gisjoin gisjoin1 year1 ansicode _merge

keep if year == 1900 | year == 1910 | year == 1920 | year == 1930

replace a=0 if a==.

save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\A\A_p1-100.dta", replace

* GENERATE OBSERVED AS PERCENTAGE OF RANDOM PLC PERCENTILE VARIABLE
clear all

use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\A\A_p1-100.dta"

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


save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\A\A_scatters.dta", replace


*** (B)

* GENERATE PERCENTILE AND MAINTAIN ONLY YEARS OF INTEREST FOR GREATER COMPUTER EFFICIENCY
clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfipsfirms.dta"
keep if year == 1900 | year == 1910 | year == 1920 | year == 1930
save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\B\cfips_firms.dta"


forval i = 1(1)99{
	clear all
	use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\B\cfips_firms.dta"
	collapse (p`i') survival*, by (year cfips_firms)
	rename survival1 survivalB1p`i'
	rename survival2 survivalB2p`i'
	save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\B\p`i'.dta", replace
}

use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\B\cfips_firms.dta"
collapse (max) survival*, by (year cfips_firms)
rename survival1 survivalB1p100
rename survival2 survivalB2p100
save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\B\p100.dta", replace



* MERGE: PERCENTILS - OBSERVED - LQ
clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\B\p1.dta"
forval i = 2(1)100{
	merge 1:1 year cfips_firms using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\B\p`i'.dta"
	drop _merge
}
rename cfips_firms cfips

merge 1:1 year cfips using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\observed_PLC_maps.dta"
drop _merge

merge 1:1 year cfips using "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\lqmap.dta"
drop if _merge!=3
drop gisjoin gisjoin1 year1 ansicode _merge

keep if year == 1900 | year == 1910 | year == 1920 | year == 1930

replace a=0 if a==.

save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\B\B_p1-100.dta", replace

* GENERATE OBSERVED AS PERCENTAGE OF RANDOM PLC PERCENTILE VARIABLE

clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\B\B_p1-100.dta"

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
replace copB2 = cop2/100

// que hacer en el caso cuando survival==0 y a>0?

save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\B\B_scatters.dta", replace


*** (8.2) SCATTER LQ (LOCATION QUOTIENT) V OP (OBSERVED AS PERCENTAGE OF RANDOM PLC PERCENTILE VALUE), 1900, 1910, 1920, 1930

* LQ

* OP - A1

clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\A\A_scatters.dta"

twoway (scatter lqnestab copA1,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1900 , xtitle(copA1 1900) ytitle (LQ) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\S_lqnestab_v_copA1_1900.png", as(png) name("Graph") replace

twoway (scatter lqnestab copA1,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1910 , xtitle(copA1 1910) ytitle (LQ) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\S_lqnestab_v_copA1_1910.png", as(png) name("Graph") replace

twoway (scatter lqnestab copA1,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1920 , xtitle(copA1 1920) ytitle (LQ) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\S_lqnestab_v_copA1_1920.png", as(png) name("Graph") replace

twoway (scatter lqnestab copA1,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1930 , xtitle(copA1 1930) ytitle (LQ) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\S_lqnestab_v_copA1_1930.png", as(png) name("Graph") replace

* OP - A2
twoway (scatter lqnestab copA2,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1900 , xtitle(copA2 1900) ytitle (LQ)  graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\S_lqnestab_v_copA2_1900.png", as(png) name("Graph") replace

twoway (scatter lqnestab copA2,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1910 , xtitle(copA2 1910) ytitle (LQ) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\S_lqnestab_v_copA2_1910.png", as(png) name("Graph") replace

twoway (scatter lqnestab copA2,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1920 , xtitle(copA2 1920) ytitle (LQ) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\S_lqnestab_v_copA2_1920.png", as(png) name("Graph") replace

twoway (scatter lqnestab copA2,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1930 , xtitle(copA2 1930) ytitle (LQ)  graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\S_lqnestab_v_copA2_1930.png", as(png) name("Graph") replace

* OP - B1

clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\B\B_scatters.dta"

twoway (scatter lqnestab copB1,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1900 , xtitle(copB1 1900) ytitle (LQ) xmtick(0(0.5)1.7) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\S_lqnestab_v_copB1_1900.png", as(png) name("Graph") replace

twoway (scatter lqnestab copB1,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1910 , xtitle(copB1 1910) ytitle (LQ) xmtick(0(1)6.5) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\S_lqnestab_v_copB1_1910.png", as(png) name("Graph") replace

twoway (scatter lqnestab copB1,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1920 , xtitle(copB1 1920) ytitle (LQ) xmtick(0(1)8.5) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\S_lqnestab_v_copB1_1920.png", as(png) name("Graph") replace

twoway (scatter lqnestab copB1,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1930 , xtitle(copB1 1930) ytitle (LQ) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\S_lqnestab_v_copB1_1930.png", as(png) name("Graph") replace

* OP - B2 

clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\B\B_scatters.dta"

twoway (scatter lqnestab copB2,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1900 , xtitle(copB2 1900) ytitle (LQ) xmtick(0(0.5)1.7) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\S_lqnestab_v_copB2_1900.png", as(png) name("Graph") replace

twoway (scatter lqnestab copB2,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1910 , xtitle(copB2 1910) ytitle (LQ) xmtick(0(1)6.5) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\S_lqnestab_v_copB2_1910.png", as(png) name("Graph") replace

twoway (scatter lqnestab copB2,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1920 , xtitle(copB2 1920) ytitle (LQ) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\S_lqnestab_v_copB2_1920.png", as(png) name("Graph") replace

twoway (scatter lqnestab copB2,  mlabel(cname) mlabsize(vsmall) mlabcolor(black) mlabposition(2) mlabangle(10)) if year==1930 , xtitle(copB2 1930) ytitle (LQ) graphregion(color(white))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\S_lqnestab_v_copB2_1930.png", as(png) name("Graph") replace


**** (9) CORRELATIONS

***  PEARSON AND SPEARMAN LQ (LOCATION QUOTIENT) V OP (OBSERVED AS PERCENTAGE OF RANDOM PLC PERCENTILE VALUE), 1900, 1910, 1920, 1930

*** (9.1) SPEARMAN 
erase spcorr.doc

*OPA1 
clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\A\A_scatters.dta"

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
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\B\B_scatters.dta"

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
erase pwcorr.doc

*OPA1 
clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\A\A_scatters.dta"

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
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\B\B_scatters.dta"

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
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\MC_outputdata_random_PLC_skeleton_cfips_years_3233cfips_maps.dta"
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
	graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\TSB1&2_`x'.png", as(png) name("Graph") replace */
}

