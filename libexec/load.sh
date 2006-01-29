#!/bin/bash
# $Id: load.sh,v 1.2 2005/11/27 15:32:49 nicolaw Exp $

echo -n "loadavg:loadavg:1MinAvg=" && \
	cat /proc/loadavg | cut -d' ' -f1-3 | sed -e's/ /,5MinAvg=/; s/ /,15MinAvg=/;'

