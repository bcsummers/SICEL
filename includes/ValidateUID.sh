#-----------------------
# ValidateUID Function
#
function ValidateUID () {
  # check to see if valid user is running this script
  if [ $UID != $* ]; then
    ERRMSG="This script can only be by user with UID of $*. UID $UID is not allowed to execute this script"
    LogError "$ERRMSG"
    echo -e "$ERRMSG"

    # remove old lock file for dead process
    RemoveLockFile

    # exit the script with error
    exit 1
  fi
}
