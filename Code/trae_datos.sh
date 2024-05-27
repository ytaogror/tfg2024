#!/bin/bash

###############################################
##   Script para obtener datos de Shelly EM
##        e introducirlos  en Influx DB
###############################################

IP=192.168.68.13
PUERTO=8086
BBDD=meter

SHELLY1=192.168.68.254
CASA=0

SHELLY2=192.168.68.253
SOLAR=0
COCHE=1

consumo_casa=0
consumo_coche=0
produccion_solar=0

### Datos de lectura General de Casa

DATOS=$(curl -s -u admin:xxx $SHELLY1/emeter/$CASA)

LOG=/tmp/meter.log

if [ "$(echo $DATOS | jq .is_valid)" == "true" ]
then
        /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "volt,meter=casa value=$(echo $DATOS|jq .voltage)"
        /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "power,meter=casa value=$(echo $DATOS|jq .power)"
        /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "reactive,meter=casa value=$(echo $DATOS|jq .reactive)"
        /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "pf,meter=casa value=$(echo $DATOS|jq .pf)"
        /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "total,meter=casa value=$(echo $DATOS|jq .total)"
        /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "total_returned,meter=casa value=$(echo $DATOS|jq .total_returned)"

        consumo_casa=$(echo $DATOS|jq .power)

        /usr/bin/mosquitto_pub -h localhost -t casageton -m "true"
        /usr/bin/mosquitto_pub -h localhost -t casagetflow -m $consumo_casa

        consumo_casa_diario_acumulado=$(echo $DATOS|jq .total)

        if [ "$(echo $DATOS|jq .power)" > 0 ] && [ "$(echo $DATOS|jq .voltage)" > 0 ]
        then
                AMPS=$(bc <<< "scale=2; $(echo $DATOS|jq .power) / $(echo $DATOS|jq .voltage)")
                /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "amps,meter=casa value=$AMPS"
        else
                /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "amps,meter=casa value=0"
        fi
        echo "$(date +'%d/%m/%Y %H:%M:%S') CASA: V:$(echo $DATOS|jq .voltage) W:$(echo $DATOS|jq .power) A:$AMPS" >> $LOG
fi


### Datos de Fotovoltaica

DATOS=$(curl -s -u admin:xxx $SHELLY2/emeter/$SOLAR)

if [ "$(echo $DATOS | jq .is_valid)" == "true" ]
then
        /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "volt,meter=solar value=$(echo $DATOS|jq .voltage)"
        /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "power,meter=solar value=$(echo $DATOS|jq .power)"
        /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "reactive,meter=solar value=$(echo $DATOS|jq .reactive)"
        /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "pf,meter=solar value=$(echo $DATOS|jq .pf)"
        /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "total,meter=solar value=$(echo $DATOS|jq .total)"
        /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "total_returned,meter=solar value=$(echo $DATOS|jq .total_returned)"

        produccion_solar=$(echo $DATOS|jq .power)

        generacion_diaria_acumulada=$(echo $DATOS|jq .total_returned)

        solar_positivo=$(echo $produccion_solar*-1 | bc )


        /usr/bin/mosquitto_pub -h localhost -t solargeton -m "true"
        /usr/bin/mosquitto_pub -h localhost -t solargetflow -m $solar_positivo

        /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "power_positivo,meter=solar value=$solar_positivo"

        if [ $(echo $DATOS|jq .power) > 0 ] && [ $(echo $DATOS|jq .voltage) > 0 ]
        then
                AMPS=$(bc <<< "scale=2; $(echo $DATOS|jq .power) / $(echo $DATOS|jq .voltage)")
                /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "amps,meter=solar value=$AMPS"
        else
                /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "amps,meter=solar value=0"
        fi
        echo "$(date +'%d/%m/%Y %H:%M:%S') SOLAR: V:$(echo $DATOS|jq .voltage) W:$(echo $DATOS|jq .power) A:$AMPS" >> $LOG
fi

### Datos de coche

DATOS=$(curl -s -u admin:xxx $SHELLY2/emeter/$COCHE)

