#!/bin/bash
# $Id: network.sh,v 1.2 2005/11/27 15:32:49 nicolaw Exp $

cat /proc/net/dev | grep ':' | sed -e's/^\s*/network:/g; s/:\s*/:/g; s/\s\s*/,/g'

