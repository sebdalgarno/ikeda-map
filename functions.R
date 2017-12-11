ps_load_spatial_db <- function(path = "~/Poisson/Data/spatial/fwa/gdb/FWA_BC.gdb", layers = NULL, crs = NULL, rename = identity,
                               envir = parent.frame(), fun = identity, ...) {
  
  check_string(path)
  if(!is_crs(crs)) ps_error("must provide a valid crs.")
  if (!is.function(rename)) ps_error("rename must be a function")
  if (!is.function(fun)) ps_error("fun must be a function")
  if (!file.exists(path)) ps_error(path, "' does not exist.")
  if(!(tools::file_ext(path) %in% c("gdb", "gpkg", "sqlite"))) ps_error("dir must have extension .gdb, .gpkg, or .sqlite")
  
  l <- sf::st_layers(path)$name
  if(is.null(layers)){layers <- l} else {layers <- layers}
  # if(!l %in% layers) ps_error("Layers do not exist in geodatabase.")
  
  g <- purrr::map(layers, ~ tryCatch(sf::st_read(dsn = path, layer = .), error = function(e) NULL))
  
  names(g) <- layers %>%
    rename() %>%
    make.names(unique = TRUE)
  
  # set crs
  if(!is.null(crs)){
    g %<>% purrr::map(function(x){
      if(is.na(sf::st_crs(x))){
        x %<>% sf::st_set_crs(crs)} else {
          x <- x
        }
    })
  }
  
  g %<>% purrr::map(fun)
  
  purrr::imap(g, function(x, name) {assign(name, x, envir = envir)})
  invisible(l)
}
