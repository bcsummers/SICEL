#!/bin/bash

# vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4

#-------------------------------------------------------------------------------
# Last-Updated :: <2012 Nov 26 10:05:58 PM Bracey Summers>
#
# sicel.sh :: system information collector (enterpise linux)
#
# @create date :: 2012-11-22
# @category :: App
# @package :: NA
# @author :: Bracey Summers <bcsummersATgmail.com>
# @copyright :: NA
# @license :: NA
# @version :: X.X
# @requirements :: none
# @notes :: none
#-------------------------------------------------------------------------------

# include Commands
. includes/Commands.sh

# common variables
DEBUG=0
USERUID=0 # root
LOGDATE=`date +'%Y-%m-%d'`
BASEPATH=/pd/home/bsummers/WORKING/SICEL
SCRIPTNAME=`echo ${0##*/} | cut -d\. -f1`
SHORTHOSTNAME=`hostname -s`
html=0
xml=0
csv=0
output_file_prefix=$SHORTHOSTNAME

# other vars
LOCKFILE="/tmp/${SCRIPTNAME}.lock"
LLOG="${BASEPATH}/logs/${SCRIPTNAME}-${LOGDATE}.log"
LERR="${BASEPATH}/logs/${SCRIPTNAME}-${LOGDATE}.err"

# include Log functions
. includes/Log.sh

# include LockFile function
. includes/LockFile.sh

# include RunCommand functions
. includes/RunCommand.sh

# include ValidateUIDS function
. includes/ValidateUID.sh

# include Time function
. includes/Timer.sh

# include Time function
. includes/GetOpt.sh

# check to see if valid UID is running script
ValidateUID "$USERUID" 

# get command line arguments
while getoptex "html xml csv prefix:" "$@"
do
  if [ "$OPTARG" ]; then
      parameter=$OPTOPT
      value="$OPTARG"
      eval $parameter='$value'
  else
      parameter=$OPTOPT
      eval $parameter=1
  fi  
done

# check command line usage
if [[ $html == 0 && $xml == 0 ]]; then
  echo -e "USAGE: $0 --html and/or --xml and/or --csv"
  echo -e "\t[--prefix=<prefix>]"
  exit 1 
fi

# start timer
StartTime

# check for LockFile and PID
LockFile

################################################################################
# SMARTS GO HERE
################################################################################

. includes/HTMLOutput.sh

# temporary files to hold data
HTMLDATA="/tmp/data.html"
HTMLTOC="/tmp/toc.html"
CSVDATA="/tmp/data.csv"
XMLDATA="/tmp/data.xml"

# vars
MYDATE=`date`
MYHOSTNAME=`hostname`
MYOSVERSION=`cat /etc/redhat-release`
# get OS ver number only
OSVER=`cat /etc/redhat-release | awk '{print $7}'`

if [ $html = 1 ]; then
  # add header to TOC file
   echo -n "<BR /><BR /><div style='width:35%;border-style:solid'>Collected on: ${MYDATE}</div><BR />" >> $HTMLTOC
   echo -n "<div style='font-size:90%;font-family:\"Courier New\"'>" >> $HTMLTOC
   echo -n "<b>Summary for $MYHOSTNAME<BR /><BR />" >> $HTMLTOC
fi

#-------------------------------------------------
# build the page
#-------------------------------------------------

#-------------------------------------------------
Header1 "System"

#------------------------
Header2 "Operating System"

Header3 "Red Hat Release"
RunCommand "cat /etc/redhat-release"

Header3 "Uname"
RunCommand "uname -a"

Header3 "OS Release"
RunCommand "cat /proc/sys/kernel/osrelease"

Header3 "Kernel Version"
RunCommand "cat /proc/sys/kernel/version"

#------------------------
Header2 "Kernel Modules"

Header3 "Modprobe"
RunCommand "cat /etc/modprobe.conf"

Header3 "Modprobe.d"
for i in `ls /etc/modprobe.d/`
do 
  Header4 "$i"
  RunCommand "cat /etc/modprobe.d/$i"
done

Header3 "Status Of Modules"
RunCommand "lsmod"

Header3 "List Of Modules"
RunCommand "modprobe -l"

