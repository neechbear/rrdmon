#!/bin/bash
# $Id: processes.sh,v 1.2 2005/11/27 15:32:49 nicolaw Exp $

echo -n "processes:allusers:"
/bin/ps --no-heading -A -o "state,user" | sort > /tmp/proc.$$
echo -n "Total=`wc -l /tmp/proc.$$|awk '{print $1}'`"

for state in `cat /tmp/proc.$$|awk '{print $1}'|sort|uniq`
do
	num=`grep "$state" /tmp/proc.$$ | wc -l`
	echo -n ",$state=$num"
done
echo

for user in `cat /tmp/proc.$$|awk '{print $2}'|sort|uniq`
do
	total=`grep " $user" /tmp/proc.$$|wc -l|awk '{print $1}'`
	echo -n "processes:$user:Total=$total"
	for state in `grep " $user" /tmp/proc.$$|awk '{print $1}'|sort|uniq`
	do
		num=`grep "$state $user" /tmp/proc.$$ | wc -l`
		echo -n ",$state=$num"
	done
	echo
done

