#### Script utilisé pour le répertoire "Sckende/TdeB_richesse_Quebec"

rm(list = ls())
library(leaflet)
library(sf)
library(rgdal)
library(rmapshaper)
library(spatialEco)
getwd()
#### Chargement données LINUX ####
# ---------- Chargement des polygones
CR01 <- rgdal::readOGR("/home/claire/Bureau/PostDoc_COLEO/GitHub/Richesse_Qc/CERQ_SHP/", layer = "CR_NIV_01_S") # Provincial
CR01 <- sp::spTransform(CR01, CRS("+proj=longlat +datum=WGS84 +no_defs"))

# ---------- Chargement des occurences d'espèces
occ <- readRDS("/home/claire/Bureau/PostDoc_COLEO/GitHub/Richesse_Qc/tmp.rds")

#### Chargement données WINDOWS ####
# ---------- Chargement des polygones
CR01 <- rgdal::readOGR("C:/Users/HP_9470m/Desktop/PostDoc_COLEO/GitHub/Richesse_Qc/CERQ_SHP", layer = "CR_NIV_01_S", stringsAsFactors = FALSE, encoding = "UTF-8")
CR01 <- sp::spTransform(CR01, CRS("+proj=longlat +datum=WGS84 +no_defs"))

str(CR01, max.level = 3)

# ---------- Chargement des occurences d'espèces
occ <- readRDS("C:/Users/HP_9470m/Desktop/PostDoc_COLEO/GitHub/Richesse_Qc/tmp.rds")



#### Provinces naturelles ####

# ----------  Création d'une fonction pour obtenir une couleur par province
pal <- colorFactor("Dark2", domain = CR01$NOM_PROV_N)

# ----------  Création d'une fonction pour obtenir une couleur par groupe d'espèces
pal_esp <- colorFactor("Dark2", domain = unique(occ$species_gr))

# ----------  Création des pop-ups par province
labels <- sprintf( #Use C-style String Formatting Commands
  "<strong>%s</strong>",
  CR01$NOM_PROV_N
) %>% lapply(htmltools::HTML)

# ---------- Association des provinces naturelles avec les occurences
# Intersection occurences et polygones
coord_occ <- occ[,c(7,8)] 
sp::coordinates(occ) <- ~lon+lat # création d'un objet de classe SpatialPointDataFrame
proj4string(occ) <- "+proj=longlat +datum=WGS84 +no_defs" # Définir le CRS des occurences
pts_in_poly <- spatialEco::point.in.poly(occ, CR01) # Association d'une province naturelle (ou NA si en dehors) et de tous ses attributs pour chaque occurence
head(pts_in_poly@data)
pts_in_poly@data$NOM_PROV_N <- as.factor(pts_in_poly@data$NOM_PROV_N)
summary(pts_in_poly@data)
pts_in_poly@data <- cbind(pts_in_poly@data, coord_occ) # récupération des lat/long
occ_qc <- pts_in_poly@data[!is.na(pts_in_poly@data$NOM_PROV_N),] # Retrait des occurences en dehors du Québec

# ---------- Sous-selection du jeu de données des occurences
# n_rows <- 50000
# occ_short <- occ[sample(nrow(occ), n_rows), ]

# ---------- Réduction de la résolution des polygones pour augmenter la vitesse
CR01_sf <- sf::st_as_sf(CR01)
CR01_sf <- rmapshaper::ms_simplify(CR01_sf, keep=.01)

# ----------  Création de la carte
#x11()
leaflet(CR01_sf) %>%
  addTiles() %>% # Affichage du fond de carte
  addPolygons(color = "white", # couleur des limites des polygones
              weight = 1,
              smoothFactor = 0.5,
              fillColor = ~pal(NOM_PROV_N), # couleur du remplissage des polygones
              fillOpacity = 0.6,
              highlightOptions = highlightOptions(color = "white",
                                                  weight = 4,
                                                  fillOpacity = 0.7,
                                                  bringToFront = TRUE),
              label = labels,
              labelOptions = labelOptions("font-weight" = "normal",
                                          padding = "3px 8px",
                                          textsize = "15px",
                                          direction = "auto")) %>%
  addMarkers(lng = occ_qc$lon,
             lat = occ_qc$lat,
             clusterOptions = markerClusterOptions()
             )

#### Régions naturelles ####
# ---------- Chargement des données LINUX

CR02 <- rgdal::readOGR("/home/claire/Bureau/PostDoc_COLEO/GitHub/Richesse_Qc/CERQ_SHP/", layer = "CR_NIV_02_S") # Régional

# ---------- Chargement des données WINDOWS
CR02 <- rgdal::readOGR("C:/Users/HP_9470m/Desktop/PostDoc_COLEO/GitHub/Richesse_Qc/CERQ_SHP", layer = "CR_NIV_02_S")

# ---------- Correction de la projection
CR02 <- spTransform(CR02, CRS("+proj=longlat +datum=WGS84 +no_defs"))

str(CR02, max.level = 3)

leaflet(CR02) %>%
  addTiles() %>% # Affichage du fond de carte
  addPolygons()
