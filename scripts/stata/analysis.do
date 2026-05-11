********************************************************************************
* Stata Do-File: Manual Event Study DID Analysis with Lead/Lag Indicators    *
* Generates coefficients for pre- and post-treatment effects.                 *
* Designed for 2004, 2007, and 2013 treated cohorts ONLY.                      *
********************************************************************************

clear all       // Clears all data from memory, starting fresh
set more off    // Prevents Stata from pausing after each screen of output

* Install coefplot package if you haven't already
ssc install coefplot, replace
eststo clear

* Set your working directory to where you saved 'eu_accession_panel_data.dta'
* IMPORTANT: Replace 'maanitmehta/Documents/' with your actual path to the .dta file!
cd "/Users/maanitmehta/Downloads/"

* Load the panel data generated from R
use "eupanel.dta", clear

cd "/Users/maanitmehta/Desktop/goodstata/graphs"

// extra data checking
summarize

// generating a new column country - which has all the countries in a numeric format useful for creating timeseries
generate country = 1
replace country = 2 if country_id == "CYP"
replace country = 3 if country_id == "CZE"
replace country = 4 if country_id == "EST"
replace country = 5 if country_id == "HRV"
replace country = 6 if country_id == "HUN"
replace country = 7 if country_id == "LTU"
replace country = 8 if country_id == "LVA"
replace country = 9 if country_id == "MLT"
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
 
 
* Declare data as panel data
tsset country year, yearly


* Generate event_time relative to treatment for each country
gen event_time = year - accession_year


* Imports
eststo: xthdidregress ra (Imports) (Treated), group(country) cohortvar(accession_year, replace)

matrix temp = r(table)

matrix b = J(20, 3, .)
matrix colnames b = 2004 2007 2013
matrix rownames b = 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015

