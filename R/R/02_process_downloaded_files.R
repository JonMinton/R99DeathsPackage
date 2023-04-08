## Process data

# We need to get the relevant data out of two excel files, both in data-raw

library(here)
library(readxl)
library(tidyverse)
library(janitor)

if (dir.exists(here("data-processed"))){
  message("The data-processed dir exists: nothing to do")
} else {
  message("The data-processed dir does not exist: creating it")
  dir.create(here("data-processed"))
}

#################################POPULATION ####################################

# Let's begin by making sure we have population estimates for each possibly relevant
# year.

# The most comprehensive dataset for population counts now appears to be
# ukpopulationestimates18382020.xlsx.
# And within this table 9

pop_years <- read_excel(here('data-raw/population/ukpopulationestimates18382020.xlsx'),
                      sheet = 'Table 9', range = 'A5:BI5') %>% names() %>%
  str_remove('Mid-')

dta_mf <- read_excel(here('data-raw/population/ukpopulationestimates18382020.xlsx'),
                     sheet = 'Table 9', range = 'A7:BI98', na = ':', col_names = pop_years) %>%
  pivot_longer(cols = -Age) %>%
  mutate(sex = 'both') %>%
  rename(age = Age)

dta_m <- read_excel(here('data-raw/population/ukpopulationestimates18382020.xlsx'),
                    sheet = 'Table 9', range = 'A101:BI192', na = ':', col_names = pop_years) %>%
  pivot_longer(cols = -Age) %>%
  mutate(sex = 'male') %>%
  rename(age = Age)

dta_f <- read_excel(here('data-raw/population/ukpopulationestimates18382020.xlsx'),
                    sheet = 'Table 9', range = 'A195:BI286', na = ':', col_names = pop_years) %>%
  pivot_longer(cols = -Age) %>%
  mutate(sex = 'female') %>%
  rename(age = Age)

dta_pop_long <-
  bind_rows(
    dta_mf, dta_f, dta_m
    ) %>%
    rename(year = name) %>%
    mutate(year = as.numeric(year))

# First save all ages, then each individual age

# Visual check that data appear reasonable:

# dta_pop_long %>%
#   filter(age != 'All Ages') %>%
#   select(age, year, sex, pop_count = value) %>%
#   mutate(age = str_remove(age, '\\+') %>% as.numeric() ) %>%
#   ggplot(aes(x = year, y = age, fill = pop_count)) +
#   geom_tile() +
#   coord_equal() +
#   facet_wrap(~sex)

dta_pop_long %>%
  filter(age == 'All Ages') %>%
  select(year, sex, pop_count = value) %>%
  write_rds(file = here('data-processed/pop_all_ages.rds'))

dta_pop_long %>%
  filter(age != 'All Ages') %>%
  select(age, year, sex, pop_count = value) %>%
  mutate(age = str_remove(age, '\\+') %>% as.numeric() ) %>%
  write_rds(file = here('data-processed/pop_individual_ages.rds'))







# # deaths at home - weekly
#
# weekly_deaths_at_home <- readxl::read_excel(
#   path = here("data-raw", "deaths-weekly", "publicationfileweek522022.xlsx"),
#   sheet = "10", range = "A6:Q58"
# ) %>% clean_names() %>%
#   pivot_longer(
#     cols = -week_number,
#     names_to = "category", values_to = "count"
#     ) %>%
#   mutate(
#     year = 2022
#   ) %>%
#   select(year, week_number, category, count)
#
# # save it
#
# weekly_deaths_at_home %>%
#   write_rds(file = here("data-processed", "weekly_deaths_at_home_2022.rds"))
#


### ONS cause of death

# There are 21 worksheets in the workbook, each for a different year
# It is not immediately clear which sex is male and which female
# But it should be easy enough to work out...

# The top left cell is consistent for all sheets
# But the bottom right cell is not
#    - it will always be column E
#    - but not necessarily the same row
#    - I will read in cells up to row 24000, then delete empty rows

read_and_clean <- function(sht){
  readxl::read_xlsx(here("data-raw", "ons_cod.xlsx"),
                    sheet = sht,
                    range = "A5:E24000") %>%
    clean_names()
}

cod_long <-
  map(1:21 %>% as.character(), # this crates the numbers 1, 2, 3, up to 21, turned into a string
      read_and_clean # this runs the above function for each sheet 1 through 21
    ) %>%
    bind_rows() %>% # this turns the 21 list elements created above into a single dataframe
    filter(!is.na(icd_10)) %>% # this gets rid of the empty rows created by reading in too many rows just in case
    filter(!is.na(year)) %>%
    filter(!is.na(sex)) %>%
    filter(!is.na(age))

cod_long


# Save this


cod_long %>%
  write_rds(here("data-processed", "cod_long.rds"))



##############################################################################

# Next step is to look at the structure of the excel (xlsx or xls) files and
# see how to extract them to tidy format

# For each excel workbook, want to
# 1) identify the relevant worksheets
# 2) read in each of the relevant sheets within a workbook
# 3) bind them together
#
workbook_dir <- here("data-raw", "deaths-cause")
workbook_dir_files <- dir(workbook_dir)

