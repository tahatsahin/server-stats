#!/bin/bash
#Show server stats, using bash
#
#script: github.com/tahatsahin/server-stats

while :; do
	# ============ CPU STATS ===========
	# Get the first line of /proc/stats
	cpu_now=($(head -n1 /proc/stat))
	# Get all columns, skip first
	cpu_sum="${cpu_now[@]:1}"
	# Replace the spaces with + => x=${cpu_sum// /+} sum=$((x))
	cpu_sum=$((${cpu_sum// /+}))
	# Get te delta
	cpu_delta=$((cpu_sum - cpu_last_sum))
	# Get idle time delta
	cpu_idle=$((cpu_now[4] - cpu_last[4]))
	# Time spent working
	cpu_used=$((cpu_delta - cpu_idle))
	# percentage
	cpu_usage=$((100 * cpu_used / cpu_delta))

	cpu_last=("${cpu_now[@]}")
	cpu_last_sum=$cpu_sum


	# ============ MEMORY STATS ===========
	# get current memory usages via ps ax, filter for memory column
	# use awk to sum all usages
	mem_sum=$(ps ax -o %mem= | awk '{s+=$1} END {print s}')


	# ============ DISK USAGE ===========
	# get total disk usage using df
	total_info=($(df -hl --total | tail -n 1))

	clear
	echo "Memory usage at $mem_sum%"
	echo "CPU usage at $cpu_usage%"
	echo "Total disk space: ${total_info[1]}, Used Disk: ${total_info[2]}, Available Space: ${total_info[3]}"
	sleep 1
done
