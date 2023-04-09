
#' Get megatables of URLs
#'
#' @param excel_workbook
#'
#' @return
#' @export
#'
#' @examples
get_urls_megatable <- function(
    excel_workbook = system.file("extdata", "all_file_info.xlsx", package = "R99DeathsPackage")
  ){
  message(dir("extdata"))
  return(
    readxl::read_excel(excel_workbook, sheet = 'links_and_descriptions')
  )
}

#' Download all URLS to raw data
#'
#' @param df
#' @param basedir
#'
#' @return
#' @export
#'
#' @examples
download_all_urls_to_data_raw <- function(df, basedir = "downloaded-files"){

  message("looking for subdirs to populate")
  distinct_subdirs <- unique(df$subdir)
  start_time <- Sys.time()

  N <- length(distinct_subdirs)
  for (i in 1:N){
    this_subdir <- here::here(basedir, distinct_subdirs[i])
    message("Searching for ", this_subdir)

    if(dir.exists(this_subdir)){
      message("Found ", this_subdir)
    } else {
      message("Not found ", this_subdir)
      message("Creating ", this_subdir)
      dir.create(this_subdir, recursive = TRUE)
    }
  }

  N <- nrow(df)

  message("There are ", N, " files in the table to download")

  for (i in 1:N){
    message("File ", i, " of ", N)
    this_url <- df$url[i]
    this_subdir <- df$subdir[i]
    this_filename <- stringr::str_extract(this_url, "[^\\/]*\\.(?:zip|xls|xlsx)$")
    message("Implied filename: ", this_filename)
    message("Subdirectory to use: ", this_subdir )
    message("Downloading now")
    destfile <- here::here(basedir, this_subdir, this_filename)

    download.file(this_url, destfile = destfile, mode = "wb")
    # mode = wb writes as binary file: very important for anything other than text files
    rm(this_url, destfile)

  }
  end_time <- Sys.time()

  time_taken <- end_time - start_time
  summary_info <- paste0(
    "This function downloaded ", N,
    " files in ", round(as.numeric(time_taken, units = 'mins'), 1),
    " minutes"
  )
  message(summary_info)
  summary_info
}


#' Unzip all zipped files
#'
#' @param basedir
#'
#' @return
#' @export
#'
#' @examples
unzip_all_zip_files <- function(basedir = here::here("downloaded-files")){
  start_time <- Sys.time()
  message("Searching for zip files in ", basedir)
  zipped_files_found <-  list.files(
    basedir,
    pattern = "\\.zip$",
    recursive = TRUE,
    include.dirs = TRUE
  )
  subdirs <- zipped_files_found %>% stringr::str_extract(pattern = "^[^\\/]*")

  N <- length(zipped_files_found)
  message("A total of ", N, " zipped files were found")

  for (i in 1:N){
    this_zipped_file <- zipped_files_found[i]
    message("unzipping ", this_zipped_file)
    unzip(here::here(basedir, this_zipped_file), exdir = here::here(basedir, subdirs[i]))
  }
  end_time <- Sys.time()
  time_taken <- end_time - start_time
  summary_info <- paste0(
    "This function unzipped ", N,
    " files in ", round(as.numeric(time_taken, units = 'mins'), 1),
    " minutes"
  )
  message(summary_info)
  summary_info
}


#' Download and unzip many files
#'
#' @return
#' @export
#'
#' @examples
download_and_unzip = function() {
  df_of_urls = get_urls_megatable()
  download_all_urls_to_data_raw(df_of_urls)
  unzip_all_zip_files()

  return (TRUE)
}