#------------------------
Header2 "Hardware Information"

Header3 "CPU"
RunCommand "cat /proc/cpuinfo"

Header3 "Memory"
RunCommand "cat /proc/meminfo"

Header3 "Physical Disk"
RunCommand "fdisk -l"

Header3 "PCI bus"
RunCommand "lspci -v"

Header3 "USB bus"
RunCommand "lsusb -v"

#------------------------
Header2 "Disk configuration"

Header3 "file system table"
RunCommand "cat /etc/fstab"

Header3 "manage MD devices (RAID)"
RunCommand "cat /etc/mdadm.conf"

Header3 "LVM"

Header4 "PV Display"
RunCommand "pvdisplay"

Header4 "VG Display"
RunCommand "vgdisplay"

Header4 "LV Display"
RunCommand "lvdisplay"

#------------------------
Header2 "PROC"

Header3 "cmdline"
RunCommand "cat /proc/cmdline"

Header3 "devices"
RunCommand "cat /proc/devices"

Header3 "filesystem"
RunCommand "cat /proc/filesystems"

Header3 "fs nfs exports"
RunCommand "cat /proc/fs/nfs/exports"

Header3 "modules"
RunCommand "cat /proc/modules"

Header3 "mounts"
RunCommand "cat /proc/mounts"

Header3 "partitions"
RunCommand "cat /proc/partitions"

Header3 "slabinfo"
RunCommand "cat /proc/slabinfo"

Header3 "sys fs inode-state"
RunCommand "cat /proc/sys/fs/inode-state"

Header3 "sys fs dentry-state"
RunCommand "cat /proc/sys/fs/dentry-state"

Header3 "sys fs file-nr"
RunCommand "cat /proc/sys/fs/file-nr"

Header3 "ipc msg"
RunCommand "cat /proc/sysvipc/msg"

Header3 "ipc sem"
RunCommand "cat /proc/sysvipc/sem"

Header3 "ipc shm"
RunCommand "cat /proc/sysvipc/shm"

#------------------------
Header2 "Settings"

Header3 "Startup Runlevel"
RunCommand "cat /etc/inittab"

Header3 "Current Runlevel"
RunCommand "who -r"

Header3 "Single User Mode Protection"
RunCommand "cat /etc/sysconfig/init"

Header3 "Limits"
RunCommand "ulimit -a"

Header3 "Bash"
RunCommand "cat /etc/bashrc"

Header3 "Profile"
RunCommand "cat /etc/profile"

Header3 "Profile.d"
for i in `ls /etc/profile.d`
do 
  Header4 "$i"
  RunCommand "cat /etc/profile.d/$i"
done

Header3 "Vim"
RunCommand "cat /etc/vimrc"

#------------------------
Header2 "Current Environment"

Header3 "Export"
RunCommand "export"

Header3 "Environment"
RunCommand "env"

Header3 "Set"
RunCommand "set"

#------------------------
Header2 "System Crons"

Header3 "Cron scripts"
for i in `ls /etc/cron.d`
do 
  Header4 "$i"
  RunCommand "cat /etc/cron.d/$i"
done

#------------------------
Header3 "Hourly Crons"
for i in `ls /etc/cron.hourly`
do 
  Header4 "$i"
  RunCommand "cat /etc/cron.hourly/$i"
done

#------------------------
Header3 "Daily Crons"
for i in `ls /etc/cron.daily`
do 
  Header4 "$i"
  RunCommand "cat /etc/cron.daily/$i"
done

#------------------------
Header3 "Weekly Crons"
for i in `ls /etc/cron.weekly`
do 
  Header4 "$i"
  RunCommand "cat /etc/cron.weekly/$i"
done

#------------------------
Header3 "Monthly Crons"
for i in `ls /etc/cron.monthly`
do 
  Header4 "$i"
  RunCommand "cat /etc/cron.monthly/$i"
done

#------------------------
Header2 "System Files"

Header3 "/etc"
RunCommand "ls -alR /etc"

#-------------------------------------------------
Header1 "Authentication"

#------------------------
Header2 "Banners"

Header3 "Issue"
RunCommand "cat /etc/issue"

Header3 "Issue Net"
RunCommand "cat /etc/issue.net"

