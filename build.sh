#!/bin/sh

# https://arup.dev/blog/2024/jekyll-cloudflare-pages-imagemagick/
# https://github.com/asdf-vm/asdf-plugins

if command -v 'asdf'; then
	asdf plugin add imagemagick && asdf install imagemagick
else
	:
fi

command -v 'convert' && convert --version

command -v 'convert' || {
asdf plugin add imagemagick && asdf install imagemagick 7.1.1-29 && asdf global imagemagick 7.1.1-29
}
#asdf plugin add imagemagick
#command -v 'convert' && convert --version
#asdf plugin update --all
#command -v 'convert' && convert --version

test -d dest && rm -fR dest
cp -R v2/ dest/

(
  cd dest && {
    cat "magick-no-comments-no-empty-lines.css"
    echo
    cat "private.css"
  } >TEMP1 && {
	mv normalize-no-comments-no-empty-lines.css TEMP2
	rm -f ./*.css
	mv TEMP2 normalize.css
	mv TEMP1 magick.css
  }
)

ls -l dest/

for SIZE1 in $(du -sb dest); do break; done
echo "[OK] alles sind $SIZE1 bytes"

find dest -type f -name 'foto-*' | while read -r LINE; do {
	convert "$LINE" -resize 700 -quality 60 +profile "*" +comment "$LINE"
} done

for SIZE2 in $(du -sb dest); do break; done
echo "[OK] $(( SIZE1 - SIZE2 )) bytes gespart, nun: $SIZE2 bytes"

find dest -type f -name 'logo*' | while read -r LINE; do {
	convert "$LINE" -resize 250 -quality 60 +profile "*" +comment "$LINE"
} done

for SIZE3 in $(du -sb dest); do break; done
echo "[OK] $(( SIZE2 - SIZE3 )) bytes gespart, nun: $SIZE3 bytes"

echo "[OK] insgesamt: $(( SIZE1 - SIZE3 )) bytes gespart, nun: $SIZE3 bytes"



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
