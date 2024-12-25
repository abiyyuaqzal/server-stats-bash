#!/bin/bash

get_cpu () {
	echo "===== CPU Usage ====="
	echo "Total CPU Usage : $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')"
}

get_memory () {
        TOTAL=$(cat /proc/meminfo | grep MemTot | awk '{print $2}')
        FREE=$(cat /proc/meminfo | grep MemFree | awk '{print $2}')
        USED=$((TOTAL-FREE))
	USED_PERCENTAGE=$(echo "scale=2; ($USED/ $TOTAL) * 100" | bc)
        echo "===== Memory Usage ====="
	echo "Total: $((TOTAL/1000000))Gb"
	echo "Used: $((USED/1000000)) ($USED_PERCENTAGE%)"
	echo "Free: $((FREE/1000000))Gb"
}

get_disk () {
	TOTAL=$(df -h | grep C: | awk '{print $2}')
	USED=$(df -h | grep C: | awk '{print $3}')
	PERCENTAGE_USED=$(df -h | grep C: | awk '{print $5}')
	FREE=$(df -h | grep C: | awk '{print $4}')
	echo "===== Disk Usage ====="
	echo "Total: $TOTAL Used: $USED ($PERCENTAGE_USED) Free: $FREE"
}

get_top_cpu () {
	echo "===== Top 5 Processes by CPU Usage ====="
	echo "$(ps -eo pid,ppid,command,%cpu --sort=-%cpu | head -6)"
}

get_top_memory () {
	echo "===== Top 5 Processes by Memory Usage ====="
	echo "$(ps -eo pid,ppid,command,%mem --sort=-%mem | head -6)"
}

additional_stats () {
	echo "===== Additional Stats ====="
	echo "OS Version: $(lsb_release -a | grep Des | sed 's/Description:\s*//')"
	echo "Uptime: $(uptime -p | sed 's/up\s*//')"
	echo "Load Average: $(cat /proc/loadavg)"
	echo "Logged-in User(s): $(top -bn1 | grep user | awk '{print $6, $7}' | sed 's/,//')"
	echo "Failed Login Attempt(s): $(grep "Failed password" /var/log/auth.log | wc -l)"
}

get_cpu
echo ""
get_memory
echo ""
get_disk
echo ""
get_top_cpu
echo ""
get_top_memory
echo ""
additional_stats
