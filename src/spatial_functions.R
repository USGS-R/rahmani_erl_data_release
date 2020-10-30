sf_to_zip <- function(zip_filename, sf_object, layer_name){
  cdir <- getwd()
  on.exit(setwd(cdir))
  dsn <- tempdir()

  sf_out <- sf_object %>% as('sf')

  sf::st_write(sf_out, dsn = dsn, layer = layer_name, driver="ESRI Shapefile", delete_dsn=TRUE) # overwrites

  files_to_zip <- data.frame(filepath = dir(dsn, full.names = TRUE), stringsAsFactors = FALSE) %>%
    mutate(filename = basename(filepath)) %>%
    filter(str_detect(string = filename, pattern = layer_name)) %>% pull(filename)

  setwd(dsn)
  # zip::zip works across platforms
  zip::zip(file.path(cdir, zip_filename), files = files_to_zip)
  setwd(cdir)
}

subset_points <- function(points_url, sites) {

  in_file <- 'in_data/gagesII_9322_sept30_2011.shp'
  if (!file.exists(in_file)) {
    dl_location <- file.path('in_data', 'catchment_points.zip')
    download.file(points_url, destfile = dl_location)
    zip::unzip(dl_location, exdir = 'in_data', overwrite = TRUE)
  }

  dat <- sf::st_read(in_file) %>%
    filter(STAID %in% sites) %>%
    select(site_no = STAID, site_name = STANAME, lat = LAT_GAGE, long = LNG_GAGE, geometry) %>%
    sf::st_transform(crs = 4326) %>% as_Spatial()

  return(dat)
}
