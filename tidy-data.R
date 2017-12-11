source('header.R')

set_sub("get")
load_datas()

bounds_bay <- ps_create_bounds(sites, pad = c(500, 1500, 500, 1500)) %>%
  st_sf

sites %<>% mutate(Description = if_else(is.na(Description), "building", as.character(Description)))
sites %<>% mutate(HaidaSource = if_else(HaidaSource == "building", NA_character_, as.character(HaidaSource)))

sites %<>% mutate(Name = if_else(Description == "haida village", "", as.character(Name))) %>%
  # mutate(Label = paste0("Haida: ", NameHaida, "\n", "Translation: ", TranslationHaida, "\n", "Common: ", Name))
  mutate(Label = paste0(NameHaida, "\n", "(", TranslationHaida, ")", "\n", Name)) %>%
  cbind(st_coordinates(.))

bay <- filter(sites, Description == "bay") 

ikeda <- filter(sites, Name == "Ikeda Point") 

awaya <- filter(sites, Name == "Awaya Point") 

jedway <- filter(sites, Name == "Jedway") 

village <- filter(sites, Description == "haida village") %>%
  mutate(Label = paste0(NameHaida, "\n", "(", TranslationHaida, ")")) %>%
  mutate(legend = "Haida Village Sites")


sites_town <- filter(sites, !(Name %in% c("Bunk House", "Ore Bins", "Power House"))) %>%
  filter(Description == "building") %>%
  mutate(legend = "Building")

bounds_town <- ps_create_bounds(sites_town, pad = c(50, 50, 50, 50)) %>%
  st_sf

ikeda_coast <- st_intersection(coastline, bounds)
ikeda_island <- st_intersection(island, bounds)

set_sub("tidy")
save_datas()