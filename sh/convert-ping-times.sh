#!/bin/sh
#
# Convert timestamps in ping repsonses to readable format.
# Taken from a file used to gather ping responses.
#
# Ping command (background and nohup so will keep alive after logoff):
# nohup ping -i 1 -W 5 -nD xxx.xxx.xxx.xxx 2>&1 >/pingtest.log &
# -i to adjust timing in seconds (default is 1 ping every second)
# -W for ping timout value
# -n to keep IP rather than lookup fqdn
# -D to add timestamp to beginning of each ping reply
#
# Output looks like:
# [1692700323.066399] 64 bytes from xx.xx.xx.xx: icmp_seq=1 ttl=64 time=0.321 ms
# [1692700324.090135] 64 bytes from xx.xx.xx.xx: icmp_seq=2 ttl=64 time=0.147 ms
# [1692700325.114255] 64 bytes from xx.xx.xx.xx: icmp_seq=3 ttl=64 time=0.218 ms
# ....
#
# Pipe ping data to this script - it will output lines with actual date
# cat pingtest.log | pingteststampconvert.sh >pingtest.txt
#
# New timeformat in pingtest.txt
#

while read line
do
    # Working conversion for single line
    #echo $line | sed 's/^[[]\([0-9]\{10\}\)\.[0-9]\+[]] \(.*\)/Time: \1 Msg: \2/'

    tstamp=`echo $line | sed 's/^[[]\([0-9]\{10\}\).*/\1/'`
    msg=`echo $line | sed 's/^[[].*[]] \(.*\)/\1/'`
    dstamp=`date -d @$tstamp "+%D %T %Z"`
    echo $dstamp $msg
done

