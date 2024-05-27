#!/bin/bash

IP=192.168.68.13
PUERTO=8086
BBDD=meter

hoy=`date +%F`
fecha="'"`date +%F`"T8:00:02.976460058Z""'"
echo "fecha " $fecha

casa=`curl -G 'http://192.168.68.13:8086/query?pretty=true'  --data-urlencode "db=meter" --data-urlencode "q=select top("value",1) from consumo_casa_acumulado where time>$fecha" | jq -r '.results[0].series[0].values[0][1]'`

coche=`curl -G 'http://192.168.68.13:8086/query?pretty=true'  --data-urlencode "db=meter" --data-urlencode "q=select top("value",1) from consumo_coche_acumulado where time>$fecha" | jq -r '.results[0].series[0].values[0][1]'`

generacion=`curl -G 'http://192.168.68.13:8086/query?pretty=true'  --data-urlencode "db=meter" --data-urlencode "q=select top("value",1) from generacion_diaria_acumulada where time>$fecha" | jq -r '.results[0].series[0].values[0][1]'`

balance_diario=$(bc <<< "scale=2; $generacion - $casa - $coche")
consumo=$(bc <<< "scale=2; $casa + $coche")

/usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "generacion,meter=balance_diario value=$generacion"
/usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "consumo,meter=balance_diario value=$consumo"
/usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "casa,meter=balance_diario value=$casa"
/usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "coche,meter=balance_diario value=$coche"
/usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "balance_diario,meter=balance_diario value=$balance_diario"

echo "generacion " $generacion
