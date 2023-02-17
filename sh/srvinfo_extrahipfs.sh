#!/bin/bash
#
# Weekly status report mailout
#

mff="dailystatus"
mof="/var/log/$mff"
mailto="admin@extrahip.net"
mailfrom="ExtrahipFS@extrahip.net"
subject="ExtrahipFS [Daily Status]"

exec > $mof
echo "to:$mailto"
echo "from:$mailfrom"
echo "subject:$subject"
echo "MIME-Version: 1.0"
echo "Content-Type: text/html"
echo "Content-Disposition: inline"
echo "<html>"
echo "<body>"
echo "<pre style=\"font: monospace\">"
echo ""

echo "**** DRIVE HEALTH ****"
drives=`ls /dev/sd?`
driveinfo="/root/driveinfo/"
driveinfoarchive="${driveinfo}arch/drives-`date +%F-%H-%M`.tgz"
#ls -l /dev/disk/by-path/ | grep -v part | cut -d' ' -f10-12 >"$driveinfo/bypath"
ls -l /dev/disk/by-path/ | grep -v part | sed 's/^.*\(pci-.*\)/\1/' >"$driveinfo/bypath"

for d in $drives; do
    dshort=`basename $d`
    driveinfoloc="$driveinfo/`basename $d`"
    smartctl --all $d >"$driveinfoloc"
    HStatus=`cat $driveinfoloc | sed -n "s/.*test result: \(..*\)$/\1/p"`
    Serial=`cat $driveinfoloc | sed -n "s/Serial [nN]umber:[ \t]*\(.*\)$/\1/p"`
#    dtemp=`cat $driveinfoloc | sed -n "s/^190 .*-\s*\(.*\)/\1/p"`
    bypath=`cat $driveinfo/bypath | grep $dshort | cut -d' ' -f1-1 | cut -d':' -f2-3`
    dtemp=`cat $driveinfoloc | grep "^190" | cut -c88-110`

    if [ x"$dtemp" = x"" ]
    then
        dtemp=`cat $driveinfoloc | grep "^194" | cut -c88-110`
    fi

    echo "`basename $d` (${Serial: -4:4}): $HStatus Temp: $dtemp Path: $bypath"

    if [ x"$HStatus" != x"PASSED" ]
    then
        echo " "; echo " "
        echo "########## ALERT #############"
        echo "Drive $d HEALTH NOT OK"
        echo "##############################"
        echo " "; echo " "
    fi
done


echo ""
echo "**** RAID ARRAYS ****"
cat /proc/mdstat

echo ""
echo "**** Space ****"
df -Pht xfs | sed 's/\/dev\///;s/\/mnt.*$//; s/  */ /g; /^Filesystem/d'

echo ""
echo "**** CPU Temp ****"
sensors

echo "**** UPS Status ****"
upsstatus=`upsc extrahipups ups.status 2>/dev/null`
upsload=`upsc extrahipups ups.load 2>/dev/null`
upscharge=`upsc extrahipups battery.charge 2>/dev/null`
echo -n "UPS Status/Load/Charge: "
echo "$upsstatus / $upsload / $upscharge"
echo ""

echo "**** Mail Relays ****"
sed -n '/sasl/s/ExtrahipFS postfix\///;s/\[[0-9]*\]: [A-Z0-9]*://;s/, sasl_method=PLAIN, sasl_username=/ USER=/p' /var/log/mail.log
echo ""

echo "**** Mail Remote Logins ****" >/var/log/mailsum
#sed -n '/Login:/s/^.* user=<\([^>]*\)>.*rip=\([0-9.]*\).*/\1 \2/p' /var/log/mail.log | sort -u >/tmp/mal
yday=$(date  --date="yesterday" | cut -d' ' -f2,3)
sed -n 's/^'"$yday"' .* Login: user=<\([^>]*\)>.*rip=\([0-9.]*\).*/\1 \2/p' /var/log/mail.log | sort -u >/tmp/mal

while read ln
do
    remip=`echo $ln | cut -d' ' -f2`
    revup=`host $remip | sed -n 's/.*pointer //p'`
    echo $ln " " $revup >>/var/log/mailsum
done </tmp/mal

cat /var/log/mailsum

echo ""
echo "</pre>"
echo "</body>"
echo "</html>"

#echo ""
#echo "**** Backup ****"
#cat /var/log/dailybackup

cat $mof | sendmail -f $mailfrom $mailto

cd $driveinfo
cp $mof .
drivesarch=`ls sd* bypath $mff`
tar -czf $driveinfoarchive $drivesarch


exit 0;