Header3 "MOTD"
RunCommand "cat /etc/motd"

#------------------------
Header2 "PAM"
for i in `ls -L /etc/pam.d/`
do 
  Header3 "$i"
  RunCommand "cat /etc/pam.d/$i"
done

#------------------------
Header2 "nsswitch.conf"
RunCommand "cat /etc/nsswitch.conf"

#------------------------
Header2 "sssd"
RunCommand "cat /etc/sssd/sssd.conf"

#------------------------
Header2 "ldap"
RunCommand "cat /etc/openldap/ldap.conf"

#------------------------
Header2 "sudo-ldap.conf"
RunCommand "cat /etc/sudo-ldap.conf"

#------------------------
Header2 "kerberos"
RunCommand "cat /etc/krb5.conf"

#------------------------
Header2 "login.defs"
RunCommand "cat /etc/login.defs"

#------------------------
Header2 "/etc/default/useradd"
RunCommand "cat /etc/default/useradd"

#------------------------
Header2 "Accounts Information"

Header3 "Passwd"
RunCommand "cat /etc/passwd"

Header3 "Groups"
RunCommand "cat /etc/group"

Header3 "Account Expiration"
RunCommand "find /home/* -maxdepth 0 -type d | grep -v lost | awk -F/ '{print \$3}' | xargs -n1 perl -e 'print \`passwd -S \$ARGV[0]\`;print \`chage -l \$ARGV[0]\`;print \"\n\"'"

Header3 "Home Directories"
RunCommand "find /home/* -maxdepth 0 -type d | xargs ls -ld"

Header3 "Email"

Header4 "Aliases"
RunCommand "cat /etc/aliases"

Header4 "Local Mail"
RunCommand "ls /var/spool/mail"

Header3 "User Crons"
for i in `ls /var/spool/cron`
do 
  Header4 "$i"
  RunCommand "cat /var/spool/cron/$i"
done

#-------------------------------------------------
Header1 "Authorization"

#------------------------
Header2 "sudoers"
RunCommand "cat /etc/sudoers"

#------------------------
Header3 "sudoers.d"
for i in `ls -L /etc/sudoers.d/`
do 
  Header4 "$i"
  RunCommand "cat /etc/sudoers.d/$i"
done

#------------------------
Header2 "at"

Header3 "allow"
RunCommand "cat /etc/at.allow"

Header3 "at deny"
RunCommand "cat /etc/at.deny"

#------------------------
Header2 "cron"

Header3 "allow"
RunCommand "cat /etc/cron.allow"

#------------------------
Header3 "deny"
RunCommand "cat /etc/cron.deny"


#-------------------------------------------------
Header1 "Audit"

#------------------------
Header2 "Audit Configuration"

Header3 "Audit"
RunCommand "cat /etc/audit/audit.rules"

Header3 "Auditd Config"
RunCommand "cat /etc/audit/auditd.conf"

#------------------------
Header2 "Users"

Header3 "Finger"
RunCommand "finger"

Header3 "W"
RunCommand "w"

Header3 "Who"
RunCommand "who"

Header3 "Last logged in users"
RunCommand "last -n 20"

Header3 "Last user login"
RunCommand "lastlog"

#------------------------
Header2 "Logging"

Header3 "Rsyslog"
RunCommand "cat /etc/rsyslog.conf"

Header3 "Log Rotation"
RunCommand "cat /etc/logrotate.conf"

Header3 "Log Rotation Scripts"
for i in `ls /etc/logrotate.d/`
do 
  Header4 "$i"
  RunCommand "cat /etc/logrotate.d/$i"
done

Header3 "Log Files"
RunCommand "ls -alR /var/log"

Header3 "dmesg"
RunCommand "dmesg"

#-------------------------------------------------
Header1 "Services"

#------------------------
Header2 "ssh_config"
RunCommand "cat /etc/ssh/ssh_config"

#------------------------
Header2 "sshd_config"
RunCommand "cat /etc/ssh/sshd_config"

#-------------------------------------------------
Header1 "Software"

#------------------------
Header2 "Yum"

Header3 "Yum configuration"
RunCommand "cat /etc/yum.conf"

