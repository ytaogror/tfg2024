#!/usr/bin/python3.7
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
