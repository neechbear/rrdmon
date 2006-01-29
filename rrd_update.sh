#!/bin/bash

PATH=$PATH:/usr/local/bin
export PATH

# Create and change to spool directory
spooldir="/var/spool/rrd"
if ! [ -d "$spooldir" ]
then
	mkdir -p "$spooldir"
fi
if ! cd "$spooldir"
then
	echo "Unable to chdir to $spooldir"
	exit
fi

# Defaults
rra="RRA:AVERAGE:0.5:1:599 \
	RRA:AVERAGE:0.5:6:700 \
	RRA:AVERAGE:0.5:24:775 \
	RRA:AVERAGE:0.5:228:796"
step=300
heartbeat=600



# cpu
if ! [ -e cpu.rrd ]
then
	rrdtool create cpu.rrd --step $step \
		DS:user:GAUGE:$heartbeat:U:U \
		DS:system:GAUGE:$heartbeat:U:U \
		DS:io_wait:GAUGE:$heartbeat:U:U \
		DS:idle:GAUGE:$heartbeat:U:U \
		$rra
fi

rrdtool update cpu.rrd \
	--template user:system:io_wait:idle \
	N:`vmstat | tail -n1 | cut -b 68- | perl -ne 's/^\s+|\s+$//g; s/\s+/:/g; print;'`



# memory
if ! [ -e memory.rrd ]
then
	rrdtool create memory.rrd --step $step \
		DS:MemTotal:GAUGE:$heartbeat:0:U \
		DS:MemFree:GAUGE:$heartbeat:0:U \
		DS:MemShared:GAUGE:$heartbeat:0:U \
		DS:Buffers:GAUGE:$heartbeat:0:U \
		DS:Cached:GAUGE:$heartbeat:0:U \
		DS:SwapCached:GAUGE:$heartbeat:0:U \
		DS:Active:GAUGE:$heartbeat:0:U \
		DS:ActiveAnon:GAUGE:$heartbeat:0:U \
		DS:ActiveCache:GAUGE:$heartbeat:0:U \
		DS:Inact_dirty:GAUGE:$heartbeat:0:U \
		DS:Inact_laundry:GAUGE:$heartbeat:0:U \
		DS:Inact_clean:GAUGE:$heartbeat:0:U \
		DS:Inact_target:GAUGE:$heartbeat:0:U \
		DS:HighTotal:GAUGE:$heartbeat:0:U \
		DS:HighFree:GAUGE:$heartbeat:0:U \
		DS:LowTotal:GAUGE:$heartbeat:0:U \
		DS:LowFree:GAUGE:$heartbeat:0:U \
		DS:SwapTotal:GAUGE:$heartbeat:0:U \
		DS:SwapFree:GAUGE:$heartbeat:0:U \
		DS:Hugepagesize:GAUGE:$heartbeat:0:U \
		$rra
fi

rrdtool update memory.rrd \
	--template MemTotal:MemFree:MemShared:Buffers:Cached:SwapCached:Active:ActiveAnon:ActiveCache:Inact_dirty:Inact_laundry:Inact_clean:Inact_target:HighTotal:HighFree:LowTotal:LowFree:SwapTotal:SwapFree:Hugepagesize \
	N`grep " kB" /proc/meminfo | tr -d ' ' | perl -ne 'if(/(\d+)/){print":$1";}'`



# load
if ! [ -e load.rrd ]
then
	rrdtool create load.rrd --step $step \
		DS:5min:GAUGE:$heartbeat:U:U \
		DS:10min:GAUGE:$heartbeat:U:U \
		DS:15min:GAUGE:$heartbeat:U:U \
		$rra
fi

rrdtool update load.rrd \
	--template 5min:10min:15min \
	N:`cat /proc/loadavg | cut -d' ' -f1-3 | tr ' ' ':'`



# processes
if ! [ -e processes.rrd ]
then
	rrdtool create processes.rrd --step $step \
		DS:total:GAUGE:$heartbeat:1:U \
		DS:io_sleep:GAUGE:$heartbeat:0:U \
		DS:in_run_queue:GAUGE:$heartbeat:0:U \
		DS:sleeping:GAUGE:$heartbeat:0:U \
		DS:traced_or_stopped:GAUGE:$heartbeat:0:U \
		DS:zombie:GAUGE:$heartbeat:0:U \
		$rra
fi

rrdtool update processes.rrd \
	--template total:io_sleep:in_run_queue:sleeping:traced_or_stopped:zombie \
	N:`ps -aeo state | perl -ne'BEGIN{@x{qw(D R S T Z)}=(0,0,0,0,0);}chomp;$x{$_}++;$x{t}++;END{print join(":",@x{qw(t D R S T Z)}),"\n";}'`



# users
if ! [ -e users.rrd ]
then
	rrdtool create users.rrd --step $step \
		DS:total_users:GAUGE:$heartbeat:0:U \
		DS:unique_users:GAUGE:$heartbeat:0:U \
		$rra
fi

rrdtool update users.rrd \
	--template total_users:unique_users \
	N:`w -h | wc -l | tr -d ' '`:`w -h | cut -d' ' -f1 | sort | uniq | wc -l | tr -d ' '`



# ping
for host in 195.200.0.71 perl.org cpan.org
do
	if ! [ -e ping-$host.rrd ]
	then
		rrdtool create ping-$host.rrd --step $step \
			DS:min:GAUGE:$heartbeat:U:U \
			DS:avg:GAUGE:$heartbeat:U:U \
			DS:max:GAUGE:$heartbeat:U:U \
			DS:mdev:GAUGE:$heartbeat:U:U \
			$rra
	fi

	rrdtool update ping-$host.rrd \
		--template min:avg:max:mdev \
		N:`ping -nqc 5 $host | grep 'min/avg/max/mdev' | cut -d ' ' -f4 | tr '/' ':'`
done



