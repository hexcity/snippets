#!/usr/bin/env python
#####################################################################
#

import subprocess

cmdlist = [ "dir" ]

print( "Python running command list: ", cmdlist )
result = subprocess.run( cmdlist , shell=True )

exit()
