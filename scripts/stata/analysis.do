********************************************************************************
* Stata Do-File: EU Accession — Dynamic DiD Event Study Analysis
* Author:        Maanit Mehta
* Affiliation:   MSc Financial Modelling & Investment, University of Glasgow
* Supervisor:    Dr. Sisir Ramanan
* Description:   Estimates cohort-specific ATETs for 9 macroeconomic indicators
*                using xthdidregress (Stata 18). Generates event-study plots and
*                coefficient beta/SE plots by accession cohort (2004, 2007, 2013).
* Data:          Data/eupanel.dta (generated from scripts/R/data_collection.R)
* Requirements:  Stata 18+
********************************************************************************

clear all
set more off

********************************************************************************
* 1. SETUP
********************************************************************************

* Update these paths before running
cd "YOUR_PROJECT_DIRECTORY"
use "Data/eupanel.dta", clear
local graphdir "Results"

summarize

********************************************************************************
* 2. PANEL SETUP
********************************************************************************

generate country = 1
replace country = 2  if country_id == "CYP"
replace country = 3  if country_id == "CZE"
replace country = 4  if country_id == "EST"
replace country = 5  if country_id == "HRV"
replace country = 6  if country_id == "HUN"
replace country = 7  if country_id == "LTU"
replace country = 8  if country_id == "LVA"
replace country = 9  if country_id == "MLT"
replace country = 10 if country_id == "POL"
replace country = 11 if country_id == "ROU"
replace country = 12 if country_id == "SVK"
replace country = 13 if country_id == "SVN"
replace country = 14 if country_id == "ALB"
replace country = 15 if country_id == "BIH"
replace country = 16 if country_id == "MKD"
replace country = 17 if country_id == "MNE"
replace country = 18 if country_id == "SRB"
replace country = 19 if country_id == "TUR"
replace country = 20 if country_id == "MDA"
replace country = 21 if country_id == "UKR"
replace country = 22 if country_id == "BLR"
replace country = 23 if country_id == "GEO"

tsset country year, yearly
gen event_time = year - accession_year

********************************************************************************
* 3. HELPER MACRO — EXTRACT AND PLOT COHORT BETAS
* Extracts ATET (row 1) and SE (row 2) from r(table) matrix
* Plots by cohort (2004=blue, 2007=red, 2013=green) across years
********************************************************************************

* Matrix layout from xthdidregress r(table):
* Columns 1-20:  2004 cohort
* Columns 21-40: 2007 cohort
* Columns 41-60: 2013 cohort

********************************************************************************
* 4. MAIN ANALYSIS
********************************************************************************

eststo clear

* Years for row labels (event window 1996-2015)
local yrlabs 1996 1997 1998 1999 2000 2001 2002 2003 2004 ///
             2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015

* --- 4.1 IMPORTS ---
eststo: xthdidregress ra (Imports) (Treated), ///
    group(country) cohortvar(accession_year, replace)
matrix temp = r(table)
estat atetplot, name(Imports, replace)
graph export "`graphdir'/Imports.jpg", as(jpg) quality(100) replace

