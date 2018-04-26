#!/usr/bin/env python
# -*- coding: utf-8 -*-

#La nota qui sotto spiega che per era-interim i parametri sono cumulati nel corso del "time-step" mentre questo non avviene
#per ERA5. Per questo motivo i dati sono stati scaricati con lo script qui sotto.

#Accumulated parameters <---- https://software.ecmwf.int/wiki/pages/viewpage.action?pageId=56658233

#In ERA-Interim the forecast accumulations (e.g. total precipitation and radiation parameters) are accumulated from the start of the #forecast, ie. from T=00:00 or T=12:00.

#For example, Snowfall with Time=12:00 and Step=9 gives the accumulated Snowfall in the time period 12:00 to 21:00 (12:00+9h).
#See also ERA-Interim data documentation, table 9, and examples 1 to 3 below..
#In ERA5, the short forecast accumulations are accumulated from the end of the previous step.
#Accumulated parameters are not available from the analyses.

from ecmwfapi import ECMWFDataServer

server = ECMWFDataServer()
    
server.retrieve({
    'class'   : "ea", 
    'dataset' : "era5",
    'stream'  : "oper",
    'padding' : "0",
    'time'    : "06/18",
    'date'    : "2014-12-31/to/2015-12-31",
    'type'    : "fc",
    'step'    : "1/to/12/by/1",	
    'levtype' : "sfc",   
    'param'   : "tp",
    'target'  : "tp.nc",
    'format'  : "netcdf",
    'grid'    : "0.25/0.25", 	
    'area'    : "50/4/35/21" 	
    })
