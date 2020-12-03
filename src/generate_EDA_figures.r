
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
    ggsave(paste0(out_dir,"/police_salary_dist.png"))

#Police Officer Age Dist (2015, chosen b/c a recent year that is pretty representative)
complaints_police %>% filter(year == 2015) %>% 
    ggplot(aes(x = approx_age)) + geom_histogram(bins = 20) +
    ggtitle("Approximate Age of Police Officers in 2015") +
    labs(x = "Approximate Age", y = "Count") +
    ggsave(paste0(out_dir,"/police_age_dist.png"))

#Distribution of years of service in 2015
complaints_police %>% filter( year == 2015) %>% 
    ggplot(aes(x = approx_years_service)) + geom_histogram(bins = 20) +
    ggtitle("Approximate Years of Service of Police Officers in 2015") +
    labs(x = "Approximate Years of Service", y = "Count") +
    ggsave(paste0(out_dir,"/police_exp_dist.png"))   

# Gender Bar Chart 2015
complaints_police %>% filter(year == 2015) %>% group_by(year, gender) %>% 
    add_count(gender) %>% 
    ggplot(aes(x = reorder(gender, -n))) + 
    geom_bar() +
    ggtitle("2015 Police Officer Gender Breakdown") +
    labs(x = "Gender", y = "Count") +
    ggsave(paste0(out_dir,"/police_gender.png"))

# Race Bar Chart for 2015
complaints_police %>% filter(year == 2015) %>% group_by(year, race) %>% 
    add_count(race) %>% 
    ggplot(aes(y = reorder(race,-n))) + 
    geom_bar() + facet_wrap(~year) + 
    ggtitle("2015 Police Officer Race Breakdown") +
    labs(x = "Count" , y = "Race") + 
    ggsave(paste0(out_dir,"/police_race.png"))

#Correlation Matrix ggpairs (can't use ggsave to save png)
png(paste0(out_dir,"/corr_matrix.png"))
corr_matrix <- complaints_police %>% 
    select(salary, approx_age, approx_years_service, complaints_per_year) %>% 
    GGally::ggpairs(progress=FALSE)

print(corr_matrix)
dev.off()
}

main(opt$all_data, opt$police_data, opt$out_dir)