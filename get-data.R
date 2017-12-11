source('header.R')
library(mapedit)

routes <- st_read("input/ikeda.gpkg", "routes")
sites <- st_read("input/ikeda.gpkg", layer = "sites") %>% st_transform(3005)
creek <- st_read("input/ikeda.gpkg", "creek") %>% st_transform(3005)
building <- st_read("input/ikeda.gpkg", layer = "buildings") %>% st_transform(3005)
train <- st_read("input/ikeda.gpkg", layer = "train") %>% st_transform(3005)

bounds <- ps_create_bounds(sites, pad = c(500, 1500, 500, 1500))

set_sub("get")
save_datas()
