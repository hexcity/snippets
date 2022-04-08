#!/usr/bin/env python
####################################################################
#

import ipaddress

MyIP = ipaddress.ip_address('172.21.96.10')

print('RevIP is:', MyIP.reverse_pointer)
