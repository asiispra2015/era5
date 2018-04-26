#!/usr/bin/env python
# -*- coding: utf-8 -*-

#Esempio di script per scaricare i dati da ECMWF
#I dati riguardano il globo e sono in formato grib.
#Il primop passo: riconvertirli in formato netCDF e trasformare il grigliato gaussioano ridotto in grigliato gaussiano
#
# cdo -R -f nc copy filegrib filenetCdf
#
#I grigliati vanno quindi riconvertiti in formato regolare lonlat: possiamo utlizzare il file griglia.txt tenendo conto
# che la risoluzione spaziale di era5 è 31km x 31km (circa 0.25)
#
#cdo remapbil,griglia.txt fileRuotato fileLonLat 

from ecmwfapi import ECMWFDataServer

server = ECMWFDataServer()
    
server.retrieve({
    'class'   : "ea", 
    'dataset' : "era5",
    'stream'  : "oper",
    'padding' : "0",
    'time'    : "0000/0100/0200/0300/0400/0500/0600/0700/0800/0900/1000/1100/1200/1300/1400/1500/1600/1700/1800/1900/2000/2100/2200/2300",
    'date'    : "2015-01-01/to/2015-12-31",
    'type'    : "an",
    'step'    : "0",	
    'levtype' : "sfc",   
    'param'   : "165.128",
    'target'  : "u10.nc",
    'format'  : "netcdf",
    'grid'    : "0.25/0.25", 	
    'area'    : "50/4/35/21" 	
    })
