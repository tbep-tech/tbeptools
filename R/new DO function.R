
library(tbeptools)
library(tidyverse)


raw_dat<-iwrraw

# take average DO for all depths at a site for each date
# Check to See if DOSAT calculated when data are available
# Answer - looks like it is calculated everywhere data are available to do so ignore and move on
target<-c('DO','DOSAT','TEMP','SALIN')
do_pull <- raw_dat %>%
  dplyr::filter(masterCode %in% target)%>%
  dplyr::group_by(class,JEI,wbid,sta,year, month,day,masterCode) %>%
  summarise(result = mean(result, na.rm = T)) %>%
  dplyr::ungroup() %>%
  tidyr::spread(masterCode, result)


# assign exceedences for class 3M DO criterion value
do_cnts<-do_pull%>%
  dplyr::filter(!is.na(DOSAT))%>%
  dplyr::mutate(do_cnt=dplyr::case_when(
                DOSAT<42 ~ 1, DOSAT >= 42 ~ 0))

# calculate exceedence rate of class 3M criterion value
do_ann<-do_cnts%>%
  dplyr::group_by(JEI,wbid,year) %>%
  summarise(cnt=n(),DOSAT_prop=mean(do_cnt, na.rm = T))

# generate binomial as to whether or not each year exceeds in two ways
# first uses DEP method and binomial probability
# second is just a straight exceedence of 10% of values in a year
do_exceed<-do_ann%>%
    dplyr::mutate(xcd=DOSAT_prop*cnt, bnml=1-pbinom(xcd-1,cnt,0.1),
    do_bnml=dplyr::case_when(bnml<0.10~1,bnml>=0.1~0),  # this includes the binomial probability calculation to match DEP method
    do_prop2=dplyr::case_when(DOSAT_prop > 0.1 ~ 1, DOSAT_prop <= 0.1 ~ 0)) #this just uses straight proportions exceeding 10% which is how i did it for the paper


