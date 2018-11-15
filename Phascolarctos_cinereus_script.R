library(spocc)
library(raster)
library(mapr)

species1 <- occ(query='Phascolarctos cinereus', from='gbif')
map_leaflet(species1)
