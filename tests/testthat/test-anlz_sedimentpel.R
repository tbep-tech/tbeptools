test_that("Checking anlz_sedimentpel class", {
  result <- anlz_sedimentpel(sedimentdata, yrrng = 2022)
  expect_is(result, 'tbl_df')
})
