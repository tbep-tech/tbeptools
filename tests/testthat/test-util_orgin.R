test_that("Correct county returned by organization identifier", {
  result <- util_orgin('21FLMANA_WQX')
  expected <- 'Manatee'
  expect_equal(result, expected)
})

test_that("Correct station column name returned by organization identifier", {
  result <- util_orgin('21FLPDEM_WQX', stanm = TRUE)
  expected <- 'pinco_station'
  expect_equal(result, expected)
})
