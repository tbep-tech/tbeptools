test_that("Check output class from read_importwqp, water quality", {

  result <- try({read_importwqp(org = '21FLMANA_WQX', type = 'wq', trace = T)})
  skip_if(inherits(result, 'try-error'), message = 'Skipping read_importwqp test')
  expect_s3_class(result, 'tbl_df')

})

test_that("Check output class from read_importwqp, fib", {

  result <- try({read_importwqp(org = '21FLMANA_WQX', type = 'fib', trace = T)})
  skip_if(inherits(result, 'try-error'), message = 'Skipping read_importwqp test')
  expect_s3_class(result, 'tbl_df')

})

test_that("Error no data for a location", {

  expect_error(read_importwqp(org = '21FLPASC_WQX', type = 'wq', trace = F), "No data")

})

test_that("Warning for no specified datum", {

  expect_warning(read_importwqp(org = '21FLPOLK_WQX', type = 'fib', trace = F),
                 "Missing datum information present for some stations, converted to EPSG 4326"
                 )

})

