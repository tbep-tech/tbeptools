test_that("Checking show_reactable class", {

  library(dplyr)
  library(tidyr)

  data(epcdata)
  data(targets)
  # data
  totab <- anlz_avedat(epcdata) %>%
    .$ann %>%
    filter(var %in% 'mean_chla') %>%
    left_join(targets, by = 'bay_segment') %>%
    select(bay_segment, yr, val, chla_thresh) %>%
    mutate(
      bay_segment = factor(bay_segment, levels = c('OTB', 'HB', 'MTB', 'LTB')),
       outcome = case_when(
        val < chla_thresh ~ 'green',
        val >= chla_thresh ~ 'red'
      )
    ) %>%
    select(bay_segment, yr, outcome) %>%
    spread(bay_segment, outcome)

  # color function
  colfun <- function(x){

    out <- case_when(
      x == 'red' ~ '#FF3333',
      x == 'green' ~ '#33FF3B'
    )

    return(out)

  }

  result <- show_reactable(totab, colfun)
  expect_is(result, 'reactable')
})
