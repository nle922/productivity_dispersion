//Build the data for analysis	
args VA_switch share_switch hours_switch output_switch cut psis

//Load the full dataset
use "Data/CoM_extract", clear

//rename some variables so easier to read
rename g000v revenue
rename f009 cost_materials_energy
rename ewemt wage_earners
rename d006 hours_per_wage_earner
rename e005s wages
rename e009s wages_salaries
//rename output_name log_output_Q //this needs to be defined if going to use physical output (output_switch==1)
gen capital = 1 //just going to do labor productivity. So capital just normalized to 1

//destring some variables used below
destring hours_per_wage_earner wages_salaries wages revenue cost_materials_energy wage_earners year, replace force

//clean up the hours_per_wage_earner variables
replace hours_per_wage_earner = . if year==1933 //variable is not consistent in this year
replace hours_per_wage_earner = 5.5*hours_per_wage_earner if hours_per_wage_earner<=12 //assume reporting hours per day
replace hours_per_wage_earner = . if hours_per_wage_earner>100 //measurement error

//create some derived establishment-level variables
gen manhours = (wage_earners*hours_per_wage_earner*50) // 50 adjusts for weeks of work per year 
label var manhours "Manhours derived = (wage_earners*hours_per_wage_earner*50)"
gen value_added = revenue - cost_materials_energy
label var value_added "Value added = revenue - cost_materials_energy"

//impute wages_salaries by scaling up wages_total using industry-level average of wages_salaries_total / wages_total
bysort industry_code_num: egen ratio = mean(wages_salaries / wages)
replace wages_salaries = ratio*wages if wages_salaries==.
//do HK adjustment to wages and salaries to pro-rate profits
local hk_adjustment = 1.63
replace wages_salaries = `hk_adjustment'*wages_salaries

//Calculate dispersion variables
do "Code/Build/build_dispersion_data" "`VA_switch'" "`share_switch'" "`hours_switch'" "`output_switch'" "`cut'" "`psis'"

//Generate extensive margin related variables
gen wgt_estab = 1
by establishment_ID, sort: egen firsttime = min(cond(wgt_estab == 1, year, .))
gen ENTER = year == firsttime
replace ENTER = . if year==1929
label var ENTER "Entered"

by establishment_ID: egen lasttime = max(cond(wgt_estab == 1, year, .))
gen EXIT = year == lasttime
replace EXIT = . if year==1935	
label var EXIT "Exiting"

//Declare a panel
egen establishment_ID_num = group(establishment_ID)
xtset establishment_ID_num year, delta(2)

//generate growth rates and forward values for some variables
foreach growth_var of varlist log_prod* dev_log_prod* log_revenue {
	gen f1_`growth_var' = f.`growth_var'
	local var_label: variable label `growth_var'
	label var f1_`growth_var' "(Forward) `var_label'"
	gen D_`growth_var' = f1_`growth_var'- `growth_var'
	label var D_`growth_var' "(Forward) growth rate in `var_label'" //growth rates over adjacent censuses (not same number of years)
}

keep log_* dev_* year ag* industry_code_num establishment_ID_num establishment_ID EXIT ENTER D_* f1_* revenue
save  "Data/Generated/VA`VA_switch'_share`share_switch'_`hours_switch'_output`output_switch'_cut`cut'", replace
