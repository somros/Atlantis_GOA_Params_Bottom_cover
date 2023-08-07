props <- read.csv('abiotic_habitat.csv')
atlantis_bgm <- read_bgm("GOA_WGS84_V4_final.bgm")
atlantis_box <- box_sf(atlantis_bgm)

# join and plot
dat <- left_join(atlantis_box, props, by = c('.bx0','boundary','botz'))


coast <- maps::map("worldHires", c("USA","Canada"), plot = FALSE, fill = TRUE)
coast_sf <- coast %>% st_as_sf() %>% st_transform(crs = atlantis_crs)

bounds <- st_bbox(atlantis_box)


p <- dat %>%
  ggplot()+
  geom_sf(aes(fill=cover))+
  scale_fill_viridis()+
  geom_sf(data = coast_sf)+
  coord_sf(xlim=c(bounds$xmin,bounds$xmax),ylim=c(bounds$ymin,bounds$ymax))+
  facet_wrap(~atlantis_class,ncol=1)+
  labs(fill = 'Proportional\ncover')+
  theme_bw()
ggsave('abiotic_cover.png',p,width = 6, height = 6)