#-----------------------
# Header1 Function
#
Header1()
{
    local name="$1"

    header1=$(($header1 + 1))
    header2="0"
    header3="0"
    header4="0"
    header2Enabled="true"
    header3Enabled="true"
    header4Enabled="true"
    
    header1Enabled="true"
    [[ -n "$onlyheader1" ]] &&  
      [[ "$onlyheader1" -ne "$header1" ]] &&  
        header1Enabled=""
    
    [[ -n "$header1Enabled" ]] &&
      printf "\n%s%d\t%s\n" \
        "<H1>${outline:+*}" "$header1" "<a name='$name'>$name</a></H1>" >> $HTMLDATA

      printf "\n\t%s%d\t%s\n" \
        "<p style='margin:0'>${outline:+*}" "$header1" "<a href='#$name'>$name</a></p>" >> $HTMLTOC
}

#-----------------------
# Header2 Function
#
Header2()
{
    local name="$1"

    header2=$(($header2 + 1))
    header3="0"
    header3Enabled="true"

    header2Enabled="true"
    [[ -n "$onlyheader2" ]] &&
      [[ "$onlyheader2" -ne "$header2" ]] &&
        header2Enabled=""

    [[ -n "$header1Enabled" ]] &&
      [[ -n "$header2Enabled" ]] &&
       printf "\n%s%d.%d\t%s\n" \
          "<H2 style='margin-bottom:0'>${outline:+**}" "$header1" "$header2" "<a name='$name'>$name</a></H2>" >> $HTMLDATA

        printf "\n\t\t%s%d.%d\t%s\n" \
          "<p style='text-indent:2em;margin:0'>${outline:+**}" "$header1" "$header2" "<a href='#$name' >$name</a></p>" >> $HTMLTOC
} 

#-----------------------
# Header3 Function
#
Header3()
{
    local name="$1"

    header3=$(($header3 + 1))

    header3Enabled="true"
    [[ -n "$onlyheader3" ]] &&
      [[ "$onlyheader3" -ne "$header3" ]] &&
        header3Enabled=""

    [[ -n "$header1Enabled" ]] &&
      [[ -n "$header2Enabled" ]] &&
        [[ -n "$header3Enabled" ]] &&
          printf "\n%s%d.%d.%d\t%s\n" \
            "<H3 style='margin-bottom:0'>${outline:+***}" "$header1" "$header2" "$header3" "<a name='$name'>$name</a></H3>" >> $HTMLDATA

          printf "\n\t\t\t%s%d.%d.%d\t%s\n" \
            "<p style='text-indent:4em;margin:0'>${outline:+***}" "$header1" "$header2" "$header3" "<a href='#$name'>$name</a></p>" >> $HTMLTOC
}

#-----------------------
# Header4 Function
#
Header4()
{
    local name="$1"

    header4=$(($header4 + 1))

    header4Enabled="true"
    [[ -n "$onlyheader4" ]] &&
      [[ "$onlyheader4" -ne "$header4" ]] &&
        header4Enabled=""

    [[ -n "$header1Enabled" ]] &&
      [[ -n "$header2Enabled" ]] &&
        [[ -n "$header3Enabled" ]] &&
          [[ -n "$header4Enabled" ]] &&
            printf "\n%s%d.%d.%d.%d\t%s\n" \
              "<H4 style='margin-bottom:0'>${outline:+***}" "$header1" "$header2" "$header3" "$header4" "<a name='$name'>$name</a></H3>" >> $HTMLDATA 
            printf "\n\t\t\t%s%d.%d.%d.%d\t%s\n" \
              "<p style='text-indent:6em;margin:0'>${outline:+***}" "$header1" "$header2" "$header3" "$header4" "<a href='#$name'>$name</a></p>" >> $HTMLTOC
}
