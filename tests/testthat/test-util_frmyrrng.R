# Test for a single year
expect_equal(util_frmyrrng(2023), "2023")

# Test for a consecutive range within the same century
expect_identical(util_frmyrrng(2020:2024), "2020-24")

# Test for a range spanning different centuries
expect_equal(util_frmyrrng(1998:2001), "1998-2001")

# Test for non-consecutive years
expect_equal(util_frmyrrng(c(2020, 2022)), "2020-2022")

# Test with prefix
expect_equal(util_frmyrrng(2023, prefix = "FY "), "FY 2023")

# Test with suffix
expect_equal(util_frmyrrng(2020:2024, suffix = " AD"), "2020-24 AD")

# Test with both prefix and suffix
expect_equal(util_frmyrrng(2020:2024, prefix = "Years ", suffix = " CE"), "Years 2020-24 CE")

# Test for a single consecutive range with prefix
expect_equal(util_frmyrrng(c(2010, 2011, 2012), prefix = "c. "), "c. 2010-12")

# Test for empty input
expect_equal(util_frmyrrng(numeric(0)), character(0))

# Test for NULL input
expect_equal(util_frmyrrng(NULL), character(0))
