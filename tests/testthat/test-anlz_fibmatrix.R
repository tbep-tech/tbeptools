test_that("Checking anlz_fibmatrix tibble class", {
  result <- anlz_fibmatrix(fibdata)
  expect_is(result, 'tbl')
})

test_that("Checking anlz_fibmatrix station error", {
  expect_error(anlz_fibmatrix(fibdata, stas = '999'), regexp = 'Station(s) not found in fibdata: 999',
               fixed = T)
})

test_that("Checking anlz_fibmatrix station error insufficient data", {
  expect_error(anlz_fibmatrix(fibdata, stas = '616'), regexp = 'Stations with insufficient data for lagyr: 616',
               fixed = T)
})
