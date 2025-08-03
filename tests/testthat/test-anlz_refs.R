test_that("Checking anlz_refs", {

  path <- system.file('tbep-refs.csv', package = 'tbeptools')
  result <- anlz_refs(path) %>%
    .[(length(.) - 3):length(.)]

  expect_equal(result, c("\tmisc={},", "\turl={http://www.tbeptech.org/TBEP_TECH_PUBS/2019/TBEP_12-19_2018_Nekton_Index.pdf},",
                         "\ttype={Technical report},", "}\n"))
})
