retrieve_ids <- function(in_file) {
  dat <- readr::read_csv(in_file) %>%
    pull(site_no)
  return(dat)
}

extract_AT_attributes <- function(out_file, in_file){
  dat <- readr::read_csv(in_file) %>%
    select(site_no, DRAIN_SQKM, STREAMS_KM_SQ_KM, STOR_NID_2009, FORESTNLCD06, PLANTNLCD06, SLOPE_PCT, RAW_DIS_NEAREST_MAJ_DAM, PERDUN, RAW_DIS_NEAREST_DAM, RAW_AVG_DIS_ALL_MAJ_DAMS, T_MIN_BASIN, T_MINSTD_BASIN, RH_BASIN, RAW_AVG_DIS_ALLDAMS, PPTAVG_BASIN, HIRES_LENTIC_PCT, T_AVG_BASIN, T_MAX_BASIN, T_MAXSTD_BASIN, NDAMS_2009, ELEV_MEAN_M_BASIN)

  readr::write_csv(dat, out_file)
}

extract_AQ_attributes <- function(out_file, in_file) {
  dat <- readr::read_csv(in_file) %>%
    select(site_no, ELEV_MEAN_M_BASIN, SLOPE_PCT, DRAIN_SQKM, HYDRO_DISTURB_INDX, STREAMS_KM_SQ_KM, BFI_AVE, NDAMS_2009, STOR_NID_2009, RAW_DIS_NEAREST_DAM, FRAGUN_BASIN, DEVNLCD06, FORESTNLCD06, PLANTNLCD06, PERMAVE, RFACT, PPTAVG_BASIN, BARRENNLCD06, DECIDNLCD06, EVERGRNLCD06, MIXEDFORNLCD06, SHRUBNLCD06, GRASSNLCD06, WOODYWETNLCD06, EMERGWETNLCD06, GEOL_REEDBUSH_DOM_PCT, STRAHLER_MAX, MAINSTEM_SINUOUSITY, REACHCODE, ARTIFPATH_PCT, ARTIFPATH_MAINSTEM_PCT, HIRES_LENTIC_PCT, PERDUN, PERHOR, TOPWET, CONTACT, CANALS_PCT, RAW_AVG_DIS_ALLCANALS, NPDES_MAJ_DENS, RAW_AVG_DIS_ALL_MAJ_NPDES, RAW_AVG_DIS_ALL_MAJ_DAMS, FRESHW_WITHDRAWAL, PCT_IRRIG_AG, POWER_NUM_PTS, POWER_SUM_MW, ROADS_KM_SQ_KM, PADCAT1_PCT_BASIN, PADCAT2_PCT_BASIN)

  readr::write_csv(dat, out_file)

}

subset_pred_discharge <- function(out_file, in_file){
  dat <- readr::read_csv(in_file) %>%
    select(site_no, datetime, `sim_discharge(cfs)` = combine_discharge) %>%
    filter(datetime > as.Date('2014-09-30')) # predicted Q only in test period

  readr::write_csv(dat, out_file)
}

subset_weather_drivers <- function(in_file) {
  dat <- readr::read_csv(in_file) %>%
    select(-X1, -`00010_Mean`, -`00060_Mean`, -combine_discharge) %>%
    filter(datetime >= as.Date('2010-10-01') & datetime <= as.Date('2016-09-30')) %>%
    select(site_no, everything())

  return(dat)
}

extract_obs <- function(out_file, var, in_file) {
  dat <- readr::read_csv(in_file) %>%
    filter(datetime >= as.Date('2010-10-01') & datetime <= as.Date('2016-09-30'))
  if (var == 'wtemp(C)') {
    dat_out <- select(dat, site_no, datetime,`00010_Mean`) %>%
      rename({{var}} := `00010_Mean`) %>%
      filter(!is.na(.data[[var]]))
  } else if (var == 'discharge(cfs)') {
    dat_out <- select(dat, site_no, datetime, `00060_Mean`) %>%
      rename({{var}} := `00060_Mean`) %>%
      filter(!is.na(var))
  }

  readr::write_csv(dat_out, out_file)

}

npy_to_csv <- function(in_file, out_file, sites) {

  np <- import('numpy')
  dat <- np$load(in_file)
  dat_long <- as.numeric(unlist(dat))
  dat_out <- tibble(site_no = rep(sites, 731),
                        datetime = rep(seq.Date(from = as.Date('2014-10-01'), to = as.Date('2016-09-30'), 1), each = 118),
                        `sim_wtemp(C)` = dat_long)

  readr::write_csv(dat_out, out_file)
}

extract_metrics <- function(out_file, mod_index, sites, in_file) {
  np <- import('numpy')
  dat <- np$load(in_file, allow_pickle = TRUE)
  dat_out <- dat$f[["A"]][mod_index][[1]]

  dat_df <- data.frame(site_no = sites,
                       Bias = dat_out[['Bias']],
                       RMSE = dat_out[['RMSE']],
                       ubRMSE = dat_out[['ubRMSE']],
                       NSE = dat_out[['NSE']],
                       NSE_res = dat_out[['NSE_res']],
                       Corr_res = dat_out[['Corr_res']])

  readr::write_csv(dat_df, out_file)

  }
