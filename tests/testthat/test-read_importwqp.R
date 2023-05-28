test_that("Check output class from read_importwqp", {

  result <- read_importwqp(org = 'Manatee', trace = T)
  expect_s3_class(result, 'tbl_df')

})
