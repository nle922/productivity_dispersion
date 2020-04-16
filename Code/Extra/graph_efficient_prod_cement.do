//Figure: Productivity dynamics for cement given some particular value for EOS
args psi_specific

use "Data/Generated/cement_for_analysis", replace

//Calculate actual and efficient levels of productivity
do "Code/Build/calc_efficient_prod" `psi_specific'

//calculate log first differences
tempvar baseyear
gen byte `baseyear' = 1 if year == 1929
foreach i of varlist log_prodInd_*_`psi_specific' mean_prod_Q_`psi_specific'{	
    sort `baseyear'
	gen d_`i' = `i'-`i'[1]
}

twoway (line d_log_prodInd_actual_`psi_specific' year, lwidth(thick)) (line d_log_prodInd_FB_`psi_specific' year, lwidth(thick) lpattern(dash)), xlab(1929(2)1935) ytitle("Log Change Relative to 1929") xtitle("Year") legend(order(1 "Productivity" 2  "No Misallocation Productivity") nobox region(lstyle(none))) ylabel(,angle(45))
graph export "Writing/Figures/Cement/cement_productivity_psi`psi_specific'.pdf", replace
