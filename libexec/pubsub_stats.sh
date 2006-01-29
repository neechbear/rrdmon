#!/bin/bash
# $Id: pubsub_stats.sh,v 1.2 2005/11/27 15:32:49 nicolaw Exp $

exit
echo "PID	Instance	Threads	Open FDs"
echo "======= =============== ======= ========"

for pid in `/bin/ps -a | grep java | awk '{print $1}'`
do
	threads=`find /proc/$pid/task/ -type d | wc -l`
	instance=`readlink /proc/$pid/cwd|sed -e's/.*\///'`
	openfds=`find /proc/$pid/task/ | egrep "/fd/[^/]*" | wc -l`
	echo "$pid	$instance	$threads	$openfds"
done




