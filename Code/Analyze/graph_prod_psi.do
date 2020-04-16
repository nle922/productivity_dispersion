//calculate changes in productivity due to changes in misallocation
args psis file_name weights //weights: variable for weighting industries in calculating aggregate changes.

use "Data/Generated/`file_name'", replace //load the data

do "Code/Build/calc_efficient_prod" "`psis'" //calculate industry-level productivity

//set default value for weights
if "`weights'"==""{
	tempvar weights
	gen `weights' = 1
	local weights = "`weights'"
}
	
//calculate fraction of percentage change in productivity due to changes in misallocation
tempvar baseyear
gen byte `baseyear' = 1 if year == 1929
foreach psi of numlist `psis' {
	sort `baseyear'
	foreach i of varlist log_prodInd_FB_`psi' log_prodInd_actual_`psi' {	
		gen d_`i' = `i'-`i'[1]
	}
	gen frac_misalloc`psi' = 1-(d_log_prodInd_FB_`psi'/d_log_prodInd_actual_`psi')
}

//collapse to year level weighting industries by `weights'
replace `weights' = 0 if `weights'<0
collapse (mean) frac_misalloc* [fw=`weights'], by(year)

//Figure: Fraction explained of productivity change by misallocation as function of psi using all the industries
gen id = _n
reshape long frac_misalloc, i(id) j(psi)
drop if year==1929 
sort psi year
twoway (line frac_misalloc psi if year==1931, lwidth(thick)) (line frac_misalloc psi if year==1933, lwidth(thick) lpattern(dash)) (line frac_misalloc psi if year==1935, lwidth(thick) lpattern(dash_dot)), ytitle("Fraction Explained by Misallocation") xtitle("Elasticity of Substitution") legend(order(1 "1931" 2 "1933" 3 "1935") nobox region(lstyle(none))) ylabel(,angle(45)) 
graph export "Writing/Figures/Intensive/frac_misalloc_`file_name'.pdf", replace
