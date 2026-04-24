#!/bin/bash

# Set the log file location
log_file="/var/log/app_name.log"
process_name="app_name"
iterations=3
sleep_interval=15

# Get the pid of the app we want to monitor
pid=$(pgrep -f "$process_name" | head -n 1)
[ -z "$pid" ] && exit 0

cpu_peak=0
mem_peak=0

# Loop over the pid and gather stats, sleeping between each run
for i in $(seq 1 "$iterations"); do
    # Run top twice (-n 2) in batch mode (-b) to get %CPU and %MEM
    stats=$(top -b -n 2 -p "$pid" | grep "$pid" | tail -1)
    [ -z "$stats" ] && break
    cpu=$(echo "$stats" | awk '{print $9}')
    mem=$(echo "$stats" | awk '{print $10}')
    cpu_peak=$(awk -v a="$cpu_peak" -v b="$cpu" 'BEGIN { print (b > a) ? b : a }')
    mem_peak=$(awk -v a="$mem_peak" -v b="$mem" 'BEGIN { print (b > a) ? b : a }')
    sleep "$sleep_interval"
done

{
    echo "DATE: $(date '+%Y-%m-%d')"
    echo "TIME: $(date '+%H:%M')"
    echo "CPU %: $cpu_peak"
    echo "Memory %: $mem_peak"
    echo
} >> "$log_file"
