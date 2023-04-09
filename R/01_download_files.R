# # Download files
# # Jon Minton
#
# # This script will download the files required for the project into the data-raw directory
#
# # More specifically, it will add required contents to the data-raw directory.
# # The data-raw directory should not be modified directly, and will not be copied over by
# # git/github, as it is .gitignored
#
# library(tidyverse)
# library(here) # for setting paths relative to base directory, regardless of where
# # the script calling the code is stored
# library(readxl)
#
#
# ################################################################################
# ########## README.MD MATERIALS #################################################
# ################################################################################
#
# ### Deaths at home
#
# # The data are below. First link is preferrable; combined excel provided separately.
# #
# # - [Deaths at home 2006-2021](https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/deathsregisteredinenglandandwalesseriesdrreferencetables)
# # - [Weekly datasets, not all included but has 2022 if needed, deaths at home](https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales)
# #
# # ### Deaths R98 and R99 (and prior ICD codes)
# # - [Deaths by age, sex, and cause (extract R98 and R99), 2001-2021, ONS](https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/the21stcenturymortalityfilesdeathsdataset)
# # - [Deaths by age, sex, and cause (extract specific ICD codes only), 1958-2000](https://webarchive.nationalarchives.gov.uk/ukgwa/20160111174808/http://www.ons.gov.uk/ons/publications/re-reference-tables.html?edition=tcm%3A77-215593)
# #
# # ### Population by age and sex
# # -	[Mid-year population estimates for England and Wales, by age and sex, 2001-2021 ONS](https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/populationestimatesforukenglandandwalesscotlandandnorthernireland)
# # -	[Population estimates and deaths by age, sex and cause, 1970-2021, ONS](https://webarchive.nationalarchives.gov.uk/ukgwa/20160111174808/http://www.ons.gov.uk/ons/publications/re-reference-tables.html?edition=tcm%3A77-215593)
# # - [Population estimates by age and sex, mid-1981 to mid-2021](https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/populationestimatesforukenglandandwalesscotlandandnorthernireland)
# # - [Populations 1901-2000 by age group and sex, E&W](https://webarchive.nationalarchives.gov.uk/ukgwa/20160111174808/http:/www.ons.gov.uk/ons/publications/re-reference-tables.html?edition=tcm:77-215593) see here [specific link](https://webarchive.nationalarchives.gov.uk/ukgwa/20160111174808mp_/http://www.ons.gov.uk/ons/rel/subnational-health1/the-20th-century-mortality-files/20th-century-deaths/populations-1901-2000.xls)
# #
#
#
#
#
#
# ################################################################################
# ################################################################################
#
#
#
#
#
# # first we check the data-raw directory exists. If it does not, create it.
#
# if (dir.exists(here("data-raw"))){
#   message("The data-raw dir exists. Nothing to do")
# } else {
#   message("The data-raw dir does not exist. Creating it")
#   dir.create(here("data-raw"))
# }
#
#
# # There are eight collections of files to download:
# # ### Deaths at home
# # - [Deaths at home 2006-2021](https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/deathsregisteredinenglandandwalesseriesdrreferencetables)
# # - [Weekly datasets, not all included but has 2022 if needed, deaths at home](https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales)
# #
# # ### Deaths R98 and R99 (and prior ICD codes)
# # - [Deaths by age, sex, and cause (extract R98 and R99), 2001-2021, ONS](https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/the21stcenturymortalityfilesdeathsdataset)
# # - [Deaths by age, sex, and cause (extract specific ICD codes only), 1958-2000](https://webarchive.nationalarchives.gov.uk/ukgwa/20160111174808/http://www.ons.gov.uk/ons/publications/re-reference-tables.html?edition=tcm%3A77-215593)
# #
# # ### Population by age and sex
# # -	[Mid-year population estimates for England and Wales, by age and sex, 2001-2021 ONS](https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/populationestimatesforukenglandandwalesscotlandandnorthernireland)
# # -	[Population estimates and deaths by age, sex and cause, 1970-2021, ONS](https://webarchive.nationalarchives.gov.uk/ukgwa/20160111174808/http://www.ons.gov.uk/ons/publications/re-reference-tables.html?edition=tcm%3A77-215593)
# # - [Population estimates by age and sex, mid-1981 to mid-2021](https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/populationestimatesforukenglandandwalesscotlandandnorthernireland)
# # - [Populations 1901-2000 by age group and sex, E&W](https://webarchive.nationalarchives.gov.uk/ukgwa/20160111174808/http:/www.ons.gov.uk/ons/publications/re-reference-tables.html?edition=tcm:77-215593) see here [specific link](https://webarchive.nationalarchives.gov.uk/ukgwa/20160111174808mp_/http://www.ons.gov.uk/ons/rel/subnational-health1/the-20th-century-mortality-files/20th-century-deaths/populations-1901-2000.xls)
# #
#
# # The purpose of this script will be to download all files implied in the above
# # in a standardised way
#
# # The purpose of the 02 script will be to process these downloaded files to produce
# # contents for the data-processed subdirectory
#
# # To do this in a way that allows me to avoid getting lost in the code and links
# # I'm going to try to produce a single mega-table with all requisite information
#
#
# # I've decided to create this mega-table as an excel worksheet to make it easier to edit and view
#
# urls_megatable <- readxl::read_excel(here("utils", "all_file_info.xlsx"), sheet = 'links_and_descriptions')
#
# # I want to consolidate a lot of previously written code into a single function that takes the above
# # and downloads one row at a time
#
# download_all_urls_to_data_raw <- function(df, basedir = here("data-raw")){
#
#   message("looking for subdirs to populate")
#   distinct_subdirs <- unique(df$subdir)
#   start_time <- Sys.time()
#
#   N <- length(distinct_subdirs)
#   for (i in 1:N){
#     this_subdir <- here(basedir, distinct_subdirs[i])
#     message("Searching for ", this_subdir)
#
#     if(dir.exists(this_subdir)){
#       message("Found ", this_subdir)
#     } else {
#       message("Not found ", this_subdir)
#       message("Creating ", this_subdir)
#       dir.create(this_subdir, recursive = TRUE)
#     }
#   }
#
#   N <- nrow(df)
#
#   message("There are ", N, " files in the table to download")
#
#   for (i in 1:N){
#     message("File ", i, " of ", N)
#     this_url <- df$url[i]
#     this_subdir <- df$subdir[i]
#     this_filename <- str_extract(this_url, "[^\\/]*\\.(?:zip|xls|xlsx)$")
#     message("Implied filename: ", this_filename)
#     message("Subdirectory to use: ", this_subdir )
#     message("Downloading now")
#     destfile <- here(basedir, this_subdir, this_filename)
#
#     download.file(this_url, destfile = destfile, mode = "wb")
#     # mode = wb writes as binary file: very important for anything other than text files
#     rm(this_url, destfile)
#
#   }
#   end_time <- Sys.time()
#
#   time_taken <- end_time - start_time
#   summary_info <- paste0(
#     "This function downloaded ", N,
#     " files in ", round(as.numeric(time_taken, units = 'mins'), 1),
#     " minutes"
#   )
#   message(summary_info)
#   summary_info
# }
#
# download_all_urls_to_data_raw(urls_megatable)
#
# ################################################################################
#
# # The next step is to identify all zipped files and unzip them in situ
#
# unzip_all_zip_files <- function(basedir = here("data-raw")){
#   start_time <- Sys.time()
#   message("Searching for zip files in ", basedir)
#   zipped_files_found <-  list.files(
#     basedir,
#     pattern = "\\.zip$",
#     recursive = TRUE,
#     include.dirs = TRUE
#   )
#   subdirs <- zipped_files_found %>% str_extract(pattern = "^[^\\/]*")
#
#   N <- length(zipped_files_found)
#   message("A total of ", N, " zipped files were found")
#
#   for (i in 1:N){
#     this_zipped_file <- zipped_files_found[i]
#     message("unzipping ", this_zipped_file)
#     unzip(here(basedir, this_zipped_file), exdir = here(basedir, subdirs[i]))
#   }
#   end_time <- Sys.time()
#   time_taken <- end_time - start_time
#   summary_info <- paste0(
#     "This function unzipped ", N,
#     " files in ", round(as.numeric(time_taken, units = 'mins'), 1),
#     " minutes"
#   )
#   message(summary_info)
#   summary_info
# }
#
# unzip_all_zip_files()
# # Deaths at home 2010-2021
# # Mid-year population estimates for England and Wales, by age and sex, 2001-2021 ONS
# # Deaths by age, sex, and cause (extract only R99), 2001-2021, ONS
# # Population estimates and deaths by age, sex and cause, 1970-2021, ONS
#
# # We'll go and download each of the files in turn
# ## Deaths at home
# # The link to the webpage:
# # https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales
# #
# # # For this each year's data are in separate files. These are as follows
# #
# # weekly_deaths_2010_2022_files <- tribble(
# #   ~year, ~link,
# #   2022, "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2022/publicationfileweek522022.xlsx",
# #   2021, "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2021/publishedweek522021.xlsx",
# #   2020, "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2020/publishedweek532020.xlsx",
# #   2019, "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2019/publishedweek522019.xls",
# #   2018, "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2018/publishedweek522018withupdatedrespiratoryrow.xls",
# #   2017, "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2017/publishedweek522017.xls",
# #   2016, "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2016/publishedweek522016.xls",
# #   2015, "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2015/publishedweek2015.xls",
# #   2014, "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2014/publishedweek2014.xls",
# #   2013, "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2013/publishedweek2013.xls",
# #   2012, "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2012/publishedweek2012.xls",
# #   2011, "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2011/publishedweek2011.xls",
# #   2010, "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2010/publishedweek2010.xls"
# # )
# #
# # # Let's download these to a more clearly labelled subdirectory
# # if (dir.exists(here("data-raw", "deaths-enw-2010-2022"))){
# #   message("dir deaths-enw-2010-2022 exists. No need to create it")
# #   message("Checking and populating the directory with zipped files")
# #   if (length(dir(here("data-raw", "deaths-enw-2010-2022"))) == 0){
# #     message("The directory is empty. Populating it")
# #     relevant_links <- weekly_deaths_2010_2022_files
# #     N <- nrow(relevant_links)
# #     message("There are ", N, " files to download")
# #     for (i in 1:N){
# #       message("Downloading file for year ", relevant_links$year[[i]])
# #       file_url <- relevant_links$link[[i]]
# #       file_name <- str_extract(file_url, "[^\\/]*\\.xls?$")
# #       message("file name implied is ", file_name)
# #       destfile <- here("data-raw", "deaths-enw-2010-2022", file_name)
# #
# #       download.file(file_url, destfile = destfile, mode = "wb")
# #       # mode = wb writes as binary file: very important for anything other than text files
# #       rm(file_url, destfile)
# #
# #     }
# #   }
# # } else {
# #   message("directory not found. Creating it")
# #   dir.create(here("data-raw", "deaths-enw-2010-2022"), recursive = TRUE)
# # }
# #
# #
# #
# # ### Deaths at home
# #
# #
# #
# # # The data are below. First link is preferrable; combined excel provided separately.
# # #
# # # - [Deaths at home 2006-2021](https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/deathsregisteredinenglandandwalesseriesdrreferencetables)
# # # - [Weekly datasets, not all included but has 2022 if needed, deaths at home](https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales)
# #
# # deaths_at_home_2006_2021_links <- tribble(
# #
# #   ~year, ~notes, ~url,
# #   2021, "", "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/deathsregisteredinenglandandwalesseriesdrreferencetables/2021/dr2021.xlsx",
# #   2020, "", "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/deathsregisteredinenglandandwalesseriesdrreferencetables/2020/deathsregisteredinenglandandwales2020.xlsx",
# #   2019, "", "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/deathsregisteredinenglandandwalesseriesdrreferencetables/2019/finalreftables2019.xlsx",
# #   2018, "", "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/deathsregisteredinenglandandwalesseriesdrreferencetables/2018/referencetablesfinalv22.xlsx",
# #   2017, "", "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/deathsregisteredinenglandandwalesseriesdrreferencetables/2017/drtables17.xls",
# #   2016, "", "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/deathsregisteredinenglandandwalesseriesdrreferencetables/2016/drtables16.xls",
# #   2015, "", "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/deathsregisteredinenglandandwalesseriesdrreferencetables/2015/drtables15.xls",
# #   2014, "tables 1 to 4 and 6 to 14", "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/deathsregisteredinenglandandwalesseriesdrreferencetables/2015/drtables15.xls",
# #   2014, "table 5", "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/deathsregisteredinenglandandwalesseriesdrreferencetables/2014table5/table5causeofdeath_tcm77-422538.xls",
# #   2013, "tables 1 to 4 and 6 to 14", "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/deathsregisteredinenglandandwalesseriesdrreferencetables/2013tables1to4and6to14/tables14and614_tcm77-381969.xls",
# #   2013, "table 5", "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/deathsregisteredinenglandandwalesseriesdrreferencetables/2013table5/table5causeofdeath_tcm77-381967.xls",
# #   2012, "tables 1 to 4 and 6 to 14", "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/deathsregisteredinenglandandwalesseriesdrreferencetables/2012tables1to4and6to14/tables14and614_tcm77-331816.xls",
# #   2012, "table 5",  "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/deathsregisteredinenglandandwalesseriesdrreferencetables/2012table5/table5causeofdeath_tcm77-331820.xls",
# #   2011, "tables 1 to 4 and 6 to 15", "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/deathsregisteredinenglandandwalesseriesdrreferencetables/2011tables1to4and6to14/tables14and614_tcm77-285095.xls",
# #   2011, "table 5", "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/deathsregisteredinenglandandwalesseriesdrreferencetables/2011table5/table5causeofdeath_tcm77-285093.xls",
# #   2010, "tables 1 to 4 and 6 to 15", "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/deathsregisteredinenglandandwalesseriesdrreferencetables/2010tables1to4and6to14/tables14and614_tcm77-239849.xls",
# #   2010, "table 5", "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/deathsregisteredinenglandandwalesseriesdrreferencetables/2010table5/table5causeofdeath_tcm77-239861.xls",
# #   2009, "zip", "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/deathsregisteredinenglandandwalesseriesdrreferencetables/2009/data-tables--2009.zip",
# #   2008, "zip", "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/deathsregisteredinenglandandwalesseriesdrreferencetables/2008/data-tables--2008.zip",
# #   2007, "zip", "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/deathsregisteredinenglandandwalesseriesdrreferencetables/2007/data-tables--2007.zip",
# #   2006, "zip", "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/deathsregisteredinenglandandwalesseriesdrreferencetables/2006/data-tables--2006.zip"
# # )
# #
# #
# #
# # c20_enw_mort_pop_links <- tribble(
# #   ~filename, ~url, ~description, ~coverage, ~filetype, ~type,
# #
# #   "The 20th Century Mortality Files - 1958-1967 ICD7 (ZIP 2773Kb)",
# #     "https://webarchive.nationalarchives.gov.uk/ukgwa/20160111174808mp_/http://www.ons.gov.uk/ons/rel/subnational-health1/the-20th-century-mortality-files/20th-century-deaths/1958-1967-icd7.zip",
# #     "Number of deaths by sex, age group and underlying cause",
# #     "Coverage: England and Wales",
# #     "zip", "deaths",
# #
# #   "The 20th Century Mortality Files - 1968-1978 ICD8 (ZIP 2997Kb)",
# #     "https://webarchive.nationalarchives.gov.uk/ukgwa/20160111174808mp_/http://www.ons.gov.uk/ons/rel/subnational-health1/the-20th-century-mortality-files/20th-century-deaths/1968-1978-icd8.zip",
# #     "Number of deaths by sex, age group and underlying cause",
# #     "Coverage: England and Wales",
# #     "zip", "deaths",
# #
# #
# #   "The 20th Century Mortality Files - 1979-1984 ICD9a (ZIP 2439Kb)",
# #     "https://webarchive.nationalarchives.gov.uk/ukgwa/20160111174808mp_/http://www.ons.gov.uk/ons/rel/subnational-health1/the-20th-century-mortality-files/20th-century-deaths/1979-1984-icd9a.zip",
# #     "Number of deaths by sex, age group and underlying cause",
# #     "Coverage: England and Wales",
# #     "zip", "deaths",
# #
# #   "The 20th Century Mortality Files - 1985-1993 ICD9b (ZIP 2991Kb)",
# #     "https://webarchive.nationalarchives.gov.uk/ukgwa/20160111174808mp_/http://www.ons.gov.uk/ons/rel/subnational-health1/the-20th-century-mortality-files/20th-century-deaths/1985-1993-icd9b.zip",
# #     "Number of deaths by sex, age group and underlying cause",
# #     "Coverage: England and Wales",
# #     "zip", "deaths",
# #
# #
# #   "The 20th Century Mortality Files - 1994-2000 ICD9c (ZIP 2216Kb)",
# #     "https://webarchive.nationalarchives.gov.uk/ukgwa/20160111174808mp_/http://www.ons.gov.uk/ons/rel/subnational-health1/the-20th-century-mortality-files/20th-century-deaths/1994-2000-icd9c.zip",
# #     "Number of deaths by sex, age group and underlying cause",
# #     "Coverage: England and Wales",
# #     "zip", "deaths",
# #
# #
# #   "The 20th Century Mortality Files - Populations 1901-2000 (Excel sheet 294Kb)",
# #     "https://webarchive.nationalarchives.gov.uk/ukgwa/20160111174808mp_/http://www.ons.gov.uk/ons/rel/subnational-health1/the-20th-century-mortality-files/20th-century-deaths/populations-1901-2000.xls",
# #     "Population data by sex and age group",
# #     "Coverage: England and Wales",
# #     "xls", "population"
# # )
# #
# #
# # # # First task is to see if there's a subdirectory for the deaths
# # #
# # if (dir.exists(here("data-raw", "deaths-enw", "zipped"))){
# #   message("dir deaths-enw exists. No need to create it")
# #   message("Checking and populating the directory with zipped files")
# #   if (length(dir(here("data-raw", "deaths-enw", "zipped"))) == 0){
# #     message("The directory is empty. Populating it")
# #     relevant_links <- c20_enw_mort_pop_links %>% filter(type == "deaths")
# #     N <- nrow(relevant_links)
# #     message("There are ", N, " files to download")
# #     for (i in 1:N){
# #       message("Downloading file with name ", relevant_links$filename[[i]])
# #       file_url <- relevant_links$url[[i]]
# #       file_name <- str_extract(file_url, "[^\\/]*\\.zip?$")
# #       message("file name implied is ", file_name)
# #       destfile <- here("data-raw", "deaths-enw", "zipped", file_name)
# #
# #       download.file(file_url, destfile = destfile, mode = "wb")
# #       # mode = wb writes as binary file: very important for anything other than text files
# #       rm(file_url, destfile)
# #
# #     }
# #   }
# # } else {
# #   message("directory not found. Creating it")
# #   dir.create(here("data-raw", "deaths-enw", "zipped"), recursive = TRUE)
# # }
# #
# # # Next step is to unzip each file in zipped to an equivalent location in unzipped
# #
# # if (dir.exists(here("data-raw", "deaths-enw", "zipped"))){
# #   message("The folder with zipped files has been found")
# #
# #   if (dir.exists(here("data-raw", "deaths-enw", "unzipped"))){
# #     message("The equivalent unzipped folder has been found. No need to create")
# #
# #     if(length(dir(here("data-raw", "deaths-enw", "unzipped"))) == 0) {
# #       message("The unzipped directory is currently empty")
# #       message("Populating this directory")
# #
# #       zipped_file_locs <- dir(here("data-raw", "deaths-enw", "zipped"), full.names = TRUE)
# #
# #       if (length(zipped_file_locs) == 0){
# #         stop("There are no zipped files to unzip")
# #       } else {
# #         N <- length(zipped_file_locs)
# #         message("There are ", N, " files to unzip")
# #
# #         dest_dir <- here("data-raw", "deaths-enw", "unzipped")
# #         for (i in 1:N){
# #           this_sourcefile <- zipped_file_locs[[i]]
# #           message("Current sourcefile: ", this_sourcefile)
# #           unzip(this_sourcefile, exdir = dest_dir)
# #         }
# #       }
# #     } else {
# #       message("The unzipped directory is not empty")
# #       message("Clear the directory to repopulation from scratch")
# #     }
# #
# #   } else {
# #     message("The equivalent folder for unzipped files has not been found")
# #     message("Creating this folder")
# #     dir.create(here("data-raw", "deaths-enw", "unzipped"))
# #   }
# # }
# #
# #
# # #######################################################################
# #
# # # Let's now do the same sort of thing, but for population
# #
# # if (dir.exists(here("data-raw", "pop-enw"))){
# #   message("dir pop-enw exists. No need to create it")
# #   message("Checking and populating the directory with files")
# #   if (length(dir(here("data-raw", "pop-enw"))) == 0){
# #     message("The directory is empty. Populating it")
# #     relevant_links <- c20_enw_mort_pop_links %>% filter(type == "population")
# #     N <- nrow(relevant_links)
# #     message("There are ", N, " files to download")
# #     for (i in 1:N){
# #       message("Downloading file with name ", relevant_links$filename[[i]])
# #       file_url <- relevant_links$url[[i]]
# #       file_name <- str_extract(file_url, "[^\\/]*\\.xls?$")
# #       message("file name implied is ", file_name)
# #       destfile <- here("data-raw", "pop-enw", file_name)
# #
# #       download.file(file_url, destfile = destfile, mode = "wb")
# #       # mode = wb writes as binary file: very important for anything other than text files
# #       rm(file_url, destfile)
# #
# #     }
# #   }
# # } else {
# #   message("directory not found. Creating it")
# #   dir.create(here("data-raw", "pop-enw"), recursive = TRUE)
# # }
# #
# #
# # #######################################################################
# # #######################################################################
# #
# #
# # # Next step is to find all the deaths files and programmatically unzip to deaths-enw
# #
# #
# # c20_enw_mort_pop_links %>%
# #   filter(type == "deaths")
# #
# # # Link to the specific file:
# # # https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2022/publicationfileweek522022.xlsx
# #
# # ## midyear population estimates for England & Wales, by age and sex, 2001-2021 ONS
# #
# # # The link to the webpage:
# #
# # # https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/populationestimatesforukenglandandwalesscotlandandnorthernireland
# #
# # # Link to the specific file:
# #
# # # https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/populationestimatesforukenglandandwalesscotlandandnorthernireland/mid2020/ukpopestimatesmid2020on2021geography.xls
# #
# #
# # # The files should be downloaded to data-raw. Processed versions saved in data-processed
# #
# # # Deaths at home
# #
# # # if (file.exists(here("data-raw", "publicationfileweek522022.xlsx"))){
# # #   message("Deaths at home already downloaded")
# # # } else {
# # #   message("Deaths at home not downloaded")
# # #   message("Downloading the file now")
# # #   file_url <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2022/publicationfileweek522022.xlsx"
# # #   destfile <- here("data-raw", "publicationfileweek522022.xlsx")
# # #
# # #   download.file(file_url, destfile = destfile, mode = "wb")
# # #   # mode = wb writes as binary file: very important for anything other than text files
# # #   rm(file_url, destfile)
# # # }
# #
# # # These files will now be put in a separate subdirectory
# #
# # if (dir.exists(here("data-raw", "deaths-at-home"))){
# #   message("Deaths at home dir exists")
# #   message("Checking and populating the directory with excel files")
# #   if (length(dir(here("data-raw", "deaths-at-home"))) == 0){
# #     message("The directory is empty. Populating it")
# #     N <- nrow(weekly_deaths_files)
# #     message("There are ", N, " files to download")
# #     for (i in 1:N){
# #       message("Downloading file for ", weekly_deaths_files$year[[i]])
# #       file_url <- weekly_deaths_files$link[[i]]
# #       file_name <- str_extract(file_url, "[^\\/]*\\.xlsx?$")
# #       message("file name implied is ", file_name)
# #       destfile <- here("data-raw", "deaths-at-home", file_name)
# #
# #       download.file(file_url, destfile = destfile, mode = "wb")
# #       # mode = wb writes as binary file: very important for anything other than text files
# #       rm(file_url, destfile)
# #
# #     }
# #
# #   } else {
# #     message("There's already at least file in this directory.")
# #     message("Clear the directory to reinitiate download")
# #   }
# # } else {
# #   message("Deaths at home dir does not exist.")
# #   message("Creating deaths-at-home subdir")
# #   dir.create(here("data-raw", "deaths-at-home"))
# # }
# #
# #
# #
# # # Population estimates
# #
# # # The following contains population estimates from around 2001 onwards
# #
# # if (file.exists(here("data-raw", "ons_pop_estimates.xls"))){
# #   message("Population estimates for 2001+ already downloaded")
# # } else {
# #   message("Population estimates for 2001+ not downloaded")
# #   message("Downloading the file now")
# #   file_url <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/populationestimatesforukenglandandwalesscotlandandnorthernireland/mid2020/ukpopestimatesmid2020on2021geography.xls"
# #   destfile <- here("data-raw", "ons_pop_estimates_from_2001.xls")
# #
# #   download.file(file_url, destfile = destfile, mode = "wb")
# #   # mode = wb writes as binary file: very important for anything other than text files
# #   rm(file_url, destfile)
# # }
# #
# #
# #
# # ## Deaths by age, sex, and cause (extract only R99), 2001-2021, ONS
# #
# # # Causes of death
# #
# # # https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/the21stcenturymortalityfilesdeathsdataset
# #
# # # specific file (most recent version)
# #
# # # https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/the21stcenturymortalityfilesdeathsdataset/current/21stcmortality.xlsx
# #
# #
# # if (file.exists(here("data-raw", "ons_cod.xlsx"))){
# #   message("Cause of death dataset already downloaded")
# # } else {
# #   message("Cause of death dataset not downloaded")
# #   message("Downloading the file now")
# #   file_url <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/the21stcenturymortalityfilesdeathsdataset/current/21stcmortality.xlsx"
# #   destfile <- here("data-raw", "ons_cod.xlsx")
# #
# #   download.file(file_url, destfile = destfile, mode = "wb")
# #   rm(file_url, destfile)
# # }
# #
# #
# #
# # ## Population estimates and deaths by age, sex and cause, 1970-2021, ONS
# #
# # # Link to the page
# #
# # # https://webarchive.nationalarchives.gov.uk/ukgwa/20160111174808/http://www.ons.gov.uk/ons/publications/re-reference-tables.html?edition=tcm%3A77-215593
# #
# # # Let's discuss this before downloading, as there are multiple files to consider
# #
# # # I *think* we need
# #
# # # ICD8 - 1968-1978 https://webarchive.nationalarchives.gov.uk/ukgwa/20160111174808mp_/http://www.ons.gov.uk/ons/rel/subnational-health1/the-20th-century-mortality-files/20th-century-deaths/1968-1978-icd8.zip
# # # ICD9a - 1979-1984 https://webarchive.nationalarchives.gov.uk/ukgwa/20160111174808mp_/http://www.ons.gov.uk/ons/rel/subnational-health1/the-20th-century-mortality-files/20th-century-deaths/1979-1984-icd9a.zip
# # # ICD9b - 1985-1993 https://webarchive.nationalarchives.gov.uk/ukgwa/20160111174808mp_/http://www.ons.gov.uk/ons/rel/subnational-health1/the-20th-century-mortality-files/20th-century-deaths/1985-1993-icd9b.zip
# # # ICD9c - 1994-2000 https://webarchive.nationalarchives.gov.uk/ukgwa/20160111174808mp_/http://www.ons.gov.uk/ons/rel/subnational-health1/the-20th-century-mortality-files/20th-century-deaths/1994-2000-icd9c.zip
# # #
# # # Population 1901-2000 https://webarchive.nationalarchives.gov.uk/ukgwa/20160111174808mp_/http://www.ons.gov.uk/ons/rel/subnational-health1/the-20th-century-mortality-files/20th-century-deaths/populations-1901-2000.xls
# #
# #
# # # The first four of these are zip files, the first of which contains a single excel workbook, containing
# # # three relevant sheets: description, icd9_1, icd9_2.
# # # The information in the workbook confirms that male =1, female = 2
# #
# # # the last link is to an excel workbook directly
# #
# #
# #
# #
