test_that("Checking anlz_sedimentaddtot", {
  result <- anlz_sedimentaddtot(sedimentdata)
  expect_is(result, 'tbl_df')
})


test_that("Checking show_sedimentmap sanity checks", {

  expect_error(anlz_sedimentaddtot(sedimentdata, param = 'Arsenic', yrrng = c(1990, 2030)))
  expect_error(anlz_sedimentaddtot(sedimentdata, param = 'Arsenic', yrrng = c(2001, 1994)))
  expect_error(anlz_sedimentaddtot(sedimentdata, param = 'asdf', yrrng = c(1993, 2000)))
  expect_error(anlz_sedimentaddtot(sedimentdata, param = 'Arsenic', bay_segment = 'asdf'))
  expect_error(anlz_sedimentaddtot(sedimentdata, param = 'Arsenic', funding_proj = 'asdf'))

})
