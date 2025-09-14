** Installing Packages **
ssc install xt
ssc install asdoc // for exporting output on word doc // 

* Importing clean data from local host into Stata *

import delimited "/Users/niteshkumar/Documents/Fall 23 New School/Summer ex 2025/Ecology, Distribution, Growth /data/master_reworked.csv", encoding(ISO-8859-1)


* Preparing the variables * 

* Step 1 : dropped varibales no longer included in the study*
drop carbonfootprint
drop toppercentileincomeshare
drop economiesbypercapitagniin2012

* Step 2 : renamed and destringed the variables for quantitative analysis

destring gdppercapita, generate(gdp_percap) ignore("NA") 
destring urbanpopulationpercent, generate(urban_index) ignore("NA")
destring ginidisposobleincome, generate(gini_disp) ignore("NA")
destring democracyindextotalcore, generate(democracy_index) ignore("NA") 

*Step 2.1* // generating log of GDP per capita 
generate loggdp_percap = log(gdp_percap)

*Step 2.2* //rename the variable for easier and standard view
rename emissionspercapita ghg_percap


* Panel data setting * 
* Step 1 : Grouping countring into IDs*
egen id = group(country)
* Step 2: Setting the Cross-section and time-series elements of the panel*
xtset id year, yearly

** Hausman test for fixed vs random test
xtreg ghg_percap gini_disp gdp_percap democracy_index urban_index, fe
estimates store fixed
xtreg ghg_percap gini_disp gdp_percap democracy_index urban_index, re
estimates store random
hausman fixed random


** Baseline Model ** // emissions and inequality //

asdoc xtreg ghg_percap gini_disp, save(./baseline3.doc) fe vce(robust)

** Incorporating Control **

asdoc xtreg ghg_percap gini_disp gdp_percap urban_index, save(./with control1.doc) fe vce(robust)
