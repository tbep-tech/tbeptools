test_that("Checking results for anlz_tbbimed", {
  tbbiscr <- anlz_tbbiscr(benthicdata)
  results <- anlz_tbbimed(tbbiscr)
  results <- results[nrow(results), ]
  expect_equal(results, structure(list(bay_segment = structure(5L, .Label = c("HB", "OTB",
                                                                              "MTB", "LTB", "TCB", "MR", "BCB"), class = "factor"), yr = 2018,
                                       TBBI = 90.98, TBBICat = structure(3L, .Label = c("Poor",
                                                                                        "Fair", "Good"), class = "factor")), row.names = c(NA, -1L
                                                                                        ), class = c("tbl_df", "tbl", "data.frame")))
})

test_that("Checking results for anlz_tbbimed, rev = T", {
  tbbiscr <- anlz_tbbiscr(benthicdata)
  results <- anlz_tbbimed(tbbiscr, rev = T)
  results <- results[nrow(results), ]
  expect_equal(results, structure(list(bay_segment = structure(3L, .Label = c("BCB",
                                                                              "MR", "TCB", "LTB", "MTB", "OTB", "HB"), class = "factor"), yr = 2018,
                                       TBBI = 90.98, TBBICat = structure(3L, .Label = c("Poor",
                                                                                        "Fair", "Good"), class = "factor")), row.names = c(NA, -1L
                                                                                        ), class = c("tbl_df", "tbl", "data.frame")))
})

