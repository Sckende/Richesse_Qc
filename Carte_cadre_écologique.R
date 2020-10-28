library(leaflet)
library(sf)
library(rgdal)

getwd()

CR00 <- rgdal::readOGR("/home/claire/Bureau/PostDoc_COLEO/GitHub/Richesse_Qc/CERQ_SHP/", layer = "CR00_LIGNES")
CR01 <- rgdal::readOGR("/home/claire/Bureau/PostDoc_COLEO/GitHub/Richesse_Qc/CERQ_SHP/", layer = "CR_NIV_01_S")
CR01 <- spTransform(CR01, CRS("+proj=longlat +datum=WGS84 +no_defs"))
CR02 <- rgdal::readOGR("/home/claire/Bureau/PostDoc_COLEO/GitHub/Richesse_Qc/CERQ_SHP/", layer = "CR_NIV_02_S")
CR02 <- spTransform(CR02, CRS("+proj=longlat +datum=WGS84 +no_defs"))

# Provinces naturelles
leaflet(CR01) %>%
  addTiles() %>% # Affichage du fond de carte
  addPolygons()

# Régions naturelles
leaflet(CR02) %>%
  addTiles() %>% # Affichage du fond de carte
  addPolygons()
