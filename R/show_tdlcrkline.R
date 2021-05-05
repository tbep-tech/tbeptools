#' Add a line or annotation to a plotly graph
#'
#' Add a line or annotation to a plotly graph for the tidal creek indicators
#'
#' @param varin chr string for the indicator
#' @param thrsel logical if something is returned, otherwise NULL, this is a hack for working with the plotly output
#' @param horiz logical indicating if output is horizontal or vertical
#' @param annotate logical indicating if output is line or annotation text
#'
#' @details This function is used internally within \code{\link{show_tdlcrkindic}} and \code{\link{show_tdlcrkindiccdf}}
#'
#' @concept show
#'
#' @return A list object passed to the layout argument of plotly, either shapes or annotate depending on user input
#' @export
#'
#' @examples
#' # code for vertical line output, chloropyll
#' show_tdlcrkline('CHLAC', thrsel = TRUE)
show_tdlcrkline <- function(varin = c('CHLAC', 'TN', 'chla_tn_ratio', 'DO', 'tsi', 'no23_ratio'), thrsel = FALSE, horiz = TRUE, annotate = FALSE) {

  # sanity checks
  varin <- match.arg(varin)

  out <- NULL

  # create lines or annotations
  if(thrsel){

    # thresholds
    thrs <- list(
      CHLAC = 11,
      TN = 1.1,
      chla_tn_ratio = 15,
      DO = 2,
      tsi = c(50, 60), # estuary, lake
      no23_ratio = 1
    )

    # annotations
    anns <- list(
      CHLAC = '',
      TN = '',
      chla_tn_ratio = '',
      DO = '',
      tsi = c('estuary', 'lake'), # estuary, lake
      no23_ratio = ''
    )

    # value to plot
    ln <- thrs[[varin]]
    ann <- anns[[varin]]

    out <- list()

    # lines
    if(!annotate){

      # horizontal
      if(horiz){
        for(i in seq_along(ln)){

          outi <- list(list(
            type = "line",
            x0 = 0,
            x1 = 1,
            xref = "paper",
            y0 = ln[i],
            y1 = ln[i],
            line = list(color = 'red', dash = 10)
          ))

          out <- c(out, outi)

        }

      }

      # vertical
      if(!horiz){
        for(i in seq_along(ln)){

          outi <- list(list(
            type = "line",
            x0 = ln[i],
            x1 = ln[i],
            yref = "paper",
            y0 = 0,
            y1 = 1,
            line = list(color = 'red', dash = 10)
          ))

          out <- c(out, outi)

        }

      }

    }

    # annotations
    if(annotate){

      # horizontal
      if(horiz){
        for(i in seq_along(ln)){

          outi <- list(list(
            x = 0,
            y = ln[i],
            text = ann[i],
            xref = "x",
            yref = "y",
            showarrow = F,
            yanchor = 'top',
            # xanchor = 'left',
            font = list(color = 'red', size = 14)
          ))

          out <- c(out, outi)

        }

      }

      # vertical
      if(!horiz){
        for(i in seq_along(ln)){

          outi <- list(list(
            x = ln[i],
            y = 1,
            text = ann[i],
            xref = "x",
            yref = "y",
            showarrow = F,
            xanchor = 'right',
            yanchor = 'top',
            textangle = 90,
            font = list(color = 'red', size = 14)
          ))

          out <- c(out, outi)

        }

      }

    }

  }

  return(out)

}
