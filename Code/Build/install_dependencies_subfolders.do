//Program to create subfolders (if they don't exist) for figures and tables

//Subfolders for figures, tables, and generated data
capture mkdir "Writing"
capture mkdir "Writing/Figures"
capture mkdir "Writing/Tables"
capture mkdir "Data/Generated"

//create figures subdirectories
foreach subdir in Aggregate Cement Intensive Extensive{
	capture mkdir "Writing/Figures/`subdir'"
}

//create tables subdirectories
foreach subdir in Extensive SumStats{
	capture mkdir "Writing/Tables/`subdir'"
}

//programs installed from SSC (capture prevents accidental rewrite if user previously modified ado files)
// foreach package_to_install in estout gtools reghdfe{
// 	capture ssc install `package_to_install'
// }
