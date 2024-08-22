
#   Trap Mapper
#   Mapping pollen traps places as part of the VegeMap project

#   Alex F Wall
#   version 22/8/24

rm(list = ls())

if (!requireNamespace("mapview", quietly = TRUE)) install.packages("mapview")
library(mapview)

if (!requireNamespace("googlesheets4", quietly = TRUE)) install.packages("googlesheets4")
library(googlesheets4)
gs4_auth(email = "alexfwall@gmail.com", cache = ".secrets")

if (!requireNamespace("tidyverse", quietly = TRUE)) install.packages("tidyverse")
library(tidyverse)

if (!requireNamespace("postcards", quietly = TRUE)) install.packages("postcards")
library(postcards)

# Read data from a Google Sheet
sheet_url <- "https://docs.google.com/spreadsheets/d/17fGeRsr3lQoOHPTL9B8MovFWV3XM7u6wvXxCPTVfmN8/edit?usp=sharing"
tm <- read_sheet(sheet_url)

tm <- tm %>% drop_na("Latitude", "Longitude")

tm <- tm %>% mutate(Country = ifelse(is.na(Country), "Unknown", Country))

# Extract just the first name from the "Installer" column
tm <- tm %>%
  mutate(Pollen_Trapper = str_extract(Installer, "^[^ ]+"))  # Extract everything before the first space


mapviewOptions(default = TRUE, fgb = FALSE, basemaps.color.shuffle = FALSE,
               basemaps = c("Esri.WorldImagery", "CartoDB.Positron", "CartoDB.DarkMatter"))

tm.mp <- sf::st_as_sf(tm, coords = c("Longitude", "Latitude"), 
                      remove = TRUE, crs = 4326)

map <- 
  
  mapview(tm.mp, xcol = "Longitude", ycol = "Latitude", 
          #zcol = "Transect",
          cex = 8, alpha.regions = 0.5, legend = TRUE, 
          col.regions = "yellow",
          layer.name = "Pollen Traps",
          popup = leafpop::popupTable(tm.mp, 
                                      zcol = c("Trap", "Country", "Installed_Date", "Pollen_Trapper")
          )
  )

print(map)

if (!requireNamespace("webshot", quietly = TRUE)) install.packages("webshot")
library(webshot)
if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
library(here)

# Convert mapview object to a leaflet object
leaflet_map <- map@map

if (!requireNamespace("htmlwidgets", quietly = TRUE)) install.packages("htmlwidgets")
library(htmlwidgets)

# Save as an HTML file using saveWidget
saveWidget(leaflet_map, "map.html", selfcontained = TRUE)
