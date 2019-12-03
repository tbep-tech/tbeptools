test_that("Checking read_formwq", {
  xlsx <- here::here('vignettes/2018_Results_Updated.xls')

  # load
  rawdat <- readxl::read_xlsx(xlsx, sheet="RWMDataSpreadsheet",
                              col_types = c("numeric", "numeric", "text", "text", "text", "text",
                                            "numeric", "numeric", "text", "numeric", "numeric",
                                            "text", "date", "text", "numeric", "text", "text",
                                            "numeric", "numeric", "numeric", "numeric", "text",
                                            "text", "text", "numeric", "text", "numeric", "text",
                                            "numeric", "text", "numeric", "text", "numeric",
                                            "text", "numeric", "text", "numeric", "text",
                                            "numeric", "text", "numeric", "text", "numeric",
                                            "text", "numeric", "text", "numeric", "text",
                                            "numeric", "text", "numeric", "text", "numeric",
                                            "text", "numeric", "text", "numeric", "text",
                                            "numeric", "text", "numeric", "text", "numeric",
                                            "text", "numeric", "text", "text", "text", "text",
                                            "text", "text", "text", "text", "text", "text",
                                            "text", "text", "text", "text", "text", "text",
                                            "text", "text", "text", "text", "text", "text",
                                            "text", "text", "text", "text", "text", "text",
                                            "text", "text", "text", "text", "text", "text",
                                            "text", "text", "text", "text", "text", "text",
                                            "text", "text", "text", "text", "text", "text",
                                            "text", "text", "text", "text", "text", "text",
                                            "text", "text", "text", "text", "text", "text",
                                            "text", "text", "text", "text", "text", "text",
                                            "text", "text", "text", "text", "text", "text",
                                            "text", "text", "text", "text", "text", "text",
                                            "text", "text", "text", "text", "text", "text",
                                            "text", "text", "text", "text", "text", "text",
                                            "text", "text", "text", "text", "text", "text",
                                            "text", "text", "text"),
                              na = '')

  # format names
  names(rawdat) <- gsub('\\r\\n', '_', names(rawdat))
  names(rawdat) <- gsub('/l$|/L$', 'L', names(rawdat))
  names(rawdat) <- gsub('/cm$', 'cm', names(rawdat))
  names(rawdat) <- gsub('/', '-', names(rawdat))
  names(rawdat) <- gsub('\\#\\-', 'num', names(rawdat))
  names(rawdat) <- gsub('\\(|\\)', '', names(rawdat))
  names(rawdat) <- gsub('\\%', 'pct', names(rawdat))
  names(rawdat) <- gsub('F\\s', '_F', names(rawdat))
  names(rawdat) <- gsub('C\\u', 'c\\u', names(rawdat))
  names(rawdat) <- gsub('^Nitrates$', 'Nitrates_mgL', names(rawdat))

  # format
  dat <- read_formwq(rawdat)

  # check if number of columns is equal to 11
  result <- ncol(dat)
  expect_equal(result, 11)

})
