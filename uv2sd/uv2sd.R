#26 ottobre 2015, programma per creare wdir e wspeed
rm(list = objects())
library("raster")
library("RPostgreSQL")
library("rpostgis")
library("rWind")
options(error=recover,warns=2)

#PARTIAMO DAL MODELLOP CHE USA WDIR WSPEED e i log del pbl
dbConnect(drv="PostgreSQL",user="guido",host="localhost",port=5432,dbname="asiispra")->conn
suppressWarnings(pgGetGeom(conn,name =c("vgriglia","centroidi") ,geom = "geom",gid="gid")->centroidi)
coordinates(centroidi)->mycoords

c("u10","v10")->UV

purrr::map(1:365,.f=function(bb){
  
  print(sprintf("Elaboro giorno %s",bb))
  
  purrr::map(UV,.f=~(pgGetRast(conn,name =c("rgriglia",.) ,rast="rast",bands=bb)))->listaLayer

  #crea brick
  brick(listaLayer)->mybrick
  #estrai i valori
  as.data.frame(extract(x=mybrick,y=centroidi))->uvData
  names(uvData)<-UV
  #crea velocità e direzione del vento
  rWind::uv2ds(uvData$u10,uvData$v10)->myWind
  
  uvData$wdir<-myWind[,c("dir")]
  uvData$wspeed<-myWind[,c("speed")]
  
  as.data.frame(cbind(mycoords,uvData))->uvData
  
  rasterFromXYZ(uvData[,c("x","y","wdir")])->grigliaDir
  rasterFromXYZ(uvData[,c("x","y","wspeed")])->grigliaSpeed
  
  list(grigliaDir,grigliaSpeed)

})->listaGiornaliera


dbDisconnect(conn)
