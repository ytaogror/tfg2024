#!/usr/bin/python3.7
import time
import math
import subprocess
import cochepy
import sys

coche = cochepy.coche('yagotorres@gmail.com')
if not coche.authorized:
    print('Use browser to login. Page Not Found will be shown at success.')
    print('Open this URL: ' + coche.authorization_url())
    coche.fetch_token(authorization_response=input('Enter URL after authentication: '))
vehicles = coche.vehicle_list()
#print(vehicles[0])
print(vehicles[0]['display_name'] + ' last seen ' + vehicles[0].last_seen() + ' at ' + str(vehicles[0]['charge_state']['battery_level']) + '% SoC')


#vehicles[0].command('START_CHARGE')
#vehicles[0].command('STOP_CHARGE')

print(vehicles[0]['charge_state']['charging_state'])
vehicles[0].command('CHARGING_AMPS',charging_amps='4')
coche.close()


def pon_amperios(amps):
        amps=str(amps)
        if amps == '3':
          vehicles[0].command('CHARGING_AMPS',charging_amps='3')
          print(vehicles[0]['charge_state']['charging_state'])
        elif amps == '4':
          vehicles[0].command('CHARGING_AMPS',charging_amps='4')
          print(vehicles[0]['charge_state']['charging_state'])
        elif amps == '5':
          vehicles[0].command('CHARGING_AMPS',charging_amps='5')
          print(vehicles[0]['charge_state']['charging_state'])
        elif amps == '6':
          vehicles[0].command('CHARGING_AMPS',charging_amps='6')
          print(vehicles[0]['charge_state']['charging_state'])
        elif amps == '7':
          vehicles[0].command('CHARGING_AMPS',charging_amps='7')
          print(vehicles[0]['charge_state']['charging_state'])
        elif amps == '8':
          vehicles[0].command('CHARGING_AMPS',charging_amps='8')
          print(vehicles[0]['charge_state']['charging_state'])
        elif amps == '9':
          vehicles[0].command('CHARGING_AMPS',charging_amps='9')
          print(vehicles[0]['charge_state']['charging_state'])
        elif amps == '26':
          vehicles[0].command('CHARGING_AMPS',charging_amps='26')
          print(vehicles[0]['charge_state']['charging_state'])


def lee_shelly():

        casa="curl -s -u admin:xxx http://192.168.68.254/emeter/0 | jq .power"
        solar="curl -s -u admin:xxx http://192.168.68.253/emeter/0 | jq .power"
        coche="curl -s -u admin:xxx http://192.168.68.253/emeter/1 | jq .power"

        #------ casa

        p = subprocess.Popen(casa, shell=True, stdout=subprocess.PIPE)
        (output, err) = p.communicate()
        p_status = p.wait()
        #print ("Command exit status/return code : ", p_status)
        consumo_casa=float(output.strip())
        print ("Command output CASA: ", consumo_casa)

        #------ solar
        p = subprocess.Popen(solar, shell=True, stdout=subprocess.PIPE)
        (output, err) = p.communicate()
        p_status = p.wait()
        produccion_solar=-1*float(output.strip())
        print ("Command output SOLAR: ", produccion_solar)

        #------ coche

        p = subprocess.Popen(coche, shell=True, stdout=subprocess.PIPE)
        (output, err) = p.communicate()
        p_status = p.wait()
        consumo_coche=float(output.strip())
        print ("Command output coche : ", consumo_coche)

        #------ consolido

        excedente=(produccion_solar-consumo_casa-consumo_coche)

        #------ ajuste

        return excedente,consumo_coche,produccion_solar,consumo_casa

while True:

        excedente,consumo_coche,produccion_solar,consumo_casa=lee_shelly()


        if (vehicles[0]['charge_state']['charging_state']) == "Stopped" :
            cargando=False
            print("Cargando puesto a FALSE")
        else:
            cargando=True
            amps=str(int(math.floor(consumo_coche/220)))
            print("Cargando puesto a TRUE")
            print("Ams actual",amps)

        if produccion_solar > 1000 :

            print("Producimos por encima de 1000 ",produccion_solar)
            amps=(produccion_solar-consumo_casa)/220
            amps=int(math.floor(amps)-1)
            print("Amps ajustando->",amps)
            pon_amperios(amps)
            amperios=amps
            if not cargando:
               print("Aqui en if not cargando -> " + str(cargando))
               vehicles[0].command('START_CHARGE')
        else:
            print("Producimos por debajo de 1000 ",produccion_solar)
            if cargando:
               print("Estamos cargando, ponemos 26 amperios y detenemos carga ")
               pon_amperios(26)
               vehicles[0].command('STOP_CHARGE')

        time.sleep(120)
