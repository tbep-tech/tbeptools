test_that("Checking read_formtransect", {

  # actual transect data
  url <- 'http://dev.seagrass.wateratlas.usf.edu/api/assessments/all__use-with-care'
  jsn <- jsonlite::fromJSON(url)
  result <- read_formtransect(jsn)
  expect_is(result, 'tbl_df')

  # raw actual transect data
  result <- read_formtransect(jsn, raw = TRUE)
  expect_is(result, 'tbl_df')

  # training transect data
  url <- 'http://dev.seagrass.wateratlas.usf.edu/api/assessments/training'
  jsn <- jsonlite::fromJSON(url)
  result <- read_formtransect(jsn, training = TRUE)
  expect_is(result, 'tbl_df')

  # raw training transect data
  result <- read_formtransect(jsn, training = TRUE, raw = TRUE)
  expect_is(result, 'tbl_df')

})
