transectocc <- anlz_transectocc(transect)

test_that("Checking show_transectavespp ggplot class", {
  result <- show_transectavespp(transectocc)
  expect_is(result, 'ggplot')
})

test_that("Checking show_transectavespp plotly class", {
  result <- show_transectavespp(transectocc, plotly = T)
  expect_is(result, 'plotly')
})

test_that("Checking show_transectavespp reactable class", {
  result <- show_transectavespp(transectocc, asreact = T)
  expect_is(result, 'reactable')
})