#
# relevant_sheet_mtrx <- readxl::excel_sheets(here(workbook_dir, workbook_dir_files[[1]])) %>%
#   str_match("(icd\\d)_(\\d*)")
#
# relevant_sheets <- relevant_sheet_mtrx[,1]
# relevant_sheets <- relevant_sheets[!is.na(relevant_sheets)]
#
# relevant_class <- relevant_sheet_mtrx[,2]
# relevant_class <- relevant_class[!is.na(relevant_class)]

# readxl::read_excel(
#   here(workbook_dir, workbook_dir_files[[1]]),
#   sheet = relevant_sheets[1]
# )
#
# readxl::read_excel(
#   here(workbook_dir, workbook_dir_files[[1]]),
#   sheet = relevant_sheets[2]
# )
#
# readxl::read_excel(
#   here(workbook_dir, workbook_dir_files[[1]]),
#   sheet = relevant_sheets[3]
# )

# then to do all three at once
find_load_and_bind_sheets_in_wb <- function(loc){

  relevant_sheet_mtrx <- readxl::excel_sheets(loc) %>%
    str_match("(icd\\d)_(\\d*)")

  relevant_sheets <- relevant_sheet_mtrx[,1]
  relevant_sheets <- relevant_sheets[!is.na(relevant_sheets)]

  relevant_class <- relevant_sheet_mtrx[,2]
  relevant_class <- relevant_class[!is.na(relevant_class)]
  relevant_class <- unique(relevant_class)

  df <-
    map(
      relevant_sheets,
      function(x){
        readxl::read_excel(
          loc,
          sheet = x
        )
      }
    ) %>%
    bind_rows() %>%
    mutate(icd_version = relevant_class) %>%
    select(icd_version, everything())

  df
}

# find_load_and_bind_sheets_in_wb(here(workbook_dir, workbook_dir_files[[4]]))

# Generalise one level further still
deaths_coded_long_term <-
  map(
    here(workbook_dir, workbook_dir_files), find_load_and_bind_sheets_in_wb
  ) %>%
  bind_rows() %>%
  mutate(
    code = coalesce(ICD_7, ICD_8, ICD_9)
  ) %>%
  select(icd_version, code, sex, yr, age, ndths) %>%
  mutate(
    yr = as.numeric(yr),
    sex = case_when(
      sex == '1' ~ 'male',
      sex == '2' ~ 'female',
      TRUE ~ NA_character_
    ),
    age = factor(
      age,
      levels = c(
        "<1",
        "01-04",
        "05-09",
        "10-14",
        "15-19",
        "20-24",
        "25-29",
        "30-34",
        "35-39",
        "40-44",
        "45-49",
        "50-54",
        "55-59",
        "60-64",
        "65-69",
        "70-74",
        "75-79",
        "80-84",
        "85+"
      ), ordered = TRUE
    )
  )
# Now to save this

write_rds(deaths_coded_long_term, here("data-processed", "enw_deaths_coded_longterm.rds"))


# And now let's combine the two causes of death tables for a complete series, and give
# it a more informative names

cod_from_2001 <- read_rds(here('data-processed/cod_long.rds')) %>%
  mutate(
    sex =
     case_when(
      sex == 1 ~ 'male',
      sex == 2 ~ 'female',
      TRUE ~ NA_character_
     )
  ) %>%
  mutate(icd_version = 'icd_10') %>%
  rename(code = icd_10) %>%
  select(icd_version, code, sex, year, age, number_of_deaths)

cod_to_2000 <- read_rds(here('data-processed/enw_deaths_coded_longterm.rds')) %>%
  rename(year = yr) %>%
  rename(number_of_deaths = ndths)

deaths_unexplained_other <-
  bind_rows(
    cod_to_2000 %>% mutate(age = as.character(age)),
    cod_from_2001 %>% mutate(age = as.character(age))
  ) %>%
  # We don't want ages up to 15
  filter(!(age %in% c('<1', 'Neonates', '01-04', '05-09', '10-14'))) %>%
  # We do want to identify the codes of most interest, which vary by icd_version
  mutate(
    code_of_interest = case_when(
      icd_version == 'icd7' & code %in% c('7950', '7953', '7955') ~ TRUE,
      icd_version == 'icd8' & code %in% c('7960', '7962', '7969') ~ TRUE,
      icd_version == 'icd9' & code %in% c('7997', '7998', '7999') ~ TRUE,
      icd_version == 'icd_10' & code %in% c('R98', 'R99')         ~ TRUE,
      TRUE ~ FALSE
    )
  ) %>%
  group_by(code_of_interest, sex, year, age) %>%
  summarise(number_of_deaths = sum(number_of_deaths)) %>%
  mutate(age = factor(age,
                      levels = c('15-19', '20-24', '25-29', '30-34', '35-39',
                                 '40-44', '45-49', '50-54', '55-59', '60-64',
                                 '65-69', '70-74', '75-79', '80-84', '85+'
                                 ),
                      ordered = TRUE)
  ) %>%
  ungroup() %>%
  pivot_wider(
    names_from = code_of_interest, values_from = number_of_deaths,
    values_fill = 0
  ) %>%
  pivot_longer(
    cols = c(`FALSE`, `TRUE`), names_to = 'code_of_interest', values_to = 'number_of_deaths'
  )


