#' Get all raw metrics for Tampa Bay Nekton Index
#'
#' Get all raw metrics for Tampa Bay Nekton Index
#'
#' @param fimdata \code{data.frame} formatted from \code{read_importfim}
#' @param all logical indicating if only TBNI metrics are returned (default), otherwise all are calcualted
#'
#' @details All raw metrics are returned in addition to those required for the TBNI.  Each row shows metric values for a station, year, and month where fish catch data were available.
#'
#' @return A data frame of raw metrics in wide fomat.  If \code{all = TRUE}, all metrics are returned, otherwise only \code{NumTaxa}, \code{BenthicTaxa}, \code{TaxaSelect}, \code{NumGuilds}, and \code{Shannon} are returned.
#' @export
#'
#' @concept analyze
#'
#' @importFrom dplyr %>%
#'
#' @examples
#' anlz_tbnimet(fimdata)
anlz_tbnimet <- function(fimdata, all = FALSE){

  # Calculate the number of taxa (NumTaxa) per set
  NumTaxa <- fimdata %>%
    dplyr::select(Reference, NODCCODE) %>%
    dplyr::group_by(Reference) %>%
    dplyr::mutate(NumTaxa1 = dplyr::n_distinct(NODCCODE)) %>%
    dplyr::mutate(NumTaxa = ifelse(NODCCODE == "9998000000", 0, as.numeric(NumTaxa1))) %>%
    dplyr::ungroup() %>%
    dplyr::select(-NODCCODE, -NumTaxa1) %>%
    dplyr::distinct() %>%
    dplyr::arrange(Reference)

  # Calculate the number of individuals per set
  NumIndiv <- fimdata %>%
    dplyr::group_by(Reference) %>%
    dplyr::summarize(NumIndiv = sum(Total_N)) %>%
    dplyr::arrange(Reference)

  # Calculate Diversity Indices - needs number of taxa and number of individuals
  Diversity <- merge(NumTaxa, NumIndiv, by = "Reference") %>%
    merge(fimdata) %>%
    dplyr::filter(!NODCCODE == "9998000000" | !is.na(NumTaxa)) %>%
    dplyr::group_by(Reference) %>%
    dplyr::mutate(pi = Total_N/NumIndiv,
           pi2 = pi*pi,
           lnpi = log(pi),
           pilnpi = pi*lnpi) %>%
    dplyr::mutate(sumpi2 = sum(pi2),
           sumpilnpi = sum(pilnpi),
           Shannon = -1*sumpilnpi,
           Simpson = 1/sumpi2,
           Pielou = Shannon/log(NumTaxa)) %>%
    dplyr::select(Reference, Shannon, Simpson, Pielou) %>%
    dplyr::distinct() %>%
    dplyr::arrange(Reference)

  # Calculate number of selected taxa per set
  TaxaSelect <- fimdata %>%
    dplyr::select(Reference, NODCCODE, Selected_Taxa) %>%
    dplyr::mutate(Select = ifelse(Selected_Taxa == "Y", 1,
      ifelse(Selected_Taxa == "N", 0,
        NA_integer_
        )
      )
    ) %>%
    dplyr::distinct() %>%
    dplyr::group_by(Reference) %>%
    dplyr::summarize(TaxaSelect = sum(Select)) %>%
    dplyr::arrange(Reference)

  # Calculate number of feeding guilds per set
  NumGuilds <- fimdata %>%
    dplyr::select(Reference, NODCCODE, Feeding_Guild) %>%
    dplyr::distinct() %>%
    dplyr::group_by(Reference) %>%
    dplyr::mutate(NumGuilds = dplyr::n_distinct(Feeding_Guild)) %>%
    dplyr::select(-NODCCODE, -Feeding_Guild) %>%
    dplyr::distinct() %>%
    dplyr::arrange(Reference)

  # prep fimdata for output
  outprp <- fimdata %>%
    dplyr::ungroup() %>%
    #apply the season - based on avearge water temperatures of FIM sampling sites
    dplyr::mutate(Season = ifelse(Month %in% c(12, 1, 2, 3), "Winter",
      ifelse(Month %in% c(4, 5), "Spring",
        ifelse(Month %in% c(6, 7, 8, 9), "Summer",
          ifelse(Month %in% c(10, 11), "Fall",
            NA_character_
            )
          )
        )
      )
    ) %>%
    dplyr::select(Reference, Year, Month, Season, bay_segment) %>%
    dplyr::distinct() %>%
    dplyr::left_join(NumTaxa, by = "Reference") %>%
    dplyr::left_join(NumIndiv, by = "Reference") %>%
    dplyr::left_join(Diversity, by = "Reference") %>%
    dplyr::left_join(TaxaSelect, by = "Reference") %>%
    dplyr::left_join(NumGuilds, by = "Reference")

  # compile only tbni metrics
  if(!all){

    # benthic taxa
    BenthTax <- fimdata %>%
      dplyr::group_by(Reference) %>%
      dplyr::mutate(
        BenthicTaxa = ifelse(Hab_Cat == "B", 1, 0)
      ) %>%
      dplyr::select(Reference, BenthicTaxa) %>%
      dplyr::summarise_all(sum)

    out <- outprp %>%
      dplyr::left_join(BenthTax, by = 'Reference') %>%
      dplyr::mutate(
        NumTaxa = ifelse(NumIndiv == 0, 0, NumTaxa),
        Shannon = ifelse(NumIndiv == 0, 0, Shannon),
        TaxaSelect = ifelse(NumIndiv == 0, 0, TaxaSelect),
        NumGuilds = ifelse(NumIndiv == as.numeric(0), 0, as.numeric(NumGuilds)),
        BenthicTaxa = ifelse(NumIndiv == 0, 0, BenthicTaxa)
      ) %>%
      dplyr::select(-Simpson, -Pielou, -NumIndiv)

  }

  # compile all else
  if(all){

    # Calculate the number of taxa metrics
    TaxaCountPrep <- fimdata %>%
      dplyr::group_by(Reference) %>%
      dplyr::mutate(
        TSTaxa = ifelse(Feeding_Cat == "TS" , 1, 0),
        TGTaxa = ifelse(Feeding_Cat == "TG", 1, 0),
        BenthicTaxa = ifelse(Hab_Cat == "B", 1, 0),
        PelagicTaxa = ifelse(Hab_Cat == "P", 1, 0),
        OblTaxa = ifelse(Est_Use == "O", 1, 0),
        MSTaxa = ifelse(Est_Cat == "MS", 1, 0),
        ESTaxa = ifelse(Est_Cat == "ES", 1,  0)
      )

    taxa <- TaxaCountPrep %>%
      dplyr::select(Reference, TSTaxa, TGTaxa, BenthicTaxa, PelagicTaxa,
                    OblTaxa, MSTaxa , ESTaxa) %>%
      dplyr::summarise_all(sum)

    # Calculate the number of individuals of selected taxa
    SelectIndiv <- fimdata %>%
      dplyr::select(Reference, Total_N, Selected_Taxa) %>%
      dplyr::filter(Selected_Taxa == "Y") %>%
      dplyr::group_by(Reference) %>%
      dplyr::summarize(SelectIndiv = sum(Total_N))

    # Calculate number of species needed to get to 90% of the catch (dominance)
    Dom <- fimdata %>%
      dplyr::select(Reference, NODCCODE, Total_N) %>%
      dplyr::arrange(Reference, desc(Total_N)) %>%
      dplyr::left_join(NumIndiv, by = "Reference") %>%
      dplyr::group_by(Reference) %>%
      dplyr::mutate(CumProp = cumsum(Total_N)/NumIndiv,
             Taxa = row_number()) %>%
      dplyr::ungroup() %>%
      dplyr::filter(CumProp >= 0.9) %>%
      dplyr::group_by(Reference) %>%
      dplyr::slice(1) %>%
      dplyr::ungroup() %>%
      dplyr::select(Reference, Taxa90 = Taxa)

    # Calculate number of individuals per functional ecological guild
    abundances <- TaxaCountPrep %>%
      dplyr::mutate(TSAbund = TSTaxa * Total_N,
             TGAbund = TGTaxa * Total_N,
             BenthicAbund = BenthicTaxa * Total_N,
             PelagicAbund = PelagicTaxa * Total_N,
             OblAbund = OblTaxa * Total_N,
             ESAbund = ESTaxa * Total_N,
             MSAbund = MSTaxa * Total_N) %>%
      dplyr::select(Reference,TSAbund, TGAbund, BenthicAbund, PelagicAbund,
             OblAbund, ESAbund, MSAbund) %>%
      dplyr::summarise_all(sum)

    # Calculate abundances of sentinel species
    Num_LR <- fimdata %>%
      dplyr::ungroup() %>%
      dplyr::select(Reference, ScientificName, Total_N) %>%
      dplyr::group_by(Reference) %>%
      dplyr::filter(ScientificName == "Lagodon rhomboides") %>%
      dplyr::summarise(Num_LR = sum(Total_N))

    # Merge metrics into 1 dataframe
    # then calculate proportion metrics, and fix the "No fish" sets to have zero value for all metrics

    out <- outprp %>%
      dplyr::left_join(taxa, by = "Reference") %>%
      dplyr::left_join(SelectIndiv, by = "Reference") %>%
      dplyr::left_join(Dom, by = "Reference") %>%
      dplyr::left_join(abundances, by = "Reference") %>%
      dplyr::left_join(Num_LR, by = "Reference") %>%
      #calculate all the proportion metrics
      dplyr::mutate(PropTG = TGAbund/NumIndiv,
             PropTS = TSAbund/NumIndiv,
             PropBenthic = BenthicAbund/NumIndiv,
             PropPelagic = PelagicAbund/NumIndiv,
             PropObl = OblAbund/NumIndiv,
             PropMS = MSAbund/NumIndiv,
             PropES = ESAbund/NumIndiv,
             PropSelect = SelectIndiv/NumIndiv) %>%
      dplyr::mutate(SelectIndiv = tidyr::replace_na(SelectIndiv, 0),
             Num_LR = tidyr::replace_na(Num_LR, 0),
             PropSelect = tidyr::replace_na(PropSelect, 0)) %>%
      #set all metrics to zero if it's a no fish set
      dplyr::mutate(NumTaxa = ifelse(NumIndiv == 0, 0, NumTaxa),
             Shannon = ifelse(NumIndiv == 0, 0, Shannon),
             Simpson = ifelse(NumIndiv == 0, 0, Simpson),
             Pielou = ifelse(NumIndiv == 0, 0, Pielou),
             TaxaSelect = ifelse(NumIndiv == 0, 0, TaxaSelect),
             SelectIndiv = ifelse(NumIndiv == 0, 0, SelectIndiv),
             NumGuilds = ifelse(NumIndiv == as.numeric(0), 0, as.numeric(NumGuilds)),
             Taxa90 = ifelse(NumIndiv == as.numeric(0), 0, as.numeric(Taxa90)),
             TSTaxa = ifelse(NumIndiv == 0, 0, TSTaxa),
             TGTaxa = ifelse(NumIndiv == 0, 0, TGTaxa),
             BenthicTaxa = ifelse(NumIndiv == 0, 0, BenthicTaxa),
             PelagicTaxa = ifelse(NumIndiv == 0, 0, PelagicTaxa),
             OblTaxa = ifelse(NumIndiv == 0, 0, OblTaxa),
             MSTaxa = ifelse(NumIndiv == 0, 0, MSTaxa),
             ESTaxa = ifelse(NumIndiv == 0, 0, ESTaxa),
             TSAbund = ifelse(NumIndiv == 0, 0, TSAbund),
             TGAbund = ifelse(NumIndiv == 0, 0, TGAbund),
             BenthicAbund = ifelse(NumIndiv == 0, 0, BenthicAbund),
             PelagicAbund  = ifelse(NumIndiv == 0, 0, PelagicAbund),
             OblAbund = ifelse(NumIndiv == 0, 0, OblAbund),
             ESAbund = ifelse(NumIndiv == 0, 0, ESAbund),
             MSAbund = ifelse(NumIndiv == 0, 0, MSAbund),
             Num_LR = ifelse(NumIndiv == 0, 0, Num_LR),
             PropTG = ifelse(NumIndiv == 0, 0, PropTG),
             PropTS = ifelse(NumIndiv == 0, 0, PropTS),
             PropBenthic = ifelse(NumIndiv == 0, 0, PropBenthic),
             PropPelagic = ifelse(NumIndiv == 0, 0, PropPelagic),
             PropObl = ifelse(NumIndiv == 0, 0, PropObl),
             PropMS = ifelse(NumIndiv == 0, 0, PropMS),
             PropES = ifelse(NumIndiv == 0, 0, PropES),
             PropSelect = ifelse(NumIndiv == 0, 0, PropSelect))

  }

  return(out)

}
