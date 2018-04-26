#!/bin/bash

#Ultima revisione 5 febbraio 2018
#################################################
#Script applicato per i parametri in cui il valore giornalieri si ottiene come media degli orari: 
# - temperatura
# - bld00/12
# - componenti del vento u/v
# - surface pressure
#################################################

#YYMMDD_I e YYMMDD_F sono le date entro cui vogliamo cumulare: se ad esempio l'anno di interesse è il 2015 -> YYMMDD_I 2015-01-01 e YYMMDD_F 2015-12-31
#(per tener conto del fatto che si tratta di valori cumulati - vedi dopo - il file conterrà anche il 2014-12-31 e il 2016-01-01 ma le ddue variabili qui sopra
#vanno fissate in base all'anno di interesse ovvero il 2015)

YYMMDD_I="2015-01-01"
YYMMDD_F="2015-12-31"

#AREA CHE COPRE l'ITALIA:
ITALIA="5,22,33,50"

#FILE GRIGLIA CHE SPECIFICA IL GRIGLIATO DI OUTPUT PER remapbil
GRIGLIA="griglia.txt"

#################################################
#Parte per il file grib scaricato da ERA5
#
#Il file grib va convertito in netCdf, utilizzando l'opzione -R che trasforma il grigliato in gaussiano regolare
# 
# cdo -R -f nc copy $fileGrib ${fileNc}
#
#######

fileInput=${1}

#Traformazione dei dati da orari a giornalieri, trasformazione del grigliato a lanlot regolare ed estrazione del subset dati per Italia
cdo sellonlatbox,${ITALIA} -remapbil,${GRIGLIA} -daymean ${fileInput} ${fileInput%.nc}_it.nc

