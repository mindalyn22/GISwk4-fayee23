
install.packages(c("sf", "tmap", "tmaptools", "RSQLite", "tidyverse"), 
                 repos = "https://www.stats.bris.ac.uk/R/")


#load data
library(sf)
# change this to your file path!!! with" /"or "\\"
shape <- st_read("D:/CASA/GIS/wk1/statistical-gis-boundaries-london/ESRI/London_Borough_Excluding_MHW.shp")


summary(shape)

plot(shape)

library(tidyverse)
#this needs to be your file path again. skip extra header. change encoding from UTF-8 to GBK(contain Chinese)
mycsv <-  read_csv("D:/CASA/GIS/wk1/fly_tipping_borough_edit.csv",skip = 1,locale=locale(encoding="GBK"))

mycsv 

#join data
shape <- shape%>%
  merge(.,
        mycsv,
        by.x="GSS_CODE", 
        by.y="Row Labels")

shape%>%
  head(., n=10)

library(tmap)
tmap_mode("plot")
# change the fill to your column name if different
shape %>%
  qtm(.,fill = "2011/12/1")

#Export data
shape %>%
  st_write(.,"D:/CASA/GIS/wk1/prac_data/Rwk1.gpkg",
           "london_boroughs_fly_tipping",
           delete_layer=TRUE)

library(readr)
library(RSQLite)

con <- dbConnect(RSQLite::SQLite(),dbname="D:/CASA/GIS/wk1/prac_data/Rwk1.gpkg")

con %>%
  dbListTables()

con %>%
  dbWriteTable(.,
               "original_csv",
               mycsv,
               overwrite=TRUE)

con %>% 
  dbDisconnect()

setwd("D:/CASA/GIS/wk1")

