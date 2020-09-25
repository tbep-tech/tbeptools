test_that("Checking show_transect class", {
  result <- show_transect(transect, site = 'S3T10')
  expect_is(result, 'ggplot')
})

test_that("Checking show_transect error for invalid site", {
  expect_error(show_transect(transect, site = 'asdf'))
})

test_that("Checking show_transect error for invalid site", {
  expect_error(show_transect(transect, site = 'S3T2', species = 'Halophila', varplo = 'Abundance'))
})
