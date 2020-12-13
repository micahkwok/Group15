# Chicago Police Dataset (CPD) - Complaints Analysis

- authors: Ela Bandari, Elanor Boyle-Stanley, Micah Kwok

Analysis of complaints received by the Chicago Police Department from the years 2005-2015.  Investigation of the relationship between salary and number of complaints received.  

## About
Here we attempted to determine if there is a relationship between salary and number of complaints received by Police Officers working for the Chicago Police Department for the years 2005-2015, using linear regression models.  We first used a simple linear regression model, this model indicates there is a negative linear relationship between salary and number of complaints received.  We then expanded our scope to multivariable regression models, including potentially confounding demographic variables such as age, race and gender. There was a small but significant positive association between salary and number of complaints when holding the effects of all demographic variables constant.

Datasets and documents used in this project are sourced from the Chicago Police Department (CPD), Civilian Office of Police Accountability (COPA), the Independent Police Review Authority (IPRA), or the City of Chicago. However, we are building off of data that has been cleaned and matched from a [repository](https://github.com/invinst/chicago-police-data) maintained by the [Invisible Institute](https://invisible.institute/introduction). 

## Report
The final report can be found [here](https://htmlpreview.github.io/?https://github.com/UBC-MDS/CPD/blob/main/doc/chicago_police_report.html)

## Usage
There are two suggested ways to replicate our analysis:

**1. Using Docker**

*note - the instructions in this section also depends on running this in a unix shell (e.g. terminal or Git Bash)*

First install [Docker](https://www.docker.com/get-started).  Then clone this GitHub repository and run the following command at the command line/terminal from the root directory of this project:

On a Windows machine:
```
docker run --rm -v "PATH-ON-YOUR-COMPUTER":/home/rstudio/CPD elanor333/cpd:v0.5.0 make --directory=home/rstudio/CPD all
```
On a non-Windows machine:
```
docker run --rm -v /$(pwd):/home/rstudio/CPD elanor333/cpd:v0.5.0 make -C home/rstudio/CPD all
```

To reset the repo to a clean state, with no intermediate or results files, run the following command at the command line/terminal from the root directory of this project:

On a Windows machine:
```
docker run --rm -v "PATH-ON-YOUR-COMPUTER":/home/rstudio/CPD elanor333/cpd:v0.5.0 make --directory=home/rstudio/CPD clean
```
On a non-Windows machine:
```
docker run --rm -v /$(pwd):/home/rstudio/CPD elanor333/cpd:v0.5.0 make -C home/rstudio/CPD clean
```

**2. Without using Docker**

To replicate the analysis, clone this GitHub repository, install the [dependencies](https://github.com/UBC-MDS/CPD#dependencies) listed below, then run the following commands at the command line/terminal from the root project directory:
```
make all
```
To reset the repo to a clean state, with no intermediate or results files, run the following command at the command line/terminal from the root directory of this project:
```
make clean
```
## Makefile Dependency Diagram
![makefile_diagram](https://github.com/UBC-MDS/CPD/blob/main/Makefile.png?raw=true)

## Dependencies
- Python 3.8.3 and Python packages:
    - docopt==0.6.2
    - pandas==1.1.1
    - requests==2.23.0

- R version 4.0.2 and R packages:
    - docopt==0.7.1
    - tidyverse==1.3.0
    - janitor==2.0.1
    - lubridate==1.7.9 
    - GGally==2.0.0
    - broom==0.7.0
    - testthat==3.0.0.9000


# References
Irizarry, R. (2020, November 16). Introduction to Data Science. Retrieved November 28, 2020, from https://rafalab.github.io/dsbook/regression.html

Invisible Institute. (2017). Invinst/chicago-police-data. Retrieved November 28, 2020, from https://github.com/invinst/chicago-police-data