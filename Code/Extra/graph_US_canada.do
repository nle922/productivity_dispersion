//Figures of aggregate data from US and Canada

//Comparing US and Canadian economies
use "Data/us_v_canada.dta", clear

keep if year<=1935 & year>=1929
label var canada_gnp "Canada GNP"
label var us_gnp "US GNP"
label var us_tfp "US TFP"
label var canada_tfp "Canada TFP"
label var year "Year"

sort year
twoway (line canada_gnp year, lwidth(thick) lcolor("black")) (line us_gnp year, lwidth(thick) lcolor("gs7")) (line canada_tfp year, lpattern(dash) lwidth(thick) lcolor("black")) (line us_tfp year, lpattern(dash) lwidth(thick) lcolor("gs7")), xlab(1929(2)1935) ytitle("Value Relative to 1929") ylabel(,angle(45)) legend(nobox region(lstyle(none)))
graph export "Writing/Figures/Aggregate/canada_vs_us.pdf", replace
