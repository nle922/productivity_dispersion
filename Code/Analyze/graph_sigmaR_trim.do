//Plot dynamics of sigmaR and productivity losses over time
args cuts psi params

//list of possible patterns. Note problem if list of stats_to_calc is longer than this list
local list_patterns "solid longdash longdash_dot shortdash shortdash_dot dash dot"
local counter = 1
foreach cut of numlist `cuts' {	
	local pattern_`cut' = "`: word `counter' of `list_patterns''"
	local ++counter
}

tempfile stash_data_here
local first = 1
foreach cut of numlist `cuts'{
	use "Data/Generated/`params'_cut`cut'", clear
	
	//collapse down to year level
	collapse (sd) dev_log_prod_*_`psi', by(year) 
	
	gen baseyear = 1 if year==1929
	sort baseyear
	//(log) productivity losses due to changes in \sigma_R
	gen prod_`cut' = (`psi'-1)/2*(dev_log_prod_Q_`psi'^2-dev_log_prod_Q_`psi'[1]^2)-`psi'/2* (dev_log_prod_R_`psi'^2-dev_log_prod_R_`psi'[1]^2)
	label var prod_`cut' "`cut'% Trimmed"
	
	if `first'==0{
		merge 1:1 year using  "`stash_data_here'", nogen
	}
	local first = 0
	save "`stash_data_here'", replace
	local string_to_plot = "`string_to_plot' (line prod_`cut' year, lwidth(thick) lpattern(`pattern_`cut''))"
}

//Figure: Effects due to changes in dispersion alone
twoway `string_to_plot', xlab(1929(2)1935) ylab(, angle(45)) ytitle("Log Points Relative to 1929") xtitle("Year") legend(nobox region(lstyle(none)))
graph export "Writing/Figures/Intensive/prod_`params'_psi`psi'_trim.pdf", replace
