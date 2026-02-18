test_that("Checking read_formtransect", {

  # actual transect data
  url <- 'https://tampabay.wateratlas.usf.edu/seagrass-transect-data-portal/api/assessments/all__use-with-care'
  jsn <- jsonlite::fromJSON(url)
  result <- read_formtransect(jsn)
  expect_is(result, 'tbl_df')

  # raw actual transect data
  result <- read_formtransect(jsn, raw = TRUE)
  expect_is(result, 'tbl_df')

  # training transect data
  url <- 'https://tampabay.wateratlas.usf.edu/seagrass-transect-data-portal/api/assessments/training'
  jsn <- jsonlite::fromJSON(url)
  result <- read_formtransect(jsn, training = TRUE)
  expect_is(result, 'tbl_df')

  # raw training transect data
  result <- read_formtransect(jsn, training = TRUE, raw = TRUE)
  expect_is(result, 'tbl_df')

})
