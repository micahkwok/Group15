# Chicago Police Dataset (CPD)

# Project Proposal: Chicago Police Data Analysis

### 1. Working Dataset

The original datasets and documents are sourced from the Chicago Police Department (CPD), Civillian Office of Police Accountability (COPA), the Independent Police Review Authority (IPRA), or the City of Chicago. However, we are building off of data that has been cleaned and matched from a [repository](https://github.com/invinst/chicago-police-data) maintained by the [Invisible Institute](https://invisible.institute/introduction). 

### 2. Research Question

With our dataset we would look answer the main inferential question of whether an officer's salary influences their complaint rate (numbe of complaints per year) using a subset of the data from the years 2005 to 2015.

### 3. Analysis Plan

As the CPD data to answer our research question is stored in 3 separate files (i.e. one file for salaries, and two filed related to information about the complaints lodged against officers), we will have to consolidate these files by joining them through the Unique Officer IDs. The first step in our analysis plan is merging and cleaning the dataframes. At this stage, we will also calculate the complaint rate (number of complaints per year) for each officer. Once we have the our data cleaned, we will use a linear regression model to determine whether officer's salary can be used to explain the difference in officer complaint rate. Other variables that may impact on complaint rate include officer age, gender and race; therefore, we will consider including these variables to our linear model. Our analysis plan will evolve as our knowledge of linear regression increases through the DSCI 561 course.    

### 4. Approach Towards Explanatory Data Analysis 

Given we are joining 3 different dataframes it is important to explore what amount of information may have been lost in the process. To do this we will be observing the:  
- Number of rows dropped during joining of data

We also want to have a good overview of our variables of interest so we will exploring the following variables:
- Number of complaints per year
- Number of complaints per officer
- Distribution of officer salary 
- Distribution of officer age, gender and ethnicity(time-permitting)

We will be displaying our EDA through:
- a correlation matrix of our variables of interest 

### 5. Presentation of Results

We could show the results of our analysis through a scatterplot with a line of regression. We will be reporting the regression coefficient for the variables in our linear model. Our presentation of results plan may evolve as our knowledge of linear regression increases through the DSCI 561 course.    

