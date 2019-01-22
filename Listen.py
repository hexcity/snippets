#!/usr/bin/env python
#####################################################################
# Create a socket and listen
#

import socket

host="0.0.0.0"
port=1234

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind( (host, port) )
s.listen()
conn, addr = s.accept()

print( "Connected by: ", addr )

while True:
    data = conn.recv()
    if data == "kill":
        break

    print( data )


s.close()
exit()
