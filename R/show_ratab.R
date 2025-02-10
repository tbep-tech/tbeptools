#' Create a bay segment assessment table for the 2022-2026 reasonable assurance period
#'
#' @param epcdata data frame of epc data returned by \code{\link{read_importwq}}
#' @param yrsel numeric indicating chosen year
#' @param bay_segment chr string for the bay segment, one of "OTB", "HB", "MTB", "LTB", "RALTB"
#' @param partialyr logical indicating if incomplete annual data for the most recent year are approximated by five year monthly averages for each parameter
#' @param outtxt1 optional text for NMC action 1, added to the outcome column
#' @param outtxt2 optional text for NMC action 2, added to the outcome column
#' @param outtxt3 optional text for NMC action 3, added to the outcome column
#' @param outtxt45 optional text for NMC actions 4 and 5, added to the outcome column
#' @param txtsz numeric indicating font size
#' @param width optional numeric value indicating width in inches
#'
#' @details Choosing \code{bay_segment = 'RALTB'} will not work with \code{\link{epcdata}} and additional data are needed to use this option.
#'
#' @return A \code{\link[flextable]{flextable}} object showing the reasonable assurance compliance of the bay segment for the selected year within the five-year period.
#'
#' @concept show
#'
#' @importFrom dplyr %>%
#'
#' @export
#'
#' @examples
#' show_ratab(epcdata, yrsel = 2024, bay_segment = 'OTB')
show_ratab <- function(epcdata, yrsel, bay_segment = c('OTB', 'HB', 'MTB', 'LTB', 'RALTB'), partialyr = F, outtxt1 = NULL, outtxt2 = NULL, outtxt3 = NULL, outtxt45 = NULL, txtsz = 13, width = NULL){

  if(!requireNamespace('ftExtra', quietly = TRUE))
    stop("Package \"ftExtra\" needed for this function to work. Please install it.", call. = FALSE)

  # defaults for text
  if(is.null(outtxt1))
    outtxt1 <- 'All years below threshold so far, not necessary for NMC Actions 2-5'
  if(is.null(outtxt2))
    outtxt2 <- "All years met threshold, not necessary for NMC Actions 3-5"
  if(is.null(outtxt3))
    outtxt3 <- "Not necessary due to observed water quality and seagrass conditions in the bay segment"
  if(is.null(outtxt45))
    outtxt45 <- "Not necessary when chlorophyll-*a* threshold met"

  # segment
  bay_segment <- match.arg(bay_segment)

  # check yrsel
  chk <- yrsel < 2022 | yrsel > 2026
  if(chk)
    stop('yrsel must be from 2022 to 2026')

  trgs <- targets %>%
    dplyr::filter(bay_segment %in% !!bay_segment) %>%
    dplyr::select(bay_segment, chla_thresh)

  segname <- targets %>%
    dplyr::filter(bay_segment %in% !!bay_segment) %>%
    dplyr::pull(name)

  hydroload <- tibble::tibble(
      bay_segment = c('OTB', 'HB', 'MTB', 'LTB', 'RALTB'),
      loadest = c(486, 1451, 799, 349, 629)
    ) %>%
    dplyr::filter(bay_segment %in% !!bay_segment) %>%
    dplyr::pull(loadest)

  avedat <- anlz_avedat(epcdata, partialyr = partialyr) %>%
    .$ann %>%
    dplyr::filter(yr > 2014) %>%
    dplyr::filter(var %in% 'mean_chla') %>%
    dplyr::filter(bay_segment %in% !!bay_segment) %>%
    dplyr::select(-var) %>%
    dplyr::mutate(yr = factor(yr, levels = seq(2015, 2026))) %>%
    tidyr::complete(bay_segment, yr) %>%
    dplyr::left_join(trgs, by = 'bay_segment') %>%
    dplyr::mutate(
      yr = as.numeric(as.character(yr)),
      val = dplyr::case_when(
        yr <= yrsel ~ val,
        T ~ NaN
      ),
      met = val >= chla_thresh,
      out1 = ifelse(met, 'Yes', 'No'),
      out1 = ifelse(is.na(met), '', paste0(out1, ' (', round(val, 1), ')')),
      out1col = dplyr::case_when(
        grepl('No', out1) ~ 'lightgreen',
        grepl('Yes', out1) ~ '#FF6347',
        out1 == '' ~ 'white'
      ),
      sums = stats::filter(met, filter= rep(1, 2), sides = 1),
      sums = dplyr::case_when(
        sums >= 2 ~ 'Yes',
        sums < 2 ~ 'No',
        is.na(sums) ~ ''
      ),
      sumscol = dplyr::case_when(
        grepl('No', sums) ~ 'lightgreen',
        grepl('Yes', sums) ~ '#FF6347',
        sums == '' ~ 'white'
      ),
      act3 = dplyr::case_when(
        sums == 'No' ~ 'N/A',
        sums == 'Yes' ~ 'Check data',
        T ~ sums
      ),
      act3col = dplyr::case_when(
        act3 == 'N/A' ~ 'lightgreen',
        act3 == 'Check data' ~ '#FF6347',
        T ~ 'white'
      )
    ) %>%
    dplyr::filter(yr > 2016)

  totab <-  tibble::tibble(
    col1 = c(
      'Bay Segment Reasonable Assurance Assessment Steps',
      NA,
      paste('**NMC Action 1:** Determine if observed chlorophyll-a exceeds FDEP threshold of', trgs$chla_thresh, 'ug/L'),
      '**NMC Action 2:** Determine if any observed chlorophyll-*a* exceedences occurred for 2 consecutive years',
      paste('**NMC Action 3:** Determine if observed hydrologically-normalized total load exceeds federally-recognized TMDL of ', hydroload, 'tons/year '),
      '**NMC Actions 4-5:** Determine if any entity/source/facility specific exceedences of 5-yr average allocation occurred during implementation period'
    ),
    col2 = c(
      'DATA USED TO ASSESS ANNUAL REASONABLE ASSURANCE',
      'Year 1 (2022)',
      avedat[avedat$yr == 2022, "out1", drop = T],
      avedat[avedat$yr == 2022, "sums", drop = T],
      avedat[avedat$yr == 2022, "act3", drop = T],
      NA
    ),
    col3 = c(
      NA,
      'Year 2 (2023)',
      avedat[avedat$yr == 2023, "out1", drop = T],
      avedat[avedat$yr == 2023, "sums", drop = T],
      avedat[avedat$yr == 2023, "act3", drop = T],
      NA
    ),
    col4 = c(
      NA,
      'Year 3 (2024)',
      avedat[avedat$yr == 2024, "out1", drop = T],
      avedat[avedat$yr == 2024, "sums", drop = T],
      avedat[avedat$yr == 2024, "act3", drop = T],
      NA
    ),
    col5 = c(
      NA,
      'Year 4 (2025)',
      avedat[avedat$yr == 2025, "out1", drop = T],
      avedat[avedat$yr == 2025, "sums", drop = T],
      avedat[avedat$yr == 2025, "act3", drop = T],
      NA
    ),
    col6 = c(
      NA,
      'Year 5 (2026)',
      avedat[avedat$yr == 2026, "out1", drop = T],
      avedat[avedat$yr == 2026, "sums", drop = T],
      avedat[avedat$yr == 2026, "act3", drop = T],
      NA
    ),
    col7 = c(
      'OUTCOME', NA, outtxt1, outtxt2, outtxt3, outtxt45
    )
  )

  out <- flextable::flextable(totab) %>%
    flextable::font(fontname = 'Lato light', part = 'all') %>%
    flextable::fontsize(size = txtsz) %>%
    flextable::delete_part('header') %>%
    flextable::border_inner() %>%
    flextable::border_outer() %>%
    flextable::width(j = 1, width = 2, unit = 'in') %>%
    flextable::width(j = 2:6, width = 3 / 5, unit = 'in') %>%
    flextable::width(j = 7, width = 1.5, unit = 'in')%>%
    flextable::align(i = 1:2, align = 'center') %>%
    flextable::align(i = 3:5, j = 2:6, align = 'center') %>%
    ftExtra::colformat_md() %>%
    flextable::bg(bg = 'lightblue') %>%
    flextable::bg(i = 3, j = 2, bg = avedat[avedat$yr == 2022, 'out1col', drop = T]) %>%
    flextable::bg(i = 4, j = 2, bg = avedat[avedat$yr == 2022, 'sumscol', drop = T]) %>%
    flextable::bg(i = 5, j = 2, bg = avedat[avedat$yr == 2022, 'act3col', drop = T]) %>%
    flextable::bg(i = 3, j = 3, bg = avedat[avedat$yr == 2023, 'out1col', drop = T]) %>%
    flextable::bg(i = 4, j = 3, bg = avedat[avedat$yr == 2023, 'sumscol', drop = T]) %>%
    flextable::bg(i = 5, j = 3, bg = avedat[avedat$yr == 2023, 'act3col', drop = T]) %>%
    flextable::bg(i = 3, j = 4, bg = avedat[avedat$yr == 2024, 'out1col', drop = T]) %>%
    flextable::bg(i = 4, j = 4, bg = avedat[avedat$yr == 2024, 'sumscol', drop = T]) %>%
    flextable::bg(i = 5, j = 4, bg = avedat[avedat$yr == 2024, 'act3col', drop = T]) %>%
    flextable::bg(i = 3, j = 5, bg = avedat[avedat$yr == 2025, 'out1col', drop = T]) %>%
    flextable::bg(i = 4, j = 5, bg = avedat[avedat$yr == 2025, 'sumscol', drop = T]) %>%
    flextable::bg(i = 5, j = 5, bg = avedat[avedat$yr == 2025, 'act3col', drop = T]) %>%
    flextable::bg(i = 3, j = 6, bg = avedat[avedat$yr == 2026, 'out1col', drop = T]) %>%
    flextable::bg(i = 4, j = 6, bg = avedat[avedat$yr == 2026, 'sumscol', drop = T]) %>%
    flextable::bg(i = 5, j = 6, bg = avedat[avedat$yr == 2026, 'act3col', drop = T]) %>%
    flextable::merge_at(i = 1:2, j = 1) %>%
    flextable::merge_at(i = 1, j = 2:6) %>%
    flextable::merge_at(i = 1:2, j = 7) %>%
    flextable::merge_at(i = 6, j = 1:6)

  if(!is.null(width))
    out <- out %>%
      flextable::width(width = width)

  return(out)

}
