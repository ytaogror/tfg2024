#!/usr/bin/python3.7
import cochepy
import requests

with cochepy.coche('xxxx@gmail.com') as coche:
    vehicles = coche.vehicle_list()
    print(vehicles[0]['display_name'] + ' -> ' + str(vehicles[0]['charge_state']['battery_level']) + '% SoC')
    data='soc,meter=coche_bat value=' + str(vehicles[0]['charge_state']['battery_level'])
    p = requests.post('http://192.168.68.13:8086/write?db=meter', data.encode() )

print(p)
print(p.status_code)
print(p.text)
