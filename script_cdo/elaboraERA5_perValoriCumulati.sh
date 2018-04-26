#!/bin/bash
#elabora il file grib

#Ultima revisione 5 febbraio 2018
#################################################
#Script applicato per i parametri in cui il valore giornalieri si ottiene come somma dei dati orari: 
# - precipitazione
#################################################


#YYMMDD_I e YYMMDD_F sono le date entro cui vogliamo cumulare: se ad esempio l'anno di interesse è il 2015 -> YYMMDD_I 2015-01-01 e YYMMDD_F 2015-12-31
#(per tener conto del fatto che si tratta di valori cumulati - vedi dopo - il file conterrà anche il 2014-12-31 e il 2016-01-01 ma le ddue variabili qui sopra
#vanno fissate in base all'anno di interesse ovvero il 2015)

YYMMDD_I="2015-01-01"
YYMMDD_F="2015-12-31"

#####################
#ATTENZIONE
#####################

#Per la precipitazione è necessario un passo in più rispetto ai parametri istantanei (quali temperatura, vento etc).Per questi ultimi il calcolo 
#della media giornaliera va fatto prendendo i valori alle ore 00, 01, 02...fino alle 23.

#Per la precipitazione si deve tener conto che il dato riferito all'ora 01 è il cumulato dalle 00 alle 01 

#(vedere anche questa pagina: 

#https://software.ecmwf.int/wiki/display/CKB/How+to+download+ERA5_test+data+via+the+ECMWF+Web+API#HowtodownloadERA5_testdataviatheECMWFWebAPI-
#Example1:Dailysurfaceinstantaneousdata(temperatureandwindspeed)

#)

#Per calcolare il cumulato giornaliero cdo usa daysum che cumula i dati giornalieri delle ore 00, 01, 02,...fino alle 23. Ma trattandosi di dati 
#cumulati sto commettendo due errori: 
# - includendo il dato alle 00 sto considerando anche i valori che vanno dalle ore 23 del giorno precedente a quello in esame  
# - fermandomi alle ore 23 sto tralasciando il valore che copre le ore dalle 23 alle 00

#Per fare il calcolo corretto dovre in pratica fare il "daysum" dalle 01 di un giorno alle 00 del giorno successivo 

#Soluzione: spostare l'orario del dato indietro di un'ora ovvero trasformo le 00 in 23, le 01 in 00, le 02 in 01 etc..
#Così facendo ottengo un cumulato giornaliero (tramite daysum in CDO) corretto.

#Ovviamente al momento del download dei dati da MARS debbo estendere la selezione anche il 31 dicembre dell'anno precedente a quello di interesse 
#e al 1 gennaio dell'anno successivo a quello di interesse (ad esempio: 31 dicembre 2014 e 1 Gennaio 2016). 

#Comando CDO: 

out=${1%.nc}_shifted.nc

echo "CREO FILE ${out} PER CORREZIONE ORA"
cdo shifttime,-1hours ${1} ${out}

#A questo punto possiamo lavorare su ${out} 

#Successivamente:
# - seleziono il periodo di interesse
# - daysum: calcolo il cumulato giornaliero
# - conversione da metri a mm (mulc,1000) 
# - annullare (zero mm) la precipitazione sotto 1mm di precipitazione 

# -b F64 necessario per aumentare la precisione dei dati, altrimenti cdo lamenta che i dati ottenuti sono fuori dal range di valori ammissibili

cdo -b F64 -setrtoc,-10000,0.99999,0 -mulc,1000 -daysum -seldate,${YYMMDD_I},${YYMMDD_F}  ${out} ${1%.nc}_daily.nc  

