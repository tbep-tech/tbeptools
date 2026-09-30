test_that("Checking show_seagrasscoverage class", {
  result <- show_seagrasscoverage(seagrass)
  expect_is(result, 'NULL')
})

test_that("Checking show_seagrasscoverage maxyr error", {
  expect_error(show_seagrasscoverage(seagrass, maxyr = 2015))
})

test_that("Checking show_seagrasscoverage class with extend = T and maxyr less than max year", {
  result <- show_seagrasscoverage(seagrass, maxyr = 2022, extend = T)
  expect_is(result, 'NULL')
})

test_that("Checking show_seagrasscoverage class with extend = F and maxyr less than max year", {
  result <- show_seagrasscoverage(seagrass, maxyr = 2022, extend = F)
  expect_is(result, 'NULL')
})

test_that("Checking show_seagrasscoverage class with covlab = F", {
  result <- show_seagrasscoverage(seagrass, covlab = F)
  expect_is(result, 'NULL')
})

test_that("Checking show_seagrasscoverage class with extend = T, covlab = F, maxyr less than max year", {
  result <- show_seagrasscoverage(seagrass, maxyr = 2022, extend = T, covlab = F)
  expect_is(result, 'NULL')
})
