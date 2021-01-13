



library(tbeptools)
library(dplyr)

# adjust category levels based on revised monte carlo
tidaltargetsmw<-tidaltargets%>%
  dplyr::mutate(investigate =dplyr::case_when(region=="West Central" ~1.38,
                                              region=="Peninsula"~1.30)) %>%
  dplyr::mutate(caution =dplyr::case_when(region=="West Central" ~ "1.38 - 0.0174 * (23.78 - (Creek_Length_m / 1000))",
                                          region=="Peninsula" ~ "1.30 - 0.0174 * (23.78 - (Creek_Length_m / 1000))"))


# create modified anlz_tdlcrk function to use tidaltargetsmw dataframe (above) with new levels

anlz_tdlcrkmw<-function (tidalcreeks, iwrraw, tidtrgs = NULL, yr = 2018)
{
  if (is.null(tidtrgs))
    tidtrgs <- tidaltargetsmw
  wcpri <- tidtrgs %>% dplyr::filter(region == "West Central") %>%
    dplyr::pull(prioritize)
  wcinv <- tidtrgs %>% dplyr::filter(region == "West Central") %>%
    dplyr::pull(investigate)
  wccau <- tidtrgs %>% dplyr::filter(region == "West Central") %>%
    dplyr::pull(caution)
  pepri <- tidtrgs %>% dplyr::filter(region == "Peninsula") %>%
    dplyr::pull(prioritize)
  peinv <- tidtrgs %>% dplyr::filter(region == "Peninsula") %>%
    dplyr::pull(investigate)
  pecau <- tidtrgs %>% dplyr::filter(region == "Peninsula") %>%
    dplyr::pull(caution)
  iwrdat <- anlz_iwrraw(iwrraw, tidalcreeks, yr = yr) %>%
    dplyr::group_by(wbid, class, JEI, year, masterCode) %>%
    dplyr::summarise(result = mean(result, na.rm = T)) %>%
    dplyr::ungroup() %>% dplyr::mutate(result = exp(result)) %>%
    tidyr::spread(masterCode, result)
  alldat <- tidalcreeks %>% sf::st_set_geometry(NULL) %>%
    dplyr::left_join(iwrdat, by = c("wbid", "JEI", "class")) %>%
    dplyr::mutate(tn_pri = dplyr::case_when(!is.na(Creek_Length_m) &
                                              !grepl("^PC|^LC", JEI) ~ wcpri, !is.na(Creek_Length_m) &
                                              grepl("^PC|^LC", JEI) ~ pepri), investigate = dplyr::case_when(!is.na(Creek_Length_m) &
                                                                                                               !grepl("^PC|^LC", JEI) ~ wcinv, !is.na(Creek_Length_m) &
                                                                                                               grepl("^PC|^LC", JEI) ~ peinv), caution = dplyr::case_when(class %in%
                                                                                                                                                                            c("3M", "2") & tn_pri == wcpri ~ eval(parse(text = wccau)),
                                                                                                                                                                          class %in% c("3M", "2") & tn_pri == pepri ~ eval(parse(text = pecau))),
                  grade = dplyr::case_when(class %in% c("3F", "1") &
                                             TN > tn_pri ~ 4, class %in% c("3F", "1") & TN <=
                                             tn_pri & investigate <= TN ~ 3, class %in% c("3F",
                                                                                          "1") & TN < investigate ~ 1, class %in% c("3M",
                                                                                                                                    "2") & TN < caution ~ 1, class %in% c("3M",
                                                                                                                                                                      "2") & caution <= TN & TN <= investigate ~ 2,
                                           class %in% c("3M", "2") & investigate <= TN &
                                             TN <= tn_pri ~ 3, class %in% c("3M", "2") &
                                             TN > tn_pri ~ 4)) %>% dplyr::group_by(id,
                                                                                   wbid, JEI, name, class, grade) %>% dplyr::summarise(cnt = n()) %>%
    tidyr::spread(grade, cnt) %>% dplyr::select(-`<NA>`)
  scrdat <- alldat %>% dplyr::rowwise() %>% dplyr::mutate(score = dplyr::case_when(!is.na(`4`) &
                                                                                     `4` > 0 ~ "Prioritize", !is.na(`3`) & `3` > 0 ~ "Investigate",
                                                                                   !is.na(`2`) & `2` > 2 ~ "Caution", is.na(`1`) & is.na(`2`) &
                                                                                     is.na(`3`) & is.na(`4`) ~ "No Data", T ~ "Monitor"),
                                                          score = dplyr::case_when(score == "Prioritize" & class %in%
                                                                                     c("3F", "1") & `4` == 1 & `3` > 1 ~ "Investigate",
                                                                                   score == "Prioritize" & class %in% c("3F", "1") &
                                                                                     `4` == 1 & `1` > 3 ~ "Monitor", T ~ score),
                                                          score = dplyr::case_when(score == "Investigate" & class %in%
                                                                                     c("3F", "1") & `3` == 1 & `1` > 3 ~ "Monitor", T ~
                                                                                     score), score = dplyr::case_when((score == "Prioritize" &
                                                                                                                         class %in% c("3M", "2")) & (`4` == 1 & sum(`1`,
                                                                                                                                                                    `2`, `3`, na.rm = T) > 2) ~ "Investigate", T ~ score),
                                                          score = dplyr::case_when((score == "Investigate" & class %in%
                                                                                      c("3M", "2") & (`4` < 1 | is.na(`4`))) & (`3` ==
                                                                                                                                  1 & sum(`1`, `2`, na.rm = T) > 1) ~ "Caution", T ~
                                                                                     score)) %>% tidyr::as_tibble() %>% dplyr::select(id,
                                                                                                                                      wbid, JEI, name, class, monitor = `1`, caution = `2`,
                                                                                                                                      investigate = `3`, prioritize = `4`, score)
  return(scrdat)
}

#test original
results <- anlz_tdlcrk(tidalcreeks, iwrraw)
show_tdlcrkmatrix(results)

#test adjusted
resultsmw <- anlz_tdlcrkmw(tidalcreeks, iwrraw)
show_tdlcrkmatrix(resultsmw)

