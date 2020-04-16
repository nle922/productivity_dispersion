//Plot changes in dispersion of efficiency and productivity
args file_name psi

use "Data/Generated/`file_name'", clear //load the data

foreach letter in Q R{
	preserve
		//calculate dispersion measures year by year pooling across industries
		local collapsing_string = "(sd) sd = dev_log_prod_`letter'_`psi'"
		foreach percentile in 10 25 75 90 95 5{
			local collapsing_string = "`collapsing_string' (p`percentile') p`percentile' = dev_log_prod_`letter'_`psi' "
		}
		collapse  `collapsing_string', by(year)

		//Calculate differences in percentiles
		gen diff9010 = p90 - p10
		gen diff7525 = p75 - p25
		gen diff9505 = p95 - p5
				
		//normalize values relative to 1929 values
		tempvar baseyear
		gen `baseyear' = 1 if year == 1929
		foreach i of varlist sd diff9505 diff9010 diff7525{
			sort `baseyear'
			gen d_`i' = 100*`i'/`i'[1]
		}
		
		label var d_sd "Standard Deviation"
		label var d_diff9010 "d9010"
		label var d_diff7525 "d7525"
		label var d_diff9505 "d9505"
		
		twoway (line d_sd year, lwidth(thick)) (line d_diff9505 year, lwidth(thick) lpattern(dash)) (line d_diff9010 year, lwidth(thick) lpattern(dash))  (line d_diff7525 year, lwidth(thick) lpattern(dot)), xlab(1929(2)1935) ylab(90(5)120, angle(45))  ytitle("Value Relative to 1929") legend(nobox region(lstyle(none))) xtitle("Year")
		graph export "Writing/Figures/Intensive/disp_`file_name'_psi`psi'_`letter'.pdf", replace
	restore
}
