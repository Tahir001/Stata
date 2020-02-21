* Assignment 3 Homework
* Section 2 | Computer Based Questions
* Eco375
* Tahir Muhammad
* 1002537613

* Clear all previously stored data
clear all

* Set working directory
cd "D:\Eco375\Assignment 3"

* Start Log File

log using logA3, text replace

/*** Question 1 ***/

* Clear all previous Data
clear all

* Load in the corresponding data file
use "angrist_krueger_91.dta"

* Lets take a look at the data 
describe 
  
** PART A **

* Regression model given in the equation
regress LWKLYWGE EDUC 

* Regressing with all of the controlled variables
regress LWKLYWGE EDUC RACE MARRIED SMSA YR20-YR28 AGEQ AGEQS NEWENG MIDATL ENOCENT WNOCENT SOATL ESOCENT WSOCENT MT 

** PART B ** 

* No Coding is necessary here

** PART C ** 

* Regression model
reg LWKLYWGE EDUC QTR120-QTR129 QTR220-QTR229 QTR320-QTR329 RACE MARRIED SMSA YR20-YR28 AGEQ AGEQS NEWENG MIDATL ENOCENT WNOCENT SOATL ESOCENT WSOCENT MT 

* Test the hetrokadasticity 
test QTR120 QTR121 QTR122 QTR123 QTR124 QTR125 QTR126 QTR127 QTR128 QTR129 QTR220 QTR221 QTR222 QTR223 QTR224 QTR225 QTR226 QTR227 QTR228 QTR229 QTR320 QTR321 QTR322 QTR323  QTR324 QTR325 QTR326 QTR327 QTR328 QTR329 

** PART D **

* Instrumental Variable Regression Model
ivregress 2sls LWKLYWGE RACE MARRIED SMSA YR20-YR28 AGEQ AGEQS NEWENG MIDATL ENOCENT WNOCENT SOATL ESOCENT WSOCENT MT (EDUC = QTR120-QTR129 QTR220-QTR229 QTR320-QTR329) 


/*** Question 2 ***/

* Clear all previously stored data
clear all

* Load in the corresponding data file
use "tipsdata.dta"

* Lets take a look at the data 
describe 
  
** PART A **

* Regression model given in the equation
regress tip total_bill size weekend dinner

** PART B **

* Save the default fitted values
predict fittedvalues 

* Save the residuals 
predict first_residuals, residual

* Draw a scatter plot
scatter first_residuals fittedvalues

** PART C ** 

* Regression model using Hetroskedasticity Robust
regress tip total_bill size weekend dinner, robust

* Save the default fitted values
predict fittedvalues2

* Save the residuals
predict second_residuals, residual

* Draw a scatter plot
scatter second_residuals fittedvalues2

** PART D **

* Tip is now a percentage of total bill
generate fractional_tip = tip / total_bill

* Regressing the new model
regress fractional_tip total_bill size weekend dinner  

* Scatter Plot
predict fittedvalues3 
predict third_residuals, residual
scatter third_residuals fittedvalues

** PART E **

* Our regression model
regress tip total_bill size weekend dinner

* Testing for Hetrokadasticity
estat hettest 

* Our Robust Regression Model
regress fractional_tip total_bill size weekend dinner

* Testing for Hetrokadasticity
estat hettest 


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
	generate Z = rnormal(10, 1)
	generate V = rnormal(0, 1)
	generate U = rnormal(0, 5)
	
	* Generate the model with the given parameters
	generate X = 3*Z + U + V
	generate Y = 5 + 4*X + U
	
	* Regressing Y onto X1
	regress Y X
		
	* Capturing the estimated beta hat value 
	return scalar Estimated_B1 = _b[X]
end 

* runs the monte carolo model 1000 times
simulate "Monte_Carlo_Model" Estimated_B1_Average = r(Estimated_B1), reps(1000)

* Provide a detailed summary for the estimated beta
sum Estimated_B1_Average, detail

* Histogram 
hist Estimated_B1_Average


** PART B ** 
	
* Clear all previously stored data
clear all

* No need for Stata Output

** PART C **

* Clear all previously stored data
clear all

* Allowing random variables to be recorded
set seed 1998

* Making the monte carlo model number 2
capture program drop Monte_Carlo_Model_Number2 
program Monte_Carlo_Model_Number2, rclass

	* Clear the Data
	drop _all

	* Generating random data with the given distributions
	set obs 1000
	
	* We take the square root of the variance to get the standard deviation
	generate U = rnormal(0, sqrt(25))
	generate V = rnormal(0,1)
	generate Z = rnormal(10,1)
	
	* Generate the model with the given parameters
	generate X = 3*Z + U + V
	generate Y = 5 + 4*X + U 
	
	* Regressing Y onto X1
	ivregress 2sls Y (X = Z)
	return scalar Estimated_B1 = _b[X]
	generate test_statistic = _b[X]/_se[X]
	return scalar test_statistic = test_statistic

end 

* runs the monte carolo model 1000 times for B1
simulate "Monte_Carlo_Model_Number2" EstimatedB1_Average = r(Estimated_B1), reps(1000)

* Provide a detailed summary for the estimated beta
summarize EstimatedB1_Average, detail

* Histogram
hist EstimatedB1_Average

* runs the monte carolo model 1000 times  for the test statistic
simulate "Monte_Carlo_Model_Number2" test_statistic1 = r(test_statistic), reps(1000)

* Provide a detailed summary for the test statistic
summarize test_statistic1, detail

* Histogram
hist test_statistic1

** PART D **

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
	set obs 1000
	
	generate V = rnormal(0, 1)
	generate Z = rnormal(10, 1)
	generate U = rnormal(0, sqrt(25))
	
	* Generate the model with the given parameters
	generate X = 0.3*Z + U + V
	generate Y = 5 + 4*X + U
	
	* Regression for the entire model
	ivregress 2sls Y (X = Z)
	return scalar EstimatedB1 = _b[X]
	gen test_statistic2 = _b[X]/_se[X]
	return scalar test_statistic2 = test_statistic2
end 

* runs the monte carolo model 1000 times for B1
simulate "Monte_Carlo_Model_Number3" EstimatedB1Average = r(EstimatedB1), reps(1000)

* Provide a detailed summary for the estimated beta
summarize EstimatedB1Average, detail

* Histogram
hist EstimatedB1Average

* runs the monte carolo model 1000 times  for the test statistic
simulate "Monte_Carlo_Model_Number3" TStat = r(test_statistic2), reps(1000)

* Provide a detailed summary for the test statistic
summarize TStat, detail

* Histogram
hist TStat

* Close the log file
log close 
