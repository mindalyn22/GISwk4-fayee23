#change working directory
setwd()

#alt - to type '<-', assigned a value
A <- 1
B <- 2
C <- A+B
C

ls()
rm(A)

#save the output to a new project
X <- function(data, argument1, argument2, argument3)

#create some datasets
Data1 <- c(1:100)
Data2 <- c(101:200)
#plot the data
plot(Data1, Data2, col="red")

#normally distributed
#vectors of 100 numbers
Data3 <- rnorm(100, mean = 53, sd =34)
Data4 <- rnorm(100, mean =64, sd=14)
#plot
plot(Data3,Data4, col="blue")

#df: data.frame
df <- data.frame(Data1, Data2)
plot(df, col="green")

#help, add "?" before the function
?rnorm

#show the first 10 and then last 10 rows of data in df...
library(tidyverse)
df %>%
  head()
df %>%
  tail()

#select elements of a data frame
data.frame[row,column]
df[1:10, 1]
df[5:15,]
df[c(2,3,6),2]
df[,1]

# provide some kind of data to dplyr followed by a %>% then a verb (or other function)
library(dplyr)
df <- df %>%
  dplyr::rename(column1 = Data1, column2=Data2)

df %>% 
  dplyr::select(column1)
#for raster data
df$column1
df[["column1"]]

#load data
#want the data in straight from the web using read_csv, 
#skipping over the 'n/a' entries as you go...
LondonData <- read_csv("https://data.london.gov.uk/download/ward-profiles-and-atlas/772d2d64-e8c6-46cb-86f9-e52b4c7851bc/ward-profiles-excel-version.csv",
                       locale = locale(encoding = "latin1"),
                       na = "n/a")
