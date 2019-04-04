#!/usr/bin/env python3
'''
@author: Peter Howlett

@description: Across the screen
'''

from time import sleep

str = "Peter Was Here"
columns = 79
sleeptime = 0.05

while True:
    for col in range(len(str),columns):
        print(str.rjust(col))
        time.sleep(sleeptime)

    for coly in range(columns,len(str),-1):
        print(str.rjust(coly))
        time.sleep(sleeptime)

exit()
