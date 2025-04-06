dir_tif <- here::here('inst/prism')
zonal_csv <- file.path(dir_tif, "_zones.csv")

test_that("read_importprism returns correct structur", {

  result <- read_importprism(
    vars      = c("tdmean", "ppt"),
    date_beg  = as.Date("1981-01-01"),
    date_end  = as.Date("1981-01-02"),
    dir_tif   = dir_tif,
    sf_zones  = tbsegshed,
    fld_zones = "bay_segment",
    zonal_csv = zonal_csv,
    verbose = T
    )

  expect_type(result, "list")
  expect_true(length(result) > 0)

})

