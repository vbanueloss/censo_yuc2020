library(dplyr)
library(stringr)

# Me tope con que lamentablemente el archivo dbf no contiene más informacion
# que la geografica, asi que hay que enlazar la base de toda la info del censo
# con los poligonos (.shp). Para ello creare la variable CVEGEO.
# Ya que me interesa la zona metropolitana de Merida y las AGEPS,
# seleccionare unicamente esto con dplyr.

# lectura de la base de datos
base<-read.csv("RESAGEBURB_31CSV20.csv", header=T, encoding = "UTF-8")

# seleccionar los municipios Kanasin, Merida y Uman
base<-base %>% filter(MUN==41 | MUN==50 | MUN==101)

# filtrar los datos para las AGEBS
base<-base %>% filter(NOM_LOC=="Total AGEB urbana")

# Con ayuda de QGIS se consulto el ID de cada poligono del shapefile. 
# Dicha variable se llama CVEGEO y tiene un cierto formato que se replicara.

# crear la variable CVEGEO
base$CVEGEO <- str_c("31",str_pad(base1$MUN, width = 3, side = "left", pad = "0"),
           str_pad(base1$LOC, width = 4, side = "left", pad = "0"),
           str_pad(base$AGEB, width = 4, side = "left", pad = "0"))
           
# este ID tambien puede ser creada en Excel con
# =31&TEXTO(D2,"000")&TEXTO(F2,"0000")&TEXTO(H2,"0000")

# imprimir la base
write.csv(base,"df_agebs.csv")
