transectocc <- anlz_transectocc(transect)

test_that("Checking show_transectsum plotly class", {
  result <- show_transectsum(transectocc, site = 'S3T10')
  expect_is(result, 'plotly')
})

test_that("Checking show_transectsum plotly class, abundance", {
  result <- show_transectsum(transectocc, site = 'S3T10', abund = T)
  expect_is(result, 'plotly')
})

test_that("Checking show_transectsum errors", {
  expect_error(show_transectsum(transectocc, site = 'asdf'))
  expect_error(show_transectsum(transectocc, site = 'S3T10', species = 'asdf'))
  expect_error(show_transectsum(transectocc, site = 'S3T1', species = 'Halophila spp.'))
})

test_that("Checking show_transectsum error for invalid color entry", {
  expect_error(show_transectsum(transectocc, site = 'S3T10', sppcol = 'red'))
})

test_that("Checking show_transectsum error for invalid year entry", {
  expect_error(show_transectsum(transectocc, site = 'S3T10', yrrng = c(2001, 2000)))
})

test_that("Checking show_transectsum error for no species at transect", {
  expect_error(show_transectsum(transectocc, site = 'S5T1', species = 'Caulerpa'))
})
