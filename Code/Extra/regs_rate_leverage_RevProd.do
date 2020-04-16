//this does some regressions with the banking data

//cut - dataset to use based on % trimmed, psi - EOS to use in calculating TFPR
args params psi

//Options for esttab output
local hline = "\specialrule{1.0pt}{0pt}{3pt}"
local midline = "\specialrule{0.25pt}{3pt}{3pt}"
local midnoline = "\specialrule{0.0pt}{3pt}{3pt}"
local posthead = "`midline'"
local postfoot = "\specialrule{1.0pt}{3pt}{3pt} \end{tabular}}"
local esttab_opts = `"prefoot("`midline'") postfoot("`postfoot'") posthead("`posthead'") star(* 0.10 ** 0.05 *** 0.01) nonumbers nomtitles nonotes b(%12.2f) se label replace tex"'
local indicate_opts = `"indicate("State Fixed Effects = _Iag001_*")"' // "State x Industry = _Iag0Xind_")"'

use "Data/Generated/`params'", replace
do "Code/Stata/Build/trans_State_StateAbbrev" ag001 state

//merge in the lending rate data
merge m:1 state year using "Data/bodenhorn_data", keep(3) nogen
label var dev_log_hourly_wage "Log Labor Cost (Deviation)"
label var rates "State-level Lending Rate"

//list of specifications to run
local specs  = `""" "dev_log_wage""' // "i.ag001*i.industry_code_num""'

eststo clear
foreach spec in `specs' {
	//run the regressions
	eststo: reg dev_log_prod_R_`psi' rates `spec' i.year, robust //cluster(state) fe
}

//output the table
local num_cols = ${eststo_counter} + 1
local prehead = "{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{*{`num_cols'}{c}} `hline' & \multicolumn{${eststo_counter}}{c}{Log Revenue Productivity (Deviation)} \\"
esttab using "Tables/TFPR_rates_`params'_`psi'.tex", prehead(`prehead') keep(rates dev_log_hourly_wage) order(rates dev_log_hourly_wage) `esttab_opts' //`indicate_opts'
