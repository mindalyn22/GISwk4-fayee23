#reproject
#crop and mask rasters
#remove and extract data from points
#drop the geometry and make plot for per month

library(sf)
library(here)
library(janitor)
library(tidyverse)
library(terra)
library(ggplot2)
library(raster)

# 打开分析范围的outline
CHNoutline <- sf::st_read(here("prac3_data", "gadm41_CHN.gpkg"), 
                      layer='ADM_ADM_0')
world_cities <- sf::st_read(here("prac3_data", "World_Cities", "World_cities.shp"))
#identify a coordinate reference system
st_crs(CHNoutline)$proj4string 
# open data 
ssp1 <- terra::rast(here("prac3_data", "wc2.1_2.5m_tmax_CMCC-ESM2_ssp126_2081-2100.tif"))
ssp5 <- terra::rast(here("prac3_data", "wc2.1_2.5m_tmin_CMCC-ESM2_ssp585_2081-2100.tif"))
# have a look at the raster layer
ssp1
ssp5
#ssp5-ssp1


#fliter cities
CHNcities <- world_cities %>%
  janitor::clean_names()%>%
  dplyr::filter(cntry_name=="China")


#crop and mask temp rasters
CHNdiff1 <- ssp1 %>%
  terra::crop(., CHNoutline)

exact_CHN1 <- CHNdiff1 %>%
  terra::mask(.,CHNoutline)

CHNdiff5 <- ssp5 %>%
  terra::crop(., CHNoutline)

exact_CHN5 <- CHNdiff5 %>%
  terra::mask(.,CHNoutline)


#subtract raster: 
CHNdiff_temp <- exact_CHN5 - exact_CHN1

#rename
month <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", 
           "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

names(CHNdiff_temp) <- month

CHN_city_diff <- terra::extract(CHNdiff_temp, CHNcities)

#join data to cities frame
#make a join ID column in the original point sf and use that to join
CHNcities_join_ID <- CHNcities %>%
  dplyr::mutate(join_id= 1:n())

#join
CHN_city_diff2 <- CHNcities_join_ID%>%
  dplyr::left_join(.,
                   CHN_city_diff,
                   by = c("join_id" = "ID"))


#Drop the geometry
city_climate_diff <- CHN_city_diff2 %>%
  dplyr::select(c(,16:27))%>%
  sf::st_drop_geometry(.)%>%
  dplyr::as_tibble()
#置换行列，变为长表
tidy_city_diff <- city_climate_diff %>%
  tidyr::pivot_longer(everything(), 
                      names_to="Months", 
                      values_to="temp_diff")
#按月份排序
facet_plot <- tidy_city_diff %>%
  dplyr::mutate(Months = factor(Months, levels = c("Jan","Feb","Mar",
                                                   "Apr","May","Jun",
                                                   "Jul","Aug","Sep",
                                                   "Oct","Nov","Dec")))

# Plot faceted histogram
plot<-ggplot(facet_plot, aes(x=temp_diff, na.rm=TRUE))+
  geom_histogram(color="black", binwidth = .1)+
  labs(title="Ggplot2 faceted difference in climate scenarios of max temp", 
       x="Temperature",
       y="Frequency")+
  facet_grid(Months ~ .)+
  theme(plot.title = element_text(hjust = 0.5))

plot