test_that("Checking anlz_sedimentave class", {
  result <- anlz_sedimentave(sedimentdata, param = 'Arsenic', yrrng = 2021)
  expect_is(result, 'tbl_df')
})

test_that("Checking anlz_sedimentave sanity checks", {

  expect_error(anlz_sedimentave(sedimentdata, param = 'Arsenic', yrrng = c(1990, 2030)))
  expect_error(anlz_sedimentave(sedimentdata, param = 'Arsenic', yrrng = c(2001, 1994)))
  expect_error(anlz_sedimentave(sedimentdata, param = 'asdf', yrrng = c(1993, 2000)))
  expect_error(anlz_sedimentave(sedimentdata, param = 'Arsenic', bay_segment = 'asdf', yrrng = c(1993, 2000)))

})
