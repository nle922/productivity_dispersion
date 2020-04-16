Replication Readme for Ziebarth (2020)

Code Directory

Stata

runme - Execute this file to generate all the figures and tables in paper. Need to change working directory to top level directory.
runme_appendix - Execute this file to generate all the figures and tables in paper's appendix. This codes assumes you ran runme.do first.

./Analyze

1. extensive_entry - Calculates counterfactual distribution of efficiency removing any entry differences.
2. extensive_exit - Calculates counterfactual distribution of efficiency removing any exit differences.
3. graph_aggregate_data - Generates figures of aggregate productivity for US.
4. graph_dispersion - Generates figures of changes in dispersion of efficiency and productivity over time.
5. graph_dispersion_industry - Generates tables of dispersion of efficiency and productivity over time by industry.
6. graph_dispersion_cement - Generates figures of dispersion of efficiency and productivity distributions for cement.
7. graph_sigmaR_psi- Calculate changes in productivity due to changes in misallocation for range of values of EOS \psi.
8. graph_sigmaR_trim - Graphs dynamics of dispersion in productivity and misallocation productivity losses for range of values of % to trim.
9. regs_extensive - Regressions predicting exit using efficiency and productivity.

./Build

1. build_cement - Build cement industry data.
2. build_COM - Builds the COM data.
3. build_dispersion_data - Generates all the variable used in the dispersion analysis for some dataset.
4. calc_efficient_prod - Calculates the efficient and actual level of productivity for a given range of \psis.
5. gen_prod_vars - Generates the productivity variables, specifically. Takes a number of args to define how productivity is calculated.
6. install_dependencies_subfolders - Installs necessary Stata packages and creates subdirectories for figures and tables.
7. output_extensive_table - Formats results for extensive margin analysis for outputting into TeX table.
8. process_extensive_data - Processes data from extensive margin analysis.

./Extra

1. graph_banks_data - Generates figures using state-level banking data.
2. graph_efficient_prod_cement - Calculate losses in productivity due to misallocation for cement without log-normal approximation.
3. graph_misalloc_measures_cement - Generates figures of misallocation measures for cement over time.
4. graph_model_results - Generates figures from the results of the model simulations.
5. graph_US_canada - Generates figures of aggregate outcomes for US and Canada.
6. regs_rate_leverage_RevProd - Runs regressions of TFPR on state-level lending rates.

	./Extra/Model

	1. calc_steadystate_noextensive - This calculates the (closed form) steady state of the model with no extensive margin.
	2. steadystate_eqns_extensive - This calculates deviations of steady state equations given a guess of the solution (as well as values for N and phi).
	Returns the inner product of the deviations vector.
	3. N_run_extensive - Solves the extensive margin model for a range of values for capital N. This numerically attempts to set the deviations of the steady state equations to 0.
	4. psi_run_extensive - Solves the extensive margin model for a range of values for elasticity of substitution (psi). This numerically attempts to set the deviations of the steady state equations to 0.
	5. psi_run_noextensive - Solves the no extensive margin model for a range of values for elasticity of substitution (psi). This numerically attempts to set the deviations of the steady state equations to 0.

	All of these write the results to the Model sub-directory in the Data folder.

Stata Dependencies: estout, gtools.

Data

1. cement_all - These are data for cement industry. They have some additional variables not found in CoM_extract.
2. CoM_extract.dta - Establishment-level data from CoM. See Vickers and Ziebarth (2017) for more information on this data source.
3. productivity_cole_ohanian.dta - Data on productivity are from Cole and Ohanian (1999).

	./Extra

	1. bodenhorn_data - Data on state-level lending rates graciously provided by Howard Bodenhorn.
	2. state_all_bank_data - Data from Comptroller of the Currency reports various years.
	3. us_v_canada.dta - Aggregate data for comparison between US and Canada during the Great Depression. These are from Table 1 of Amaral and MacGee (2002).

	./Generated
	
	Build do files save datasets in this folder.
