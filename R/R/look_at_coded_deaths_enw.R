# Analyse deaths_coded_longterm

pacman::p_load(here, tidyverse)

dta_deaths <- read_rds(here("data-processed", "enw_deaths_coded_longterm.rds"))
dta_popn <- read_rds(here('data-processed', 'enw_deaths_coded_longterm.rds'))
# Descriptive stats/sense checks

# total deaths over time

dta_deaths %>%
  group_by(yr) %>%
  summarise(ndths = sum(ndths)) %>%
  ungroup() %>%
  ggplot(aes(yr, ndths)) +
  geom_line() +
  expand_limits(y = 0)

# total deaths over time by sex

dta_deaths %>%
  group_by(yr, sex) %>%
  summarise(ndths = sum(ndths)) %>%
  ungroup() %>%
  ggplot(aes(yr, ndths, colour = sex, group = sex)) +
  geom_line() +
  expand_limits(y = 0)


# Only interested in specific age groups

age_groups_of_interest <- c(
  "15-19", "20-24", "25-29", "30-34", "80-84",
  "35-39", "40-44", "45-49", "50-54", "55-59",
  "60-64", "65-69", "70-74", "75-79",  "85+"
)

# Trends by age groups of interest

dta_deaths %>%
  filter(age %in% age_groups_of_interest) %>%
  group_by(yr) %>%
  summarise(ndths = sum(ndths)) %>%
  ungroup() %>%
  ggplot(aes(yr, ndths)) +
  geom_line() +
  expand_limits(y = 0)


dta_deaths %>%
  filter(age %in% age_groups_of_interest) %>%
  group_by(yr, sex) %>%
  summarise(ndths = sum(ndths)) %>%
  ungroup() %>%
  ggplot(aes(yr, ndths, colour = sex, group = sex)) +
  geom_line() +
  expand_limits(y = 0)


##############################################################################

# Now to calculate death rates

dta_deaths
dta_popn

# Need to know which codes to keep




dta_deaths %>%
  filter(age %in% age_groups_of_interest) %>%
  left_join(dta_popn, by = c('sex', 'yr', 'age'))


