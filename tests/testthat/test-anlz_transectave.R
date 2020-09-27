test_that("Checking results for anlz_transectave", {

  transectocc <- anlz_transectocc(transect)
  results <- anlz_transectave(transectocc)
  results <- results[1, ]
  expect_equal(results, structure(list(yr = 1998, bay_segment = structure(5L, .Label = c("OTB",
                                                                                         "HB", "MTB", "LTB", "BCB"), class = "factor"), foest = 81.5079365079365,
                                       focat = structure(4L, .Label = c("red", "orange", "yellow",
                                                                        "green"), class = "factor")), row.names = c(NA, -1L), class = c("tbl_df",
                                                                                                                                        "tbl", "data.frame")))
})

test_that("Checking results for anlz_transectave, rev = T", {

  results <- anlz_transectave(transectocc, rev = T)
  results <- results[1, ]
  expect_equal(results, structure(list(yr = 1998, bay_segment = structure(1L, .Label = c("BCB",
                                                                                         "LTB", "MTB", "HB", "OTB"), class = "factor"), foest = 81.5079365079365,
                                       focat = structure(4L, .Label = c("red", "orange", "yellow",
                                                                        "green"), class = "factor")), row.names = c(NA, -1L), class = c("tbl_df",
                                                                                                                                        "tbl", "data.frame")))
})

