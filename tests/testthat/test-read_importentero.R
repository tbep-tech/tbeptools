library(mockery)

# Mock data for read.csv
mock_data <- data.frame(
  MonitoringLocationIdentifier = c("station1", "station2"),
  ActivityLocation.LatitudeMeasure = c(27.123, 27.456),
  ActivityLocation.LongitudeMeasure = c(-82.123, -82.456),
  ResultMeasureValue = c("100", "200"),
  ResultMeasure.MeasureUnitCode = c("cfu/100mL", "cfu/100mL"),
  MeasureQualifierCode = c("", ""),
  ActivityStartDate = c("2023-01-01", "2023-01-02"),
  ActivityStartTime.Time = c("10:00", "11:00"),
  ActivityStartTime.TimeZoneCode = c("EST", "EST"),
  DetectionQuantitationLimitMeasure.MeasureValue = c(5, 5),
  ResultLaboratoryCommentText = c("No issues", "No issues")
)

# Define the test case
test_that("read_importentero works correctly", {
  # Mock the download.file function
  mock_download <- mock()
  stub(read_importentero, "download.file", mock_download)

  # Mock the read.csv function
  mock_read_csv <- mock(return_value = mock_data)
  stub(read_importentero, "read.csv", mock_read_csv)

  # Prepare arguments
  args <- list(
    siteid = c("21FLHILL_WQX-101", "21FLHILL_WQX-102"),
    characteristicName = c("Enterococci", "Enterococcus"),
    startDateLo = "01-01-2023",
    startDateHi = "12-31-2023"
  )

  # Call the function with mocked dependencies
  result <- read_importentero(args)

  # Define expected output
  expected_output <- data.frame(
    date = as.Date(c("2023-01-01", "2023-01-02")),
    station = c("station1", "station2"),
    ecocci = c(100, 200),
    ecocci_censored = c(FALSE, FALSE),
    ecocci_units = c("cfu/100mL", "cfu/100mL"),
    qualifier = c("", ""),
    LabComments = c("No issues", "No issues"),
    Latitude = c(27.123, 27.456),
    Longitude = c(-82.123, -82.456),
    time = c("10:00", "11:00"),
    time_zone = c("EST", "EST"),
    MDL = c(5, 5),
    yr = c(2023, 2023),
    mo = c(1, 1)
  )

  # Check if the result matches the expected output
  expect_equal(result, expected_output)

  # Verify that the mock functions were called as expected
  expect_called(mock_download, 1)
  expect_called(mock_read_csv, 1)
})
