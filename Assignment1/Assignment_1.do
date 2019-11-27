*Assignment 1 Homework
*Eco375
*Tahir Muhammad
*1002537613

clear all

*Set working directory
cd "D:\Eco375\Assignment1"

log using logA1, text replace

**** Question 1 ****

*Load in the data file
use "WeightFoodDays"

*Lets take a look at the data
describe

* Generating the required columns for Q1 part B
generate WeightKilograms = WeightPounds/2.20462
generate Hieght = 1.73
generate BMI = WeightKilograms/((Hieght)^2)

* Finding the mean, variance, standard devition and total number of observations for the required variables
tabstat WeightPounds WaistInches PlatesFoodCons BMI, stat(mean var sd count)

* Creating two scatter plots for Weight & Waist and seeing thier relationship over time  
scatter WeightPounds TimeUnitDay
scatter WaistInches TimeUnitDay

* Part D; Regression 
regress WeightPounds TimeUnitDay

**** Question 2 ****

* Clear all previous data
clear all
 
 *Set working directory
cd "D:\Eco375\Assignment1"

* Load in the data file for this question
use "AMS_exporters"

* Lets take a look at the data
describe

* The Total males and females employed
generate TotalEmployment = employment_m + employment_w

* The ln of each manufacturer's employees
generate LnTotalEmployment = ln(TotalEmployment)

* The ln of exports
generate LnExports = ln(exports)

* Showing the mean, standard deviation, median, 25% and 50% quartiles for required variables
tabstat exports TotalEmployment LnTotalEmployment LnExports, stat(mean sd median p25 p75)

* Scatter plot for LnTotalEmployment and LnExports
scatter LnExports LnTotalEmployment

* Regression of the model part c
reg LnExports LnTotalEmployment

* Part 2D
* Getting the true median for Total Employment and Exports
tabstat TotalEmployment exports, stat(median)

* Storing the ln of median total employees 
generate LnMedianTotalEmployemees = ln(94) 

* Predicting the median exports by the regression model
generate EstimatedExports =  9.567017 +  0.9976858*LnMedianTotalEmployemees

* Show the results of the predicted exports
display EstimatedExports 

* Part 2E 
* Generating ln of materian and capital 
generate LnMaterial = ln(materials) 
generate LnCaptial = ln(capital) 

//Predicting the multiple regression model
regress LnExports LnTotalEmployment LnMaterial LnCaptial
//there is a huge change. This happens bcz ..

*Part 2F
regress LnTotalEmployment LnMaterial LnCaptial

*Estimating the error term, u
predict Error_rate, resid

*running the last regression for part F as required
regress LnExports Error_rate


/*** Question 3 ***/
* PART A *
	
* Clear all previous data
clear all

* Allowing random variables to be recorded
set seed 1997


* Making the model 
capture program drop Monte_Carlo_Model 
program Monte_Carlo_Model, rclass

	* Clear data
	drop _all

	* Generating random data with the given distributions
	set obs 100
	generate V = rnormal(-1,sqrt(2))
	generate U = rnormal(0,sqrt(3))
	generate X1 = rnormal(0,1)
	generate X2 = 0.4*X1 + V
	
	* Generate the model with the given parameters
	generate Y = 5 - 2*X1 - 3*X2 + U 
	
	* Regressing X1 and X2 onto Y
	reg Y X1 X2
	
	* Capturing the parameter values
	return scalar BetaZero = _b[_cons]
	return scalar BetaOne = _b[X1]
	return scalar BetaTwo = _b[X2]
end 

// Running the model 1000 times and recording the parameter value for Beta_0
simulate "Monte_Carlo_Model" All_BetaZero = r(BetaZero), reps(1000)
summarize All_BetaZero
hist All_BetaZero

// Running the model 1000 times and recording the parameter values for Beta_1
simulate "Monte_Carlo_Model" All_BetaOne = r(BetaOne), reps(1000)
summarize All_BetaOne
hist All_BetaOne

// Running the model 1000 times and recording the parameter values for Beta_2
simulate "Monte_Carlo_Model" All_BetaTwo = r(BetaTwo), reps(1000)
summarize All_BetaTwo
hist All_BetaTwo


* PART B *
clear all

set seed 1998

capture program drop Monte_Carlo
program Monte_Carlo, rclass

	* Clear data
	drop _all

	* Data generating process
	set obs 100
	gen V = rnormal(-1,sqrt(2))
	gen U = rnormal(0,sqrt(3))
	gen X1 = rnormal(0,1)
	gen X2 = 0.4*X1 + V
	
	* Generate the model with the given parameters
	gen Y = 5 - 2*X1 - 3*X2 + U 
	
	* Regressing X1 onto Y
	reg Y X1
	
	* Capturing the parameter values
	return scalar All_of_the_BetaZeros = _b[_cons]
	return scalar All_of_the_BetaOnes = _b[X1]
	
end 
// Running the model 1000 times and recording the parameter value for Beta_0
simulate "Monte_Carlo" mean_BetaZero = r(All_of_the_BetaZeros), reps(1000)
sum mean_BetaZero
hist mean_BetaZero

// Running the model 1000 times and recording the parameter values for Beta_1
simulate "Monte_Carlo" mean_BetaOne = r(All_of_the_BetaOnes), reps(1000)
sum mean_BetaOne
hist mean_BetaTwo

log close
