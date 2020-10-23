test_that("Checking anlz_tbbiscr", {

  tbbiscr <- anlz_tbbiscr(benthicdata)

  result <- tbbiscr[nrow(tbbiscr), ]
  expect_equal(result, structure(list(StationID = 12744L, AreaAbbr = "MTB", FundingProject = "TBEP",
                                      ProgramID = 18L, ProgramName = "Dredge Hole Study", Latitude = 27.822125,
                                      Longitude = -82.487685, date = structure(17247, class = "Date"),
                                      yr = 2017, TotalAbundance = 11075, SpeciesRichness = 31,
                                      TBBI = 88.01, TBBICat = "Healthy", Salinity = 28.87), row.names = c(NA,
                                                                                                          -1L), class = c("tbl_df", "tbl", "data.frame")))
})
