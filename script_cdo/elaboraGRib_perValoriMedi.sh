#!/bin/bash

#Ultima revisione 17 aprile 2018
#################################################
#Script applicato per i parametri: 
# - temperatura
#
#################################################

#################################################
#I file netCDF su grigliato regolare sono stati scaricati direttamente da ECMWF 
#######

fileInput=${1}

#Traformazione dei dati da orari a giornalieri
cdo -b F64 -daymean ${fileInput} ${fileInput%.nc}_daily.nc

