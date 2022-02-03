********************************************************************************
*Outlier Counts
********************************************************************************

/* This is a simply wrapper for discrete_outlier. It takes a list of variables 
as the first argument. The second argument is enumerator variable, i.e. the
second argument in discrete_outlier. 

After iterating through the variables in the list, the program counts the number
of p-values <= 0.05 for each enumerator. 

For example, you might run it like this:


local variables eduattain employyear employmt relationship occupation 

outlier_counts `variables', enum_var(enumid)

*/ 


capture program drop outlier_counts 

program define outlier_counts  

syntax varlist, enum_var(varname)

foreach i of local varlist  {
    
	discrete_outlier `i' `enum_var'
	
}


*Keeping only variables selected above (plus enumerator variable) and one row per enumerator

gen x = 1

bysort `enum_var': gen running_count = sum(x) 
drop if running_count > 1

keep `enum_var' pval*


*Counting p-values that are significant for each enumerator

gen sig_count = 0

unab pvalues : pval_*

display "`pvalues'"

foreach i of local pvalues {
    
	replace sig_count = (sig_count + 1) if(`i' <= 0.05)
	
}

sort sig_count

end 