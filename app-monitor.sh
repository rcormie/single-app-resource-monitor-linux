#!/bin/bash

# Set the log file location
log_file="/var/log/app_name.log"

# Get the pid of the app we want to monitor
pid=$(pgrep -f "app_name" | head -n 1)

# Run top twice (-n 2) in batch mode (-b) to get %CPU and %MEM
stats=$(top -b -n 2 -p "$pid" | grep "$pid" | tail -1)
cpu=$(echo "$stats" | awk '{print $9}')
mem=$(echo "$stats" | awk '{print $10}')

{
    echo "DATE: $(date '+%Y-%m-%d')"
    echo "TIME: $(date '+%H:%M')"
    echo "CPU %: $cpu"
    echo "Memory %: $mem"
    echo
} >> "$log_file"
