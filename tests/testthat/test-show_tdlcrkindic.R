test_that("Checking show_tdlcrkindic class", {
  id <- cntdat$id[1]
  result <- show_tdlcrkindic(id, cntdat, thrsel = TRUE, yr = 2024)
  expect_is(result, 'plotly')
})
test_that("Checking show_tdlcrkindic empty data", {
  result <- show_tdlcrkindic('xxxxxxx', cntdat, thrsel = TRUE, yr = 2024)
  expect_null(result)
})


