#' Create a table for the annual management outcome assessments
#'
#' Create a table for the annual management outcome assessments for chlorophyll-a and light attenuation by bay segment
#'
#' @inheritParams anlz_yrattain
#' @param caption logical indicating if a caption is added using \code{\link[flextable]{set_caption}}
#' @param family chr string indicating font family for text labels
#' @param txtsz numeric indicating font size
#' @param width optional numeric value indicating width in inches
#'
#' @return A \code{\link[flextable]{flextable}} object showing the segment-averaged chlorophyll-a and light attenuation for the selected year, with bay segment names colored by the management outcome used in \code{\link{show_matrix}}.
#'
#' @importFrom dplyr %>%
#'
#' @concept show
#'
#' @export
#'
#' @examples
#' show_annualassess(epcdata, yrsel = 2022)
#' show_annualassess(epcdata, yrsel = 2022, caption = T)
show_annualassess <- function(epcdata, yrsel, partialyr = F, caption = F, family = 'Arial', txtsz = 12, width = NULL){

  totab <- anlz_yrattain(epcdata, yrsel = yrsel, partialyr = partialyr) %>%
    dplyr::mutate(
      chla_val = round(chla_val, 1),
      chla_target = round(chla_target, 1),
      la_val = round(la_val, 2),
      la_target = round(la_target, 2),
      outcome = dplyr::case_when(
        outcome == 'green' ~ '#2DC938',
        outcome == 'yellow' ~ '#E9C318',
        outcome == 'red' ~ '#CC3231'
      )
    )

  outcome <- totab$outcome
  totab <- totab %>%
    dplyr::select(-outcome)

  tab <- flextable::flextable(totab) %>%
    flextable::bg(j = 'bay_segment', bg = outcome) %>%
    flextable::add_header_row(colwidths = c(1, 2, 2), values = c('Segment', 'Chl-a (ug/L)', 'light')) %>%
    flextable::compose(
      i = 1, j = 4:5, part = "header",
      value = flextable::as_paragraph("Light Penetration (m", flextable::as_sup("-1"), ')')
    ) %>%
    flextable::set_header_labels(values = c('', yrsel, 'target', yrsel, 'target')) %>%
    flextable::align(align = 'center', part = 'all', j = 2:5)

  if(caption){

    cap.val <- paste0('Water quality outcomes for ', yrsel , '.')
    tab <- tab %>%
      flextable::set_caption(
        flextable::as_paragraph(
          flextable::as_chunk(cap.val,
            props = flextable::fp_text_default(font.family = family, font.size = txtsz)
          )
        )
      )

  }

  if(!is.null(width))
    tab <- tab %>%
      flextable::width(width = width)

  tab <- tab %>%
    flextable::font(fontname = family, part = 'all') %>%
    flextable::fontsize(size = txtsz, part = 'all')

  return(tab)

}
