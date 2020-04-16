//process data for extensive margin analysis
args letter psi stats rep prefix

foreach ext in "" "_hat" {
	local collapsing_string = "(mean) mean`ext' = `prefix'log_prod_`letter'_`psi'`ext' (sd) sd`ext' = `prefix'log_prod_`letter'_`psi'`ext'"
	foreach percentile in 10 25 75 90 95 5 { 
		local collapsing_string = "`collapsing_string' (p`percentile') p`percentile'`ext' = `prefix'log_prod_`letter'_`psi'`ext'"
	}
	preserve 
		collapse `collapsing_string', by(year)
		gen p7525`ext' = p75`ext' - p25`ext'
		gen p9010`ext' = p90`ext' - p10`ext'
		gen p9505`ext' = p95`ext' - p5`ext'
		gen rep = `rep'
		tempfile data`ext'
		save `data`ext''
	restore
}
use `data_hat', replace
qui merge 1:1 year using `data'
	foreach diff_range in `stats'{
	gen diff`diff_range' = round(`diff_range'_hat - `diff_range', .01)
}	
keep diff* `stats' year rep
