test_that("Check output class from read_importwqp", {

  result <- try({read_importwqp(org = 'Manatee', trace = T)})
  skip_if(inherits(result, 'try-error'), message = 'Skipping read_importwqp test')
  expect_s3_class(result, 'tbl_df')

})
