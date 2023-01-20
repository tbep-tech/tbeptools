test_that("Checking show_sedimentave class", {
  result <- show_sedimentave(sedimentdata, param = 'Arsenic', yrrng = 2021)
  expect_is(result, 'ggplot')
})

test_that("Checking show_sedimentave plotly class", {
  result <- show_sedimentave(sedimentdata, param = 'Arsenic', yrrng = 2021, plotly = T)
  expect_is(result, 'plotly')
})
