source('header.R')
library(mapedit)

ps_load_spatial_db(path = "input/ikeda.gpkg", fun = function(x){st_transform(x, 3005)})
rm(ikeda)

set_sub("get")
save_datas()



