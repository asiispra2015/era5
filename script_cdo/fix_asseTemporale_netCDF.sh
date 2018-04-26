#!/bin/bash

#ATTENZIONE: QUESTO SCRIPT NON VA UTILIZZATO! I file netCDF in formato UTM se processati con settaxis non sono più allineati con la griglia
#di riferimento. BUG DI CDO? LASCIATO POST SULLA PAGINA DEL MAX-PLANK-INSTITUT

#I file netCDF prodotti da CDO o da R vanno uniformati rispetto all'asse temporale
#in modo di avere un asse con lo stesso formato (anno mese giorno ora) per tutte le variabili

#I file utm sono i file netCDF in lat/lon regolare convertiti in UTM epsg:32632 utilizzando un raster .tif come template

for ii in $(ls *utm.nc);do
	cdo settaxis,2015-01-01,00:00:00,1days $ii ${ii%.nc}_time_axis.nc; 
done
