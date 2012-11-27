#-----------------------
# LockFile Function
#
function LockFile () {
  if [ -f "$LOCKFILE" ]; then
    # get pid from lockfile
    read PID < $LOCKFILE

    # verify the process is running
    ps -p $PID -o cmd= | grep $0

    # get the status of the ps command
    ps_status=$?

    # check to see if the ps command returned anything
    if [ $ps_status == 0 ]; then
      ERRMSG="LockFile/PID found for $0 [$LOCKFILE($PID)]. Exiting script."
      LogError "$ERRMSG"
      echo -e "$ERRMSG"

      # exit the script with error
      exit 1
    else
      ERRMSG="LockFile exist, but could not find PID [$LOCKFILE($PID)]. Removing stale LockFile".
      LogError "$ERRMSG"

      # remove old lock file for dead process
      RemoveLockFile

      # put pid in lockfile
      echo $$ > $LOCKFILE
    fi  
  else
    # put pid in lockfile
    echo $$ > $LOCKFILE
  fi
}

#-----------------------
# RemoveLockFile Function
#
function RemoveLockFile () {
  # remove old lock file for dead process
  rm $LOCKFILE
}
