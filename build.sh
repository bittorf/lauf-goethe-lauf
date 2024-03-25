#!/bin/sh

apt-get install imagemagick

test -d dest && rm -fR dest
cp -R v2/ dest/
for SIZE1 in $(du -sb dest); do break; done
echo "[OK] alles sind $SIZE1 bytes"

find dest -type f -name 'foto-*' | while read -r LINE; do {
	convert "$LINE" -resize 700 -quality 60 +profile "*" +comment "$LINE"
} done

for SIZE2 in $(du -sb dest); do break; done
echo "[OK] $(( SIZE2 - SIZE1 )) bytes gespart, nun: $SIZE2 bytes"

echo
echo "##################"
echo "# /proc/cpuinfo"
head /proc/cpuinfo
echo
echo "# /proc/meminfo"
head /proc/meminfo
echo
command -v 'ip' && ip a
command -v 'ifconfig' && ifconfig
command -v 'route' && route -n
cat /proc/net/route
cat /etc/resolv.conf
cat /etc/*release*
echo "public IP: $( curl -s ifconfig.io )"
echo "id: $( id )"
echo "##################"

# https://github.com/iijlab/html-validator-cli
command -v 'validatehtml' && {
	(
		cd dest && {
			if validatehtml .; then
				echo "[OK] checked HTML syntax"
				cd - || exit
				true
			else
				echo "[ERROR] during HTML syntax check"
				false
			fi
		}
	)

	exit $?
}

true
