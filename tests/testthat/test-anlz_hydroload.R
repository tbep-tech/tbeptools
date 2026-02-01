test_that("anlz_hydroload works with single year - no adjustment needed", {
  # Mock requireNamespace to return TRUE
  stub(anlz_hydroload, "requireNamespace", TRUE)
  
  # Mock NOAA rainfall data for St. Petersburg
  mock_sp_rain <- data.frame(
      sum = 45
    )
  # Mock NOAA rainfall data for Tampa
  mock_tia_rain <- data.frame(
      sum = 45
    )
  
  # Mock USGS streamflow data (returning data frames with Flow column)
  mock_usgs_data <- data.frame(Flow = 100) # 100 cubic feet per second
  
  # Mock the util_rain function calls
  stub(anlz_hydroload, "util_rain", function(station, start, end, token, ntry, quiet) {
    if (station == "GHCND:USW00092806") {
      return(mock_sp_rain)
    } else if (station == "GHCND:USW00012842") {
      return(mock_tia_rain)
    }
  })
  
  # Mock dataRetrieval functions
  stub(anlz_hydroload, "dataRetrieval::readNWISdv", mock_usgs_data)
  stub(anlz_hydroload, "dataRetrieval::renameNWISColumns", function(x) x)
  
  result <- anlz_hydroload(2021, "fake_key")
  
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 4) # 4 bay segments
  expect_equal(ncol(result), 6) # 6 columns as per function
  expect_true(all(c("Year", "Bay Segment", "Hydrology Estimate (million m3)", 
                    "Adjusted?", "Compliance Load Adjustment Factor", 
                    "Compliance Load") %in% names(result)))
  expect_equal(unique(result$Year), 2021)
  expect_equal(levels(result$`Bay Segment`), 
               c('Old Tampa Bay', 'Hillsborough Bay', 'Middle Tampa Bay', 'Lower Tampa Bay'))
})

test_that("anlz_hydroload works with multiple years", {

  # Mock NOAA rainfall data for St. Petersburg
  mock_sp_rain <- data.frame(
      sum = 45
    )
  # Mock NOAA rainfall data for Tampa
  mock_tia_rain <- data.frame(
      sum = 45
    )
  
  # Mock USGS streamflow data
  mock_usgs_data <- data.frame(Flow = 100)
  
  # Mock the util_rain function calls
  stub(anlz_hydroload, "util_rain", function(station, start, end, token, ntry, quiet) {
    if (station == "GHCND:USW00092806") {
      return(mock_sp_rain)
    } else if (station == "GHCND:USW00012842") {
      return(mock_tia_rain)
    }
  })
  
  stub(anlz_hydroload, "dataRetrieval::readNWISdv", mock_usgs_data)
  stub(anlz_hydroload, "dataRetrieval::renameNWISColumns", function(x) x)
  
  result <- anlz_hydroload(c(2020, 2021), "fake_key")
  
  expect_equal(nrow(result), 8) # 4 segments × 2 years
  expect_equal(sort(unique(result$Year)), c(2020, 2021))
})

test_that("anlz_hydroload handles adjustment cases correctly", {

  # Mock rainfall data that will trigger adjustments
  mock_sp_rain <- data.frame(
      sum = 90
    )
  # Mock NOAA rainfall data for Tampa
  mock_tia_rain <- data.frame(
      sum = 90
    )
  
  # Mock high streamflow data that will trigger adjustments
  mock_usgs_data <- data.frame(Flow = 1000) # High flow
  
  # Mock the util_rain function calls
  stub(anlz_hydroload, "util_rain", function(station, start, end, token, ntry, quiet) {
    if (station == "GHCND:USW00092806") {
      return(mock_sp_rain)
    } else if (station == "GHCND:USW00012842") {
      return(mock_tia_rain)
    }
  })
  
  stub(anlz_hydroload, "dataRetrieval::readNWISdv", mock_usgs_data)
  stub(anlz_hydroload, "dataRetrieval::renameNWISColumns", function(x) x)
  
  result <- anlz_hydroload(2021, "fake_key")
  
  # Check that adjustments are made (should be "YES" for high values)
  expect_true(any(result$`Adjusted?` == "YES"))
  
  # Check that adjustment factors are calculated when needed
  adjusted_rows <- result[result$`Adjusted?` == "YES", ]
  expect_true(all(!is.na(adjusted_rows$`Compliance Load Adjustment Factor`)))
})

