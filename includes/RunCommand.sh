#-----------------------
# RunCommand()
#
##RunCommand()
##{
##    MSG="RunCommand $@"
##    LogInfo "$MSG"
##    eval LANG=C "$@" >& /dev/null
##    if [ $? == 0 ]; then
##        STATUS="SUCCESS"
##    else
##        STATUS="FAILED"
##    fi
##}

#-----------------------
# RunCommand()
#
RunCommand()
{
    LogInfo "$@"
    OUTPUT=$(echo $@ | /bin/sh)
    STATUS=$?

    if [ $html == 1 ]; then
      if [ $STATUS == 0 ]; then
        # output
        echo -n "<div style='font-size:80%;font-family: Courier, \"Courier New\", monospace;font-style:italic;margin-top:0;color:gray'>($@)</div>" >> $HTMLDATA
        echo -n "<div style='font-size:80%;font-family: Courier, \"Courier New\", monospace;border:1px dotted black;background-color:E1E1E1;margin:2px'>" >> $HTMLDATA
        echo "$OUTPUT" | sed 's/\s/\&nbsp;/g' | sed 's/$/\<BR \/\>/g' >> $HTMLDATA
        echo -n "</div>" >> $HTMLDATA

        STATUS_MSG="SUCCEDED"
        STATUS_COLOR="GREEN"
      else
        STATUS_MSG="FAILED"
        STATUS_COLOR="RED"
      fi
      LogInfo "STATUS -> $STATUS_MSG"

      echo -n "<div style='font-size:80%;font-family: Courier, \"Courier New\", monospace;font-style:italic;margin-top:0;color:${STATUS_COLOR}'>(${STATUS_MSG})</div>" >> $HTMLDATA
    fi

    if [ $csv == 1 ]; then
      if [ $STATUS == 0 ];then
        STATUS_MSG="SUCCEDED"
      else
        STATUS_MSG="FAILED"
      fi

      echo -e "\"$@\",\"${STATUS_MSG}\",\"${OUTPUT}\"" >> $CSVDATA

    fi
}
