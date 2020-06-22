test_that("Checking anlz_tbnimet, tbni metrics only", {

  # raw metric data
  dat <- anlz_tbnimet(fimdata)

  # get last row of data
  result <- dat[nrow(dat), ]
  expect_equal(result, structure(list(Reference = "TBM2019121309", Year = 2019, Month = 12,
                                      Season = "Winter", bay_segment = "MTB", NumTaxa = 5, Shannon = 0.727591345714938,
                                      TaxaSelect = 0, NumGuilds = 2, BenthicTaxa = 5), row.names = c(NA,
                                                                                                     -1L), class = c("tbl_df", "tbl", "data.frame"))
  )

})

test_that("Checking anlz_tbnimet, all metrics", {

  # raw metric data
  dat <- anlz_tbnimet(fimdata, all = T)

  # get last row of data
  result <- dat[nrow(dat), ]
  expect_equal(result, structure(list(Reference = "TBM2019121309", Year = 2019, Month = 12,
                                      Season = "Winter", bay_segment = "MTB", NumTaxa = 5, NumIndiv = 76,
                                      Shannon = 0.727591345714938, Simpson = 1.61974200785193,
                                      Pielou = 0.452077921175931, TaxaSelect = 0, NumGuilds = 2,
                                      TSTaxa = 5, TGTaxa = 0, BenthicTaxa = 5, PelagicTaxa = 0,
                                      OblTaxa = 5, MSTaxa = 2, ESTaxa = 3, SelectIndiv = 0, Taxa90 = 2,
                                      TSAbund = 76, TGAbund = 0, BenthicAbund = 76, PelagicAbund = 0,
                                      OblAbund = 76, ESAbund = 73, MSAbund = 3, Num_LR = 0, PropTG = 0,
                                      PropTS = 1, PropBenthic = 1, PropPelagic = 0, PropObl = 1,
                                      PropMS = 0.0394736842105263, PropES = 0.960526315789474,
                                      PropSelect = 0), row.names = c(NA, -1L), class = c("tbl_df",
                                                                                         "tbl", "data.frame"))
  )

})

