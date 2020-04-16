//Figures from banking data

//set baseyear for normalizing values
local baseyear = 1929

//Figure: dispersion in and levels of leverage
use "Data/state_all_bank_data", clear
drop if assets_state==.

//generate various aggregate statistics on capital, assets, and leverage
foreach level_of_agg in all state {
	foreach type_of_var in total_capital assets {
		bysort year: egen agg_`type_of_var'_`level_of_agg' = total(`type_of_var'_`level_of_agg')
	}
	gen leverage_`level_of_agg' = assets_`level_of_agg'/total_capital_`level_of_agg'
	
	foreach stat_to_calc in sd mean iqr {
		bysort year: egen `stat_to_calc'_leverage_`level_of_agg' = `stat_to_calc'(leverage_`level_of_agg')
	}
}

//collapse down to year
collapse (firstnm) *_all *_state, by(year)

//create index values relative to 1929 value
gen baseyear = 1 if year == `baseyear'
foreach i of varlist *_all *_state{
	sort baseyear
	gen scale_`i' = 100*`i'/`i'[1]
}

label var year "Year"
label var scale_sd_leverage_all "Standard Deviation of Leverage"
label var scale_leverage_all "Leverage"
label var scale_agg_total_capital_all "Capital"

sort year
twoway (line scale_leverage_all year if year>=1929 & year<=1935, lwidth(thick) lpattern(dash)) (line scale_agg_total_capital_all year if year>=1929 & year<=1935,  lwidth(thick) lpattern(dash_dot)) (line scale_sd_leverage_all year if year>=1929 & year<=1935, lwidth(thick)), xlab(1929(2)1935) ytitle("Value Relative to `baseyear'") ylabel(,angle(45)) legend(nobox region(lstyle(none)))
graph export "Writing/Figures/Aggregate/std_dev_leverage_all_banks.pdf", replace

//Figure: dispersion in borrowing rates using data from Bodenhorn
use "Data/bodenhorn_data", clear

//create "percentiles" of rates
gquantiles p_rates = rates, xtile nquantiles(50) by(year)
//trim tails
drop if p_rates<5 | p_rates>46

collapse (sd) sd_rates = rates (iqr) iqr_rates = rates (mean) mean_rates = rates, by(year)

//calculate various statistics summarizing rates across states and then create index value relative to 1929 value
gen baseyear = 1 if year==`baseyear'
sort baseyear
foreach stat_to_calc in sd iqr mean{
	gen scale_`stat_to_calc'_rates = 100*`stat_to_calc'_rates / `stat_to_calc'_rates[1]
}

label var scale_mean_rates "Mean of Lending Rates"
label var scale_iqr_rates "IQR of Lending Rates"
label var scale_sd_rates "Standard Deviation of Lending Rates"
label var year "Year"

sort year
twoway (line scale_mean_rates year if year>=1929 & year<=1935, lwidth(thick) lpattern(dot)) (line scale_iqr_rates year if year>=1929 & year<=1935, lwidth(thick) lpattern(dash)) (line scale_sd_rates year if year>=1929 & year<=1935, lwidth(thick)), ylabel(,angle(45)) legend(nobox region(lstyle(none))) xlab(1929(2)1935) ytitle("Value Relative to `baseyear'")
graph export "Writing/Figures/Aggregate/std_dev_lending_rates_bodenhorn.pdf", replace
