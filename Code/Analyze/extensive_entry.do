//Counterfactual productivity distribution removing entry penalty. 
//Originally derived from code for earnings inequality project.
args params psi

local reps = 25 //set number of bootstrap replications
local stats = "sd p7525 p9010 p9505" //dispersion measures to calculate

//Labels for figures
local label_R = "Productivity"
local label_Q = "Efficiency"

//set of additional controls beyond industry, year, and state fixed effects. 
local controls log_revenue

//Tempfile to hold the bootstrap results
tempfile bootstrap

foreach letter in R Q{
	clear
	save `bootstrap', emptyok replace
	forvalues rep = 0(1)`reps'{
		use "Data/Generated/`params'.dta", clear //load the data	
		//First rep is actual data and the rest are bootstrap samples.
		if `rep'>0 {
			bsample, strata(year industry_code_num) //sample within a year + industry
		}
		
		gen log_prod_`letter'_`psi'_hat = .
		foreach year in 1931 1933 1935 {
			//run regression and take out entry effect
			qui: reghdfe log_prod_`letter'_`psi' ENTER `controls' if year==`year', absorb(industry_code_num ag001_fips)
			replace log_prod_`letter'_`psi'_hat = log_prod_`letter'_`psi' - _b[ENTER] * ENTER if year==`year'
			if `rep'==0{
				//plot actual and counterfactual distribut ions
				twoway (kdensity log_prod_`letter'_`psi' if year==`year', lwidth(thick)) (kdensity log_prod_`letter'_`psi'_hat if year==`year', lpattern(dash) lwidth(thick)), legend(order(1 "Actual" 2 "Counterfactual") nobox region(lstyle(none))) ylab(, angle(45)) ytitle("Density") xtitle("`label_`letter''")
				graph export "Writing/Figures/Extensive/predicted_prod`year'_enter_`params'_`letter'_psi`psi'.pdf", replace
			}
		}
		
		//calculate some statistics of counterfactual distribution
		do "Code/Build/process_extensive_data" `letter' `psi' "`stats'" `rep'
		append using `bootstrap'
		save `bootstrap', replace
	}

	//prepare data for outputting to table that can be read into TeX
	use `bootstrap', replace
	do "Code/Build/output_extensive_table" "`stats'"
	export delimited using "Writing/Tables/Extensive/Entry_boot_`params'_`letter'_psi`psi'.tex", delimiter("&") replace novarnames 
}
