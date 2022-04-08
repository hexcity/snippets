#!/bin/sh
#
# -f to detach terminal
# -N disallows commands - just portforward
# -R [remote-bindaddress]:port:ourside-host:ourside-port
#

log="/var/log/remac"
mof="/var/log/remacmsg"
mailto="admin@extrahip.net"
mailfrom="tigertownnas@extrahip.net"
subject="Tigertown [Remac]"

# Make sure not already running, if it is kill the old one
#oldpid=`ps -ef | grep remac | grep -v grep | awk '{print $2}'`
#
#echo "oldpids: $oldpid"
#
#if [ ! X$oldpid = 'X' ]; then
#    echo "`date`: starting $0 but found running pids so killing them: $oldpid" >>$log
#    kill -TERM $oldpid
#else
#    echo "`date`: starting $0" >>$log
#fi

while :
do
    # If there are dead tunnels kill them off - cant use this brain dead lsof to check socket state
    #suffering=`lsof -itcp:40028 -stcp:^established -a`
    suffering=`lsof -itcp:40028 | grep -v ESTABLISHED | grep -v COMMAND | head -1 | awk '{print $2}'`

    if [ ! X$suffering = 'X' ]; then
        dt=`date`
        echo "$dt: found suffering" >>$log
        echo "to:$mailto" >$mof
        echo "from:$mailfrom" >>$mof
        echo "subject:$subject" >>$mof
        echo "" >>$mof
        echo "**** Killing dead tunnels: $suffering" >>$mof
        echo "" >>$mof

        echo "$dt: killing dead tunnels: $suffering" >>$log
        kill -TERM $suffering
    
        echo "" >>$mof
        echo "$dt: sending mail notification" >>$log
        cat $mof | sendmail -f $mailfrom $mailto
        sleep 5
    fi

    pid=`ps -ef | grep 40028 | grep -v grep | head -1 | awk '{print $2}'`

    if [ X$pid = 'X' ]; then
        dt=`date`
        echo "$dt: no running tunnel pids found" >>$log
        echo "to:$mailto" >$mof
        echo "from:$mailfrom" >>$mof
        echo "subject:$subject" >>$mof
        echo "" >>$mof
        echo "**** Establishing tunnel `date` ****" >>$mof
        echo "" >>$mof

        echo "$dt: establishing tunnel" >>$log
        ssh -o ServerAliveInterval=180 -o ServerAliveCountMax=2 -p 40028 -f -N -R *:40002:localhost:22 root@ssh.extrahip.net >>$mof 2>&1
    
        echo "" >>$mof
        echo "$dt: sending mail notification" >>$log
        cat $mof | sendmail -f $mailfrom $mailto
    fi

    sleep 600;
done
