
# author: Micah Kwok
# date: 2020-11-26

"Creates eda plots for the pre-processed data from the Chicago Police Department.
Saves the plots as a png file.
Usage: src/generate_EDA_figures.r --all_data=<all_data> --police_data=<police_data> --out_dir=<out_dir>
  
Options:
--all_data=<all_data>     Path (including filename) to preprocessed full dataset
--police_data=<police_data>     Path (including filename) to preprocessed subsetted data of Police Officers
--out_dir=<out_dir> Path to directory where the plots should be saved
" -> doc

library(tidyverse)
library(janitor)
library(stringr)
library(lubridate)
library(docopt)
library(testthat)

opt <- docopt(doc)

main <- function(all_data, police_data , out_dir) {

#Load the data
complaints_all_staff <- read_csv(all_data)
complaints_police <- read_csv(police_data)    

# create out directory
try({
  dir.create(out_dir)
})

# Complaints by year
complaints_all_staff %>% 
    group_by(year) %>%
    summarize(n = sum(complaints_per_year)) %>%
    ggplot(aes(x = year, y = n)) + 
    geom_line() + 
    ggtitle("Complaints per Year") + 
    labs(x = "Year", y = "Count of Complaints") + 
    scale_x_continuous(breaks = 2005:2015) + 
    ggsave(paste0(out_dir,"/complaints_by_year.png"))

# Number of police staff/records per year (included in analysis)
complaints_all_staff %>% 
    count(year) %>%
    ggplot(aes(x = year, y = n)) + 
    geom_line() + 
    ggtitle("Number of Police Staff per Year") + 
    labs(x = "Year", y = "Count of Officers") + 
    scale_x_continuous(breaks = 2005:2015) +
    ggsave(paste0(out_dir,"/staff_by_year.png"))

#Histogram of total complaints per officer - total complaints does not match because one complaint can be tied to multiple officers
complaints_all_staff %>% 
    group_by(link_UID) %>%
    summarize(n = sum(complaints_per_year)) %>%
    ggplot(aes(x = n)) +
    labs(x = "Number of Complaints", y = "Count") + 
    ggtitle("Total Complaints per Officer (2005-2015)") +
    geom_histogram(bins = 20) +
    ggsave(paste0(out_dir,"/total_complaints_histogram.png"))

#Faceted per year histogram
complaints_all_staff %>% 
    group_by(link_UID, year) %>%
    summarize(n = sum(complaints_per_year)) %>%
    ggplot(aes(x = n)) +
    labs(x = "Number of Complaints", y = "Count") + 
    ggtitle("Total Complaints per Police Staff (2005-2015)") +
    geom_histogram(bins = 20) +
    facet_wrap(~year, nrow=3) + 
    theme(axis.title = element_text(size = 14),
        plot.title = element_text(size = 20)) +
    ggsave(paste0(out_dir,"/faceted_histogram.png"))

# Complaints by officer rank
complaints_all_staff %>% 
    group_by(cleaned_rank) %>%
    summarize(n = sum(complaints_per_year)) %>%
    mutate(cleaned_rank = ifelse(n < 100, "OTHER", as.character(cleaned_rank))) %>%
    ggplot(aes(y=(reorder(cleaned_rank,-n)), x = n)) +
    labs(x = "Number of Complaints", y = "Rank", title = "Total Complaints per Rank", subtitle = "(2005-2015)") + 
    geom_col() +
    ggsave(paste0(out_dir,"/complaints_by_rank.png"))

#Police Officer Salary Distribution (2015)
complaints_police %>%
    ggplot(aes(x = salary)) + 
    geom_histogram() + 
    ggtitle("Distribution of Police Officer Salary") + 
    labs(x = "Salary", y = "Count", subtitle = "(2005-2015)") + 
    scale_x_continuous(labels = scales::label_dollar()) +
    theme(axis.title = element_text(size = 14),
        axis.text = element_text(size=12),
        plot.title = element_text(size = 20)) +
    ggsave(paste0(out_dir,"/police_salary_dist.png"))

#Create Histogram function    
create_histogram <- function(year_input, x_input, title, x_lab, y_lab, file_name) {
    if(!is.numeric(year_input)){
      stop("year_input must be numerical value")
    }
  
    if(!is.character(title)|| !is.character(x_lab) || !is.character(y_lab)){
      stop("title, x_lab, y_lab must be string")
    }
  
    complaints_police %>% filter(year == year_input) %>% 
        ggplot(aes(x = {{x_input}})) + geom_histogram(bins = 20) +
        ggtitle(title) +
        labs(x = x_lab, y = y_lab) +
        ggsave(paste0(out_dir,file_name))
}    

test_that("Incorrect inputs should throw out error", {
    expect_error(create_histogram(2015, approx_age, 1, TRUE, 2, 'text'))
    expect_error(create_histogram('text', approx_age, 'text','text','text','text'))
})

#Police Officer Age Dist (2015, chosen b/c a recent year that is pretty representative)
create_histogram(2015, approx_age, 'Approximate Age of Police Officers in 2015', 'Approximate Age', 'Count', '/police_age_dist.png')

#Distribution of years of service in 2015    
create_histogram(2015, approx_years_service, 'Approximate Years of Service of Police Officers in 2015', 'Approximate Years of Service', 'Count', '/police_exp_dist.png')    

#Create Bar Chart Function
create_barchart <- function(year_input, y_input, title, x_lab, y_lab, file_name){
    if(!is.numeric(year_input)){
      stop("year_input must be numerical value")
    }
  
    if(!is.character(title)|| !is.character(x_lab) || !is.character(y_lab)){
      stop("title, x_lab, y_lab must be string")
    }
  
    complaints_police %>% filter(year == year_input) %>% group_by(year, {{y_input}}) %>% 
      add_count({{y_input}}) %>% 
      ggplot(aes(y = reorder({{y_input}},-n))) + 
      geom_bar() +
      ggtitle(title) +
      labs(x = x_lab , y = y_lab) +
      ggsave(paste0(out_dir,file_name))
}

test_that("Incorrect inputs should throw out error", {
    expect_error(create_barchart(2015, approx_age, 5, TRUE, 72, 'text'))
    expect_error(create_barchart('text', approx_age, 'text','text','text','text'))
})

# Gender Bar Chart 2015
create_barchart(2015, gender, "2015 Police Officer Gender Breakdown", "Gender", "Count", "/police_gender.png")

# Race Bar Chart for 2015
create_barchart(2015, race, "2015 Police Officer Race Breakdown", "Race", "Count", "/police_race.png")

#Correlation Matrix ggpairs (can't use ggsave to save png)
png(paste0(out_dir,"/corr_matrix.png"))
corr_matrix <- complaints_police %>% 
    select(salary, approx_age, approx_years_service, complaints_per_year) %>% 
    GGally::ggpairs(progress=FALSE)

print(corr_matrix)
dev.off()
}

main(opt$all_data, opt$police_data, opt$out_dir)
