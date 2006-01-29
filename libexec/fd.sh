#!/bin/bash
# $Id: fd.sh,v 1.2 2005/11/27 15:32:49 nicolaw Exp $

echo -n "fd:fd:TotalAllocated="
cat /proc/sys/fs/file-nr | sed -e's/\s\s*/,TotalFreeAllocated=/; s/\s\s*/,MaximumOpen=/;'

