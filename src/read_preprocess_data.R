# author: Elanor Boyle-Stanley
# date: 2020-11-26

"This script reads in raw csv files and preps the data for analysis, primarily data cleaning and joining

Usage: read_preprocess_data.R --file_path=<file_path> --out_dir=<out_dir>

Options:
--file_path=<file_path>     Path to data file
--out_dir=<out_dir>         Path to write cleaned file(s)
" -> document

library(tidyverse)
library(docopt)
library(janitor)
library(stringr)
library(lubridate)

opt <- docopt(document)

main <- function(file_path, out_dir) {
    # Load csv files.  Readin all columns as characters, 
    # eliminates issues with formatting (some cr_id were defaulting to NA)
    accused_df <- read_csv(paste0(file_path, "/accused.csv"), col_type = paste(rep("c",10),collapse = ""))
    complaints_df <- read_csv(paste0(file_path,"/complaints.csv"), col_type = paste(rep("c",11),collapse = ""))
    salary_df <- read_csv(paste0(file_path, "/salary.csv"), col_types = paste(rep("c",8),collapse = ""))
    demographics_df <- read_csv(paste0(file_path,"/demographics.csv"), col_types = paste(rep("c",20), collapse = ""))
    
    
    # find duplicates the complaints and accused dataframes
    accused_duplicates <- accused_df %>% 
        mutate(cr_id_num = str_match(cr_id,"[0-9]+")) %>%
        get_dupes(cr_id_num, UID)
    
    complaints_duplicates <- complaints_df %>% 
        mutate(cr_id_num = str_match(cr_id,"[0-9]+")) %>%
        get_dupes(cr_id_num)
    
    # filter to include on `cv == 1` this will then be used to 
    # remove these records from the imported accused & complaints dataset
    accused_duplicates_to_remove <- accused_duplicates %>%
        filter(cv == 1)
    
    complaints_duplicates_to_remove <- complaints_duplicates %>%
        filter(cv == 1)
    
    # remove duplicate records from accused & complaints dataframe
    accused_df_deduplicated <- accused_df %>% 
        anti_join(accused_duplicates_to_remove, by = c("cr_id", "UID"))
    
    complaints_df_deduplicated <- complaints_df %>% 
        anti_join(complaints_duplicates_to_remove, by = c("cr_id"))
    
    
    # Join complaints, modify datatypes & filter on years of interest
    complaints_joined = left_join(accused_df_deduplicated, complaints_df_deduplicated, by = 'cr_id')
    
    complaints_joined <- complaints_joined %>%
        mutate(incident_date = ymd(incident_date),
               complaint_date = ymd(complaint_date),
               closed_date = ymd(closed_date),
               incident_year = year(incident_date)) %>%
        filter(incident_year >= 2005, incident_year <= 2015) %>%
        group_by(link_UID, incident_year) %>%
        nest() %>%
        mutate(complaints_per_year =  map_dbl(data, ~sum(!is.na(.$cr_id))))
    
    #Modify salary datatypes and filter on years of interest
    salary_df <- salary_df %>%
        mutate(year = as.numeric(year),
               spp_date = ymd(spp_date),
               salary = as.numeric(salary)) %>%
        filter(year >= 2005, year <= 2015)

    # Code to clean demographics dataframe 
    # Note 1: only relevant columns were selected
    # Note 2: Org_start_date = date as officer, start_date = date as officer in CPD.
    demographics_df <- demographics_df %>%  
        select(UID, link_UID, race, gender, birth_year, cleaned_rank, 
               org_hire_date, start_date, resignation_date) %>% 
        mutate(birth_year = as.numeric(birth_year),
               org_hire_date= ymd(org_hire_date),
               start_date= ymd(start_date),
               resignation_date= ymd(resignation_date))
    
    #Join salaries and joint complaints
    df_merged <- full_join(salary_df, complaints_joined, by = c('link_UID', c("year" = "incident_year")))
    
    # Join demographics to merged datadrame
    df_merged_demographics <- left_join(df_merged, demographics_df, by = c('link_UID', "cleaned_rank"))
    
    # add ordering for rank senority - adapted from http://directives.chicagopolice.org/directives/data/a7a57be2-1291da66-88512-91e3-fb25744de048d4ef.html
    # also referenced https://en.wikipedia.org/wiki/Police_rank#United_States
    rank_order = c("DEPUTY SUPERINTENDENT", "FIRST DEPUTY SUPERINTENDENT", 
                   "ASSISTANT SUPERINTENDENT", "SUPERINTENDENT\'S CHIEF OF STAFF", "GENERAL COUNSEL", "CHIEF", "DEPUTY CHIEF", "COMMANDER", 
                   "SERGEANT", "DETECTIVE", "INVESTIGATOR", "FIELD TRAINING OFFICER", "POLICE OFFICER", "CIVILIAN")
    
    # Create all staff dataframe for analysis
    complaints_all_staff <- df_merged_demographics %>%
        # remove records where no salary or demographic information was avaiable
        drop_na(salary, race) %>% 
        # drop columns not used in analysis
        select(-rank, - pay_grade, -spp_date, -UID.x, -UID.y, -data) %>%     
        # calculate approximate age and approximate years of service
        mutate(approx_age = year - birth_year, 
               approx_years_service = if_else(is.na(start_date), year - year(org_hire_date), year - year(start_date))) %>%         
        # change to factor
        mutate(cleaned_rank = factor(cleaned_rank, levels = rank_order)) %>%   
        # convert NAs to 0
        mutate(complaints_per_year = if_else(is.na(complaints_per_year), 0, complaints_per_year)) 
                      
    # Create police officer dataframe for analysis  
    complaints_police <- complaints_all_staff %>%
    filter(cleaned_rank == "POLICE OFFICER")

    # try to create directory
    try({
    dir.create(out_dir)
    })

    # write to .csv
    write_csv(complaints_all_staff, paste0(out_dir, "/complaints_all_staff.csv"))         
    write_csv(complaints_police, paste0(out_dir,"/complaints_police.csv"))
}

main(opt$file_path, opt$out_dir)
    
