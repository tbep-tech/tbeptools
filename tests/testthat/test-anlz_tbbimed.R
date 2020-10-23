test_that("Checking results for anlz_tbbimed", {
  tbbiscr <- anlz_tbbiscr(benthicdata)
  results <- anlz_tbbimed(tbbiscr)
  results <- results[nrow(results), ]
  expect_equal(results, structure(list(bay_segment = structure(5L, .Label = c("HB", "OTB",
                                                                              "MTB", "LTB", "TCB", "MR", "BCB", "All", "All (wt)"), class = "factor"),
                                       yr = 2018, Degraded = 0, Healthy = 0.666666666666667, Intermediate = 0.333333333333333,
                                       TBBICat = structure(3L, .Label = c("Poor", "Fair", "Good"
                                       ), class = "factor")), row.names = c(NA, -1L), groups = structure(list(
                                         .rows = structure(list(1L), ptype = integer(0), class = c("vctrs_list_of",
                                                                                                   "vctrs_vctr", "list"))), row.names = c(NA, -1L), class = c("tbl_df",
                                                                                                                                                              "tbl", "data.frame")), class = c("rowwise_df", "tbl_df", "tbl",
                                                                                                                                                                                               "data.frame")))
})

test_that("Checking results for anlz_tbbimed, rev = T", {
  tbbiscr <- anlz_tbbiscr(benthicdata)
  results <- anlz_tbbimed(tbbiscr, rev = T)
  results <- results[nrow(results), ]
  expect_equal(results, structure(list(bay_segment = structure(5L, .Label = c("All (wt)",
                                                                              "All", "BCB", "MR", "TCB", "LTB", "MTB", "OTB", "HB"), class = "factor"),
                                       yr = 2018, Degraded = 0, Healthy = 0.666666666666667, Intermediate = 0.333333333333333,
                                       TBBICat = structure(3L, .Label = c("Poor", "Fair", "Good"
                                       ), class = "factor")), row.names = c(NA, -1L), groups = structure(list(
                                         .rows = structure(list(1L), ptype = integer(0), class = c("vctrs_list_of",
                                                                                                   "vctrs_vctr", "list"))), row.names = c(NA, -1L), class = c("tbl_df",
                                                                                                                                                              "tbl", "data.frame")), class = c("rowwise_df", "tbl_df", "tbl",
                                                                                                                                                                                               "data.frame")))

})