# Let's look at the counts graphically
deaths_unexplained_other %>%
  ggplot(aes(year, age, fill = number_of_deaths)) +
  facet_grid(sex ~ code_of_interest) +
  geom_tile()
# This is reassuring in showing that the unexplained deaths are just a
# very small proportion of all deaths

deaths_unexplained_other %>%
  filter(code_of_interest == 'TRUE') %>%
  ggplot(aes(year, age, fill = number_of_deaths)) +
  facet_wrap(~ sex) +
  geom_tile()
# This suggests that there has been an increasing number of deaths
# in upper-middle aged men especially in deaths which are categorised as unexplained
# There also does not appear to be a very substantial change in the values by icd chapter,
# with the possible exception of the transition from icd8 to icd9 (from 1979/1980)


# Now let's find the corresponding population sizes
death_rate_data <-
  dta_pop_long %>%
    filter(age != 'All Ages') %>%
    filter(sex != 'both') %>%
    mutate(age = str_remove(age, '\\+') %>% as.numeric()) %>%
    arrange(year) %>%
    mutate(age_group =
    cut(age,
      breaks = c(seq(15, 85, by = 5), 100),
      labels = c('15-19', '20-24', '25-29', '30-34', '35-39', '40-44', '45-49', '50-54', '55-59', '60-64', '65-69', '70-74', '75-79', '80-84', '85+'),
      ordered_result = TRUE
      )
    ) %>%
    filter(!is.na(age_group)) %>%
    group_by(sex, age_group, year) %>%
    summarise(pop_size = sum(value)) %>%
    ungroup() %>%
    right_join(
      deaths_unexplained_other,
      by = c('sex' = 'sex', 'year' = 'year', 'age_group' = 'age')
    ) %>%
    mutate(
      mort_rate = number_of_deaths / pop_size
    )

# Save this:

write_rds(death_rate_data, file = 'data-processed/death_rates_unexplained_other.rds')
# Visualise rates

death_rate_data %>%
  filter(code_of_interest == 'FALSE') %>%
  ggplot(aes(year, age_group, fill = mort_rate)) +
  facet_wrap(~ sex) +
  geom_tile()

death_rate_data %>%
  filter(code_of_interest == 'TRUE') %>%
  ggplot(aes(year, age_group, fill = mort_rate)) +
  facet_wrap(~ sex) +
  geom_tile()

# Logged
death_rate_data %>%
  filter(code_of_interest == 'FALSE') %>%
  ggplot(aes(year, age_group, fill = log(mort_rate))) +
  facet_wrap(~ sex) +
  geom_tile()

death_rate_data %>%
  filter(code_of_interest == 'TRUE') %>%
  ggplot(aes(year, age_group, fill = log(mort_rate))) +
  facet_wrap(~ sex) +
  geom_tile()





#################################################################################




#Now to do the same with the MYEB2 dataset

dta_pop_2001_plus <- read_csv('data-raw/population/MYEB2_detailed_components_of_change_for reconciliation_EW_(2021_geog21).csv')

dta_pop_2001_plus %>%
  mutate(
    sex = case_when(
      sex == 1 ~ 'female',
      sex == 2 ~ 'male',
      TRUE ~ NA_character_
    )
  ) %>% view()
  filter(country == 'E') %>%
  pivot_longer(
    population_2001:other_adjust_2021,
    names_to = c('type', 'year'),
    names_pattern = "(^.*)_(\\d{4})"
  )  %>%
  pivot_wider(
    names_from = type,
    values_from = value
  ) %>%

  replace_na(
    list(
      population = 0, births = 0, deaths = 0,
      internal_in = 0, internal_out = 0,
      international_in = 0, international_out = 0,
      unattrib = 0, special_change = 0, other_adjust = 0
    )
  ) %>%
  mutate(
    internal_net = ifelse(is.na(internal_net), internal_in - internal_out, internal_net),
    international_net = ifelse(is.na(international_net), international_in - international_out, international_net)
  ) %>%
  select(-ladcode21, -ladname21, -country) %>%
  group_by(sex, age, year) %>%
  summarise(across(everything(), sum))



# # Age is MESSY
#
# # Let's visualise which age categories exist for which years
#
# xtabs(~ age + yr, data = tmp) -> tmp2
# as.data.frame(tmp2) %>%
#   ggplot(aes(yr, age, fill = factor(Freq))) +
#   geom_tile()
#
# # Maybe it's good enough for the range of years of interest?
#
# xtabs(~ age + yr, data = tmp %>% filter(yr >= 1958)) -> tmp2
# as.data.frame(tmp2) %>%
#   ggplot(aes(yr, age, fill = factor(Freq))) +
#   geom_tile()
#
# # Yes! Within the range of interest the age categories are completely consistent!
#


