### Preamble ###
# Purpose: Use opendatatoronto to get meta data about the portal
# Author: Amy Farrow
# Contact: amy.farrow@mail.utoronto.ca
# Date: 2021-01-21
# Pre-requisites: None
# to-dos:


### Workspace setup ###
# install.packages("opendatatoronto")
# install.packages("tidyverse")
library(opendatatoronto)
library(tidyverse)

### Get data ###
raw_data <-
  opendatatoronto::search_packages("Catalogue quality scores") %>%
  opendatatoronto::list_package_resources() %>%
  dplyr::filter(name %in% c("catalogue-scorecard")) %>%  # This is the name of the resource we are interested in.
  dplyr::select(id) %>%
  opendatatoronto::get_resource()

### Save raw data ###
write_csv(raw_data, "inputs/data/raw_data.csv")

### Remove raw data from the environment ###
#rm(raw_data)
