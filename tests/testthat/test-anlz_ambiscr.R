test_that("anlz_ambiscr returns expected columns for standard AMBI", {

  expect_true(all(c('StationID', 'AreaAbbr', 'yr', 'TotalGroupCount',
                     'PercentG1', 'PercentG2', 'PercentG3', 'PercentG4', 'PercentG5',
                     'BC', 'AMBI', 'AMBICat', 'SitePollutionClassification',
                     'BioticIndex', 'DominatingEcologicalGroup', 'BenthicCommunityHealth')
                   %in% names(ambiscr)))

})

test_that("anlz_ambiscr standard AMBI has AMBI column, not TBAMBI", {

  expect_true('AMBI' %in% names(ambiscr))
  expect_false('TBAMBI' %in% names(ambiscr))

})

test_that("anlz_ambiscr AMBI-TB has TBAMBI column, not AMBI", {

  expect_true('TBAMBI' %in% names(ambiscr_tb))
  expect_false('AMBI' %in% names(ambiscr_tb))

})

test_that("anlz_ambiscr row 1000 matches expected values", {

  result <- ambiscr[1000, ]
  expect_equal(result, structure(list(StationID = 1759L, StationNumber = "03HR187",
    AreaAbbr = "HR", FundingProject = "Rivers", ProgramID = 4L,
    ProgramName = "Benthic Monitoring", Latitude = 27.99773,
    Longitude = -82.467567, date = structure(12290, class = "Date"),
    yr = 2003, TotalGroupCount = 10L, PercentG1 = 0, PercentG2 = 50,
    PercentG3 = 30, PercentG4 = 20, PercentG5 = 0, BC = 2.55,
    AMBI = 6.36, SitePollutionClassification = "Slightly Polluted",
    BioticIndex = "2", DominatingEcologicalGroup = "Group III",
    BenthicCommunityHealth = "Unbalanced", AMBICat = "Slightly Polluted"),
    row.names = c(NA, -1L), class = c("tbl_df", "tbl", "data.frame")))

})

test_that("anlz_ambiscr AMBI-TB row 1000 matches expected values", {

  result <- ambiscr_tb[1000, ]
  expect_equal(result, structure(list(StationID = 1759L, StationNumber = "03HR187",
    AreaAbbr = "HR", FundingProject = "Rivers", ProgramID = 4L,
    ProgramName = "Benthic Monitoring", Latitude = 27.99773,
    Longitude = -82.467567, date = structure(12290, class = "Date"),
    yr = 2003, TotalGroupCount = 13L, PercentG1 = 7.69230769230769,
    PercentG2 = 46.1538461538462, PercentG3 = 15.3846153846154,
    PercentG4 = 0, PercentG5 = 30.7692307692308, BC = 3, TBAMBI = 5.71,
    SitePollutionClassification = "Slightly Polluted", BioticIndex = "2",
    DominatingEcologicalGroup = "Group III", BenthicCommunityHealth = "Unbalanced",
    TBAMBICat = "Slightly Polluted"),
    row.names = c(NA, -1L), class = c("tbl_df", "tbl", "data.frame")))

})

test_that("anlz_ambiscr azoic stations get BC = 7, score = 0, and Azoic categories", {

  azoic <- ambiscr[!is.na(ambiscr$BC) & ambiscr$BC == 7, ]
  expect_true(nrow(azoic) > 0)
  expect_true(all(azoic$AMBI == 0))
  expect_true(all(azoic$TotalGroupCount == 0L))
  expect_true(all(azoic$AMBICat == 'Azoic'))
  expect_true(all(azoic$SitePollutionClassification == 'Azoic'))

})

test_that("anlz_ambiscr BC is within the valid range [0, 7]", {

  bc <- ambiscr$BC[!is.na(ambiscr$BC)]
  expect_true(all(bc >= 0 & bc <= 7))

})

test_that("anlz_ambiscr rejects an unrecognised type argument", {

  expect_error(anlz_ambiscr(benthicdata, type = 'invalid'))

})
