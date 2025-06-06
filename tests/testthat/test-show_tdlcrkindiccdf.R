test_that("Checking show_tdlcrkindiccdf class", {
  id <- cntdat$id[1]
  result <- show_tdlcrkindiccdf(id, cntdat, thrsel = TRUE, yr = 2024)
  expect_is(result, 'plotly')
})
test_that("Checking show_tdlcrkindiccdf empty data", {
  result <- show_tdlcrkindiccdf('xxxxxxx', cntdat, thrsel = TRUE, yr = 2024)
  expect_null(result)
})


