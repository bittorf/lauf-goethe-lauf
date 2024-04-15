#!/bin/sh

# https://arup.dev/blog/2024/jekyll-cloudflare-pages-imagemagick/
# https://asdf-vm.com/
# https://github.com/asdf-vm/asdf-plugins

command -v 'jq' || {
	asdf plugin-add jq  # https://github.com/ryodocx/asdf-jq.git
	asdf install jq latest
	asdf global jq latest
}

#if command -v 'asdf'; then
#	command -v 'convert' || {
#		asdf plugin add imagemagick
#		asdf install imagemagick latest
#		asdf global imagemagick latest
#	}
#else
#	:
#fi
#
#if command -v 'convert'; then
#	convert --version
#else
#	:
#fi

test -d dest && rm -fR dest
cp -pR v2/ dest/

(
  cd dest && {
    # TEMP1: join 'magick' + 'private'
    cat "magick-no-comments-no-empty-lines.css"
    echo
    cat "private.css"
  } >TEMP1 && {
	# TEMP1: remove unneeded stuff
	sed -i '/@charset/d' TEMP1
	sed -i '/@import/d'  TEMP1

	# TEMP2: normalize
	mv normalize-no-comments-no-empty-lines.css TEMP2

	# TEMP3: fonts
	mv google-fonts-1713205420107.css TEMP3

	# cleanup:
	rm -f ./*.css

	# build: normalize.css
	mv  TEMP2   normalize.css

	# build: magick.css
	mv    TEMP3   magick.css
	cat   TEMP1 >>magick.css
	rm -f TEMP1

	echo "# head magick.css"
	head magick.css
	echo
  }
)

echo
echo "# building sitemap:"
unix2from_gitfile() { for UNIX in $( git log -1 --date=unix -- "$1" | grep ^Date: ); do :; done; echo "$UNIX"; }
unix2iso8601() { date +'%Y-%m-%dT%H:%M:%S%:z' -d@"$1"; }
#
# insert real change date into sitemap - FIXME! it does not work
#
PATTERN='2024-03-25T16:33:40+00:00-A'
UNIX="$( unix2from_gitfile 'v2/index.html' )"
NEW="$( unix2iso8601 "$UNIX" )"
sed -i "s/$PATTERN/$NEW/" dest/sitemap.xml
#
PATTERN='2024-03-25T16:33:40+00:00-B'
UNIX="$( unix2from_gitfile 'v2/media/Lauf-Goethe-lauf_Haftungsausschluss_Teilnehmer.pdf' )"
NEW="$( unix2iso8601 "$UNIX" )"
sed -i "s/$PATTERN/$NEW/" dest/sitemap.xml


echo
echo "# replacing image:comments with HTML:"
( cd dest/media/images/ && ./replace ../../index.html . >tmp && mv tmp ../../index.html )


echo
echo "# remove unneeded files:"
rm -f dest/media/images/dl
rm -f dest/media/images/replace
find dest/media/images/ -type f | grep ".json$\|.href$\|.title$\|.alt$" | while read -r LINE; do rm -f "$LINE"; done


echo
echo "# producing zipfile:"
(
  NEWDIR='www.lauf-goethe-lauf.de-images-original'
  ZIP="$NEWDIR.zip"
  cd dest/media && \
  mv originals "$NEWDIR" && \
  zip "$ZIP" "$NEWDIR/"* && \
  rm -fR "$NEWDIR"
)


echo
echo "# all files:"
echo
( cd dest/ && find . -type f -ls )



ignore_the_rest()
{
# debug dates: - seems the checkout is done using --depth=1 so we have no history - FIXME!
echo "# git log -7"
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

}

true
