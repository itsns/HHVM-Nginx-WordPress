#! /bin/bash
# Use this script on a cron every minute to restart hhvm if it crashes
if [ "$1" == "" ]; then
        echo "Usage: `basename $0` svcname"
        exit 1
fi

SVCNAME=$1
PID="`cat /var/run/hhvm/hhvm.${SVCNAME}.pid`"

if [ "$PID" == "" ]; then
        echo No PID, starting up
        /etc/init.d/hhvm.${SVCNAME} start
else
        if [ "`ps ax -o pid | grep $PID`" == "" ]; then
                echo HHVM PID $PID not running, starting up
                # Stop, just in case, if crashed. Else you would get:
                #  * WARNING: hhvm.83 has already been started
                /etc/init.d/hhvm.${SVCNAME} stop
                /etc/init.d/hhvm.${SVCNAME} start
        fi
fi