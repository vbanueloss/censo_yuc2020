library(tidyverse)
library(sf)

#lectura de la informacion
df_agebs<-read.csv("df_agebs.csv")

### variables de interes
# VIVPAR_HAB
# VPH_NDACMM
# VPH_AUTOM
# VPH_MOTO
# VPH_BICI

# seleccionar variables de interes y reemplazar * por NA
df_agebs <- df_agebs %>% select(CVEGEO, VIVPAR_HAB, VPH_NDACMM, 
                               VPH_AUTOM, VPH_MOTO, VPH_BICI) %>%
  mutate_at(vars(-CVEGEO), na_if, "*")
# cambiar a variables de tipo numerico  
df_agebs <- mutate_at(df_agebs, vars(-CVEGEO), funs(as.numeric))

### lectura de poligonos
mapa_agebs<-st_read("31a.shp")
length(mapa_agebs$CVEGEO) #1532

# seleccionar municipios MERIDA, KANASIN, UMAN
mapa_agebs <- mapa_agebs %>% filter(CVE_MUN=="041" | CVE_MUN=="050" | CVE_MUN=="101")
length(mapa_agebs$CVEGEO) #628
length(df_agebs$CVEGEO) #624

### union de las bases por medio de la variable CVEGEO
mapa_agebs<-left_join(mapa_agebs, df_agebs, by="CVEGEO")
names(mapa_agebs)

### visualizacion de datos
 ## con ggplot

ggplot(data=mapa_agebs) +
  geom_sf(aes(fill=VPH_NDACMM), color='black') +
  xlab("Longitud") + ylab("Latitud") + 
  coord_sf(ylim=c(1037964.9,1068000),xlim=c(3768071,3789000))+
  ggtitle("Número de viviendas que no disponen de automóvil
  o camioneta, ni de motocicleta o motoneta", subtitle = "Censo de Población y Vivienda") +
  theme_classic()+
  scale_fill_continuous(low = "#FEF0D9", high = "#991200")

ggplot(data=mapa_agebs) +
  geom_sf(aes(fill=VPH_NDACMM/VIVPAR_HAB), color='black') +
  xlab("Longitud") + ylab("Latitud") + 
  coord_sf(ylim=c(1037964.9,1068000),xlim=c(3768071,3789000))+
  ggtitle("Porcentaje de viviendas que no disponen de automóvil
  o camioneta, ni de motocicleta o motoneta", subtitle = "Censo de Población y Vivienda") +
  theme_classic()+
  scale_fill_continuous(low = "#FEF0D9", high = "#991200")

 ## con tmap
library('tmap')

# A diferencia de ggplot, se debe de crear la variable antes para poder graficarla
mapa_agebs <- mapa_agebs %>% mutate(PVPH_NDACMM=VPH_NDACMM/VIVPAR_HAB)

# mapa base
mapa <- tm_shape(mapa_agebs) + tm_borders()

#viviendas particulares habitadas
mapa + tm_fill(col="VIVPAR_HAB")

#viviendas sin carro ni moto
mapa + tm_fill(col="VPH_NDACMM")

# sin frame y utilizando tm_polygons en vez de tm_borders
g1<-tm_shape(mapa_agebs) +
  tm_polygons(col="PVPH_NDACMM") + tm_layout(frame=F)

# sin leyenda
g2<-tm_shape(mapa_agebs) +
  tm_polygons(col="PVPH_NDACMM") + tm_layout(legend.show = F, frame=F)

### guardar un mapa en formato png
tmap_save(g1,"PVPH_NDACMM1.png")