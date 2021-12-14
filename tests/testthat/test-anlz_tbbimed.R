test_that("Checking results for anlz_tbbimed", {

  results <- anlz_tbbimed(tbbiscr)
  results <- results[1, ]
  expect_equal(results, structure(list(bay_segment = structure(8L, .Label = c("OTB", "HB",
                                                                              "MTB", "LTB", "TCB", "MR", "BCB", "All", "All (wt)"), class = "factor"),
                                       yr = 1993, Degraded = 0.3, Healthy = 0.244444444444444, Intermediate = 0.455555555555556,
                                       TBBICat = structure(1L, .Label = c("Poor", "Fair", "Good"
                                       ), class = "factor")), row.names = c(NA, -1L), groups = structure(list(
                                         .rows = structure(list(1L), ptype = integer(0), class = c("vctrs_list_of",
                                                                                                   "vctrs_vctr", "list"))), row.names = c(NA, -1L), class = c("tbl_df",
                                                                                                                                                              "tbl", "data.frame")), class = c("rowwise_df", "tbl_df", "tbl",
                                                                                                                                                                                               "data.frame")))
})

test_that("Checking results for anlz_tbbimed, rev = T", {

  results <- anlz_tbbimed(tbbiscr, rev = T)
  results <- results[1, ]
  expect_equal(results, structure(list(bay_segment = structure(2L, .Label = c("All (wt)",
                                                                              "All", "BCB", "MR", "TCB", "LTB", "MTB", "HB", "OTB"), class = "factor"),
                                       yr = 1993, Degraded = 0.3, Healthy = 0.244444444444444, Intermediate = 0.455555555555556,
                                       TBBICat = structure(1L, .Label = c("Poor", "Fair", "Good"
                                       ), class = "factor")), row.names = c(NA, -1L), groups = structure(list(
                                         .rows = structure(list(1L), ptype = integer(0), class = c("vctrs_list_of",
                                                                                                   "vctrs_vctr", "list"))), row.names = c(NA, -1L), class = c("tbl_df",
                                                                                                                                                              "tbl", "data.frame")), class = c("rowwise_df", "tbl_df", "tbl",
                                                                                                                                                                                               "data.frame")))

})

