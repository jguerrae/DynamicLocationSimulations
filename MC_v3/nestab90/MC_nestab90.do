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

cd "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v3\nestab90\"

use "MC_inputdata_year_entry.dta" // en CADA AÑO CUANTOS ENSA,BLADORES ENTRATRON

expand entry //EXPANDO NUMERO DE ENSAMBLADORES QUE ENTRARON CADA AÑO, ESTO ME DEJA CON 971 OBSERVCIONES Una fila repetida por cada firma
gen firmid= _n //LE ASIGNO UN ID A CADA FIRMAa cada una de las firmas que entro cada año
order firmid //ordeno la firma, el año en el que entro
gen rep=1000 
expand rep //Genero mil escenarios, ie, la firma 1 de las 4 que entro en 1895, puedo haber entrado en 1000 lugares distintos. Hasta ahora voy 971mil OBS
bysort firmid: gen repid= _n //para cada firma, le asigno la replicación
order repid //OK

*** (2) ALLOCATING RANDOMLY AN OBSERVED ASSEMBLER IDENTITY TO EACH FIRM-ENTRY YEAR-REPLICATION OBSERVATION (RANDOM ALLOCATION OF 1 OUT OF 971 SMITHCOMPANY IDs TO EACH 971,000 FIRM OBSERVATION WITHOUT REPLACEMENT SUCH THAT A FIRM THAT ENTERS WITHIN A GIVEN REPLICATION CANNOT ENTER AGAIN) - I HAVE CHECKED THIS, CORRECT, WITHOUT REPLACEMENT
 
set obs 971000
set seed 4540
gen smithrandom = floor((970+1)*runiform() + 1) //codido unico entre 1 y 971
bysort repid: egen smithid=rank(smithrandom), unique //por replicación, dale un numero del 1 al 971 a cada firma-->OK

//IMPORTA EL SMITHID

*** (3) ALLOCATE RANDONMLY AN OBSERVED ASSEMBLER LOCATION IDENTITY TO EACH FIRM-ENTRY YEAR-ASSEMBLER ID-REPLICATION OBSERVATION (RANDOM ALLOCATION OF 1 OF 10,000 POSSIBLE FIRM-LOCATIONS FOR ESTABLISHMENTS, INCOME MARKET ACCESS, INCOME FOREIGN MARKET ACCESS AND KNOWLEDGE STOCK IN 1890 (CROSS-COUNTY SHARE OF APROX 10,000 OBSERVATIONS FOR EACH VARIABLE) TO EACH 971,000 FIRM OBSERVATIONS, WITH REPLACEMENT WITHIN A GIVEN REPLICATION SUCH THAT AGGLOMERATION MAY BE OBSERVED)

*** I CHECKED RESULTS OF CODE FOR ESTABLISMENTS (RANDOM ALLOCATION OF 1 OF 337,902 POSSIBLE FIRM-LOCATION TO EACH 971,000 FIRM OBSERVATIONS, WITH REPLACEMENT WITHIN A GIVEN REPLICATION SUCH THAT AGGLOMERATION MAY BE OBSERVED) - I HAVE CHECKED THIS, CORRECT WITH REPLACEMENT: CFIPS WITH LOW ENTRY HAS FREQUENCY 1 (AUGUSTA, FL) OUT OF 971,000 REPLICATIONS, WHILE CFIPS WITH HIGH ENTRY (NEW YORK, NY) HAS 72,849 OUT OF 971,000 REPLICATIONS

set obs 971000
set seed 3219
gen cfipsfirmsid = floor(( 100012 +1)*runiform() + 1) //le asigno a cada firma en cada firma un posible ID, hasta ahora no hay manera de decir que NY tiene que tener más ensambladores que Cuyahoga, solo voy con las firmas (KKK), COMO ES UNIFORME ESPERO QUE LA FRECUENCIA DE CADA CFIPSfirmsid SEA PARECIDA

//EFECTIVAMENTE -->ok histogram cfipsfirmsid

//por cada replicación se tienen varios numeros entre 1 y 1000012 aprox normal


*** (3.1) MERGE DATASET TO SMITHCOMPANYCODE CFIPS CFIPSFIRMS

sort smithid
merge m:m smithid using "MC_inputdata_smith.dta"
drop _merge //hago el merge de el smithcompanycode qye realmente tenia, ya que en este hay archivo hay una correspondencia entre 

sort cfipsfirmsid
merge m:m cfipsfirmsid using "MC_inputdata_cfips_nestab90.dta" //este archivo tiene una correspondencia entre la proporción del county (numero de filas) el cfipsid: un id unico de filas y un cfipsfirmsid: que uno para cada una de las 100mil obs

