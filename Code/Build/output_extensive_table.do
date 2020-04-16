//Output results of extensive margin analysis
args stats

local diff_vars = ""
foreach stat in `stats'{
	bysort year: egen diff`stat'_3 = sd(diff`stat')
	rename diff`stat' diff`stat'_1
	rename `stat' diff`stat'_2
	local diff_vars = "`diff_vars' diff`stat'_"
}
keep if rep==0
reshape long `diff_vars', i(year) j(type)
qui tostring `diff_vars', replace force format("%12.2f")	

//fill in std. error estimates "below" point estimates
foreach diff_var in `diff_vars'{
	replace `diff_var' = "[" + `diff_var'+"]" if type==2
	replace `diff_var' = "(" + `diff_var'+")" if type==3
}
drop type rep
qui describe, varlist
local numitems = wordcount(r(varlist))
local lastsvar : word `numitems' of `r(varlist)'
replace `lastsvar' = `lastsvar'+"\\"
keep if year==1931 | year==1933 | year==1935
replace year = . if _n==2 | _n==3 | _n==5 | _n== 6 | _n==8 | _n== 9
