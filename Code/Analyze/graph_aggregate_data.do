//Figure: Graph aggregate productivity dynamics for US during Great Depression
use "Data/productivity_cole_ohanian", clear

keep if year<=1935 & year>=1929
label var tfp "Total Factor Productivity"
label var labor_productivity "Labor Productivity"

sort year
twoway (line tfp year, lpattern(solid) lwidth(thick)) (line labor_productivity year, lpattern(dash) lwidth(thick)), legend(nobox region(lstyle(none))) xlabel(1929(2)1935) ylabel(,angle(45)) xtitle("Year") ytitle("Value Relative to 1929")  
graph export "Writing/Figures/Aggregate/productivity_behavior.pdf", replace