//el cfipsfirmsid tiene una uniforme del actual, el que estoy anexando también pero viene amarrado con un cfips_firms (county) que conserva la proporción de firmas por county. Entonces para la replicación 1 hay 84 firmas en nuevayork.

//así como el cfipsfirmsid: que es un id para cada firma distinta según el share, se hace el merge. Este numero lo había creado previamente en el paso (KKK) uniformemente entre 1 y 10000, como esta uniformemente y el archivo nestab90 está repartido con las proporciones de los estados entonces la proporción de participación de cada estado se mantendrá. NY aparecerá más veces que Cuyahoga


drop _merge
drop in 971001/971006

order smithcompanycode, after (smithid)
order cfips_firms, after (cfipsfirmsid)

//sigo teniendo una firma X de las 4 de 1895, en un proceso que se simuló mil veces, es decir pudo haber entrado en ese año mil veces a varios countys distintos.

//ej: la firma 156 (971) que corresponde a 442 (siguiendo el smith company code), entro en el 1902 (36)  en la replicación 685 (1000) al estado 1001.

//Así para cada año tendré 1000 * # firmas que entraron. Ej: 4000 en 1985 --> tab year, 

//SI HAY UN POTENCIAL CAMBIO DEBERÍA ESTAR AQUÍ. AQUÍ EN 85 DEBERÍA CAMBIAR LA PROPORCIÓN DE CFIPS_FIRMS, LUEGO PARA EL SIGUIEN AÑO DEBERÍA CAMBIAR, Y ASÍ SUCESIVAMENTE.
//LO IDEAL SERÍA HACER UN MERGE CON LAS NUEVAS PROPORCIONES.


//MIRAR EL TAB POR AÑO// ny tiene el 7.5 en 1890, eso se debería consevar para todos los año, incluso si hay 4000 o más en cada año.

tab year 
tab year if cfips_firms == 36061

//en general NUEVA YORK PARA TODOS ESOS AÑOS ESTÁ TENIENDO UNA PROPORCIÓN de 7% más un error.


//pasos a seguir, colocar la proporción año a año, mutplicarla por el número de firmas de ese año 4000 etc etc y luego hacer un merge.//en este punto hago el merge!


//(971*1000 hasta ahora)

*** (3.2) EXPAND DATASET


//para poder incorporar los años en los que pudo estar viva expando el dataset 
gen maxage=1930-year+1 //la edad máxima que puede vivir cada firma
expand maxage //aquí es donde el dataser queda de 21 millones

/////
//toca explcuir los de antes y los de después. Solo coger los de ese año. 
//toca ver en que año mueren.
//puede vivir hasta 20 años.


//36 años obs en 0 y la vamos llenando de 1 si están vivos. Esos 4 que entraron en el 95 pueden vivir hasta 36 años y eso quiere decir que creamos con el expand creamos, euqivale a un append (si estamos 895) de 36 años donde hay 36 obs y luego se llena de 1 siguiendo a cada ensamblador hasta que se muera.

//aleatoria con y sin reemplazo, lo que no podemos cambiar es la secuencia de entrada. Eso es es lo que da la dinamica del PLC observado. 
//No existe ningún modelo teórico que diga la forma de la distribución tiempo entrada. 4,3,3,6.
//CON REEMPLAZO CON AGLOMERACIÓN MÁS QUE PROPORCIONAL A LOS CROSS-COUNTRY SHARES. "En qué condiciones una industria"

/////
***

bysort repid firmid: gen yearid= _n //para cada pareja replicación-firma le asigno una edad entre 1 y el número de año que sobrevivió
//ej: la firma 1 (que entró en 1895) tiene 36 años para sobrevivir en cada replicación, entonces se le asignara un numero del 1 al 36 en cada final (que son 36) en cada replicación.
// es decir, cada x firma, que tiene y filas (según los años que puede sobrevivur) se le asigna un numero del 1 al numero de año que puede sobrevivir)


//HASTA ESTE PUNTO LA CLAVE ESTÁ EN CONSERVAR EL AÑO (EJ: 1 Y CAMBIAR LA PROPORCIÓN DE COUNTYS QUE APRECEN, SEGÚN EL SHARE PARA CADA AÑO)


rename year entryyear //cambio al año a año de entrada
gen year=entryyear+yearid-1 // el nuevo "año" es: el año en el que entro menos los años que sobrevivió - 1. Este sería el año en el que muere:
//ej: la firma 1 en la ()rep que sea)entro en 1895 + 36 = 1931 -1 = 1930
order year, before (entryyear) 

