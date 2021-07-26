test_that("Checking anlz_tbnimet, tbni metrics only", {

  # raw metric data
  dat <- anlz_tbnimet(fimdata)

  # get last row of data
  result <- dat[1, ]
  expect_equal(result, structure(list(Reference = "TBM1998010906", Year = 1998, Month = 1,
                                      Season = "Winter", bay_segment = "OTB", NumTaxa = 2, Shannon = 0.362210557135449,
                                      TaxaSelect = 0, NumGuilds = 2, BenthicTaxa = 0), row.names = c(NA,
                                                                                                     -1L), class = c("tbl_df", "tbl", "data.frame"))
  )

})

test_that("Checking anlz_tbnimet, all metrics", {

  # raw metric data
  dat <- anlz_tbnimet(fimdata, all = T)

  # get last row of data
  result <- dat[1, ]
  expect_equal(result, structure(list(Reference = "TBM1998010906", Year = 1998, Month = 1,
                                      Season = "Winter", bay_segment = "OTB", NumTaxa = 2, NumIndiv = 17,
                                      Shannon = 0.362210557135449, Simpson = 1.26200873362445,
                                      Pielou = 0.522559374536941, TaxaSelect = 0, NumGuilds = 2,
                                      TSTaxa = 2, TGTaxa = 0, BenthicTaxa = 0, PelagicTaxa = 2,
                                      OblTaxa = 2, MSTaxa = 0, ESTaxa = 2, SelectIndiv = 0, Taxa90 = 2,
                                      TSAbund = 17, TGAbund = 0, BenthicAbund = 0, PelagicAbund = 17,
                                      OblAbund = 17, ESAbund = 17, MSAbund = 0, Num_LR = 0, PropTG = 0,
                                      PropTS = 1, PropBenthic = 0, PropPelagic = 1, PropObl = 1,
                                      PropMS = 0, PropES = 1, PropSelect = 0), row.names = c(NA,
                                                                                             -1L), class = c("tbl_df", "tbl", "data.frame"))
  )

})

