sf_to_zip <- function(zip_filename, sf_object, layer_name){
  cdir <- getwd()
  on.exit(setwd(cdir))
  dsn <- tempdir()
  
  sf_out <- dplyr::select(sf_object, seg_id_nat, geometry)
  
  sf::st_write(sf_out, dsn = dsn, layer = layer_name, driver="ESRI Shapefile", delete_dsn=TRUE) # overwrites
  
  files_to_zip <- data.frame(filepath = dir(dsn, full.names = TRUE), stringsAsFactors = FALSE) %>%
    mutate(filename = basename(filepath)) %>%
    filter(str_detect(string = filename, pattern = layer_name)) %>% pull(filename)

  setwd(dsn)
  # zip::zip works across platforms
  zip::zip(file.path(cdir, zip_filename), files = files_to_zip)
  setwd(cdir)
}