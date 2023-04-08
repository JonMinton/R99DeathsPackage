
# SPECIFICATION
# - [ ] plot figure 1a: EASR oer time
# - [ ] plot figure 1b: EASR disaggregated by sex
# - [ ] plot figure 1c: partial EASR disaggregated by sex and broad age groups (19-59y, 60+?)
# - ensure vertical bars indicating changes in ICD versions
#


# DEPENDENCIES
#  - PACKAGES

pacman::p_load(tidyverse)

# - Internal functions

source("utils/calc_easr_by_explained_unexplained.R")


# RUNNING

# - get data

# Now set up to return a list of two DFs

# FIGURE 1A: EASRs over time (both sexes combined)
easrs_overall = calc_easr_by_groups(groupBySex = FALSE) %>%
  filter(code_of_interest == "TRUE") %>%
  select(-code_of_interest)

easrs_overall %>%
  ggplot(aes(x = year, y = easr)) +
  geom_line()

