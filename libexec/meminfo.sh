#!/bin/bash
# $Id: meminfo.sh,v 1.2 2005/11/27 15:32:49 nicolaw Exp $

echo -n "meminfo:meminfo:"
#cat /proc/meminfo | sed -e's/^/,/; s/:\(.*\)\(kB\)/_\2=\1/; s/:/=/; s/\s\s*//;'
cat /proc/meminfo | sed -e's/^/,/; s/:\(.*\)\(kB\)/=\1/; s/:/=/; s/\s\s*//g;' | tr -d '\n' | cut -b2-;

