#!/bin/sh
#
# -f to detach terminal
# -N disallows commands - just portforward
# -R [remote-bindaddress]:port:ourside-host:ourside-port
#

mof="/var/log/remac"
mailto="admin@extrahip.net"
mailfrom="tigertownnas@extrahip.net"
subject="Tigertown [Remac]"

while :
do
    pid=`ps -ef | grep 40028 | grep -v grep | awk '{print $2}'`

    if [ X$pid = 'X' ]; then
        echo "to:$mailto" >$mof
        echo "from:$mailfrom" >>$mof
        echo "subject:$subject" >>$mof
        echo "" >>$mof
        echo "**** Establishing tunnel `date` ****" >>$mof
        echo "" >>$mof

# Add keepalives
# 
# ssh -o ServerAliveInterval=180 -o ServerAliveCountMax=2 $HOST
#
#From <https://askubuntu.com/questions/936728/how-to-keep-ssh-connection-alive> 

        ssh -o ServerAliveInterval=180 -o ServerAliveCountMax=2 -p 40028 -N -R *:40002:localhost:22 root@ssh.extrahip.net >>$mof 2>&1
    
        echo "" >>$mof
        echo "SSH tunnel died - restarting: `date`" >>$mof

        cat $mof | sendmail -f $mailfrom $mailto
    fi

    sleep 600;
done
