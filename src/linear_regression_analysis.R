"This script reads in the processed csv file and fits linear regression models to it.  

Usage: linear_regression_analysis.R --file_path=<file_path> --out_dir=<out_dir>

Options:
--file_path=<file_path>     Path to processed data file
--out_dir=<out_dir>         Path to write cleaned analyses
"-> document

library(tidyverse)
library(docopt)


opt <- docopt(document)

main <- function(file_path, out_dir) {

# Load complaints dataframe 
complaints_police <- read_csv(paste0(file_path,'/complaints_police.csv'))

# Scale salaries for regression
complaints_police <- complaints_police %>% 
  mutate(salary_scaled = salary / 10000)

# Simple linear regression model (response = complaint_per_year, explanatory = salary_scaled)
salary_reg <- lm(complaints_per_year ~ salary_scaled, data = complaints_police) %>% 
  broom::tidy()
try({
  dir.create(out_dir)
})

saveRDS(salary_reg, file = paste0(out_dir, "/salary_reg.rds"))

# Linear regression model with salary and gender 
salary_gender_reg <- lm(complaints_per_year ~ salary_scaled + gender, data = complaints_police) %>% 
  broom::tidy()

saveRDS(salary_gender_reg, file = paste0(out_dir, "/salary_gender_reg.rds"))

# Linear regression model with salary and all demographic variables
salary_demographics_reg <- lm(complaints_per_year ~ salary_scaled + gender + race + approx_age , data = complaints_police) %>% 
  broom::tidy()

saveRDS(salary_demographics_reg , file = paste0(out_dir, "/salary_demographics_reg.rds"))


}

main(opt$file_path, opt$out_dir)

