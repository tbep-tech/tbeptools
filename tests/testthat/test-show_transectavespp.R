test_that("Checking show_transectavespp ggplot class", {
  result <- show_transectavespp(transectocc, sppcol = rep('red', 6))
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

test_that("Checking show_transectavespp error for invalid color entry", {
  expect_error(show_transectavespp(transectocc, sppcol = 'red'))
})
