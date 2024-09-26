globalVariables(c("Chlorophyll_aQ", "Latitude", "Longitude", "SampleTime", "SampleDepth",
                  "SecchiDepth", "Station_Number", "TotalDepth", "bay_segment", "chla",
                  "epchc_station", "mo", "sd_m", "stations", "yr", "mean_chla", "mean_la", "mean_sdm", "sdm",
                  "sum_chla", "sum_sdm", "chla_thresh", "name", "targets", "val", "var", "yval", ".",
                  "chl_la", "data", "durats", "la", "na.omit", "outcome", "smallex", "target",
                  "thresh", "trgtyp", "nums", "est", "bsmap", "geometry", "tbseg", "met",
                  "<NA>", "JEI", "cnt", "grade", "masterCode", "result", "score", "tidalcreeks", "wbid", "year",
                  "title", "index", "subindex", "tag", "type", "act", "caution", "region", "investigate",
                  "tidaltargets", "1", "2", "3", "4", "outcometxt", "Act", "Result", "chl", "mags",
                  "outcome.x", "segval", "Sal-B", "Sal-M", "Sal-T", "Action",
                  "CHLAC", "Creek_Length_m", "TN", "TP", "chla_tsi", "day", "nut_tsi", "Source", "Tidal",
                  "median", "no23_ratio", "color", "Flow", "adj", "bs", "compload", "ests", "value",
                  "COUNT", "Date", "NAME", "PHYLUM", "StationNumber", "Units", "tbseglines", "Chlorophyll-a",
                  "uncorr_Q", "Secchi_Q", "Cells", "Commonname", "Count", "Include_TB_Index",
                  "NODCCODE", "Number", "Reference", "Sampling_Date", "Scientificname",
                  "Species_record_id", "Splitlevel", "Splittype", "Stratum", "effort", "fimstations",
                  "tbnispp", "BenthicAbund", "BenthicTaxa", "Chlorophyll_a", "uncorr_ugL", "CumProp", "ESAbund",
                  "ESTaxa", "Feeding_Guild", "MSAbund", "MSTaxa", "Month", "NumTaxa1", "OblAbund", "OblTaxa",
                  "PelagicAbund", "PelagicTaxa", "Pielou", "PropSelect", "ScientificName", "Season", "Select",
                  "Selected_Taxa", "Shannon", "Simpson", "TGAbund", "TGTaxa", "TSAbund", "TSTaxa", "Taxa",
                  "Total_N", "Year", "lnpi", "pi2", "pilnpi", "sumpi2", "sumpilnpi", "Chlorophyll_a uncorr_ugL",
                  "NumGuilds", "NumTaxa", "ScoreBenthicTaxa", "ScoreNumGuilds", "ScoreNumTaxa", "ScoreShannon",
                  "ScoreTaxaSelect", "TBNI_Score", "TaxaSelect", "fimdat", "tbniref", "Segment_TBNI",
                  "prioritize", "seval", "TBNI_Scoreall", 'Abundance', 'Agency', 'Savspecies', 'Site', 'aveval',
                  'matches', 'sdval', 'BladeLength_Avg', 'BladeLength_StdDev', 'Crew', 'ID',
                  'ShootDensity_Avg','ShootDensity_StdDev', 'Species', 'SpeciesAbundance', 'Transect', 'Average',
                  'Median', 'MonitoringAgency', 'grp', 'sumval', 'sumvar', 'ObservationDate', 'Depth',
                  'SeagrassEdge', 'TempWater-B', 'TempWater-C', 'TempWater-T',
                  'Total_NitrogenQ', 'Total_Nitrogen', 'tn', 'indyr', 'monitor', 'author', 'AdjCount',
                  'AdjCountAbundance', 'ArrivalTime', 'CapitellidAbundance', 'COLONIAL/PLANKTONIC?', 'FAMILY',
                  'Grab', 'IsComplete', 'ProgramID', 'ProgramName', 'RawCountAbundance', 'Salinity',
                  'SpeciesRichness', 'SpionidAbundance', 'StandardizingConstant', 'StandPropLnSpecies',
                  'StationID', 'StratumID', 'SumofAdjCount', 'SumofCount', 'TAXA_GROUP', 'TAXA_ID', 'TaxaCount',
                  'TaxaCountID', 'TaxaID', 'TaxaListId', 'TaxaListID', 'TBBI', 'TBBICat', 'tbsegshed',
                  'TotalAbundance', 'bb', 'pa', 'TRAN_ID', 'bbest', 'focat', 'nsites', 'trnpts', 'foest',
                  'All', 'All (wt)', 'cntwts', 'grndn', 'nwts', 'per', 'tbbicatid', 'tbbicatwt', 'total',
                  'AreaAbbr', 'AreaID', 'FundingId', 'FundingProject', 'no23_source', 'no23_tidal', 'DOSAT',
                  'DOSAT_prop', 'ch_tn_rat_ind', 'chla_ind', 'do_bnml', 'do_cnt', 'do_prop', 'fo', 'nox_ind',
                  'sta', 'tn_ind', 'tsi_ind', 'xcd', 'AssessmentYear', 'disqual', 'disqual2', 'newComment',
                  'rCode', 'Grid', 'COLONIAL.PLANKTONIC.', "Color345_F45", "Color345_F45Q", "ProgramId",
                  "Turbidity", "TurbidityQ", "grpact",
                  "Acres", "AnalysisTypeAbbr", "AreaName", "BenthicTaxa_P5", "BenthicTaxa_P95",
                  "BetweenTELPEL", "CASNumber", "Category", "DOHCertification", "DataSource",
                  "Est_Cat", "Est_Use", "ExceedsPEL", "Feeding_Cat", "Goal", "Goal2050",
                  "HMPU_TARGETS", "Hab_Cat", "Hexagon", "LabIdNumber", "LaboratoryAbbr", "MDLCode",
                  "MDLText", "MethodTypeAbbr", "NELACNumber", "NumGuilds_P5", "NumGuilds_P95",
                  "NumTaxa_P5", "NumTaxa_P95", "PEL","PELRatio", "PQLText", "Parameter",
                  "ParameterID", "PrepMethod", "PropBenthic", "PropES", "PropMS", "PropObl",
                  "PropPelagic", "PropTG", "PropTS", "Qualifier", "Replicate", "ResultComments",
                  "SedResultsType", "Shannon_P5", "Shannon_P95", "TEL", "Target", "Target2030",
                  "Taxa90", "TaxaSelect_P5", "TaxaSelect_P95", "TempWater-M", "ValueAdjusted",
                  "ValueNum", "ValueText", "WQMQCSignOff", "acresdiff", "ave", "category",
                  "changerate", "fillv", "goaleval", "goalprop", "grandave", "hiv", "ind",
                  "lacres", "lov", "lyr", "metric", "targeteval", "targetprop", "textv", "tn_pri",
                  "yeardiff", "Degraded" ,"Healthy", "Intermediate", "Bay Segment", "Aluminum",
                  "fit", "lwr", "upr", "ActivityStartDate", "ActivityStartTime.Time",
                  "ActivityTypeCode", "AirTemp", "CharacteristicName", "Class", "Color_345_F45_PCU",
                  "Color_345_F45_Q", "HUC", "HorizontalCoordinateReferenceSystemDatumName", "LabIDNumber",
                  "LatitudeMeasure", "LongitudeMeasure", "MonitoringLocationIdentifier", "Notes",
                  "PKBasin", "PrimaryStationType", "ResultMeasure.MeasureUnitCode",
                  "ResultMeasureValue", "RunName", "Sal_Bottom_ppth", "Sal_Mid_ppth",
                  "Sal_Top_ppth", "Sample Collector", "Sample_Depth_m", "Temp_Water_Bottom_degC",
                  "Temp_Water_Mid_degC", "Temp_Water_Top_degC", "Total_Depth_m",
                  "Turbidity_JTU-NTU", "Turbidity_Q", "WBID", "WINStation", "YearMonth", "chla_q",
                  "datum", "lat", "lon", "qual", "sd_check", "sd_q", "sd_raw_m", "station", "time",
                  "tn_q", "uni", "E_Coliform", "E_ColiformQ", "Enterococci", "EnterococciQ",
                  "Fecal_Coliform", "Fecal_ColiformQ", "Total_Coliform", "Total_ColiformQ",
                  "entero", "ecoli", "fcolif", "totcol", "areasfib", "Var1", "Var2", "colnm",
                  "indnm", "brk", "cls", "conc", "exced", "gmean", "MWQA", "station_tot",
                  "sumgt400", "yearfac", "nyrs", "ActivityDepthHeightMeasure.MeasureUnitCode",
                  "ActivityDepthHeightMeasure.MeasureValue", "chla_target", "chla_val",
                  "la_target", "la_val", "MonitoringLocationTypeName", "loadest", "out1",
                  "v", "z", "ActivityLocation.LatitudeMeasure", "ActivityLocation.LongitudeMeasure",
                  "ActivityStartTime.TimeZoneCode", "DetectionQuantitationLimitMeasure.MeasureValue",
                  "MeasureQualifierCode", "ResultLaboratoryCommentText", "V1", "V2", "V3", "Var3",
                  "entero_censored", "rain", "rain_total", "sumgt", "wet_sample",
                  "LabComments", "entero_units", "qualifier", "catchprecip", "wetdry", "TSN",
                  "MDL", "long_name", "tbsegdetail", "time_zone", "tot")
)

#' @importFrom grDevices rgb
NULL

#' @importFrom utils download.file
NULL

#' @importFrom tools md5sum
NULL

#' @importFrom methods .S4methods new
NULL

#' @importFrom stats ecdf lm median na.omit pbinom predict sd t.test
NULL

#' @importFrom utils read.csv
NULL

#' @importFrom graphics arrows points polygon text
NULL
