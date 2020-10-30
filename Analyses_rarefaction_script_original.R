
#================================================================================

# Préparation de l'environnement

#================================================================================

library(iNEXT)

#================================================================================

# Charger les données

#================================================================================

data = readRDS("./source_data/tmp.rds")

#================================================================================

# Subset selon les contraintes imposées par le menu

#================================================================================

#================================================================================

# Analyse de raréfaction

#================================================================================

groups <- unique(data$species_gr)

freq <- list()

for(i in 1:length(groups))
{
  
  sub <- subset(data,
                data$species_gr == groups[i])
  
  freq[[i]] <- sort(table(sub$scientific_name),
                    decreasing = TRUE)
  
}

names(freq) <- groups

rare <- iNEXT(freq, q=0,
              datatype="incidence_freq")

#================================================================================

# Réalisation du tableau

#================================================================================

#rare$AsyEst[rare$AsyEst[,2]=="Species richness",c(1,3,4,6,7)]

rare$AsyEst[rare$AsyEst$Diversity=="Species richness",c(1,3,4,6,7)]