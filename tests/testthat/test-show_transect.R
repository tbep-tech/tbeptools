test_that("Checking show_transect class", {
  result <- show_transect(transect, species = 'Halodule', site = 'S3T10')
  expect_is(result, 'ggplot')
})

test_that("Checking show_transect class, facet TRUE", {
  result <- show_transect(transect, site = 'S3T10', species = 'Halodule', facet = TRUE)
  expect_is(result, 'ggplot')
})

test_that("Checking show_transect plotly class", {
  result <- show_transect(transect, site = 'S3T10', species = 'Halodule', plotly = TRUE)
  expect_is(result, 'plotly')
})

test_that("Checking show_transect error for invalid site", {
  expect_error(show_transect(transect, species = 'Halodule', site = 'asdf'))
})

test_that("Checking show_transect error for invalid site", {
  expect_error(show_transect(transect, site = 'S3T2', species = 'Halophila', varplo = 'Abundance'))
})

test_that("Checking show_transect error for invalid species", {
  expect_error(show_transect(transect, site = 'S3T2', species = 'Halophillllla', varplo = 'Abundance'))
})
