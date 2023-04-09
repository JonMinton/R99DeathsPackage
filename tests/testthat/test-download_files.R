test_that("The excel workbook of URLs for data files can be found and loaded", {
  actual = get_urls_megatable()

  expect_true("data.frame" %in% class(actual))
})


# test_that("Files can be downloaded from URLs", {
#   df_of_urls = get_urls_megatable()
#   download_all_urls_to_data_raw(df_of_urls)
#
#   expect_equal(list.files(here::here("downloaded-files", "deaths")) |> length(), 20L)
# })

test_that("Files downloaded can by unzipped where found", {
  actual = unzip_all_zip_files()

  expect_true("character" %in% class(actual))

})


test_that("download and unzip just 'works'", {
  expect_true(download_and_unzip())
})
