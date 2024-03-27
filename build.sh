#!/bin/sh

# https://arup.dev/blog/2024/jekyll-cloudflare-pages-imagemagick/
# https://asdf-vm.com/
# https://github.com/asdf-vm/asdf-plugins

if command -v 'asdf'; then
	command -v 'convert' || {
		asdf plugin add imagemagick
		asdf install imagemagick latest
		asdf global imagemagick latest
	}
else
	:
fi

if command -v 'convert'; then
	convert --version
else
	exit 1
fi

test -d dest && rm -fR dest
cp -pR v2/ dest/

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

echo "# ls dest/"
ls -l dest/

echo
for SIZE1 in $(du -sb dest); do break; done
echo "[OK] alles sind $SIZE1 bytes"

find dest -type f -name 'foto-*' | while read -r LINE; do {
	convert "$LINE" -resize 700 -quality 60 +profile "*" +comment "$LINE"
} done

echo
for SIZE2 in $(du -sb dest); do break; done
echo "[OK] $(( SIZE1 - SIZE2 )) bytes gespart, nun: $SIZE2 bytes"

find dest -type f -name 'logo*' | while read -r LINE; do {
	convert "$LINE" -resize 250 -quality 60 +profile "*" +comment "$LINE"
} done
set -x
# https://stackoverflow.com/questions/39056537/why-don-t-svg-images-scale-using-the-css-width-property
# scale to 250px - see CSS-class .image-partner
find dest -type f -iname '*logo*.svg' | while read -r LINE; do {
	ls -l "$LINE"
	BASE="$( basename -- "$LINE" )"
	convert "$LINE" -resize 250 -quality 60 "$LINE.jpg" || continue
	ls -l "$LINE.jpg"
	file "$LINE.jpg"
	sed -i "s/$BASE/$BASE.jpg/g" dest/index.html
} done
set +x

echo
for SIZE3 in $(du -sb dest); do break; done
echo "[OK] $(( SIZE2 - SIZE3 )) bytes gespart, nun: $SIZE3 bytes"


echo "[OK] stripping metadata"
for SIZE4 in $(du -sb dest); do break; done
#
# strip all metadata:
find dest/media/ -type f | while read -r LINE; do {
	convert "$LINE" -strip "$LINE"
} done
#
for SIZE5 in $(du -sb dest); do break; done
echo "[OK] metadata removed: $(( SIZE4 - SIZE5 )) bytes gespart, nun: $SIZE5 bytes"

echo
echo "[OK] insgesamt: $(( SIZE1 - SIZE5 )) bytes gespart, nun: $SIZE5 bytes"

unix2from_gitfile() { for UNIX in $( git log -1 --date=unix -- "$1" | grep ^Date: ); do :; done; echo "$UNIX"; }
unix2iso8601() { date +'%Y-%m-%dT%H:%M:%S%:z' -d@"$1"; }

# insert real change date into sitemap - FIXME! it does not work
#
PATTERN='2024-03-25T16:33:40+00:00-A'
UNIX="$( unix2from_gitfile 'v2/index.html' )"
NEW="$( unix2iso8601 "$UNIX" )"
sed -i "s/$PATTERN/$NEW/" dest/sitemap.xml

PATTERN='2024-03-25T16:33:40+00:00-B'
UNIX="$( unix2from_gitfile 'v2/media/Lauf-Goethe-lauf_Haftungsausschluss_Teilnehmer.pdf' )"
NEW="$( unix2iso8601 "$UNIX" )"
sed -i "s/$PATTERN/$NEW/" dest/sitemap.xml

# debug dates:
echo "gitlog:"
ls -la
git log -7

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

echo
echo "# /proc/net/route"
cat /proc/net/route

echo
echo "# /etc/resolv.conf"
cat /etc/resolv.conf

echo
echo "# /etc/*release*"
cat /etc/*release*

echo
echo "public IP: $( curl -s ifconfig.io )"

echo
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
