test_that("Checking read_formphyto", {
  xlsx <- 'phytodata.xlsx'

  # load
  rawdat <- readxl::read_xlsx(xlsx, na = c('', 'NULL'),
                              col_types = c("text", "text", "text", "text", "text", "text", "date", "text",
                                                           "text", "text", "text", "text", "text", "text", "text", "text",
                                                           "text", "text", "text", "text", "text", "text", "text", "text",
                                                           "text", "text")
  )

  # format
  dat <- read_formphyto(rawdat)


  # check if number of columns is equal to 11
  result <- ncol(dat)
  expect_equal(result, 8)

})
