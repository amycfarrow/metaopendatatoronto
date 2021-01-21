### Preamble ###
# Purpose: Use opendatatoronto to get meta data about the portal
# Author: Amy Farrow
# Contact: amy.farrow@mail.utoronto.ca
# Date: 2021-01-21
# Pre-requisites: None
# to-dos:


### Workspace setup ###
# install.packages("opendatatoronto")
library(opendatatoronto)
library(tidyverse)

### Get data ###
metaopendata <-
  opendatatoronto::search_packages("Catalogue quality scores") %>%
  opendatatoronto::list_package_resources() %>%
  dplyr::filter(name %in% c("catalogue-scorecard")) %>% # This is the row we are interested in.
  dplyr::select(id) %>%
  opendatatoronto::get_resource()

### Save data ###
write_csv(metaopendata, "inputs/data/raw_data.csv")