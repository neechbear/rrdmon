#!/bin/bash
# $Id: avgcpu.sh,v 1.2 2005/11/27 15:32:49 nicolaw Exp $

echo -n "avgcpu:avgcpu:"
str=`iostat -c | grep '\.' | tail -n1 | sed -e's/^\s*//g; s/\s\s*/ /g;'`
read user nice sys iowait idle <<FFOO
$str
FFOO
echo "user=$user,nice=$nice,sys=$sys,iowait=$iowait,idle=$idle"


