//This is wrapper script that generates all figures and tables for Ziebarth (2020)

//main_psi: Baseline value of EOS
local main_psi = 4
//psis: range of values for EOS 
local psis = "2(2)6"
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
//cuts: Range of percentiles of tails to trim 
local cuts = "2(2)6"

//Install dependencies and create necessary subfolders
do "Code/Build/install_dependencies_subfolders"

//Creates datasets as a function of percentile to cut
foreach cut of numlist `cuts'{
 	qui do "Code/Build/build_COM" "`VA_switch'" "`share_switch'" "`hours_switch'" "`output_switch'" "`cut'" "`psis'"
}

//Dynamics of aggregate U.S. and Canadian economies
do "Code/Analyze/graph_aggregate_data"

//Define parameters for main results
local params = "VA`VA_switch'_share`share_switch'_`hours_switch'_output`output_switch'_cut`main_cut'"

//Dynamics of dispersion measures of efficiency and productivity
do "Code/Analyze/graph_dispersion" "`params'" `main_psi'

//Changes in dispersion by industry
do "Code/Analyze/graph_dispersion_industry" "`params'" `main_psi'

//Dynamics of sigma_R and productivity losses due to sigma_R as function of psi
do "Code/Analyze/graph_sigmaR_psi" "`psis'" "`params'"

//Extensive margin analysis
do "Code/Analyze/regs_extensive" "`params'" `main_psi'
do "Code/Analyze/extensive_exit" "`params'" `main_psi'

//Wages as labor input
local hours_switch = "wage_earners"
qui do "Code/Build/build_COM" "`VA_switch'" "`share_switch'" "`hours_switch'" "`output_switch'" "`main_cut'" "`main_psi'"
do "Code/Analyze/graph_dispersion" "VA`VA_switch'_share`share_switch'_`hours_switch'_output`output_switch'_cut`main_cut'" `main_psi'  

//Wages + (imputed) salaries as labor input
local hours_switch = "wages_salaries"
qui do "Code/Build/build_COM" "`VA_switch'" "`share_switch'" "`hours_switch'" "`output_switch'" "`main_cut'" "`main_psi'"
do "Code/Analyze/graph_dispersion" "VA`VA_switch'_share`share_switch'_`hours_switch'_output`output_switch'_cut`main_cut'" `main_psi'  

//Hours as labor input
local hours_switch = "manhours"
qui do "Code/Build/build_COM" "`VA_switch'" "`share_switch'" "`hours_switch'" "`output_switch'" "`main_cut'" "`main_psi'"
do "Code/Analyze/graph_dispersion" "VA`VA_switch'_share`share_switch'_`hours_switch'_output`output_switch'_cut`main_cut'" `main_psi'  
