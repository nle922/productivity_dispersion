//This is wrapper script that generates all figures and tables for appendix to Ziebarth (2020)

//psis: range of values for EOS 
local psis = "2(2)6"

//main_psi: Baseline value of EOS
local main_psi = 4
//main_cut: Baseline percentile of tails to trim
local main_cut = 2
//VA_switch: if ==1, then value added formulation. if = 0, then gross output.
local VA_switch = 1
//share_switch: if ==0, then weight labor input by labor share. if ==1, then no weighting just raw output per unit of labor input
local share_switch = 0
//hours_switch: name of variable to use as labor input (manhours, wage_earners, wages_salaries, or wages)
local hours_switch = "wages" 
//output_switch: if ==1, then use physical output. if ==0, then output backed out from CES demand structure.
local output_switch = 0

//Define parameters for main results
local params = "VA`VA_switch'_share`share_switch'_`hours_switch'_output`output_switch'_cut`main_cut'"

//Create cement datasets
do "Code/Build/build_cement" "`psis'"

//Dispersion measures over time for cement
do "Code/Analyze/graph_dispersion_cement"

//Entry results
do "Code/Analyze/extensive_entry" "`params'" `main_psi' 
