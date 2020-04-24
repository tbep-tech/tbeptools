test_that("Checking anlz_tbnimet, tbni metrics only", {

  # raw metric data
  dat <- anlz_tbnimet(fimdata)

  # get last row of data
  result <- dat[nrow(dat), ]
  expect_equal(result, structure(list(Reference = "TBM2018121305", Year = 2018, Month = 12,
                                      Season = "Winter", bay_segment = "LTB", NumTaxa = 1, Shannon = 0,
                                      TaxaSelect = 1, NumGuilds = 1, BenthicTaxa = 1), row.names = c(NA,
                                                                                                     -1L), class = c("tbl_df", "tbl", "data.frame")))

})

test_that("Checking anlz_tbnimet, all metrics", {

  # raw metric data
  dat <- anlz_tbnimet(fimdata, all = T)

  # get last row of data
  result <- dat[nrow(dat), ]
  expect_equal(result, structure(list(Reference = "TBM2018121305", Year = 2018, Month = 12,
                                      Season = "Winter", bay_segment = "LTB", NumTaxa = 1, NumIndiv = 8,
                                      Shannon = 0, Simpson = 1, Pielou = NaN, TaxaSelect = 1, NumGuilds = 1,
                                      TSTaxa = 1, TGTaxa = 0, BenthicTaxa = 1, PelagicTaxa = 0,
                                      OblTaxa = 0, MSTaxa = 1, ESTaxa = 0, SelectIndiv = 8, Taxa90 = 1,
                                      TSAbund = 8, TGAbund = 0, BenthicAbund = 8, PelagicAbund = 0,
                                      OblAbund = 0, ESAbund = 0, MSAbund = 8, Num_LR = 0, PropTG = 0,
                                      PropTS = 1, PropBenthic = 1, PropPelagic = 0, PropObl = 0,
                                      PropMS = 1, PropES = 0, PropSelect = 1), row.names = c(NA,
                                                                                             -1L), class = c("tbl_df", "tbl", "data.frame")))

})

