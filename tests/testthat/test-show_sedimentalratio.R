test_that("Checking show_sedimentalratio sanity checks", {

  expect_error(show_sedimentalratio(sedimentdata, param = 'asdf'))
  expect_error(show_sedimentalratio(sedimentdata, param = 'Arsenic', yrrng = c(1990, 2030)))
  expect_error(show_sedimentalratio(sedimentdata, param = 'Arsenic', yrrng = c(2001, 1994)))
  expect_error(show_sedimentalratio(sedimentdata, param = 'asdf', yrrng = c(1993, 2000)))
  expect_error(show_sedimentalratio(sedimentdata, param = 'Arsenic', bay_segment = 'asdf'))
  expect_error(show_sedimentalratio(sedimentdata, param = 'Arsenic', funding_proj = 'asdf'))

})


test_that("Checking show_sedimentalratio class", {
  result <- show_sedimentalratio(sedimentdata, param = 'Arsenic', yrrng = 2023)
  expect_is(result, 'ggplot')
})

test_that("Checking show_sedimentalratio plotly class", {
  result <- show_sedimentalratio(sedimentdata, param = 'Arsenic', yrrng = 2023, plotly = T)
  expect_is(result, 'plotly')
})
