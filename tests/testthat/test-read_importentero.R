library(mockery)

# Mock data for read.csv
mock_data <- data.frame(
  MonitoringLocationIdentifier = c("station1", "station2"),
  ActivityLocation.LatitudeMeasure = c(27.8893, 27.8589),
  ActivityLocation.LongitudeMeasure = c(-82.4774, -82.4686),
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

  stas <- c("21FLHILL_WQX-101", "21FLHILL_WQX-102")

  # Call the function with mocked dependencies
  result <- read_importentero(stas = stas, startDate = "2023-01-01", endDate = "2023-12-31")

  # Define expected output
  expected_output <- data.frame(
    date = as.Date(c("2023-01-01", "2023-01-02")),
    yr = c(2023, 2023),
    mo = c(1, 1),
    time = c("10:00", "11:00"),
    time_zone = c("EST", "EST"),
    long_name = c("Hillsborough Bay", "Hillsborough Bay"),
    bay_segment = c("HB", "HB"),
    station = c("station1", "station2"),
    entero = c(100, 200),
    entero_censored = c(FALSE, FALSE),
    MDL = c(5, 5),
    entero_units = c("cfu/100mL", "cfu/100mL"),
    qualifier = c("", ""),
    LabComments = c("No issues", "No issues"),
    Latitude = c(27.8893, 27.8589),
    Longitude = c(-82.4774, -82.4686)
  )

  # Check if the result matches the expected output
  expect_equal(result, expected_output)

  # Verify that the mock functions were called as expected
  expect_called(mock_download, 1)
  expect_called(mock_read_csv, 1)

})
