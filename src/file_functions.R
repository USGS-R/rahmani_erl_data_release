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

zip_dir <- function(out_file, in_dir) {
  if(!dir.exists(dirname(out_file))) dir.create(dirname(out_file))
  curdir <- getwd()
  on.exit(setwd(curdir))
  setwd(dirname(in_dir))
  zip::zip(file.path(curdir, out_file), files = basename(in_dir))
}

copy_zip_repo <- function(out_file, cache_dir, source_dir) {
  # cache_dir is probably created, but just in case...
  if(!dir.exists(dirname(cache_dir))) dir.create(dirname(cache_dir))

  # copy the repo into the same dir where we'll create the zip file
  unlink(cache_dir, recursive=TRUE)
  file.copy(source_dir, dirname(cache_dir), recursive=TRUE)

  # remove all .gitignored files, .git/, and .gitignore
  gitignore <- readr::read_lines(file.path(cache_dir, '.gitignore')) %>%
    # gsub('\\.', '\\\\.', .) %>%
    gsub('\\*\\*', '*', .) %>%
    gsub('\\*', '.*', .) %>%
    gsub('/$', '', .) %>%
    file.path(cache_dir, .)
  for(gi in gitignore) {
    message('unlinking ', gi)
    unlink(gi, recursive=TRUE)
  }
  unlink(file.path(cache_dir, '.git'), recursive=TRUE)
  unlink(file.path(cache_dir, '.gitignore'))

  # zip the repo
  zip_dir(out_file, cache_dir)
}
