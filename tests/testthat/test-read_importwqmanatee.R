test_that("Check output class from read_importwqmanattee", {

  result <- read_importwqmanatee(trace = T)
  expect_s3_class(result, 'tbl_df')

})
