library(pacman)
p_load(XML, readr,openxlsx,tidyverse, rvest,xml2, stringr)
rm(list=ls(all=TRUE))
#Web scraping de resultados encuestas Polls-Mx
polls_mx <- "https://polls.mx/presidencia/"
polls_mx_web <- readLines(polls_mx, encoding = "UTF-8")
polls_mx_web <- htmlParse(polls_mx_web,encoding = "UTF-8")
#polls_mx_web["//p"] 
#---------
tabla_encuestas_pollsmx <-  as.data.frame(readHTMLTable(polls_mx_web))
tabla_encuestas_pollsmx <- tabla_encuestas_pollsmx[2:17,]
names(tabla_encuestas_pollsmx) <- c("Fecha","Encuestadora","Alianza_Partido","Porcentaje","Diferencia")

tabla_encuestas_pollsmx$Fecha <- as.Date(tabla_encuestas_pollsmx$Fecha)
tabla_encuestas_pollsmx
#write.xlsx(tabla_encuestas_pollsmx, "encuestas-pollsmx.xlsx"
encuestas_pollmx <- xml2::read_html("https://polls.mx/presidencia/")
###############################################################################33
#### Web scraping de las publicaciones de diferentes casas encuestadoras
#----CASO: 1 ENKOLL
enkoll_web <- read_html("http://www.enkoll.com/publicaciones")
enkoll_web
#----------
publicaciones_enkoll <-enkoll_web|> html_nodes("a")|>
  html_attr("href")|>str_subset("\\.pdf") 

publicaciones_enkoll[[3]]
#---
download.file(
  url = publicaciones_enkoll[[1]], 
  destfile = "amlo-quinto-informe.pdf", mode = "wb"
)

for (url in publicaciones_enkoll[[2]]){ 
  download.file(url, destfile = basename(url), mode = "wb") 
  
  }
#############################################################
#----CASO: 2 COVARRUBIAS Y ASOCS
covarrubias_web <- read_html("https://www.pulso.com.mx/index.php?q=rumbo_a_2024&n=electorales")

publicaciones_covarrubias <-covarrubias_web|> html_nodes("a")|>
  html_attr("href")|>str_subset("\\.pdf") 

publicaciones_covarrubias <- str_c("https://www.pulso.com.mx", publicaciones_covarrubias)
publicaciones_covarrubias
#---
for (url in publicaciones_covarrubias){ download.file(url, destfile = basename(url), mode = "wb") }


#---CASO: Mendoza y Blanco
p_load(httr2)


meba_web <- read_html("https://mendozablanco.com.mx/publicaciones/")
publicaciones_meba <-meba_web|> html_nodes("a")|>html_attr("href")
publicaciones_meba <-  publicaciones_meba[32:88]

for (url in publicaciones_meba){ download.file(url, destfile = basename(url), mode = "curl") }

rm(publicaciones_meba, meba_web)



# alternate way to "download.file"
fil <- GET("https://mendozablanco.com.mx/publicaciones/", 
           write_disk("tmp.fil"))

fil
# get what name the site suggests it shld be
fname <- str_match(headers(fil)$`content-disposition`, "\"(.*)\"")[2]
# rename
file.rename("tmp.fil", fname)

fname

#----CASO: 2 GEA ISA
gea_web <- read_html("https://invesoc.com/encuestaspublicas.php")

publicaciones_gea <- gea_web|> html_nodes("a")|>
  html_attr("href")|>str_subset("\\.pdf") 


publicaciones_gea <- str_c("https://invesoc.com", publicaciones_gea)
publicaciones_gea
#---
for (url in publicaciones_gea){ download.file(url, destfile = basename(url), mode = "wb") }




#--CASO : RUBRUM 
rubrum_web <- read_html("https://rubrum.info/download/datos-de-preferencias-presidenciables-hacia-el-2024-28-de-agosto-del-2023/")

publicaciones_rubrum <- rubrum_web|> html_nodes("a")|>
  html_attr("href")|>str_subset("\\.pdf") 

publicaciones_rubrum


#------
gobernarte_web <- read_html("https://gobernarte.com.mx/encuesta-elecciones-presidenciales-rumbo-al-2024-resultados-de-julio-2023/")


publicaciones_gobernarte <- gobernarte_web|> html_nodes("a")|>
  html_attr("href")|>str_subset("\\.pdf") 


for (url in publicaciones_gobernarte){ download.file(url, destfile = basename(url), mode = "wb") }

##--CASO: CAMPAING & ELECTIONS

ce_web <- read_html("https://presidenciables2024.com/encuestas-los-presidenciables/")


publicaciones_ce <- ce_web|> html_nodes("a")|>
  html_attr("href")|>str_subset("\\.pdf") 

publicaciones_ce

rm(ce_web,gobernarte_web)
#------
electoralia_web <- read_html("https://electoralia.com.mx/")


publicaciones_electoralia <- electoralia_web|> html_nodes("a")|>
  html_attr("href")|>str_subset("\\.pdf") 


for (url in publicaciones_electoralia){ download.file(url, destfile = basename(url), mode = "wb") }

#--------------------
laencuesta_web <- read_html("https://laencuesta.mx/secciones/encuestas/")


publicaciones_laencuesta <- laencuesta_web|> html_nodes("a")|>
  html_attr("href")|>str_subset("\\.pdf") 


for (url in publicaciones_electoralia){ download.file(url, destfile = basename(url), mode = "wb") }


#-----Votia
votia_web <- read_html("https://www.votia.com.mx/preferencias-electorales-rumbo-a-elecciones-del-2024/")

publicaciones_votia <- votia_web|> html_nodes("a")|>
  html_attr("href")|>str_subset("\\.pdf") 


for (url in publicaciones_votia){ download.file(url, destfile = basename(url), mode = "wb") }

#------
gii300_web <- read_html("https://www.gii360.net/presidenciales-2024")

publicaciones_gii300 <- gii300_web|> html_nodes("a")|>
  html_attr("href")|>str_subset("\\.pdf") 


for (url in publicaciones_gii300){ download.file(url, destfile = basename(url), mode = "wb") }

#--------Massive caller
massivecall_web <- read_html("https://www.massivecaller.com")

publicaciones_massivecall <- massivecall_web|> html_nodes("a")|>
  html_attr("href")|>str_subset("\\.pdf") 

publicaciones_massivecall <- str_c("https://www.massivecaller.com/", publicaciones_massivecall)
publicaciones_massivecall

for (url in massivecall_web){ download.file(url, destfile = basename(url), mode = "wb") }
