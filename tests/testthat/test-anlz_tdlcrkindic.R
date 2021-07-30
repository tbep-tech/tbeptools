test_that("Checking anlz_tdlcrkindic", {

  result <- cntdat %>%
    .[1, ]

  expect_equal(result, structure(list(id = 1L, name = "Rock Creek", JEI = "CC01", wbid = "2052",
                                      class = "3M", year = 2011, CHLAC = 1.3940221304312, COLOR = 3.3990193250105,
                                      COND = NA_real_, DO = 4.24981140613221, DOSAT = 58.2645671918945,
                                      NO23 = 0.00646784363808401, ORGN = NA_real_, SALIN = 33.6778477525267,
                                      TKN = 0.492777403969896, TN = 0.498142786625561, TP = 0.0583140416974018,
                                      TSS = NA_real_, TURB = 2.53237883401071, chla_tn_ratio = 2.79843885700798,
                                      tn_tp_ratio = 8.54241572227973, chla_tsi = 21.5835819028942,
                                      tn_tsi = 42.2020032461405, tn2_tsi = 44.6216423556016, tp_tsi = 57.2246782524562,
                                      tp2_tsi = 72.1538928364498, nut_tsi = 44.6216423556016, tsi = 33.1026121292479,
                                      no23_source = NA_real_, no23_tidal = NA_real_, no23_ratio = NA_real_,
                                      do_bnml = 0, do_prop = 0), row.names = 1L, class = "data.frame"))

})


test_that("Checking anlz_tdlcrkindic radar plot output", {

  result <- cntdatrdr %>%
    .[1:6, ]

  expect_equal(result, structure(list(id = c(1L, 1L, 1L, 1L, 1L, 1L),
                                      JEI = c("CC01","CC01", "CC01", "CC01", "CC01", "CC01"),
                                      wbid = c("2052", "2052", "2052", "2052", "2052", "2052"),
                                      var = c("ch_tn_rat_ind", "chla_ind", "do_prop", "nox_ind", "tn_ind", "tsi_ind"),
                                      val = c(0, 0, 60, NaN, 0, 0)), row.names = c(NA, -6L), class = c("tbl_df", "tbl", "data.frame")))

})


