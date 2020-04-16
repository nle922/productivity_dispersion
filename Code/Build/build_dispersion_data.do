//Generates data for dispersion analysis
args VA_switch share_switch hours_switch output_switch cut psis

//generate logged values of these variables
foreach var_to_log in value_added revenue cost_materials_energy wage_earners manhours wages capital wages_salaries{
	destring  `var_to_log', replace force
	local var_label: variable label `var_to_log'
	gen log_`var_to_log' = log(`var_to_log')
	label variable log_`var_to_log' "Log `var_label'"
}

foreach psi of numlist `psis'{
	//calculate productivity variables
	do "Code/Build/gen_prod_vars"  "`VA_switch'" "`share_switch'" "`hours_switch'" "`output_switch'" "`psi'" "1"
		
	//trim tails of TFPR or TFPQ distributions.
	local top = 101-`cut'
	local condition = `"(p_log_prod_R>=`cut'&p_log_prod_R<=`top'&p_log_prod_Q>=`cut'&p_log_prod_Q<=`top')"'
	 
	foreach letter in Q R {
		//drop these and re-create after trimming tails
		drop dev_log_prod_`letter'_`psi' log_prod_`letter'_`psi'
		//rename to avoid conflict
		rename p_log_prod_`letter'_`psi' p_log_prod_`letter'
	}
	
	//recalculate productivity variables after trimming
	do "Code/Build/gen_prod_vars" "`VA_switch'" "`share_switch'" "`hours_switch'" "`output_switch'" "`psi'" "`condition'"
	drop p_log_prod_*
}
