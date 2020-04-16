//Plot misallocation measures for cement industry
args psi //value of psi to use

use "Data/Generated/cement_for_analysis", replace

gen corr_R_Q = .

levelsof year, local(years)
foreach i of local years{
	//calculate corr. between TFPR & TFPQ year by year pooling industries
	capture corr dev_log_prod_R_`psi' dev_log_prod_Q_`psi' if year==`i' 
	capture replace corr_R_Q = r(rho) if year==`i' 
}

//calculate dispersion measures year by year pooling across industry
collapse (sd) std_log_prod_R = dev_log_prod_R_`psi' std_log_prod_Q = dev_log_prod_Q_`psi' (first) corr_R_Q, by(year)

//normalize values relative to 1929 values
tempvar baseyear
gen `baseyear' = 1 if year == 1929
foreach i of varlist corr_R_Q std_log*{
	sort `baseyear'
	gen d_`i' = 100*`i'/`i'[1]
}

//Label and plot variables
label var d_std_log_prod_R "Std. Dev. of Productivity"
label var d_std_log_prod_Q "Std. Dev. of Efficiency"
label var d_corr_R_Q "Correlation of Productivity and Efficiency"
twoway (line d_std_log_prod_R year, lwidth(thick)) (line d_std_log_prod_Q year, lwidth(thick) lpattern(dash))  (line d_corr_R_Q year, lwidth(thick) lpattern(dot)), xlab(1929(2)1935) ylab(, angle(45))  ytitle("Value Relative to 1929") legend(nobox region(lstyle(none))) xtitle("Year")
graph export "Writing/Figures/Cement/mis_cement_for_analysis_psi`psi'.pdf", replace
