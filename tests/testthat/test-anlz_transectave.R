test_that("Checking results for anlz_transectave", {

  results <- anlz_transectave(transectocc)
  results <- results[1, ]
  expect_equal(results, structure(list(bay_segment = structure(1L, .Label = c("Tampa Bay",
                                                                              "OTB", "HB", "MTB", "LTB", "BCB"), class = "factor"), yr = 1998,
                                       foest = 58.0035143354157, focat = structure(2L, .Label = c("#EE7600",
                                                                                                           "#E9C318", "#2DC938", "#CC3231"), class = "factor")), class = c("grouped_df",
                                                                                                           "tbl_df", "tbl", "data.frame"), row.names = c(NA, -1L), groups = structure(list(
                                                                                                             bay_segment = structure(1L, .Label = c("Tampa Bay", "OTB",
                                                                                                                                                    "HB", "MTB", "LTB", "BCB"), class = "factor"), .rows = structure(list(
                                                                                                                                                      1L), ptype = integer(0), class = c("vctrs_list_of", "vctrs_vctr",
                                                                                                                                                                                         "list"))), class = c("tbl_df", "tbl", "data.frame"), row.names = c(NA,
                                                                                                                                                                                                                                                            -1L), .drop = TRUE)))

})

test_that("Checking results for anlz_transectave, rev = T", {

  results <- anlz_transectave(transectocc, rev = T)
  results <- results[1, ]
  expect_equal(results, structure(list(
    bay_segment = structure(1L, .Label = c("BCB", "LTB", "MTB", "HB", "OTB", "Tampa Bay"), class = "factor"),
    yr = 1998,
    foest = 81.031746031746,
    focat = structure(2L, .Label = c("#E9C318", "#2DC938", "#EE7600", "#CC3231"), class = "factor")),
    class = c("grouped_df", "tbl_df", "tbl", "data.frame"),row.names = c(NA, -1L),
    groups = structure(list(bay_segment = structure(1L, .Label = c("BCB", "LTB", "MTB", "HB", "OTB", "Tampa Bay"),
                                                    class = "factor"), .rows = structure(list(1L), ptype = integer(0),
                                                                                         class = c("vctrs_list_of", "vctrs_vctr", "list"))), class = c("tbl_df", "tbl", "data.frame"), row.names = c(NA, -1L), .drop = TRUE)))

})

