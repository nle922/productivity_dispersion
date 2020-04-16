//Calculate efficient and actual industry-level productivity as well as straight mean of log TFPQ
args psis //numlist of values for psi

//calculate FB and actual level of productivity as a function of psi
foreach psi of numlist `psis' {
	gen log_prodInd_FB_`psi' = exp((`psi'-1)*log_prod_Q_`psi') //FB industry productivity
	gen log_prodInd_actual_`psi' = exp((`psi'-1)*(log_prod_Q_`psi'-dev_log_prod_R_`psi')) //Actual industry productivity
	gen mean_prod_Q_`psi' = log_prod_Q_`psi'
}

//Calculate means at the industry-year level
collapse (mean) log_prodInd_FB_* log_prodInd_actual_* mean_prod_Q_*, by(industry_code_num year)

//Rescale by 1/(\psi-1) and then will just need to aggregate across industries using VA shares
foreach psi of numlist `psis' {
	foreach var_to_scale in log_prodInd_FB_`psi' log_prodInd_actual_`psi'{
		replace `var_to_scale' = (1/(`psi'-1))*log(`var_to_scale')
	}
}
