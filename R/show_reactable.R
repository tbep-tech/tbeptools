#' Create reactable table from matrix data
#'
#' Create reactable table from matrix data
#'
#' @param totab A data frame in wide format of summarized results
#' @param colfun Function specifying how colors are treated in cell background
#' @param nrows numeric specifying number of rows in the table
#'
#' @importFrom reactable colDef
#'
#' @details This function is used internally within \code{\link{show_matrix}} and \code{\link{show_wqmatrix}}
#'
#' @family visualize
#'
#' @return A \code{\link[reactable]{reactable}} table
#'
#' @export
#'
#' @examples
#' data(targets)
#' data(epcdata)
#'
#' library(tidyr)
#' library(dplyr)
#'
#' # data
#' totab <- anlz_avedat(epcdata) %>%
#'   .$ann %>%
#'   filter(var %in% 'mean_chla') %>%
#'   left_join(targets, by = 'bay_segment') %>%
#'   select(bay_segment, yr, val, chla_thresh) %>%
#'   mutate(
#'     bay_segment = factor(bay_segment, levels = c('OTB', 'HB', 'MTB', 'LTB')),
#'      outcome = case_when(
#'       val < chla_thresh ~ 'green',
#'       val >= chla_thresh ~ 'red'
#'     )
#'   ) %>%
#'   select(bay_segment, yr, outcome) %>%
#'   spread(bay_segment, outcome)
#'
#' # color function
#' colfun <- function(x){
#'
#'   out <- case_when(
#'     x == 'red' ~ '#FF3333',
#'     x == 'green' ~ '#33FF3B'
#'   )
#'
#'   return(out)
#'
#' }
#'
#' show_reactable(totab, colfun)
show_reactable <- function(totab, colfun, nrows = 10) {

  out <- reactable::reactable(totab,
    defaultPageSize = nrows,
    columns = list(
     yr = colDef(
       name = "Year"
     )
    ),
    defaultColDef = colDef(
     style = function(value){
       list(background = colfun(value))
       }
    )
  )

  return(out)

}
