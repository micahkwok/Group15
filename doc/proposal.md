# Project Proposal: Chicago Police Data Analysis

### 1. Working Dataset

The original datasets and documents are sourced from the Chicago Police Department (CPD), Civillian Office of Police Accountability (COPA), the Independent Police Review Authority (IPRA), or the City of Chicago. However, we are building off of data that has been cleaned and matched from a [repository](https://github.com/invinst/chicago-police-data) maintained by the [Invisible Institute](https://invisible.institute/introduction). 

### 2. Research Question

With our dataset we would look answer the main inferential question of whether a police staff member's salary influences their complaint rate (number of complaints per year) using a subset of the data from the years 2005 to 2015. We would like to better understand factors associated with complaint rate. Based on [previous research] (https://www.nber.org/digest/jan07/police-pay-and-performance) demonstrating a relationship between arrest rates and police staff member salary, we suspect that salary may also be asssociated complaint rates.

### 3. Analysis Plan

As the data to answer our research question is stored in 3 separate files (i.e. one file for salaries, and two files related to information about the complaints lodged against police staff members), we will have to consolidate these files by joining them through the Unique ID field. The first step in our analysis plan is merging and cleaning the dataframes. Once we have cleaned our data, we will use a linear regression model to determine whether a police staff member's salary is associated with their complaint rate. The response variable for our model is the complaint rate while the explanatory variable is the salary. We have also considered other variables that may impact on complaint rate which include the staff member's age, gender and race; therefore, we will consider including these variables to our linear model if time permits. Our analysis plan may evolve as our knowledge of linear regression increases through the DSCI 561 course.    

### 4. Approach Towards Explanatory Data Analysis 

The first step in our EDA is to ensure that we have a thorough understanding of our dataset and that our dataset is in a form where we can easily make visualizations from. We achieve this by: 
- Validating our understanding of dataset by probing the data and checking relevant resources (such as the data dictionary provided by the original creators)
- Systematically checking for and removing duplicates in each dataset
- Joining the 3 datasets on appropriate features  


We also want to have a good overview of our variables of interest so we will be making visualizations of the following variables:
- Number of complaints per year 
- Number of complaints per rank 
- Number of complaints per officer/police staff member 
- Distribution of salary by rank  
- Complaints rate by salary
- A correlation matrix of salary, year and complaint rate 

### 5. Presentation of Results

We plan to show the results of our analysis through a scatterplot with a line of regression. We plan to report the regression coefficient, the confidence interval, and p-value for salary as well as any other terms we include as part of our linear model. Our plan for the presentation of results may evolve as our knowledge of linear regression increases through the DSCI 561 course.    

