//Table of changes in dispersion of efficiency and productivity by industry
args file_name psi

local stats = "mean sd diff9010 diff7525 diff9505"

use "Data/Generated/`file_name'", clear //load the data

foreach letter in Q R{
	preserve
		//calculate dispersion measures by year and industry
		local collapsing_string = "(mean) mean = log_prod_`letter'_`psi' (sd) sd = log_prod_`letter'_`psi'"
		foreach percentile in 10 25 75 90 95 5{
			local collapsing_string = "`collapsing_string' (p`percentile') p`percentile' = log_prod_`letter'_`psi' "
		}
		collapse  `collapsing_string', by(year industry_code_num)

		//Calculate differences in percentiles
		gen diff9010 = p90 - p10
		gen diff7525 = p75 - p25
		gen diff9505 = p95 - p5
		
		//Reshape for outputting to tables by statistic
		keep `stats' industry_code_num year
		reshape wide `stats', i(industry_code_num) j(year)
		
		//Normalize to 1929 value by industry
		forvalues year = 1935(-2)1929{
			foreach stat in `stats'{
				replace `stat'`year' = 100*`stat'`year' / `stat'1929
			}
		}
		
		//Final preparation for output to table
		foreach stat in `stats'{
			tostring `stat'*, force replace format(%9.0f)
			replace `stat'1935 = `stat'1935 + "\\"
			export delimited industry_code_num `stat'* using "Writing/Tables/SumStats/ind_`stat'_`letter'_`psi'.tex", delimiter("&") replace novarnames 
		}
	restore
}