matrix b = J(20, 3, .)
matrix colnames b = c2004 c2007 c2013
matrix rownames b = `yrlabs'
forval i = 1/20 {
    matrix b[`i',1] = temp[1,`i']
    matrix b[`i',2] = temp[1,20+`i']
    matrix b[`i',3] = temp[1,40+`i']
}
svmat double b
twoway (line b1 year, lcolor(blue)) ///
       (line b2 year, lcolor(red))  ///
       (line b3 year, lcolor(green)), ///
       legend(label(1 "2004") label(2 "2007") label(3 "2013")) ///
       title("Imports — Beta (ATET)") ytitle("ATET") xtitle("Year")
graph export "`graphdir'/Imports_Beta.jpg", as(jpg) quality(100) replace
drop b1 b2 b3

* --- 4.2 EXPORTS ---
eststo: xthdidregress ra (Exports) (Treated), ///
    group(country) cohortvar(accession_year, replace)
matrix temp = r(table)
estat atetplot, name(Exports, replace)
graph export "`graphdir'/Exports.jpg", as(jpg) quality(100) replace

matrix b = J(20, 3, .)
matrix colnames b = c2004 c2007 c2013
matrix rownames b = `yrlabs'
forval i = 1/20 {
    matrix b[`i',1] = temp[1,`i']
    matrix b[`i',2] = temp[1,20+`i']
    matrix b[`i',3] = temp[1,40+`i']
}
svmat double b
twoway (line b1 year, lcolor(blue)) ///
       (line b2 year, lcolor(red))  ///
       (line b3 year, lcolor(green)), ///
       legend(label(1 "2004") label(2 "2007") label(3 "2013")) ///
       title("Exports — Beta (ATET)") ytitle("ATET") xtitle("Year")
graph export "`graphdir'/Exports_Beta.jpg", as(jpg) quality(100) replace
drop b1 b2 b3

* --- 4.3 GROSS CAPITAL FORMATION ---
eststo: xthdidregress ra (Gross_Capital_Formation) (Treated), ///
    group(country) cohortvar(accession_year, replace)
matrix temp = r(table)
estat atetplot, name(GCF, replace)
graph export "`graphdir'/Gross_Capital_Formation.jpg", as(jpg) quality(100) replace

matrix b = J(20, 3, .)
matrix colnames b = c2004 c2007 c2013
matrix rownames b = `yrlabs'
forval i = 1/20 {
    matrix b[`i',1] = temp[1,`i']
    matrix b[`i',2] = temp[1,20+`i']
    matrix b[`i',3] = temp[1,40+`i']
}
svmat double b
twoway (line b1 year, lcolor(blue)) ///
       (line b2 year, lcolor(red))  ///
       (line b3 year, lcolor(green)), ///
       legend(label(1 "2004") label(2 "2007") label(3 "2013")) ///
       title("Gross Capital Formation — Beta (ATET)") ytitle("ATET") xtitle("Year")
graph export "`graphdir'/Gross_Capital_Formation_Beta.jpg", as(jpg) quality(100) replace
drop b1 b2 b3

* --- 4.4 GDP GROWTH ---
eststo: xthdidregress ra (GDP_Growth) (Treated), ///
    group(country) cohortvar(accession_year, replace)
matrix temp = r(table)
estat atetplot, name(GDP, replace)
graph export "`graphdir'/GDP_Growth.jpg", as(jpg) quality(100) replace

matrix b = J(20, 3, .)
matrix colnames b = c2004 c2007 c2013
matrix rownames b = `yrlabs'
forval i = 1/20 {
    matrix b[`i',1] = temp[1,`i']
    matrix b[`i',2] = temp[1,20+`i']
    matrix b[`i',3] = temp[1,40+`i']
}
svmat double b
twoway (line b1 year, lcolor(blue)) ///
       (line b2 year, lcolor(red))  ///
       (line b3 year, lcolor(green)), ///
       legend(label(1 "2004") label(2 "2007") label(3 "2013")) ///
       title("GDP Growth — Beta (ATET)") ytitle("ATET") xtitle("Year")
graph export "`graphdir'/GDP_Growth_Beta.jpg", as(jpg) quality(100) replace
drop b1 b2 b3

* --- 4.5 INFLATION ---
eststo: xthdidregress ra (Inflation) (Treated), ///
    group(country) cohortvar(accession_year, replace)
matrix temp = r(table)
estat atetplot, name(Inflation, replace)
graph export "`graphdir'/Inflation.jpg", as(jpg) quality(100) replace

matrix b = J(20, 3, .)
matrix colnames b = c2004 c2007 c2013
matrix rownames b = `yrlabs'
forval i = 1/20 {
    matrix b[`i',1] = temp[1,`i']
    matrix b[`i',2] = temp[1,20+`i']
    matrix b[`i',3] = temp[1,40+`i']
}
svmat double b
twoway (line b1 year, lcolor(blue)) ///
       (line b2 year, lcolor(red))  ///
       (line b3 year, lcolor(green)), ///
       legend(label(1 "2004") label(2 "2007") label(3 "2013")) ///
       title("Inflation — Beta (ATET)") ytitle("ATET") xtitle("Year")
graph export "`graphdir'/Inflation_Beta.jpg", as(jpg) quality(100) replace
drop b1 b2 b3

* --- 4.6 UNEMPLOYMENT ---
eststo: xthdidregress ra (Unemployment) (Treated), ///
    group(country) cohortvar(accession_year, replace)
matrix temp = r(table)
estat atetplot, name(Unemployment, replace)
graph export "`graphdir'/Unemployment.jpg", as(jpg) quality(100) replace

matrix b = J(20, 3, .)
matrix colnames b = c2004 c2007 c2013
matrix rownames b = `yrlabs'
forval i = 1/20 {
    matrix b[`i',1] = temp[1,`i']
    matrix b[`i',2] = temp[1,20+`i']
    matrix b[`i',3] = temp[1,40+`i']
}
svmat double b
twoway (line b1 year, lcolor(blue)) ///
       (line b2 year, lcolor(red))  ///
       (line b3 year, lcolor(green)), ///
       legend(label(1 "2004") label(2 "2007") label(3 "2013")) ///
       title("Unemployment — Beta (ATET)") ytitle("ATET") xtitle("Year")
graph export "`graphdir'/Unemployment_Beta.jpg", as(jpg) quality(100) replace
drop b1 b2 b3

* --- 4.7 CURRENT ACCOUNT BALANCE ---
eststo: xthdidregress ra (Current_Account_Balance) (Treated), ///
    group(country) cohortvar(accession_year, replace)
matrix temp = r(table)
estat atetplot, name(CAB, replace)
graph export "`graphdir'/Current_Account_Balance.jpg", as(jpg) quality(100) replace

matrix b = J(20, 3, .)
matrix colnames b = c2004 c2007 c2013
matrix rownames b = `yrlabs'
forval i = 1/20 {
    matrix b[`i',1] = temp[1,`i']
    matrix b[`i',2] = temp[1,20+`i']
    matrix b[`i',3] = temp[1,40+`i']
}
svmat double b
twoway (line b1 year, lcolor(blue)) ///
       (line b2 year, lcolor(red))  ///
       (line b3 year, lcolor(green)), ///
       legend(label(1 "2004") label(2 "2007") label(3 "2013")) ///
       title("Current Account Balance — Beta (ATET)") ytitle("ATET") xtitle("Year")
graph export "`graphdir'/Current_Account_Balance_Beta.jpg", as(jpg) quality(100) replace
drop b1 b2 b3

* --- 4.8 EXCHANGE RATE ---
eststo: xthdidregress ra (Exchange_Rate_USD) (Treated), ///
    group(country) cohortvar(accession_year, replace)
matrix temp = r(table)
estat atetplot, name(FX, replace)
graph export "`graphdir'/Exchange_Rate_USD.jpg", as(jpg) quality(100) replace

matrix b = J(20, 3, .)
matrix colnames b = c2004 c2007 c2013
matrix rownames b = `yrlabs'
forval i = 1/20 {
    matrix b[`i',1] = temp[1,`i']
    matrix b[`i',2] = temp[1,20+`i']
    matrix b[`i',3] = temp[1,40+`i']
}
svmat double b
twoway (line b1 year, lcolor(blue)) ///
       (line b2 year, lcolor(red))  ///
       (line b3 year, lcolor(green)), ///
       legend(label(1 "2004") label(2 "2007") label(3 "2013")) ///
       title("Exchange Rate USD — Beta (ATET)") ytitle("ATET") xtitle("Year")
graph export "`graphdir'/Exchange_Rate_USD_Beta.jpg", as(jpg) quality(100) replace
drop b1 b2 b3

* --- 4.9 GOVERNMENT CONSUMPTION ---
eststo: xthdidregress ra (Government_Consumption) (Treated), ///
    group(country) cohortvar(accession_year, replace)
matrix temp = r(table)
estat atetplot, name(GovCon, replace)
graph export "`graphdir'/Government_Consumption.jpg", as(jpg) quality(100) replace

matrix b = J(20, 3, .)
matrix colnames b = c2004 c2007 c2013
matrix rownames b = `yrlabs'
forval i = 1/20 {
    matrix b[`i',1] = temp[1,`i']
    matrix b[`i',2] = temp[1,20+`i']
    matrix b[`i',3] = temp[1,40+`i']
}
svmat double b
twoway (line b1 year, lcolor(blue)) ///
       (line b2 year, lcolor(red))  ///
       (line b3 year, lcolor(green)), ///
       legend(label(1 "2004") label(2 "2007") label(3 "2013")) ///
       title("Government Consumption — Beta (ATET)") ytitle("ATET") xtitle("Year")
graph export "`graphdir'/Government_Consumption_Beta.jpg", as(jpg) quality(100) replace
drop b1 b2 b3

********************************************************************************
* 5. HETEROGENEITY / ROBUSTNESS CHECKS
********************************************************************************

eststo: xthdidregress ra (Imports Exports) (Treated), ///
    group(country) cohortvar(accession_year, replace)
estat atetplot, name(Exp_Imp, replace)
graph export "`graphdir'/Exports_on_Imports.jpg", as(jpg) quality(100) replace

eststo: xthdidregress ra (Exports Imports) (Treated), ///
    group(country) cohortvar(accession_year, replace)
estat atetplot, name(Imp_Exp, replace)
graph export "`graphdir'/Imports_on_Exports.jpg", as(jpg) quality(100) replace

eststo: xthdidregress ra (Government_Consumption GDP_Growth) (Treated), ///
    group(country) cohortvar(accession_year, replace)
estat atetplot, name(GovCon_GDP, replace)
graph export "`graphdir'/GovCon_on_GDP_Growth.jpg", as(jpg) quality(100) replace

eststo: xthdidregress ra (GDP_Growth Government_Consumption) (Treated), ///
    group(country) cohortvar(accession_year, replace)
estat atetplot, name(GDP_GovCon, replace)
graph export "`graphdir'/GDP_Growth_on_GovCon.jpg", as(jpg) quality(100) replace

eststo: xthdidregress ra (Imports GDP_Growth) (Treated), ///
    group(country) cohortvar(accession_year, replace)
estat atetplot, name(Imp_GDP, replace)
graph export "`graphdir'/Imports_on_GDP_Growth.jpg", as(jpg) quality(100) replace

eststo: xthdidregress ra (Exports GDP_Growth) (Treated), ///
    group(country) cohortvar(accession_year, replace)
estat atetplot, name(Exp_GDP, replace)
graph export "`graphdir'/Exports_on_GDP_Growth.jpg", as(jpg) quality(100) replace

********************************************************************************
* 6. FINAL OUTPUT TABLE
********************************************************************************

esttab, label

********************************************************************************
* END OF DO-FILE
********************************************************************************
