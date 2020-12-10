# Chicago Police Dataset (CPD)

- authors: Ela Bandari, Elanor Boyle-Stanley, Micah Kwok

Analysis of complaints received by the Chigaco Police Department from the years 2005-2015.  Investigate if there is a relationship between salary and number of complaints received.  

## About
Here we attempted to determine if there is a relationship between salary and number of complaints received by Police Officers working for the Chicago Police Department for the years 2005-2015, using linear regression models.  We first used a simple linear regression model, this model indicates there is a negative linear relationship between salary and number of complaints recevied.  We then expanded scope to multivariale regression models, including potentially confounding demographic variables such as age, race and gender.  Given the demographic variables had a statistically significant impact on the number of complaints, they were identified as potentially confounding variables and taken into consideration in modelling the relationship between number of complaints and salary.  We intend to continue to explore these relationship in future iterations of the project. 

Datasets and documents used in this project are sourced from the Chicago Police Department (CPD), Civillian Office of Police Accountability (COPA), the Independent Police Review Authority (IPRA), or the City of Chicago. However, we are building off of data that has been cleaned and matched from a [repository](https://github.com/invinst/chicago-police-data) maintained by the [Invisible Institute](https://invisible.institute/introduction). 

## Report
The final report can be found [here](https://htmlpreview.github.io/?https://github.com/UBC-MDS/CPD/blob/main/doc/chicago_police_report.html)

## Usage
In order to replicate our analysis, clone this GitHub repository, ensure you have installed all the dependencies below, then run the following commands at the command lin/terminal from the project directory. 

```
# Download data
python src/download_data.py --url=https://github.com/invinst/chicago-police-data/blob/master/data/unified_data/complaints/complaints-complaints.csv.gz?raw=true --path=data/raw/complaints.csv
python src/download_data.py --url=https://github.com/invinst/chicago-police-data/blob/master/data/unified_data/complaints/complaints-accused.csv.gz?raw=true --path=data/raw/accused.csv
python src/download_data.py --url=https://github.com/invinst/chicago-police-data/blob/master/data/unified_data/salary/salary-ranks_2002-2017_2017-09.csv.gz?raw=true --path=data/raw/salary.csv
python src/download_data.py --url=https://github.com/invinst/chicago-police-data/blob/master/data/unified_data/profiles/final-profiles.csv.gz?raw=true --path=data/raw/demographics.csv

# Clean / preprocess data
Rscript src/read_preprocess_data.R --file_path=data/raw --out_dir=data/processed

# Create exploritory data analysis figures and write to file
Rscript src/generate_EDA_figures.R --all_data=data/processed/complaints_all_staff.csv --police_data=data/processed/complaints_police.csv --out_dir=eda/images

# Run statistical analysis 
Rscript src/linear_regression_analysis --file_path=data/processed --out_dir=results
```

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


# References
Irizarry, R. (2020, November 16). Introduction to Data Science. Retrieved November 28, 2020, from https://rafalab.github.io/dsbook/regression.html

Invisible Institute. (2017). Invinst/chicago-police-data. Retrieved November 28, 2020, from https://github.com/invinst/chicago-police-data