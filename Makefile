# Makefile
# Ela Bandari, Elanor Boyle-Stanley, Micah Kwok

# This driver script completes the analysis of complaints received 
# by the Chigaco Police Department from the years 2005-2015.  
# Investigate if there is a relationship between salary and number of complaints received.

# example usage:
# make all

all: results eda/images doc/chicago_police_report.html 

# Download data
data/raw/complaints.csv: src/download_data.py
	python src/download_data.py --url=https://github.com/invinst/chicago-police-data/blob/master/data/unified_data/complaints/complaints-complaints.csv.gz?raw=true --path=data/raw/complaints.csv
    
data/raw/accused.csv: src/download_data.py
	python src/download_data.py --url=https://github.com/invinst/chicago-police-data/blob/master/data/unified_data/complaints/complaints-accused.csv.gz?raw=true --path=data/raw/accused.csv
    
data/raw/salary.csv: src/download_data.py
	python src/download_data.py --url=https://github.com/invinst/chicago-police-data/blob/master/data/unified_data/salary/salary-ranks_2002-2017_2017-09.csv.gz?raw=true --path=data/raw/salary.csv
    
data/raw/demographics.csv: src/download_data.py
	python src/download_data.py --url=https://github.com/invinst/chicago-police-data/blob/master/data/unified_data/profiles/final-profiles.csv.gz?raw=true --path=data/raw/demographics.csv

# Clean / preprocess data
data/processed: data/raw/complaints.csv data/raw/accused.csv data/raw/salary.csv data/raw/demographics.csv src/read_preprocess_data.R 
	Rscript src/read_preprocess_data.R --file_path=data/raw --out_dir=data/processed

# Create exploritory data analysis figures and write to file
eda/images: data/processed src/generate_EDA_figures.R
	Rscript src/generate_EDA_figures.R --all_data=data/processed/complaints_all_staff.csv --police_data=data/processed/complaints_police.csv --out_dir=eda/images

# Run statistical analysis 
results: data/processed src/linear_regression_analysis.R
	Rscript src/linear_regression_analysis.R --file_path=data/processed --out_dir=results

# write the report
doc/chicago_police_report.html: eda/images results doc/chicago_police_report.Rmd doc/references.bib 
	Rscript -e "rmarkdown::render('doc/chicago_police_report.Rmd')"

# remove analysis files    
clean: 
	rm -rf data
	rm -rf results
	rm -rf eda/images
	rm -rf doc/chicago_police_report.html
