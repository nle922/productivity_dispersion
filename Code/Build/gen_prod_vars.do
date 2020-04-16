//Generate productivity variables
args VA_switch share_switch hours_switch output_switch psi condition

//tempvars to hold input and output variables
tempvar log_output_R log_output_Q materials_share labor_share capital_share log_inputs log_labor 

//generate industry level totals for use in calculating cost shares
foreach var_to_agg of varlist value_added revenue wages_salaries cost_materials_energy{
	tempvar ind_`var_to_agg'
	bysort industry_code_num: egen `ind_`var_to_agg'' = total(`var_to_agg')	if `condition'
}

//Switch: variable to be used for labor input
gen `log_labor' = log_`hours_switch'
 
//Switch: value added or revenue for output measure and calculate cost shares
if `VA_switch'==1 {
	gen `labor_share' = `ind_wages_salaries'/`ind_value_added'
	gen `materials_share' = 0
	gen `log_output_R' = log_value_added
}
else {
	gen `labor_share' = `ind_wages_salaries'/`ind_revenue'
	gen `materials_share' = `ind_cost_materials_energy'/`ind_revenue'
	gen `log_output_R' = log_revenue
}
gen `capital_share' = 1-`labor_share'-`materials_share'

//Switch: productivity as output/labor or TFP including all factors of production (possibly materials in gross output specification)
if `share_switch' {
	//note `materials_share' always correctly defined since = 0 when `VA_switch'==1
	gen `log_inputs' = `labor_share'*`log_labor' + `materials_share'*log_cost_materials_energy + `capital_share'*log_capital
}
else {
	gen `log_inputs' = `log_labor'
}	

//Switch: use physical output or output inferred from revenue using CES structure
if `output_switch' {
	gen `log_output_Q' = log_output_Q //this needs to be defined earlier
}
else {
	gen `log_output_Q' = (`psi'/(`psi'-1)) * `log_output_R'
}

foreach letter in Q R {
	//calculate log productivity = log output - log inputs
	gen log_prod_`letter'_`psi' = `log_output_`letter'' - `log_inputs' if `condition'
	replace log_prod_`letter'_`psi' = . if ~`condition' //set to missing for those that are trimmed
	//calculate unweighted average of log productivity `letter'
	tempvar mean_`letter'
	bysort industry_code_num year: egen `mean_`letter'' = mean(log_prod_`letter'_`psi')
	//calculate the log difference with geometric mean
	gen dev_log_prod_`letter'_`psi' = log_prod_`letter'_`psi' - `mean_`letter''
	//calculate percentiles of the distributions by year and industry 
	gquantiles p_log_prod_`letter'_`psi' = dev_log_prod_`letter'_`psi', xtile by(year) nquantiles(100)
	label var log_prod_`letter'_`psi' "TFP`letter' (psi=`psi')"
	label var dev_log_prod_`letter'_`psi' "Log Difference of TFP`letter' (psi=`psi') from Industry-Year Geometric Mean"
}
