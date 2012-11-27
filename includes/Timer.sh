# StartTime function
function StartTime () {
  # start timer
  STARTTIME=`date +'%s'`
}

# LogTimer function
function LogTime () {
  # current time
  CURRENTTIME=`date +'%s'`

  # log timer
  CURRENTRUNTIME=`echo "scale=2; (($CURRENTTIME - $STARTTIME) / 60)" | bc`

  echo "$CURRENTRUNTIME minutes"
}
