#### Preamble ####
# Purpose: Download data from opendatatoronto
# Author: Zihan Zhang
# Data: 26 January 2022
# Contact: zhanzihan.zhang@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)
library(opendatatoronto)


#### Data download ####
# From https://open.toronto.ca/dataset/toronto-shelter-system-flow/

# Datasets are grouped into 'packages' that have multiple datasets
# also called 'resources' that are relevant to that topic. So we first look at the package
# using a unique key that we obtain from the datasets webpage (see above).

# get all resources for this package
resources <- list_package_resources("ac77f532-f18b-427c-905c-4ae87ce69c93")

# We need the unique key from that list of resources
# There is only one resource and so get_resource() will load that.
# If there is more than one resource then need to either filter or specify
monthly_shelter_usage <- 
  resources %>% 
  get_resource()


#### Save data ####
write_csv(monthly_shelter_usage, "inputs/data/monthly_shelter_usage.csv")




#### Data cleaning ####
 
