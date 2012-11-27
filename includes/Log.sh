# Log function
function LogInfo () {

  LOGSTAMP=`date +'%Y-%m-%d %H:%M:%S'`

  # output to log
  echo -e "$LOGSTAMP - INFO - $*" >> $LLOG

  # send to syslog
  logger -p local2.notice -t $SCRIPTNAME "INFO - $TITLE $*"

  if [ $DEBUG != 0 ]; then
    echo -e "$LOGSTAMP :: INFO :: $*"
  fi

  LOGMSG="$LOGMSG\n$*"
}

# LogError function
function LogError () {

  LOGSTAMP=`date +'%Y-%m-%d %H:%M:%S'`

  # output to log
  echo -e "$LOGSTAMP - ERROR - $*" >> $LERR

  # send to syslog
  logger -p local2.notice -t $SCRIPTNAME "ERROR - $TITLE $*"

  if [ $DEBUG != 0 ]; then
    echo -e "$LOGSTAMP - ERROR - $*"
  fi

  ERRLOGMSG="$ERRLOGMSG\n$*"
}
