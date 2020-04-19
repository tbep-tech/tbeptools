test_that("Checking show_segplotly class", {
  result <- show_segplotly(epcdata)
  expect_is(result, 'plotly')
})