///hasta aquí entiendo bien el código


*** (4) ALLOCATE RANDOMLY A SURVIVAL AGE (RESULTING FROM THE PROBABILITY TO SURVIVE ONE MORE YEAR AT EACH AGE ESTIMATED FROM OBSERVED PLC DATA) TO EACH FIRM-ENTRY YEAR-ASSEMBLER ID-LOCATION-REPLICATION OBSERVATION - SURVIVAL GIVEN BY PROBABILITY OF SURVIVAL ONE MORE YEAR FROM LOGIT ESTIMATE OF OBSERVED SURVIVAL ON OBSERVED AGE IN T-1 WITHOUT FIXED COUNTY AND YEAR EFFECTS + INTERPOLATING MISSING ESTIMATED VALUES (SEE FILE ONE MORE YEAR SURVIVAL)

set obs 21205001
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



*** (6) STEP 4 GENERATE copB2_1: OBSERVED AS PERCENTAGE OF RANDOM PLC

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

*MAX

gen copB2_1=.


//LOOP MAX
forval i= 1(1)100{
	replace copB2_1=`i' if a==survivalB2p`i' & a>0
}

//NO TIENEN HISTORIA
replace copB2_1=0 if a<=0 

//OBERVADO < P1
replace copB2_1=0 if a<survivalB2p1

//OBSERVED > P100
replace copB2_1 = ((a/survivalB2p100)*100) if a > survivalB2p100 & a>0

//OBSERVED < P100 & OBSERVED < P100
replace copB2_1 = 99.5 if a > survivalB2p99 & a < survivalB2p100

sort copB2_1

///////////////////////////////////////////////////////////////////////////////

*MIN

gen copB2_2=copB2_1

forval i= 100(-1)1{
	replace copB2_2=`i' if a==survivalB2p`i' & a>0
}

///////////////////////////////////////////////////////////////////////////////

*MEDIAN

gen copB2_3=copB2_1
replace copB2_3=(copB2_1+copB2_2)/2

save "B\B_copB2.dta", replace


********************************************************************************
********************************************************************************
********************************************************************************

//(7) STEP X GENERATE DESCRIPTIVE STATISTICS

// ssc install estout

clear all
use "B\B_copB2.dta"

