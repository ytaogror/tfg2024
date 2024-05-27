#!/usr/bin/python3.7

#   _____          _ __                  _                                _ _           _                                 _______ ______ _____    _    _       _      
#  / ____|        | /_/                 | |                              | | |         | |                               |__   __|  ____/ ____|  | |  | |     (_)     
# | |     ___   __| |_  __ _  ___     __| | ___  ___  __ _ _ __ _ __ ___ | | | __ _  __| | ___    _ __   __ _ _ __ __ _     | |  | |__ | |  __   | |  | |_ __  _ _ __ 
# | |    / _ \ / _` | |/ _` |/ _ \   / _` |/ _ \/ __|/ _` | '__| '__/ _ \| | |/ _` |/ _` |/ _ \  | '_ \ / _` | '__/ _` |    | |  |  __|| | |_ |  | |  | | '_ \| | '__|
# | |___| (_) | (_| | | (_| | (_) | | (_| |  __/\__ \ (_| | |  | | | (_) | | | (_| | (_| | (_) | | |_) | (_| | | | (_| |    | |  | |   | |__| |  | |__| | | | | | |   
#  \_____\___/ \__,_|_|\__, |\___/   \__,_|\___||___/\__,_|_|  |_|  \___/|_|_|\__,_|\__,_|\___/  | .__/ \__,_|_|  \__,_|    |_|  |_|    \_____|   \____/|_| |_|_|_|   
# __     __             __/ |______                         ___   ___ ___  _  _                  | |                                                                  
# \ \   / /            |___/__   __|                       |__ \ / _ \__ \| || |                 |_|                                                                  
#  \ \_/ /_ _  __ _  ___      | | ___  _ __ _ __ ___  ___     ) | | | | ) | || |_                                                                                     
#   \   / _` |/ _` |/ _ \     | |/ _ \| '__| '__/ _ \/ __|   / /| | | |/ /|__   _|                                                                                    
#    | | (_| | (_| | (_) |    | | (_) | |  | | |  __/\__ \  / /_| |_| / /_   | |                                                                                      
#    |_|\__,_|\__, |\___/     |_|\___/|_|  |_|  \___||___/ |____|\___/____|  |_|                                                                                      
#              __/ |                                                                                                                                                  
#             |___/                                                                                                                                                   

from http.server import *
from urllib import parse
import os
import cgi
import datetime

class GetHandler(CGIHTTPRequestHandler):
    def do_GET(self):
      if self.path == '/puerta1':
        form = cgi.FieldStorage()
        self.send_response(200)
        self.send_header('Content-Type', 'text/html; charset=utf-8')
        self.end_headers()
        self.wfile.write(str(os.popen('/home/pi/shelly/shelly.puerta1.sh').read()).encode('utf-8'))

      elif self.path == '/cochedinamico_on':
        form = cgi.FieldStorage()
        self.send_response(200)
        self.send_header('Content-Type', 'text/html; charset=utf-8')
        self.end_headers()
        self.wfile.write(str(os.popen('systemctl start coche_dinamico.service').read()).encode('utf-8'))

      elif self.path == '/cochedinamico_off':
        form = cgi.FieldStorage()
        self.send_response(200)
        self.send_header('Content-Type', 'text/html; charset=utf-8')
        self.end_headers()
        self.wfile.write(str(os.popen('systemctl stop coche_dinamico.service').read()).encode('utf-8'))

      elif self.path == '/cochedinamico_status':
        form = cgi.FieldStorage()
        self.send_response(200)
        self.send_header('Content-Type', 'text/html; charset=utf-8')
        self.end_headers()
        self.wfile.write(str(os.popen('systemctl status coche_dinamico.service | head -3 | tail -1').read()).encode('utf-8'))

      else:
        form = cgi.FieldStorage()
        self.send_response(200)
        self.send_header('Content-Type', 'text/html; charset=utf-8')
        self.end_headers()

if __name__ == '__main__':
    from http.server import HTTPServer
    server = HTTPServer(('192.168.68.13', 8089), GetHandler)
    print('Starting server, use <Ctrl-C> to stop')
    server.serve_forever() 
