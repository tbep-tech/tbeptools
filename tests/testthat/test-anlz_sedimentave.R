test_that("Checking anlz_sedimentave class", {
  result <- anlz_sedimentave(sedimentdata, param = 'Arsenic', yrrng = 2022)
  expect_is(result, 'tbl_df')
})
