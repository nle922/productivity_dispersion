//Generate data for cement analysis
args psis

//if VA_switch = 0, then use quantity and include materials share. should really use labor share weighted as well in this case. =1, then use real value added deflated by firm-level price
local VA_switch = 0
//if share_switch==0, then weight labor input by labor share. if =1, then no weighting just raw output per unit of labor input
local share_switch = 0
//if hours_switch==1 then use hours per wage earner, if =0, then use just total wage earners, if =2, then use wages+salaries
local hours_switch = "wages" //"wages_salaries"
//if want to use model implied values
local output_switch = 0
//trim tails and then recalculate labor shares and the like
local cut = 0

//Load the cement data
use "Data/cement_all", clear

//rename some variables 
rename g000v revenue
rename f009 cost_materials_energy
rename ewemt wage_earners
rename d006 hours_per_wage_earner
rename e005s wages
rename z_capacity capital
rename e004s salaries
rename gp_q_pc real_quantity //real quantity is physical output of portland cement

destring year salaries real_quantity hours_per_wage_earner wage_earners wages revenue cost_materials_energy, replace force

//generate total wages + salaries which is missing for some reason
gen wages_salaries = wages + salaries 
//now impute missing values by scaling up total wages based on industry average
egen ratio = mean(wages_salaries / wages)
replace wages_salaries = ratio*wages if wages_salaries==.
//do HK constant adjustment
local hk_adjustment = 1.63
replace wages_salaries = `hk_adjustment'*wages

//clean up the hours_per_wage_earner variables
replace hours_per_wage_earner= . if year==1933
replace hours_per_wage_earner = 5*hours_per_wage_earner if hours_per_wage_earner<=12
replace hours_per_wage_earner = . if hours_per_wage_earner>100

//create some derived establishment-level variables
gen manhours = (wage_earners*hours_per_wage_earner*50) //adjust for number of work weeks (50) 
label var manhours "Manhours derived = (wage_earners*hours_per_wage_earner*50/12)"
gen value_added = revenue - cost_materials_energy
label var value_added "Value added = revenue - cost_materials_energy"
gen hourly_wage = wages / manhours
label var hourly_wage "Wage = wages / manhours"
gen log_output_Q = log(real_quantity)
gen industry_code_num = 1001

do "Code/Build/build_dispersion_data" "`VA_switch'" "`share_switch'" "`hours_switch'" "`output_switch'" `cut' "`psis'" 

//Drop unnecessary variables
numlist "`psis'"
local psi_list `r(numlist)'
local psi: word 1 of `psi_list'
foreach letter in R Q{
	rename log_prod_`letter'_`psi' log_prod_`letter'
	label var log_prod_`letter' "TFP`letter'"
	drop log_prod_`letter'_* dev_log_prod_`letter'_*
}

save "Data/Generated/cement_for_analysis", replace
