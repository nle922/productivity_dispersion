//Counterfactual distributions of productivity taking into account exit.
//Derived from code by Benguria et al. (2020)
args params psi

local reps = 25 //set number of bootstrap replications
local stats = "sd p7525 p9010 p9505" //dispersion measures to calculate

//Labels for figures
local label_R = "Productivity (Deviation from Industry-Year Mean)"
local label_Q = "Efficiency (Deviation from Industry-Year Mean)"

//Regression specifications 
local spec1 = "log_revenue i.year i.ag001_fips i.industry_code_num" //Size + State and industry fixed effects
local spec2 = "i.year i.ag001_fips i.industry_code_num" //State and industry fixed effects only
local spec3 = "i.year" //Year effects only

//tempfile to hold bootstrap results
tempfile bootstrap

foreach letter in R Q{
	clear
	save `bootstrap', emptyok replace
	forvalues rep = 0(1)`reps'{
		use "Data/Generated/`params'.dta", clear //load the data
		
		//first rep is actual data and bootstrap samples after that
		if `rep'>0 {
			bsample, strata(year industry_code_num) //sample with replacement in a year + industry
		}
		//shift years
		replace year = year + 2

		//regression of growth rates of productivity variables for continuing establishments
		forvalues spec = 1/3{
			foreach type_var in log_prod_`letter'_`psi' {
				qui xi: reg D_`type_var' `spec`spec''
				predict D_`type_var'_hat`spec', xb //predict growth rates for those that exit
				gen f1_`type_var'_hat`spec' = f1_`type_var'  //fill in actual values for those non-missing
				replace f1_`type_var'_hat`spec' = `type_var' + D_`type_var'_hat`spec' if f1_`type_var'_hat`spec' == . //fill in predicted values for those missing
			}	
	
			if `rep'==0{
				//plot counterfactual density for each year.
				forvalues year = 1931(2)1935 {
					preserve
					//keep a subset for consistent plotting
					keep if year == `year'
					twoway (kdensity f1_log_prod_`letter'_`psi', lwidth(thick))  (kdensity f1_log_prod_`letter'_`psi'_hat`spec', lwidth(thick) lpattern(dash)) , ytitle("Density")  legend(order(1 "Actual" 2 "Counterfactual") nobox region(lstyle(none))) ylab(, angle(45)) xtitle("`label_`letter''")
					graph export "Writing/Figures/Extensive/predicted_prod`year'_exit_spec`spec'_`params'_`letter'_psi`psi'.pdf", replace
					restore
				}
			}		
		}
		
		//Set as predicted value to use
		rename f1_log_prod_`letter'_`psi'_hat1 f1_log_prod_`letter'_`psi'_hat
		//calculate some statistics of counterfactual distribution
		do "Code/Build/process_extensive_data" `letter' `psi' "`stats'" `rep' "f1_"
		append using `bootstrap'
		save `bootstrap', replace
	}
	
	//prepare data for outputting to table that can be read into TeX
	use `bootstrap', replace
	do "Code/Build/output_extensive_table" "`stats'"
	export delimited using "Writing/Tables/Extensive/Exit_boot_`params'_`letter'_psi`psi'.tex", delimiter("&") replace novarnames 
}
