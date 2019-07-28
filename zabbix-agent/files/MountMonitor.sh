#!/bin/bash

if [ -n "$2" ]; then
  MOUNTPOINT="$2"
fi

usage() {
  echo "Usage: `basename $0` scan | isMountpointMounted mountpoint | usage"
}

scan() {
  count=`cat /etc/fstab | egrep -v "swap|^#|^$" | awk '{print $2}' | wc -l`
  echo -n '{'
  echo -n '"data":['
  num=1
  for mount in `cat /etc/fstab | egrep -v "swap|^#|^$" | awk '{print $2}' | sed 's/\.//g' | sed 's/\/$//g'`
  do
    num=$((num+1))
    if [ $num == $count ]; then
      echo -n '{"'{#FS_MOUNT_POINT}'":"'$mount'"}'
    else
      echo -n '{"'{#FS_MOUNT_POINT}'":"'$mount'"},'
    fi
  done
  echo -n "]"
  echo -n "}"
}


isMountpointMounted() {
  if [ `cat /proc/mounts | awk '{print $2}' | egrep -v "^#|swap|^$" | egrep -x -m 1 $MOUNTPOINT` ]; then
    echo 0
  else
    echo 1
  fi
}

case $1 in
  scan) scan;;
  isMountpointMounted) isMountpointMounted;;
  usage) usage;;
  *) usage;;
esac
