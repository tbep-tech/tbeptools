test_that("Checking show_sedimentpelave class", {
  result <- show_sedimentpelave(sedimentdata, yrrng = 2022)
  expect_is(result, 'ggplot')
})

test_that("Checking show_sedimentpelave plotly class", {
  result <- show_sedimentpelave(sedimentdata, yrrng = 2022, plotly = T)
  expect_is(result, 'plotly')
})
