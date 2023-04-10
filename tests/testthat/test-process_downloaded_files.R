test_that("can find directory of unprocessed files", {
  base_loc = here::here()
  expect_true("downloaded-files" %in% dir(base_loc))
})

test_that("can check for data-processed directory", {
  base_loc = here::here()
  # actual = !("data-processed" %in% base_loc)
  # expect_true(actual)
  actual = check_make_dir()
  expect_true(actual)
  # actual = ("data-processed" %in% base_loc)
  # expect_true(actual)
})

test_that("population files are processed", {
  actual = process_population_files()
  expect_true(actual)

})

test_that("cause of death files are processed", {
  actual = process_cause_of_deaths_files()
  expect_true(actual)
})
