#### Preamble ####
# Purpose: Clean the Catalogue quality scores data (CQS) downloaded from Open 
# Data Toronto
# Author: Amy Farrow
# Date: 2021-01-24
# Contact: amy.farrow@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the CQS data and saved it to inputs/data
# - Change these to yours
# Any other information needed?


#### Workspace setup ####
library(haven)
library(tidyverse)
library(lubridate) # for handing the recorded_at variable

### Read in the raw data ###
raw_data <- readr::read_csv("inputs/data/raw_data.csv")

### Select variables of interest ###
reduced_data <- 
  raw_data %>% 
  select(package, 
         accessibility,
         completeness,
         freshness,
         metadata,
         usability,
         score_norm,
         grade_norm,
         recorded_at)
rm(raw_data)

### Remove all data collected after January 24th, 2021.###
# My original analysis only includes data up until January 24th 2021.
# This code ensures that my analysis can be replicated after that date.
reduced_data <-
  reduced_data %>%
  filter(recorded_at < "2021-01-24 00:10:00")

### Clean data ###
# This properly formats the collection time and date
# and relevels the grades so that the order is lowest to highest.
cleaned_data <-
  reduced_data %>%
  mutate(recorded_at = as_datetime(recorded_at),
         grade_norm = fct_relevel(grade_norm, "Bronze", "Silver","Gold")) %>%
  rename(quality = score_norm, grade = grade_norm)
rm(reduced_data)

### Save cleaned data ###
write_csv(cleaned_data, "inputs/data/cleaned_data.csv")

### Remove cleaned data from the environment ###
#rm(cleaned_data)
         