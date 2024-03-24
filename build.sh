#!/bin/sh

test -d dest && rm -fR dest
cp -R v2/ dest/
find dest -type f

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
