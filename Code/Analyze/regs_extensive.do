//Predict exit based on productivity, efficiency, and size

//params - VA`VA_switch'_share`share_switch'_`hours_switch'_output`output_switch'_cut`cut'
//psi - value of psi to use in calculating efficiency
args params psi

use "Data/Generated/`params'.dta", clear //load the data

//varable labels
label var log_prod_Q_`psi' "Efficiency"
label var log_prod_R_`psi' "Productivity"
label var log_revenue "Revenue"

gen sample_to_use = . //mark consistent sample to use

foreach year in 1929 1931 1933 {
	eststo clear
	eststo: qui reghdfe EXIT log_prod_R_`psi' if year == `year', absorb( industry_code_num) vce(robust)
	replace sample_to_use = e(sample)==1
	sum EXIT if year == `year' & e(sample)==1
	qui sum log_prod_R_`psi' if year == `year' & e(sample)==1, detail
	di "IQR of Productivity in `year'= "
	di `r(p75)' - `r(p25)' 	//IQR of Productivity
	eststo: qui reghdfe EXIT log_prod_Q_`psi' if year == `year' & sample_to_use==1, absorb( industry_code_num) vce(robust)
	qui sum log_prod_Q_`psi' if year == `year' & e(sample)==1, detail
	di "IQR of Efficiency in `year'= "
	di `r(p75)' - `r(p25)' 	//IQR of Efficiency
	eststo: qui reghdfe EXIT log_revenue if year == `year' & sample_to_use==1, absorb( industry_code_num) vce(robust)
	eststo: qui reghdfe EXIT log_prod_R_`psi' log_prod_Q_`psi' if year == `year' & sample_to_use==1, absorb( industry_code_num) vce(robust)
	eststo: qui reghdfe EXIT log_prod_R_`psi' log_prod_Q_`psi' log_revenue if year == `year' & sample_to_use==1, absorb( industry_code_num) vce(robust)
	esttab using "Writing/Tables/Extensive/regs_extensive_`year'", keep(log_prod_Q_`psi' log_prod_R_`psi' log_revenue) order(log_prod_R_`psi' log_prod_Q_`psi' log_revenue) nomtitles nonotes se label replace tex b(%12.2f) star(* 0.10 ** 0.05 *** 0.01) mgroups("Exiting", prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat())
}
