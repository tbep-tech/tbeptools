test_that("Checking read_formtransct", {

  # actual transect data
  url <- 'http://dev.seagrass.wateratlas.usf.edu/api/assessments/all__use-with-care'
  jsn <- jsonlite::fromJSON(url)
  result <- read_formtransect(jsn)
  expect_is(result, 'tbl_df')

  # training transect data
  url <- 'http://dev.seagrass.wateratlas.usf.edu/api/assessments/training'
  jsn <- fromJSON(url)
  result <- read_formtransect(jsn, training = TRUE)
  expect_is(result, 'tbl_df')

})
