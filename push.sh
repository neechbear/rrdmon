#!/bin/bash
# $Id: push.sh,v 1.1 2005/11/27 15:31:27 nicolaw Exp $

HOSTS="192.168.1.122 192.168.1.123 192.168.1.124"

for host in $HOSTS
do
	rsync -alpve 'ssh' --cvs-exclude --exclude=push.sh \
		/home/nicolaw/cvs/RRDMon/* \
		$host:/home/system/RRDMon/
done

