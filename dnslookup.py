#!/usr/bin/env python
####################################################################
#

import ipaddress
import socket

MyIP = ipaddress.ip_address('172.21.96.10')
dName = "www.intel.com"
dIP = "10.220.13.167"

resName = socket.gethostbyname_ex(dName)
try:
    resNameAddr = socket.gethostbyaddr(dIP)
except Exception as Ex:
    resNameAddr = ['N/A']
    print(f'No DNS found for {dIP}: Exception: {Ex}')

print(f'IP: {MyIP} - RevIP is: {MyIP.reverse_pointer}')
print(f'DNS name {dName}: {socket.gethostbyname(dName)}')
print(f'gethostbyname_ex: {resName}')
print(f'gethostbyaddr: {resNameAddr} - first entry: {resNameAddr[0]}')
