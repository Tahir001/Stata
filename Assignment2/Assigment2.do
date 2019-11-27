* Assignment 2 Homework
* Section 2 | Computer Based Questions
* Eco375
* Tahir Muhammad
* 1002537613

* Clear all previously stored data
clear all

* Set working directory
cd "D:\Eco375\Assignment2"

* Start capute log 
log using logA2, text replace

/*** Question 1 ***/

* Load in the corresponding data file
use "ANES2016.dta"

* Lets take a look at the data 
describe 
  
** PART A **

regress loginc female black age agesq educ1 educ2 educ3 educ4 

** PART B **

* Regression model with education of a highschool dropout to be base case 
regress loginc female black age agesq educ0 educ2 educ3 educ4

** PART C ** 

* Done by the calculations of the beta
* Using the regression model here for convience 
regress loginc female black age agesq educ1 educ2 educ3 educ4

/*** Question 2 ***/

* Clear all previously stored data
clear all

*Load in the corresponding data file
use "PWT_data.dta"

* Lets take a look at the data 
describe 

** PART A **

* Create a new column as the ratio of GDP in 1995 over GDP in 1975
generate _ratio_ = gdp1995/gdp1975  

* Create a new column for the log/ln of GDP in 1975 
generate ln_gdp_1975 = ln(gdp1975)

** Create a new column for the log of GDP in 1995 over GDP in 1975
generate ln_ratio = ln(_ratio_)

regress ln_ratio ln_gdp_1975

** PART B **

regress ln_ratio ln_gdp_1975 hci1975

** PART C **

regress ln_ratio ln_gdp_1975 gcf1975 hci1975

test hci1975 gcf1975

/*** Question 3 ***/
	
* Clear all previously stored data
clear all

** PART A **

* Allowing the values of random variables to be saved
set seed 1997

* Making the monte carlo model 
capture program drop Monte_Carlo_Model 
program Monte_Carlo_Model, rclass

	* Clear data
	drop _all

	* Generating random data with the given distributions
	set obs 100
	
	* We take the square root of the variance to get the standard deviation
	generate U = rnormal(0,sqrt(5))
	generate X1 = runiform(0,1)
	
	* Generate the model with the given parameters
	generate Y = -10 + 5*X1 + U 
	
	* Regressing Y onto X1
	reg Y X1
	
	* testing if the beta 1 is equal to 5
	test _b[X1] = 5
	
	* Capturing the p value into into p 
	return scalar p = r(p)
end 

* runs the monte carolo model 1000 times and stores the p value each time
simulate "Monte_Carlo_Model" p = r(p), reps(1000)

* Provide a detailed summary for Model Number 1
summarize p, detail

summarize p if p < 0.05

** PART B I.**
	
* Clear all previously stored data
clear all

* Allowing random variables to be recorded
set seed 1998

* Making the monte carlo model number 2
capture program drop Monte_Carlo_Model_Number2 
program Monte_Carlo_Model_Number2, rclass

	* Clear data
	drop _all

	* Generating random data with the given distributions
	set obs 100
	
	* We take the square root of the variance to get the standard deviation
	generate U = rnormal(0,sqrt(5))
	generate X1 = runiform(0,1)
	
	* Generate the model with the given parameters
	generate Y = -10 + 5*X1 + U 
	
	* Regressing Y onto X1
	reg Y X1
	
	* testing if the beta 1 is equal to 4.5
	test _b[X1] = 4.5
	
	* Capturing the p value into into p 
	return scalar p = r(p)
end 

* runs the monte carolo model 1000 times and stores the p value each time
simulate "Monte_Carlo_Model_Number2" p = r(p), reps(1000)

* Provide a detailed summary for Model Number 2
summarize p, detail

summarize p if p < 0.05

* PART B II.*
	
* Clear all previously stored data
clear all

* Allowing random variables to be recorded
set seed 1999

* Making the monte carlo model number 3
capture program drop Monte_Carlo_Model_Number3 
program Monte_Carlo_Model_Number3, rclass

	* Clear data
	drop _all

	* Generating random data with the given distributions
	set obs 100
	
	generate U = rnormal(0,sqrt(5))
	generate X1 = runiform(0,1)
	
	* Generate the model with the given parameters
	generate Y = -10 + 5*X1 + U 
	
	* Regressing Y onto X1
	reg Y X1
	
	* testing if the beta1 is equal to 0
	test _b[X1] = 0
	* Capturing the p value into into p 
	return scalar p = r(p)
end 

* runs the monte carolo model 1000 times and stores the p value
simulate "Monte_Carlo_Model_Number3" p = r(p), reps(1000)

* Provide a detailed summary for Model Number 3
summarize p, detail

summarize p if p < 0.05

* Close the log file
log close 

