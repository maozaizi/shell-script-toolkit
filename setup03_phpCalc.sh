#!/bin/bash
################################
# Bitte die PHP-Version angeben!
################################
phpv="8.3"
################################
AvailableRAM=$(awk '/MemAvailable/ {printf "%d", $2/1024}' /proc/meminfo)
AverageFPM=$(ps --no-headers -o 'rss,cmd' -C php-fpm$phpv | awk '{ sum+=$1 } END { printf ("%d\n", sum/NR/1024,"M") }')
FPMS=$((AvailableRAM/AverageFPM))
PMaxSS=$((FPMS*2/3))
PMinSS=$((PMaxSS/2))
PStartS=$(((PMaxSS+PMinSS)/2))
clear
echo ""
echo "Verfügbarer Speicher (RAM) =              "$AvailableRAM "MB"
echo "Speicherverbrauch FPM-Prozesse =  "$AverageFPM "MB"
echo ""
echo "pm.max_children =      "$FPMS
echo "pm.start_servers =     "$PStartS
echo "pm.min_spare_servers = "$PMinSS
echo "pm.max_spare_servers = "$PMaxSS
echo ""
echo " » https://www.c-rieger.de «"
echo ""
exit 0