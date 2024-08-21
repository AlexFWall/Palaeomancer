#                                                            
#    Traps n Maps locations                           
#                                                            
#    Written by Alex F Wall                                  
#    version 12-07-2024                                      
#
#    requires packages within .Rprofile                      

if (!requireNamespace("tidyverse", quietly = TRUE)) install.packages("tidyverse")
library(tidyverse)

if (!requireNamespace("mapview", quietly = TRUE)) install.packages("mapview")
library(mapview)

if (!requireNamespace("googlesheets4", quietly = TRUE)) install.packages("googlesheets4")
library(googlesheets4)

# Read data from a Google Sheet
sheet_url <- "https://docs.google.com/spreadsheets/d/1UJg_n3N37sIlt3zRsUzhtZDJDXR3iB5-9ChF1fDvGBE/edit#gid=973178456"
tm <- read_sheet(sheet_url)

tm <- tm %>% drop_na("Latitude", "Longitude")

mapviewOptions(default = TRUE, fgb = FALSE, basemaps.color.shuffle = FALSE,
               basemaps = c("CartoDB.Positron", "Esri.WorldImagery", "CartoDB.DarkMatter"))

tm.mp <- sf::st_as_sf(tm, coords = c("Longitude", "Latitude"), 
                      remove = TRUE, crs = 4326)

TrapMap <- 

  mapview(tm.mp, xcol = "Longitude", ycol = "Latitude", 
          #zcol = "Transect",
          cex = 8, alpha.regions = 0.5, legend = TRUE, 
          #  col.regions = "green",
          layer.name = "T&M sites",
          popup = leafpop::popupTable(tm.mp, 
#                        zcol = c("TERN_ID", "Pollen_ID", "X", "geometry")
          )
  )

print(TrapMap)

# Install and load htmlwidgets package
if (!requireNamespace("htmlwidgets", quietly = TRUE)) install.packages("htmlwidgets")
library(htmlwidgets)

# Save the map using saveWidget
saveWidget(TrapMap@map, "map.html", selfcontained = TRUE)
