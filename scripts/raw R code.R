#### Preamble ####
# Purpose: Download data from opendatatoronto
# Author: Zihan Zhang
# Data: 5 February 2022
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



#### Set up libraries ####
library(tidyverse)
library(palmerpenguins)

library(opendatatoronto)
library(janitor)
library(knitr)



#### Data cleaning ####

monthly_shelter_usage_clean <-
  clean_names(monthly_shelter_usage)
monthly_shelter_usage_clean


monthly_shelter_usage_clean <- monthly_shelter_usage_clean %>%
  mutate(mon = substr(date_mmm_yy, 1, 3)) %>%
  mutate(Y =substr(date_mmm_yy, 5, 6 ))


monthly_shelter_usage_clean <- monthly_shelter_usage_clean %>%
  mutate(m = case_when(mon == 'Jan' ~ 1,
                       mon == 'Feb' ~ 2,
                       mon == 'Mar' ~ 3,
                       mon == 'Apr' ~ 4,
                       mon == 'May' ~ 5,
                       mon == 'Jun' ~ 6,
                       mon == 'Jul' ~ 7,
                       mon == 'Aug' ~ 8,
                       mon == 'Sep' ~ 9,
                       mon == 'Oct' ~ 10,
                       mon == 'Nov' ~ 11,
                       TRUE ~12)) %>%
  arrange(m)



monthly_shelter_usage_clean$inflow = monthly_shelter_usage_clean$returned_from_housing+
  monthly_shelter_usage_clean$returned_to_shelter+
  monthly_shelter_usage_clean$newly_identified 



monthly_shelter_usage_clean$outflow = monthly_shelter_usage_clean$moved_to_housing +
  monthly_shelter_usage_clean$no_recent_shelter_use



#### Table1 ####

library(kableExtra)
monthly_shelter_usage_clean %>%
  filter(population_group == 'All Population') %>%
  select(date_mmm_yy,ageunder16, age16_24, age16_24,age25_44,age45_64,age65over )%>%
  slice(1:24) %>%
  kable(
    caption = "shelter flow",
    col.names = c("Date","age under 16","age 16-24","age 25-44","age45-64", "age 65 over"),
    digits = 1,
    booktabs = TRUE, 
    linesep = "",
    align = c('l', 'l', 'c', 'c', 'r', 'r'),
  ) %>%
  add_header_above(c( " "=1, "Youth" = 1, "Working age" = 3, "Aged" =1))

monthly_shelter_usage_clean$net = monthly_shelter_usage_clean$inflow - monthly_shelter_usage_clean$outflow





#### Figure1 ####

library(ggplot2)
graph1 <- monthly_shelter_usage_clean %>%
  filter(population_group == 'All Population') %>%
  ggplot(aes(x=m, y=net,color=Y)) +
  geom_point()+
  geom_line()+
  labs(x="Month", y ="Net Change", title = "Monthly Net Change in the Number of Homeless People", color = "Year") +
  scale_color_brewer(palette = "Set1", labels = c("2020", "2021")) +
  scale_x_continuous(breaks =seq(1,12,1)) +
  theme_minimal()
graph1


#### Figure 2 ####

monthly_shelter_usage_clean %>%
  filter(population_group == 'All Population') %>%
  ggplot(aes(x=m, y=actively_homeless,color=Y))+
  geom_point() +
  geom_line() +
  scale_x_continuous(breaks =seq(1,12,1)) +
  scale_color_brewer(palette = "Set1", labels = c("2020", "2021")) +
  labs(x="Month", 
       y ="Actively Homelessness",
       title = "People Actively Experiencing Homelessness Each Month", 
       color = "Year") +
  theme_minimal()


#### Figure 3 ####

monthly_shelter_usage_clean %>%
  ggplot(aes(x=population_group, y= actively_homeless)) +
  geom_bar(stat = "identity") +
  labs(x="Population Group",
       y="Actively Homelessness",
       title = "People Actively Experiencing Homelessness in Different Population Group") +
  theme_minimal()


#### Reference ####

citation()
citation(package = "ggplot2")
citation(package = "opendatatoronto")

citation(package = "janitor")
citation(package = "kableExtra")