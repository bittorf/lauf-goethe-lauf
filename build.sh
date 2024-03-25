#!/bin/sh

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
head /proc/cpuinfo
head /proc/meminfo
ip a
ifconfig
route -n
cat /etc/resolv.conf
cat /etc/*release*
curl ifconfig.io
id
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
