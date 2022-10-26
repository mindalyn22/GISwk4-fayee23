library(sf)
library(tmap) 
library(tmaptools)
library(RSQLite)
library(tidyverse)

#load data
#read in the shapefile
shape <- st_read(
  "D:/CASA/GIS/wk1/statistical-gis-boundaries-london/ESRI/London_Borough_Excluding_MHW.shp")
# read in the csv. skip extra header. change encoding from UTF-8 to GBK(contain Chinese)
mycsv <-  read_csv("D:/CASA/GIS/wk1/fly_tipping_borough_edit.csv",skip = 1,locale=locale(encoding="GBK"))

#join data
# merge csv and shapefile, change "x""y" to your column name if different, x <- shape,y <- csv
shape <- shape%>%
  merge(.,
        mycsv,
        by.x="GSS_CODE",
        by.y="Row Labels")
# set tmap to plot
tmap_mode("plot")
# have a look at the map
qtm(shape, fill = "2011_12")

#export data
# write to a .gpkg, set layer name
shape %>%
  st_write(.,"D:/CASA/GIS/wk1/prac_data/Rwk1.gpkg",
           "london_boroughs_fly_tipping",
           delete_layer=FALSE) # it should be TRUE if re-run 
# connect to the .gpkg
con <- dbConnect(SQLite(),dbname="D:/CASA/GIS/wk1/prac_data/Rwk1.gpkg")
# list what is in it
con %>%
  dbListTables()
# add the original .csv
con %>%
  dbWriteTable(.,
               "original_csv",
               mycsv,
               overwrite=TRUE)
# disconnect from it
con %>% 
  dbDisconnect()

setwd("D:/CASA/GIS/wk1")

