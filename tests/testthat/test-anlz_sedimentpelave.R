test_that("Checking anlz_sedimentpelave class", {
  result <- anlz_sedimentpelave(sedimentdata, yrrng = 2021)
  expect_is(result, 'tbl_df')
})
