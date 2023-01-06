test_that("Checking anlz_sedimentpel class", {
  result <- anlz_sedimentpel(sedimentdata, yrrng = 2021)
  expect_is(result, 'tbl_df')
})

test_that("Checking anlz_sedimentpel sanity checks", {

  expect_error(anlz_sedimentpel(sedimentdata, yrrng = c(1990, 2030)))
  expect_error(anlz_sedimentpel(sedimentdata, yrrng = c(2001, 1994)))

})
