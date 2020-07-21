test_that("Checking anlz_trnjsn", {

  # actual transect data
  trnjsn <- read_trnjsn()
  result <- anlz_trnjsn(trnjsn)

  expect_is(result, 'tbl_df')

  # training transect data
  trnsjn <- read_trnjsn(training = TRUE)
  result <- anlz_trnjsn(trnjsn, training = TRUE)

  expect_is(result, 'tbl_df')

})
