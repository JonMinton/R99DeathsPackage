


death_rate_data <- read_rds('data-processed/death_rates_unexplained_other.rds')
# https://www.opendata.nhs.scot/dataset/standard-populations

reference_population <- read_csv("https://www.opendata.nhs.scot/dataset/4dd86111-7326-48c4-8763-8cc4aa190c3e/resource/edee9731-daf7-4e0d-b525-e4c1469b8f69/download/european_standard_population.csv")

# reference_population_by_sex <- read_csv("https://www.opendata.nhs.scot/dataset/4dd86111-7326-48c4-8763-8cc4aa190c3e/resource/29ce4cda-a831-40f4-af24-636196e05c1a/download/european_standard_population_by_sex.csv")
#
# # There's actually no need to download by sex as the reference population sizes are identical throughout
# reference_population_by_sex %>% pivot_wider(names_from = Sex, values_from = EuropeanStandardPopulation)

easr_by_unexplained_explained <-
death_rate_data %>%
  mutate(age_group = as.character(age_group)) %>%
  left_join(
    reference_population %>%
      rename(age = AgeGroup) %>%
      mutate(age = str_remove(age, 'years') %>% str_trim()) %>%
      mutate(age = case_when(
        age %in% c('85-89', '90plus') ~ '85+',
        TRUE ~ age
      )) %>%
      filter(!(age %in% c('0-4', '5-9', '10-14'))) %>%
      group_by(age) %>%
      summarise(EuropeanStandardPopulation = sum(EuropeanStandardPopulation)) %>%
      ungroup() %>%
      mutate(
        pop_weight = EuropeanStandardPopulation / sum(EuropeanStandardPopulation)
      ) %>%
      select(age_group = age, pop_weight)
  ) %>%
  mutate(
    tmp = mort_rate * pop_weight
  ) %>%
  group_by(sex, year, code_of_interest) %>%
  summarise(easr = sum(tmp, na.rm = TRUE)) %>%
  ungroup() %>%
  filter(between(year, 1961, 2020))

# Now to visualise

easr_by_unexplained_explained %>%
  ggplot(aes(x = year, y = easr, group = sex, colour = sex)) +
  facet_wrap(~ code_of_interest, scales = 'free_y') +
  geom_line() +
  expand_limits(y = 0)

# Problems:
# 1 ) data for all other causes from 1961-1970 look wrong - too low - discontinuity
# 2 ) More apparent that codes for around 1980-1990 not quite the same as for before/after
# 3) Rapid increase in unexplained deaths around 1990 to 2005, then a plateau afterwards



