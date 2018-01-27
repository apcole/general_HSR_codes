/*Two ways of calculating volume quartiles, deciles, etc*/


/*Collapsing by hospital ID, ranking and dividing into quartiles*/
/*Gives equal numbers of HOSPITALS in each quartile, unequal numbers of patients*/

#delimit;
gen CASELOAD=1;
collapse (sum) CASELOAD, by (HOSP_NRD);
xtile CASELOAD_QUART=CASELOAD, nquantiles(4);
label define CASELOAD_QUART 
	1 "1st quartile" 
	2 "2nd quartile" 
	3 "3rd quartile" 
	4 "4th quartile";
label values CASELOAD_QUART CASELOAD_QUART;
la var CASELOAD "Caseload at HOSP_NRD per year"; 
la var CASELOAD_QUART " Quartile of volume of HOSP_NRD (after Excluding caseload=1)";
keep CASELOAD CASELOAD_QUART HOSP_NRD;
save "Caseload.dta", replace;
use "NRD_2014_Core_Readmit_Narrow_Costs_Hosp_Severity.dta", clear;
merge m:1 HOSP_NRD using "Caseload.dta";
drop _merge; 
rm "Caseload.dta";


/* Without collapsing by hospital ID, you can sort patients by hospital ID */
/* _N is Stata notation for the total number of observations with the same value*/
/* Code creates a variable "CASELOAD" whose value is the number of observations with that same value of HOSP_NRD */ 
/* Rank and divice into quartiles */
/* gives equal numbers of PATIENTS in each quartile, unequal numbers of hospitals*/
/* Code assumes that each observation is a single case*/

#delimit;
sort HOSP_NRD;
quietly by HOSP_NRD:  generate CASELOAD=_N;
xtile CASELOAD_QUART=CASELOAD, nquantiles(4);
label define CASELOAD_QUART 
	1 "1st quartile" 
	2 "2nd quartile" 
	3 "3rd quartile" 
	4 "4th quartile";
label values CASELOAD_QUART CASELOAD_QUART;
la var CASELOAD "Caseload at HOSP_NRD per year"; 
la var CASELOAD_QUART " Quartile of volume of HOSP_NRD (after Excluding caseload=1)";



/*Calculates the mean and median number of patients in each quartile*/
#delimit;
mean CASELOAD if CASELOAD_QUART==1;
mean CASELOAD if CASELOAD_QUART==2;
mean CASELOAD if CASELOAD_QUART==3;
mean CASELOAD if CASELOAD_QUART==4;

summarize CASELOAD if CASELOAD_QUART==1, detail;
summarize CASELOAD if CASELOAD_QUART==2, detail;
summarize CASELOAD if CASELOAD_QUART==3, detail;
summarize CASELOAD if CASELOAD_QUART==4, detail;

