zip_this <- function(out_file, .object){
  
  if ('data.frame' %in% class(.object)){
    filepath <- basename(out_file) %>% tools::file_path_sans_ext() %>% paste0('.csv') %>% file.path(tempdir(), .)
    write_csv(.object, path = filepath)
    zip_this(out_file = out_file, .object = filepath)
  } else if (class(.object) == 'character' & file.exists(.object)){
    # for multiple files?
    curdir <- getwd()
    on.exit(setwd(curdir))
    setwd(dirname(.object))
    zip::zip(file.path(curdir, out_file), files = basename(.object))
  } else {
    stop("don't know how to zip ", .object)
  }
}

zip_obs <- function(out_file, in_file){
  if (grepl('csv', in_file)) {
    zip_this(out_file, .object = readr::read_csv(in_file))
    
  } else if (grepl('rds', in_file)) {
    zip_this(out_file, .object = readRDS(in_file))
  } else {
    message('There is no reader for this filetype. Please modify function zip_obs.')
  }
  
}