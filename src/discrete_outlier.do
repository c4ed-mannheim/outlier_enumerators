*******************************************************************************
* Discrete Outlier

/*

discrete outlier takes a discrete (categorical) variable and for each enumerator 
(or other variable) iteratively constructs two way contigency tables (using tab2)
of all observations minus that enumerator against all observations from that 
enumerator.

P-values are calculated using Fisher's exact test. The p-values are then written
to a variable with is the name of the input variable with the prefix 'pval_'.

*/

*******************************************************************************
capture program drop discrete_outlier 

program define discrete_outlier 

//The first value after the command defines the variable.

local var `1'

//The second value after the command defines the groups, 
//for our purposes this will typically be enumerators.

local enum `2'

//Here we define a new variable which is the variable name with the prefix "pval"

gen pval_`var' = .

levelsof `enum', local(levels)

//Now we loop across the levels to calculate fisher's exact test for each level, 
//i.e. all enumerators -1 v. that 1 enumerator. 

foreach i of local levels {

gen ind = 0
replace ind = 1 if(`enum' == `i')

tab2 `var' ind, exact 

replace pval_`var' = r(p_exact) if(`enum' == `i')

drop ind 

}

end 

********************************************************************************


