#!/bin/sh

echo "##################"
head /proc/cpuinfo
head /proc/meminfo
ip a
ifconfig
cat /etc/resolv.conf
cat /etc/*release*
curl ifconfig.io
id
echo "##################"

mkdir -p dest

{
echo "<html>"
echo "<head><title>Lauf Goethe!</title></head>"
echo "<body bgcolor=white>"
echo "Hier entsteht bald etwas...Geduld!"
echo "<body></html>"
} >"dest/index.html"

true