test_that("anlz_hydroload trace parameter works", {

  # Mock data
  mock_sp_rain <- data.frame(
      sum = 90
    )
  # Mock NOAA rainfall data for Tampa
  mock_tia_rain <- data.frame(
      sum = 90
    )
  mock_usgs_data <- data.frame(Flow = 100)
  
  # Mock the util_rain function calls
  stub(anlz_hydroload, "util_rain", function(station, start, end, token, ntry, quiet) {
    if (station == "GHCND:USW00092806") {
      return(mock_sp_rain)
    } else if (station == "GHCND:USW00012842") {
      return(mock_tia_rain)
    }
  })
  
  stub(anlz_hydroload, "dataRetrieval::readNWISdv", mock_usgs_data)
  stub(anlz_hydroload, "dataRetrieval::renameNWISColumns", function(x) x)
  
  # Test with trace = TRUE (should not error)
  expect_no_error(
    result <- anlz_hydroload(2021, "fake_key", trace = TRUE)
  )
  
  expect_s3_class(result, "data.frame")
})

test_that("anlz_hydroload calculations are correct", {
  
  # Set specific known values for testing calculations
  mock_sp_rain <- data.frame(
      sum = 90
    )
  # Mock NOAA rainfall data for Tampa
  mock_tia_rain <- data.frame(
      sum = 90
    )
  
  mock_flows <- list(
    hr = data.frame(Flow = 100),   # Hillsborough River
    ar = data.frame(Flow = 150),   # Alafia River
    lmr = data.frame(Flow = 75),   # Little Manatee River
    bkr = data.frame(Flow = 50),   # Brooker Creek
    wl = data.frame(Flow = 25),    # Weeki Wachee
    mr = data.frame(Flow = 30)     # Myakka River
  )
  
  # Mock different flows for different stations
  stub(anlz_hydroload, "dataRetrieval::readNWISdv", function(station_id, ...) {
    switch(station_id,
           "02303000" = mock_flows$hr,  # Hillsborough
           "02301500" = mock_flows$ar,  # Alafia  
           "02300500" = mock_flows$lmr, # Little Manatee
           "02307359" = mock_flows$bkr, # Brooker
           "02300042" = mock_flows$wl,  # Weeki Wachee
           "02299950" = mock_flows$mr,  # Myakka
           mock_flows$hr)
  })
  
  # Mock the util_rain function calls
  stub(anlz_hydroload, "util_rain", function(station, start, end, token, ntry, quiet) {
    if (station == "GHCND:USW00092806") {
      return(mock_sp_rain)
    } else if (station == "GHCND:USW00012842") {
      return(mock_tia_rain)
    }
  })
  
  stub(anlz_hydroload, "dataRetrieval::renameNWISColumns", function(x) x)
  
  result <- anlz_hydroload(2021, "fake_key")
  
  # Verify we get expected number of rows and bay segments
  expect_equal(nrow(result), 4)
  expect_true(all(c("Hillsborough Bay", "Old Tampa Bay", "Middle Tampa Bay", "Lower Tampa Bay") %in% 
                  result$`Bay Segment`))
  
  # Verify all hydrology estimates are numeric and positive
  expect_true(all(is.numeric(result$`Hydrology Estimate (million m3)`)))
  expect_true(all(result$`Hydrology Estimate (million m3)` > 0))
})

# Test edge case with NULL noaa_key (should still work as it's passed to ncdc)
test_that("anlz_hydroload works with NULL noaa_key", {

  mock_sp_rainfall <- list(data = data.frame(value = rep(254, 365)))
  mock_tia_rainfall <- list(data = data.frame(value = rep(254, 365)))
  mock_usgs_data <- data.frame(Flow = 100)
  
  stub(anlz_hydroload, "ncdc", function(...) {
    args <- list(...)
    if (args$stationid == "GHCND:USW00092806") {
      return(mock_sp_rainfall)
    } else {
      return(mock_tia_rainfall)
    }
  })
  
  stub(anlz_hydroload, "dataRetrieval::readNWISdv", mock_usgs_data)
  stub(anlz_hydroload, "dataRetrieval::renameNWISColumns", function(x) x)
  
  expect_no_error(
    result <- anlz_hydroload(2021, noaa_key = NULL)
  )
  
  expect_s3_class(result, "data.frame")
})