forval i = 1/20 {
	matrix b[`i', 1] = temp[1, `i']
	matrix b[`i', 2] = temp[1, 20+`i']
	matrix b[`i', 3] = temp[1, 40+`i']
}

svmat double b

twoway (line b1 year, ms(O) sort lcolor(blue)) (line b2 year, ms(Oh) sort lcolor(red)) (line b3 year, ms(Oh) sort lcolor(green)), legend(label (1 "2004") label(2 "2007") label(3 "2013")) title("Imports - Beta (Estimated Treatment Effect)") ytitle("b") xtitle("Year")

graph export "Imports_b.jpg", as(jpg) quality(100) replace

drop b1 b2 b3

forval i = 1/20 {
	matrix b[`i', 1] = temp[2, `i']
	matrix b[`i', 2] = temp[2, 20+`i']
	matrix b[`i', 3] = temp[2, 40+`i']
}

svmat double b

twoway (line b1 year, ms(O) sort lcolor(blue)) (line b2 year, ms(Oh) sort lcolor(red)) (line b3 year, ms(Oh) sort lcolor(green)), legend(label (1 "2004") label(2 "2007") label(3 "2013")) title("Imports - Standard Error") ytitle("S.E.") xtitle("Year")

graph export "Imports_SE.jpg", as(jpg) quality(100) replace

drop b1 b2 b3


estat aggregation, cohort
estat aggregation, time 

estat atetplot, name(Imports, replace)
graph combine Imports, title("Imports") saving("Imports.gph", replace)
graph export "/Users/maanitmehta/Desktop/goodstata/graphs/jpg/Imports.jpg", as(jpg) quality(100) replace
* Imports Complete



* testing 
* matrix test = r(table)
* matlist test
* matlist test[1, 1...]

* Exports
eststo: xthdidregress ra (Exports) (Treated), group(country) cohortvar(accession_year, replace)

matrix temp = r(table)
esttab mat(temp) using "/Users/maanitmehta/Desktop/goodstata/graphs/Exports.csv", replace

estat aggregation, cohort
estat aggregation, time graph

estat atetplot, name(Exports, replace)
graph combine Exports, title("Exports") saving("/Users/maanitmehta/Desktop/goodstata/graphs/Exports.gph", replace)


matrix b = J(20, 3, .)
matrix colnames b = 2004 2007 2013
matrix rownames b = 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015

forval i = 1/20 {
	matrix b[`i', 1] = temp[1, `i']
	matrix b[`i', 2] = temp[1, 20+`i']
	matrix b[`i', 3] = temp[1, 40+`i']
}

svmat double b

twoway (line b1 year, ms(O) sort lcolor(blue)) (line b2 year, ms(Oh) sort lcolor(red)) (line b3 year, ms(Oh) sort lcolor(green)), legend(label (1 "2004") label(2 "2007") label(3 "2013")) title("Exports - Beta (Estimated Treatment Effect)") ytitle("b") xtitle("Year")

graph export "Exports_Beta.jpg", as(jpg) quality(100) replace

drop b1 b2 b3

forval i = 1/20 {
	matrix b[`i', 1] = temp[2, `i']
	matrix b[`i', 2] = temp[2, 20+`i']
	matrix b[`i', 3] = temp[2, 40+`i']
}

svmat double b

twoway (line b1 year, ms(O) sort lcolor(blue)) (line b2 year, ms(Oh) sort lcolor(red)) (line b3 year, ms(Oh) sort lcolor(green)), legend(label (1 "2004") label(2 "2007") label(3 "2013")) title("Exports - Standard Error") ytitle("S.E.") xtitle("Year")

graph export "Exports_SE.jpg", as(jpg) quality(100) replace

drop b1 b2 b3
* Exports Complete


* Gross_Capital_Formation
eststo: xthdidregress ra (Gross_Capital_Formation) (Treated), group(country) cohortvar(accession_year, replace)

matrix temp = r(table)
esttab mat(temp) using "/Users/maanitmehta/Desktop/goodstata/graphs/Gross_Capital_Formation.csv", replace
estat aggregation, cohort
estat aggregation, time

estat atetplot, name(Gross_Capital_Formation, replace)
graph combine Gross_Capital_Formation, title("Gross_Capital_Formation") saving("/Users/maanitmehta/Desktop/goodstata/graphs/Gross_Capital_Formation.gph", replace)

matrix b = J(20, 3, .)
matrix colnames b = 2004 2007 2013
matrix rownames b = 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015

forval i = 1/20 {
	matrix b[`i', 1] = temp[1, `i']
	matrix b[`i', 2] = temp[1, 20+`i']
	matrix b[`i', 3] = temp[1, 40+`i']
}

svmat double b

twoway (line b1 year, ms(O) sort lcolor(blue)) (line b2 year, ms(Oh) sort lcolor(red)) (line b3 year, ms(Oh) sort lcolor(green)), legend(label (1 "2004") label(2 "2007") label(3 "2013")) title("Gross_Capital_Formation - Beta (Estimated Treatment Effect)") ytitle("b") xtitle("Year")

graph export "Gross_Capital_Formation_Beta.jpg", as(jpg) quality(100) replace

drop b1 b2 b3

forval i = 1/20 {
	matrix b[`i', 1] = temp[2, `i']
	matrix b[`i', 2] = temp[2, 20+`i']
	matrix b[`i', 3] = temp[2, 40+`i']
}

svmat double b

twoway (line b1 year, ms(O) sort lcolor(blue)) (line b2 year, ms(Oh) sort lcolor(red)) (line b3 year, ms(Oh) sort lcolor(green)), legend(label (1 "2004") label(2 "2007") label(3 "2013")) title("Gross_Capital_Formation - Standard Error") ytitle("S.E.") xtitle("Year")

graph export "Gross_Capital_Formation_SE.jpg", as(jpg) quality(100) replace

drop b1 b2 b3
* Gross_Capital_Formation Complete


* GDP_Growth
eststo: xthdidregress ra (GDP_Growth) (Treated), group(country) cohortvar(accession_year, replace)

matrix temp = r(table)

estat atetplot, name(GDP_Growth, replace)
graph combine GDP_Growth, title("GDP_Growth") saving("/Users/maanitmehta/Desktop/goodstata/graphs/GDP_Growth.gph", replace)
graph export "/Users/maanitmehta/Desktop/goodstata/graphs/jpg/GDP_Growth.jpg", as(jpg) quality(100) replace

estat aggregation, cohort
estat aggregation, time 


matrix b = J(20, 3, .)
matrix colnames b = 2004 2007 2013
matrix rownames b = 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015

forval i = 1/20 {
	matrix b[`i', 1] = temp[1, `i']
	matrix b[`i', 2] = temp[1, 20+`i']
	matrix b[`i', 3] = temp[1, 40+`i']
}

svmat double b

twoway (line b1 year, ms(O) sort lcolor(blue)) (line b2 year, ms(Oh) sort lcolor(red)) (line b3 year, ms(Oh) sort lcolor(green)), legend(label (1 "2004") label(2 "2007") label(3 "2013")) title("GDP_Growth - Beta (Estimated Treatment Effect)") ytitle("b") xtitle("Year")

graph export "GDP_Growth_Beta.jpg", as(jpg) quality(100) replace

drop b1 b2 b3

forval i = 1/20 {
	matrix b[`i', 1] = temp[2, `i']
	matrix b[`i', 2] = temp[2, 20+`i']
	matrix b[`i', 3] = temp[2, 40+`i']
}

svmat double b

twoway (line b1 year, ms(O) sort lcolor(blue)) (line b2 year, ms(Oh) sort lcolor(red)) (line b3 year, ms(Oh) sort lcolor(green)), legend(label (1 "2004") label(2 "2007") label(3 "2013")) title("GDP_Growth - Standard Error") ytitle("S.E.") xtitle("Year")

graph export "GDP_Growth_SE.jpg", as(jpg) quality(100) replace

drop b1 b2 b3
* GDP_Growth Complete



* Inflation
eststo: xthdidregress ra (Inflation) (Treated), group(country) cohortvar(accession_year, replace)

matrix temp = r(table)

estat aggregation, cohort
estat aggregation, time

estat atetplot, name(Inflation, replace)
graph combine Inflation, title("Inflation") saving("/Users/maanitmehta/Desktop/goodstata/graphs/Inflation.gph", replace)
graph export "/Users/maanitmehta/Desktop/goodstata/graphs/jpg/Inflation.jpg", as(jpg) quality(100) replace


matrix b = J(20, 3, .)
matrix colnames b = 2004 2007 2013
matrix rownames b = 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015

forval i = 1/20 {
	matrix b[`i', 1] = temp[1, `i']
	matrix b[`i', 2] = temp[1, 20+`i']
	matrix b[`i', 3] = temp[1, 40+`i']
}

svmat double b

twoway (line b1 year, ms(O) sort lcolor(blue)) (line b2 year, ms(Oh) sort lcolor(red)) (line b3 year, ms(Oh) sort lcolor(green)), legend(label (1 "2004") label(2 "2007") label(3 "2013")) title("Inflation - Beta (Estimated Treatment Effect)") ytitle("b") xtitle("Year")

graph export "Inflation_Beta.jpg", as(jpg) quality(100) replace

drop b1 b2 b3

forval i = 1/20 {
	matrix b[`i', 1] = temp[2, `i']
	matrix b[`i', 2] = temp[2, 20+`i']
	matrix b[`i', 3] = temp[2, 40+`i']
}

svmat double b

twoway (line b1 year, ms(O) sort lcolor(blue)) (line b2 year, ms(Oh) sort lcolor(red)) (line b3 year, ms(Oh) sort lcolor(green)), legend(label (1 "2004") label(2 "2007") label(3 "2013")) title("Inflation - Standard Error") ytitle("S.E.") xtitle("Year")

graph export "Inflation_SE.jpg", as(jpg) quality(100) replace

drop b1 b2 b3
* Inflation Complete





* Unemployment
eststo: xthdidregress ra (Unemployment) (Treated), group(country) cohortvar(accession_year, replace)

matrix temp = r(table)

estat aggregation, cohort
estat aggregation, time

estat atetplot, name(Unemployment, replace)
graph combine Inflation, title("Unemployment") saving("/Users/maanitmehta/Desktop/goodstata/graphs/Unemployment.gph", replace)
graph export "/Users/maanitmehta/Desktop/goodstata/graphs/jpg/Unemployment.jpg", as(jpg) quality(100) replace


matrix b = J(20, 3, .)
matrix colnames b = 2004 2007 2013
matrix rownames b = 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015

forval i = 1/20 {
	matrix b[`i', 1] = temp[1, `i']
	matrix b[`i', 2] = temp[1, 20+`i']
	matrix b[`i', 3] = temp[1, 40+`i']
}

svmat double b

twoway (line b1 year, ms(O) sort lcolor(blue)) (line b2 year, ms(Oh) sort lcolor(red)) (line b3 year, ms(Oh) sort lcolor(green)), legend(label (1 "2004") label(2 "2007") label(3 "2013")) title("Unemployment - Beta (Estimated Treatment Effect)") ytitle("b") xtitle("Year")

graph export "Unemployment_Beta.jpg", as(jpg) quality(100) replace

drop b1 b2 b3

forval i = 1/20 {
	matrix b[`i', 1] = temp[2, `i']
	matrix b[`i', 2] = temp[2, 20+`i']
	matrix b[`i', 3] = temp[2, 40+`i']
}

svmat double b

twoway (line b1 year, ms(O) sort lcolor(blue)) (line b2 year, ms(Oh) sort lcolor(red)) (line b3 year, ms(Oh) sort lcolor(green)), legend(label (1 "2004") label(2 "2007") label(3 "2013")) title("Unemployment - Standard Error") ytitle("S.E.") xtitle("Year")

graph export "Unemployment_SE.jpg", as(jpg) quality(100) replace

drop b1 b2 b3
* Unemployment Complete





* Current_Account_Balance
eststo: xthdidregress ra (Current_Account_Balance) (Treated), group(country) cohortvar(accession_year, replace)

matrix temp = r(table)

estat aggregation, cohort
estat aggregation, time

estat atetplot, name(Current_Account_Balance, replace)
graph combine Current_Account_Balance, title("Current_Account_Balance") saving("/Users/maanitmehta/Desktop/goodstata/graphs/Current_Account_Balance.gph", replace)
graph export "/Users/maanitmehta/Desktop/goodstata/graphs/jpg/Current_Account_Balance.jpg", as(jpg) quality(100) replace


matrix b = J(20, 3, .)
matrix colnames b = 2004 2007 2013
matrix rownames b = 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015

forval i = 1/20 {
	matrix b[`i', 1] = temp[1, `i']
	matrix b[`i', 2] = temp[1, 20+`i']
	matrix b[`i', 3] = temp[1, 40+`i']
}

svmat double b

twoway (line b1 year, ms(O) sort lcolor(blue)) (line b2 year, ms(Oh) sort lcolor(red)) (line b3 year, ms(Oh) sort lcolor(green)), legend(label (1 "2004") label(2 "2007") label(3 "2013")) title("Current_Account_Balance - Beta (Estimated Treatment Effect)") ytitle("b") xtitle("Year")

graph export "Current_Account_Balance_Beta.jpg", as(jpg) quality(100) replace

drop b1 b2 b3

forval i = 1/20 {
	matrix b[`i', 1] = temp[2, `i']
	matrix b[`i', 2] = temp[2, 20+`i']
	matrix b[`i', 3] = temp[2, 40+`i']
}

svmat double b

twoway (line b1 year, ms(O) sort lcolor(blue)) (line b2 year, ms(Oh) sort lcolor(red)) (line b3 year, ms(Oh) sort lcolor(green)), legend(label (1 "2004") label(2 "2007") label(3 "2013")) title("Current_Account_Balance - Standard Error") ytitle("S.E.") xtitle("Year")

graph export "Current_Account_Balance_SE.jpg", as(jpg) quality(100) replace

drop b1 b2 b3
* Current_Account_Balance Complete





* Exchange_Rate_USD
eststo: xthdidregress ra (Exchange_Rate_USD) (Treated), group(country) cohortvar(accession_year, replace)

matrix temp = r(table)

estat aggregation, cohort
estat aggregation, time 

estat atetplot, name(Exchange_Rate_USD, replace)
graph combine Exchange_Rate_USD, title("Exchange_Rate_USD") saving("/Users/maanitmehta/Desktop/goodstata/graphs/Exchange_Rate_USD.gph", replace)
graph export "/Users/maanitmehta/Desktop/goodstata/graphs/jpg/Exchange_Rate_USD.jpg", as(jpg) quality(100) replace

matrix b = J(20, 3, .)
matrix colnames b = 2004 2007 2013
matrix rownames b = 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015

forval i = 1/20 {
	matrix b[`i', 1] = temp[1, `i']
	matrix b[`i', 2] = temp[1, 20+`i']
	matrix b[`i', 3] = temp[1, 40+`i']
}

svmat double b

twoway (line b1 year, ms(O) sort lcolor(blue)) (line b2 year, ms(Oh) sort lcolor(red)) (line b3 year, ms(Oh) sort lcolor(green)), legend(label (1 "2004") label(2 "2007") label(3 "2013")) title("Exchange_Rate_USD - Beta (Estimated Treatment Effect)") ytitle("b") xtitle("Year")

graph export "Exchange_Rate_USD_Beta.jpg", as(jpg) quality(100) replace

drop b1 b2 b3

forval i = 1/20 {
	matrix b[`i', 1] = temp[2, `i']
	matrix b[`i', 2] = temp[2, 20+`i']
	matrix b[`i', 3] = temp[2, 40+`i']
}

svmat double b

twoway (line b1 year, ms(O) sort lcolor(blue)) (line b2 year, ms(Oh) sort lcolor(red)) (line b3 year, ms(Oh) sort lcolor(green)), legend(label (1 "2004") label(2 "2007") label(3 "2013")) title("Exchange_Rate_USD - Standard Error") ytitle("S.E.") xtitle("Year")

graph export "Exchange_Rate_USD_SE.jpg", as(jpg) quality(100) replace

drop b1 b2 b3
* Exchange_Rate_USD Complete





* Government_Consumption
eststo: xthdidregress ra (Government_Consumption) (Treated), group(country) cohortvar(accession_year, replace)

matrix temp = r(table)

esttab mat(temp) using "/Users/maanitmehta/Desktop/goodstata/graphs/Government_Consumption.csv", replace

estat aggregation, cohort
estat aggregation, time

estat atetplot, name(Government_Consumption, replace)
graph combine Government_Consumption, title("Government_Consumption") saving("/Users/maanitmehta/Desktop/goodstata/graphs/Government_Consumption.gph", replace)
graph export "/Users/maanitmehta/Desktop/goodstata/graphs/jpg/Government_Consumption.jpg", as(jpg) quality(100) replace

matrix b = J(20, 3, .)
matrix colnames b = 2004 2007 2013
matrix rownames b = 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015

forval i = 1/20 {
	matrix b[`i', 1] = temp[1, `i']
	matrix b[`i', 2] = temp[1, 20+`i']
	matrix b[`i', 3] = temp[1, 40+`i']
}

svmat double b

twoway (line b1 year, ms(O) sort lcolor(blue)) (line b2 year, ms(Oh) sort lcolor(red)) (line b3 year, ms(Oh) sort lcolor(green)), legend(label (1 "2004") label(2 "2007") label(3 "2013")) title("Government_Consumption - Beta (Estimated Treatment Effect)") ytitle("b") xtitle("Year")

graph export "Government_Consumption_Beta.jpg", as(jpg) quality(100) replace

drop b1 b2 b3

forval i = 1/20 {
	matrix b[`i', 1] = temp[2, `i']
	matrix b[`i', 2] = temp[2, 20+`i']
	matrix b[`i', 3] = temp[2, 40+`i']
}

svmat double b

twoway (line b1 year, ms(O) sort lcolor(blue)) (line b2 year, ms(Oh) sort lcolor(red)) (line b3 year, ms(Oh) sort lcolor(green)), legend(label (1 "2004") label(2 "2007") label(3 "2013")) title("Government_Consumption - Standard Error") ytitle("S.E.") xtitle("Year")

graph export "Government_Consumption_SE.jpg", as(jpg) quality(100) replace

drop b1 b2 b3
* Government_Consumption Complete


// graph export "/Users/maanitmehta/Desktop/goodstata/graphs/jpg/Imports.jpg", as(jpg) quality(100) replace
// graph export "/Users/maanitmehta/Desktop/goodstata/graphs/jpg/Exports.jpg", as(jpg) quality(100) replace
// graph export "/Users/maanitmehta/Desktop/goodstata/graphs/jpg/Gross_Capital_Formation.jpg", as(jpg) quality(100) replace
// graph export "/Users/maanitmehta/Desktop/goodstata/graphs/jpg/GDP_Growth.jpg", as(jpg) quality(100) replace
// graph export "/Users/maanitmehta/Desktop/goodstata/graphs/jpg/Inflation.jpg", as(jpg) quality(100) replace
// graph export "/Users/maanitmehta/Desktop/goodstata/graphs/jpg/Unemployment.jpg", as(jpg) quality(100) replace
// graph export "/Users/maanitmehta/Desktop/goodstata/graphs/jpg/Current_Account_Balance.jpg", as(jpg) quality(100) replace
// graph export "/Users/maanitmehta/Desktop/goodstata/graphs/jpg/Exchange_Rate_USD.jpg", as(jpg) quality(100) replace
// graph export "/Users/maanitmehta/Desktop/goodstata/graphs/jpg/Government_Consumption.jpg", as(jpg) quality(100) replace
//

esttab, label



* twoway (line Imports year if accession_year==2004, ms(O) sort lcolor(blue)) (line Imports year if accession_year==2007, ms(Oh) sort lcolor(red)) (line Imports year if accession_year==2013, ms(Oh) sort lcolor(green)) (line Imports year if accession_year==0, ms(Oh) sort lcolor(black)), legend(label (1 "2004") label(2 "2007") label(3 "2013") label(4 "Never Treated"))





** Imports on Exports
eststo: xthdidregress ra (Imports Exports) (Treated), group(country) cohortvar(accession_year, replace)

estat atetplot, name(Imports, replace)
graph combine Imports, title("Imports on Exports") saving("Imports_with_Exports.gph", replace)
graph export "/Users/maanitmehta/Desktop/goodstata/graphs/jpg/Imports_with_Exports.jpg", as(jpg) quality(100) replace


** Exports on Imports 
eststo: xthdidregress ra (Exports Imports) (Treated), group(country) cohortvar(accession_year, replace)

estat atetplot, name(Imports, replace)
graph combine Imports, title("Exports on Imports") saving("Exports_with_Imports.gph", replace)
graph export "/Users/maanitmehta/Desktop/goodstata/graphs/jpg/Exports_with_Imports.jpg", as(jpg) quality(100) replace

** Government_Consumption on GDP_Growth
eststo: xthdidregress ra (Government_Consumption GDP_Growth) (Treated), group(country) cohortvar(accession_year, replace)

estat atetplot, name(Imports, replace)
graph combine Imports, title("Government_Consumption on GDP_Growth") saving("Government_Consumption_with_GDP_Growth.gph", replace)
graph export "/Users/maanitmehta/Desktop/goodstata/graphs/jpg/Government_Consumption_with_GDP_Growth.jpg", as(jpg) quality(100) replace


** GDP_Growth on Government_Consumption
eststo: xthdidregress ra (GDP_Growth Government_Consumption) (Treated), group(country) cohortvar(accession_year, replace)

estat atetplot, name(Imports, replace)
graph combine Imports, title("GDP_Growth on Government_Consumption") saving("GDP_Growth_with_Government_Consumption.gph", replace)
graph export "/Users/maanitmehta/Desktop/goodstata/graphs/jpg/GDP_Growth_with_Government_Consumption.jpg", as(jpg) quality(100) replace

** Imports on GDP_Growth
eststo: xthdidregress ra (Imports GDP_Growth) (Treated), group(country) cohortvar(accession_year, replace)

estat atetplot, name(Imports, replace)
graph combine Imports, title("Imports on GDP_Growth") saving("Imports_with_GDP_Growth.gph", replace)
graph export "/Users/maanitmehta/Desktop/goodstata/graphs/jpg/Imports_with_GDP_Growth.jpg", as(jpg) quality(100) replace


** Exports on GDP_Growth 
eststo: xthdidregress ra (Exports GDP_Growth) (Treated), group(country) cohortvar(accession_year, replace)

estat atetplot, name(Imports, replace)
graph combine Imports, title("Exports on GDP_Growth") saving("Exports_with_GDP_Growth.gph", replace)
graph export "/Users/maanitmehta/Desktop/goodstata/graphs/jpg/Exports_with_GDP_Growth.jpg", as(jpg) quality(100) replace

