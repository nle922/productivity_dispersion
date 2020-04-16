//Plot dynamics of productivity changes due to (1) efficiency and (2) productivity
args psis params

//list of possible patterns. Note problem if list of stats_to_calc is longer than this list
local list_patterns "solid longdash longdash_dot shortdash shortdash_dot dash dot"
local counter = 1
foreach psi of numlist `psis' {	
	local pattern_`psi' = "`: word `counter' of `list_patterns''"
	local ++counter
}

use "Data/Generated/`params'", clear //load the data

//collapse down to year level by industry
collapse (sd) dev_log_prod_*, by(year)

//initialize strings used in plotting
local string_to_plot = ""
gen baseyear = 1 if year==1929
foreach psi of numlist `psis' {
	//index values for dispersion
	sort baseyear
	//(log) productivity losses due to changes in \sigma^2_R relative to those in \sigma^2_Q
	gen prod_`psi' = (`psi'-1)/2*(dev_log_prod_Q_`psi'^2-dev_log_prod_Q_`psi'[1]^2)-`psi'/2* (dev_log_prod_R_`psi'^2-dev_log_prod_R_`psi'[1]^2)
	label var prod_`psi' "{&psi}=`psi'"
	local string_to_plot = "`string_to_plot' (line prod_`psi' year, lwidth(thick) lpattern(`pattern_`psi''))"
}

//Figure: Effects due to dispersion. 
twoway `string_to_plot', xlab(1929(2)1935) ylab(, angle(45)) ytitle("Log Points Relative to 1929") xtitle("Year") legend(nobox region(lstyle(none)))
graph export "Writing/Figures/Intensive/prod_`params'_psi.pdf", replace
