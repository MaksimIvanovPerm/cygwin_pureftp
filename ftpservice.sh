#!/bin/bash

prog="/usr/sbin/pure-ftpd"
pidfile=${PIDFILE-/var/run/pure-ftpd.pid}

logfile="/cygdrive/c/Temp/pure_ftpd.log"
OPTIONS="--bind 192.168.100.3,2121 -4 -H -E -B -d -O stats:${logfile} -l puredb:/etc/pureftpd.pdb"

start() {
 local v_statement="${prog} $OPTIONS"
 local v_pid v_piffromfile v_already_running
 v_already_running=1
 v_piffromfile=""
 
 ps aef | grep -q "$prog" 
 RETVAL=$?
 if [ "$RETVAL" -eq "0" ]
 then
   v_pid=`ps aef | grep  "$prog" | awk '{printf "%s", $1}'`
   [ -f "$pidfile" ] && v_piffromfile=`cat $pidfile`
   if [ "$v_piffromfile" == "$v_pid" ] 
   then
     v_already_running=0
   else
     echo $v_pid > "$pidfile"
   fi
 fi  
 
 if [ "$v_already_running" -eq "1" ] 
 then
  echo -n $"Starting $prog: "
  eval "${prog} $OPTIONS"
  [ "$?" -eq "0" ] && echo "OK" || echo "Fail: ${v_statement}"
 else
  echo "$prog already running with pid: $v_pid"
 fi
}

stop() {
 ps aef | grep -q "$prog" 
 RETVAL=$?
 if [ "$RETVAL" -eq "0" ]
 then
   v_pid=`ps aef | grep  "$prog" | awk '{printf "%s", $1}'`
   kill -9 $v_pid
   [ -f "$pidfile" ] && rm -f $pidfile
   echo "Stopped"
 else
   echo "Nothing to stop"
 fi
}

status() {
 local v_pid v_piffromfile v_already_running
 v_already_running=1
 v_piffromfile=""
 
 ps aef | grep -q "$prog" 
 RETVAL=$?
 if [ "$RETVAL" -eq "0" ]
 then
   v_pid=`ps aef | grep  "$prog" | awk '{printf "%s", $1}'`
   [ -f "$pidfile" ] && v_piffromfile=`cat $pidfile`
   if [ "$v_piffromfile" == "$v_pid" ] 
   then 
     v_already_running=0
   else
     echo $v_pid > "$pidfile"
   fi
  echo "$prog is running with pid $v_pid pidfile: $pidfile"
 else
  echo "$prog is not running"
 fi  

}

# See how we were called.
case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  status)
        status -p ${pidfile} memcached
        RETVAL=$?
        ;;
  *)
        echo "Usage: $0 {start|stop|status}"
        RETVAL=2
        ;;
esac