Header3 "Yum Repositories"
for i in `ls /etc/yum.repos.d/ | grep "\.repo"`
do 
  Header4 "$i"
  RunCommand "cat /etc/yum.repos.d/$i"
done

#------------------------
Header2 "Installed Package List"
RunCommand "yum list installed"

#------------------------
Header2 "Updates Package List"
RunCommand "yum -C list updates"

#------------------------
Header2 "YUM Log"
RunCommand "cat /var/log/yum.log"

#------------------------
Header2 "Configured Services"
RunCommand "chkconfig --list | grep \":on\""

#-------------------------------------------------
Header1 "Resources"

#------------------------
Header2 "Uptime"
RunCommand "uptime"

Header2 "Memory"
RunCommand "free"

Header2 "Virutal Memory"
RunCommand "vmstat"

Header2 "File system"
RunCommand "df -k -P -T"

Header2 "Process Tree"
RunCommand "pstree"

Header2 "Top Processes"
RunCommand "top -b -n 1"

#Header2 "System Resources Statistics"
#RunCommand "dstat --all --nocolor -t 1 20"

Header2 "Process Details"
RunCommand "ps -elwf"

Header2 "Open Files"
RunCommand "lsof -P"

#-------------------------------------------------
Header1 "Network"

#------------------------
Header2 "Network Security"

Header3 "Iptables running"
RunCommand "iptables -v -L -n"

Header3 "TCP Wrappers"

Header4 "Allowed"
RunCommand "cat /etc/hosts.allow"

Header4 "Denied"
RunCommand "cat /etc/hosts.deny"

#------------------------
Header2 "Network Settings"

Header3 "resolv.conf"
RunCommand "cat /etc/resolv.conf"

Header3 "network"
RunCommand "cat /etc/sysconfig/network"

Header3 "Interfaces"
RunCommand "ifconfig -a"

Header3 "Routes"
RunCommand "netstat -rn"

Header3 "Listen Ports"
RunCommand "netstat -nlp"

Header3 "All connections"
RunCommand "netstat -a"

#------------------------
Header2 "Interface Configs"
for i in `ls /etc/sysconfig/network-scripts/ifcfg*`
do 
  Header3 "$i"
  RunCommand "cat $i"
done

#------------------------
Header2 "Network Bonding"
for i in `ls /proc/net/bonding/*`
do
  Header3 "$i"
  RunCommand "cat $i"
done

#------------------------
Header2 "Network Services"

Header3 "NTP"

Header4 "NTP configuration"
RunCommand "cat /etc/ntp.conf"

Header4 "NTP query"
RunCommand "ntpq -p"

Header3 "Network File system (NFS)"

Header4 "Configured exports"
RunCommand "cat /etc/exports"

Header4 "Current exports"
RunCommand "exportfs -v"

Header4 "NFS configuration"
RunCommand "cat /etc/sysconfig/nfs"

Header4 "NFS mount configuration"
RunCommand "cat /etc/nfsmount.conf"

Header4 "NFS mapping configuration"
RunCommand "cat /etc/idmapd.conf"

# output the data
if [ $html == 1 ]; then
  # add header to TOC file
  echo -n "<div>" >> $HTMLTOC

  cat $HTMLTOC > "${output_file_prefix}.html"
  cat $HTMLDATA >> "${output_file_prefix}.html"

  # remove temporary files
  rm -fr $HTMLTOC
  rm -fr $HTMLDATA
fi

if [ $xml == 1 ]; then
  echo "COMMAND,STATUS,OUTPUT" > "${output_file_prefix}.xml"
  cat $xml >> "${output_file_prefix}.xml"

  # remove temporary files
  rm -fr $XMLDATA
fi

if [ $csv == 1 ]; then
  echo "COMMAND,STATUS,OUTPUT" > "${output_file_prefix}.csv"
  cat $csv >> "${output_file_prefix}.csv"

  # remove temporary files
  rm -fr $CSVDATA
fi

################################################################################
# SMART END HERE
################################################################################

# remove lock file
RemoveLockFile

# log timer 
TIMER=$(LogTime) 
MSG="Total Run Time [$TIMER]." 
LogInfo "$MSG"
