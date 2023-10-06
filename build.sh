#!/bin/sh

head /proc/cpuinfo
head /proc/meminfo
ip a
cat /etc/*release*
curl ifconfig.io
id

mkdir -p dest
echo "<html><head><title>$( date )::mytitle></title></head><body bgcolor=green>mybody</body></html>" >"dest/index.html"
true