foreach x of numlist 36061 25025 42101 17031 39061 39035 26163 18141 17019 {
	putexcel set "DS_copB2.xlsx", sheet(`x') modify
	tabstat copB2_1 copB2_2 copB2_3 if cfips==`x' , statistics(min p10 p50 mean p90 max iqr sd) save
	matrix  T_`x' =  r(StatTotal)
	putexcel A1 = matrix(T_`x'), names
}



********************************************************************************
********************************************************************************
********************************************************************************

//(8) KERNEL DISTRIBUTION
clear all
use "B\B_copB2.dta"
drop if a==0

foreach x of numlist 1900 1910 1920 1930{
	twoway (histogram copB2_1, color(black%80) width(5)) (kdensity copB2_1, lcolor(black)) ///
	(histogram copB2_2, color(blue%90) width(5)) (kdensity copB2_2, lcolor(blue)) ///
	(histogram copB2_3, color(red%40) width(5)) (kdensity copB2_3, lcolor(red)) ///
	if year==`x', title(Kernel nestab90 `x' ) graphregion(color(white)) xscale(range(0 5))
	graph export "KD_copB2s_`x'.png", as(png) name("Graph") replace
}


twoway  (kdensity copB2_3 if year ==1900, lcolor(black)) ///
 (kdensity copB2_3 if year ==1910, lcolor(blue)) ///
 (kdensity copB2_3 if year ==1920 , lcolor(red)) ///
 (kdensity copB2_3 if year ==1930, lcolor(orange)), ///
 title(TS Kernel nestab ) graphregion(color(white)) xscale(range(0 5)) ///
 legend( order(1 "1900" 2 "1910" 3 "1920" 4 "1930") )
 graph export "KDH_TScopB2_3.png", as(png) name("Graph") replace
	

********************************************************************************
********************************************************************************
********************************************************************************

*** (5) STEP 5 TIME SERIES


**OBSERVED, P10, P90

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
 cname="St Joseph"     cfips==18141  
 cname="Champaigne"    cfips==17019 */


foreach x of numlist 36061 25025 42101 17031 39061 39035 26163 18141 17019 {
	twoway (tsline a, lcolor(blue)) (tsline survivalB2p10, lcolor(black) lpattern(vshortdash)) ///
	(tsline survivalB2p90, lcolor(black) lpattern(vshortdash)) if cfips==`x', ///
	title(nestab90_survivalB2 & observed: `x') graphregion(color(white))
	graph export "TSB1&2_`x'.png", as(png) name("Graph") replace
}



**OBSERVED, P10, P90, COBPS

clear all
use "B\B_copB2.dta"
tsset cfips year, yearly

foreach x of numlist 36061 25025 42101 17031 39061 39035 26163 18141 17019 {
	twoway (tsline a, yaxis(1) lcolor(blue)) (tsline survivalB2p10, yaxis(1) lcolor(black) lpattern(vshortdash)) ///
	(tsline survivalB2p90, yaxis(1) lcolor(black) lpattern(vshortdash)) ///
	(tsline copB2_1, yaxis(2) lcolor(red)) (tsline copB2_2, yaxis(2) lcolor(orange)) (tsline copB2_3, yaxis(2) lcolor(green)) if cfips==`x', ///
	title(nestab_survivalB2 & observed: `x') 
	graph export "TS_copB2s_`x'.png", as(png) name("Graph") replace
}






*** (6) STEP 4 GENERATE copB2_1: OBSERVED AS PERCENTAGE OF RANDOM PLC

* GENERATE PERCENTILE AND MAINTAIN ONLY YEARS OF INTEREST FOR GREATER COMPUTER EFFICIENCY
clear all
use "MC_outputdata_random_PLC_inc_all_possible_outcomes_rep_year_cfipsfirms.dta"
save "C\cfips_firms.dta", replace


forval i = 1(1)82{
	clear all
	use "C\cfips_firms.dta"
	collapse (p`i') survival*, by (year cfips_firms)
	rename survival2 survivalB2p`i'
	save "C\p`i'.dta", replace
}

use "C\cfips_firms.dta"
collapse (max) survival*, by (year cfips_firms)
rename survival2 survivalB2p100
save "C\p100.dta", replace



* MERGE: PERCENTILS - OBSERVED - LQ
clear all
use "C\p1.dta"
forval i = 2(1)100{
	merge 1:1 year cfips_firms using "C\p`i'.dta"
	drop _merge
}
rename cfips_firms cfips

merge 1:1 year cfips using "MC_inputdata_observed_PLC_maps.dta"
drop _merge

// merge 1:1 year cfips using "lqmap.dta"
// drop if _merge!=3
// drop gisjoin gisjoin1 year1 ansicode _merge


replace a=0 if a==.

save "C\B_p1-100.dta", replace

* GENERATE OBSERVED AS PERCENTAGE OF RANDOM PLC PERCENTILE VARIABLE

clear all
use "C\B_p1-100.dta"

*MAX

gen copB2_1=.


//LOOP MAX
forval i= 1(1)100{
	replace copB2_1=`i' if a==survivalB2p`i' & a>0
}

//NO TIENEN HISTORIA
replace copB2_1=0 if a<=0 

//OBERVADO < P1
replace copB2_1=0 if a<survivalB2p1

//OBSERVED > P100
replace copB2_1 = ((a/survivalB2p100)*100) if a > survivalB2p100 & a>0

//OBSERVED < P100 & OBSERVED < P100
replace copB2_1 = 99.5 if a > survivalB2p99 & a < survivalB2p100

sort copB2_1

///////////////////////////////////////////////////////////////////////////////

*MIN

gen copB2_2=copB2_1

forval i= 100(-1)1{
	replace copB2_2=`i' if a==survivalB2p`i' & a>0
}

///////////////////////////////////////////////////////////////////////////////

*MEDIAN

gen copB2_3=copB2_1
replace copB2_3=(copB2_1+copB2_2)/2

save "C\B_copB2.dta", replace


********************************************************************************
********************************************************************************
********************************************************************************


clear all
use "C\B_copB2.dta"
tsset cfips year, yearly

foreach x of numlist 36061 25025 42101 17031 39061 39035 26163 18141 17019 {
	twoway (tsline a, yaxis(1) lcolor(blue)) (tsline survivalB2p10, yaxis(1) lcolor(black) lpattern(vshortdash)) ///
	(tsline survivalB2p90, yaxis(1) lcolor(black) lpattern(vshortdash)) ///
	(tsline copB2_3, yaxis(2) lcolor(red)) if cfips==`x', ///
	title(nestab90_survivalB2 & observed: `x') graphregion(color(white))
	graph export "C\TS_copB2s_`x'.png", as(png) name("Graph") replace
}


















