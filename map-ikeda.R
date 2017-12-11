source('header.R')
set_sub("tidy")
load_datas()

bounds_town <- ps_create_bounds(sites_town, pad = 100) %>%
  st_sf

lims_bay <- st_bbox(bounds_bay) %>%
  ps_pad_bbox(c(-1610, -1200, 200, 200)) %>%
  as.vector

lims_town <- st_bbox(bounds_town) %>%   
  # ps_pad_bbox(c(50, 200, 0, 0)) %>%
  as.vector

map <- ggplot() +
  geom_sf(data = ikeda_island, fill = "white", alpha = 0.9) +
  geom_sf(data = creek, color = "#0087be") + 
  geom_point(data = village, aes(x = X, y = Y, color = legend), size = 3, show.legend = T) +
  scale_color_manual(values = c("black", "black"), name = "", guide = "legend") +
  geom_label_repel(data = slice(village, 1), aes(x = X, y = Y, label = Label), 
            size = 3.5, nudge_x = -350, nudge_y = 500, fontface = "bold") +
  geom_label_repel(data = slice(village, 2), aes(x = X, y = Y, label = Label), 
            size = 3.5, nudge_x = 700, nudge_y = 300, fontface = "bold") +
  geom_text_repel(data = bay, aes(x = X, y = Y, label = Label), 
             size = 3.5, nudge_x = 900, nudge_y = -150, fontface = "bold", point.padding = unit(2, "lines")) +
  geom_text(data = awaya, aes(x = X, y = Y, label = Label), 
             size = 3.5, nudge_x = 520, nudge_y = -100, fontface = "bold") +
  geom_text_repel(data = ikeda, aes(x = X, y = Y, label = Label), 
             size = 3.5, nudge_x = 260, nudge_y = 200, fontface = "bold") +
  geom_text(data = jedway, aes(x = X, y = Y, label = Name), 
             size = 3.5, nudge_x = 200, nudge_y = 100, fontface = "bold") +
  geom_text(data = NULL, aes(x = bay$X, y = bay$Y, label = "Inlet Big Creek"), 
            size = 3.5, nudge_x = -1900, nudge_y = -300, fontface = "bold", color = "#0087be") +
  geom_sf(data = bounds_town, fill = "transparent", size = 1.5, color = "black") +
  coord_sf(xlim = c(lims_bay[1], lims_bay[3]), ylim = c(lims_bay[2], lims_bay[4])) +
  theme(panel.background = element_rect(fill = "light blue"),
        legend.position = c(0.11, 0.09),
        legend.background = element_rect(fill = "transparent"),
        legend.key = element_blank()) +
  labs(x = "Longitude", y = "Latitude") +
  ggsn::scalebar(data = NULL, location = "bottomleft", dist = 0.5,
                 height = 0.007, st.size = 2.3, st.dist = 0.015,
                 x.min = lims_bay[1], x.max = lims_bay[3], y.min = lims_bay[2], y.max = lims_bay[4]) 

inset <- ggplot() +
  geom_sf(data = ikeda_island, fill = "white", alpha = 0.9) +
  geom_sf(data = creek, color = "#0087be") + 
  geom_sf(data = buildings, fill = "black") +
  # geom_point(data = sites_town, aes(x = X, y = Y, color = legend), size = 4) +
  scale_color_manual(values = "black", name = "", guide = "legend") +
  # geom_sf(data = train, color = "grey30") +
  geom_text_repel(data = filter(sites_town, Name == "Blacksmith Shop"), aes(x = X, y = Y, label = Name),
                  size = 6, nudge_x = -40, nudge_y = -20) +
  geom_text_repel(data = filter(sites_town, Name == "Assay Office"), aes(x = X, y = Y, label = Name),
                  size = 6, nudge_x = -10, nudge_y = 20) +
  geom_text_repel(data = filter(sites_town, Name == "Barn"), aes(x = X, y = Y, label = Name),
                  size = 6, nudge_x = -25, nudge_y = -10) +
  geom_text_repel(data = filter(sites_town, Name == "Residence"), aes(x = X, y = Y, label = Name),
                  size = 6, nudge_x = -5, nudge_y = 20) +
  geom_text_repel(data = filter(sites_town, Name == "Wharf"), aes(x = X, y = Y, label = Name),
                  size = 6, nudge_x = -5, nudge_y = 10) +
  geom_text_repel(data = filter(sites_town, Name == "Ore Bunkers"), aes(x = X, y = Y, label = Name),
                  size = 6, nudge_x = -5, nudge_y = 20) +
  coord_sf(xlim = c(lims_town[1], lims_town[3]), ylim = c(lims_town[2], lims_town[4])) +
  ggmap::theme_inset() +
  theme(panel.background = element_rect(fill = "light blue")) +
  labs(x = "Longitude", y = "Latitude") +
  ggsn::scalebar(data = NULL, location = "topleft", dist = 0.1,
                 height = 0.009, st.size = 2.7, st.dist = 0.02,
                 x.min = lims_town[1], x.max = lims_town[3], y.min = lims_town[2], y.max = lims_town[4]) +
  theme(legend.position = c(0.075, 0.92),
        legend.background = element_rect(fill = "transparent"),
        legend.key = element_blank(),
        panel.border = element_rect(fill = "transparent", color = "black", size = 2))


dir.create("output/plots/maps")
png(filename = "output/plots/maps/ikeda_map.png", width = 3200, height = 2400, res = 300)
vpm <- viewport(width = 1, height = 1, x = 0.5, y = 0.5)
vpi <- viewport(width = 0.45, height = 0.45, x = 0.505, y = 0.922, just = c("right", "top"))
print(map, vp = vpm)
print(inset, vp = vpi)
dev.off()