if [ "$(echo $DATOS | jq .is_valid)" == "true" ]
then
        /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "volt,meter=coche value=$(echo $DATOS|jq .voltage)"
        /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "power,meter=coche value=$(echo $DATOS|jq .power)"
        /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "reactive,meter=coche value=$(echo $DATOS|jq .reactive)"
        /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "pf,meter=coche value=$(echo $DATOS|jq .pf)"
        /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "total,meter=coche value=$(echo $DATOS|jq .total)"
        /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "total_returned,meter=coche value=$(echo $DATOS|jq .total_returned)"

        consumo_coche=$(echo $DATOS|jq .power)

        /usr/bin/mosquitto_pub -h localhost -t cochegeton -m "true"
        /usr/bin/mosquitto_pub -h localhost -t cochegetflow -m $consumo_coche

        consumo_coche_diario_acumulado=$(echo $DATOS|jq .total)

        if [ $(echo $DATOS|jq .power) > 0 ] && [ $(echo $DATOS|jq .voltage) > 0 ]
        then
                AMPS=$(bc <<< "scale=2; $(echo $DATOS|jq .power) / $(echo $DATOS|jq .voltage)")
                /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "amps,meter=coche value=$AMPS"
        else
                /usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "amps,meter=coche value=0"
        fi
        echo "$(date +'%d/%m/%Y %H:%M:%S') coche: V:$(echo $DATOS|jq .voltage) W:$(echo $DATOS|jq .power) A:$AMPS" >> $LOG
fi


 consumo_total=$(echo $consumo_coche+$consumo_casa | bc )
 consumo_red=$(echo $consumo_coche+$consumo_casa+$produccion_solar | bc )
 balance_energetico_diario=$(echo $generacion_diaria_acumulada-$consumo_casa_diario_acumulado-$consumo_coche_diario_acumulado | bc )

 /usr/bin/mosquitto_pub -h localhost -t redgeton -m "true"
 /usr/bin/mosquitto_pub -h localhost -t redgetflow -m $consumo_red


if [ $consumo_red \> 0 ]; then

        echo "consumo >0"
        venta=0
        compra=$consumo_red
        /usr/bin/mosquitto_pub -h localhost -t excedentesgeton -m "true"
        /usr/bin/mosquitto_pub -h localhost -t excedentesgetflow -m "0"
else
        echo "consumo <0"
        compra=0
        venta=$(echo $consumo_red*-1 | bc )
        /usr/bin/mosquitto_pub -h localhost -t excedentesgeton -m "true"
        /usr/bin/mosquitto_pub -h localhost -t excedentesgetflow -m $(echo $consumo_red*-1 | bc)

fi

echo "Consumo red "$consumo_red
echo "Compra "$compra
echo "Venta "$venta

/usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "compra,meter=resumen value=$compra"

/usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "venta,meter=resumen value=$venta"


/usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "consumo_total,meter=resumen value=$consumo_total"
/usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "consumo_red,meter=resumen value=$consumo_red"
/usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "consumo_casa,meter=resumen value=$consumo_casa"

/usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "balance_energetico_diario,meter=acumulado value=$balance_energetico_diario"
/usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "consumo_coche_acumulado,meter=acumulado value=$consumo_coche_diario_acumulado"
/usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "generacion_diaria_acumulada,meter=acumulado value=$generacion_diaria_acumulada"
/usr/bin/curl -s -i -XPOST "http://${IP}:${PUERTO}/write?db=${BBDD}" --data-binary "consumo_casa_acumulado,meter=acumulado value=$consumo_casa_diario_acumulado"


 echo "consumo total " $consumo_total
 echo "produccion solar actual" $produccion_solar
 echo "consumo red actual " $consumo_red
 echo "Compra "$compra
 echo "Venta "$venta


 echo "generacion diara acumulada " $generacion_diaria_acumulada
 echo "consumo_casa_diario_acumulado " $consumo_casa_diario_acumulado
 echo "consumo_coche_diario_acumulado " $consumo_coche_diario_acumulado
 echo "balance_energetico_diario " $balance_energetico_diario 
