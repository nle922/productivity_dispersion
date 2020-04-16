//create graphs of model output

//insheet the simulation data for intensive margin model
//Fig: effects of capital shock
import delimited "Data/Model/sim_data.csv", clear
//from psis_run_noextensive.m

//generates first differences
sort v1 //This is N
foreach i of varlist v2 v3 v4{
	gen first_`i' = `i'[1]
	gen diff_`i' = `i'-first_`i'
}

rename diff_v2 TFP
rename diff_v3 Y
rename diff_v4 L
label var Y "Change in Output"
label var TFP "Change in Productivity"
label var L "Change in Labor"
label var v1 "Bank Capital"
twoway (line L v1, lwidth(thick)) (line Y v1, lwidth(thick) lpattern(dash)) (line TFP v1, lwidth(thick) lpattern(dash_dot)) if v1<30, graphregion(color(white))
graph export "Figures/Model/sim_results_noExtensive.pdf", replace

//insheet the simulation data for extensive margin model with marginal cost shocks 
//Figure: effects of marginal cost shock. 
import delimited "Data/Model/sim_results_extensive.csv", clear
//from phis_run_extensive.m

//generate first differences
sort v9 //v9 is omega
foreach i of varlist v2-v9{
	gen first_`i' = `i'[1]
	gen diff_`i' = `i'-first_`i'
}

rename diff_v6 mean_TFP
rename diff_v7 std_dev_TFPQ
rename diff_v4 corr_R_Q
rename diff_v8 std_dev_TFPR
label var v9 "Marginal Cost of Leverage"
label var mean_TFP "Change in Mean TFPQ"
label var std_dev_TFPQ "Change in Std. Dev. TFPQ"
label var corr_R_Q "Change in Corr."
label var std_dev_TFPR "Change in Std. Dev. TFPR"

twoway (line mean_TFP v9, lwidth(thick)) (line std_dev_TFPQ v9, lwidth(thick) lpattern(dash)) (line corr_R_Q v9, lwidth(thick) lpattern(dash_dot)) (line std_dev_TFPR v9, lwidth(thick) lpattern(dash_dot))
graph export "Figures/Model/sim_results_extensive.pdf",  replace
 
//insheet the simulation data for extensive margin model with capital cost shocks 
//Figure: Effects of capital shock in extensive margin model
import delimited "Data/Model/sim_results_extensiveCapital.csv", clear
//from N_run_extensive.m

//generate first differences
sort v9 //v9 is bank capital
foreach i of varlist v2-v9{
	gen first_`i' = `i'[1]
	gen diff_`i' = `i'-first_`i'
}

rename diff_v6 mean_TFP
rename diff_v7 std_dev_TFPQ
rename diff_v4 corr_R_Q
rename diff_v8 std_dev_TFPR
label var v9 "Bank Capital"
label var mean_TFP "Change in Mean TFPQ"
label var std_dev_TFPQ "Change in Std. Dev. TFPQ"
label var corr_R_Q "Change in Corr."
label var std_dev_TFPR "Change in Std. Dev. TFPR"

twoway (line mean_TFP v9, lwidth(thick)) (line std_dev_TFPQ v9, lwidth(thick) lpattern(dash)) (line corr_R_Q v9, lwidth(thick) lpattern(dash_dot)) (line std_dev_TFPR v9, lwidth(thick) lpattern(dash_dot))
graph export "Figures/Model/sim_results_extensive_N.pdf",  replace
 
