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
    cat "magick-no-comments-no-empty-lines.css"
    echo
    cat "private.css"
  } >TEMP1 && {
	# TEMP2
	mv normalize-no-comments-no-empty-lines.css TEMP2
	sed -i '/@charset/d' TEMP2
	sed -i '/@import/d'  TEMP2

	# TEMP3
	mv google-fonts-1713205420107.css TEMP3

	# build: normalize.css
	rm -f ./*.css
	mv  TEMP3   normalize.css
	cat TEMP2 >>normalize.css && rm -f TEMP2

	# build: magick.css
	mv TEMP1 magick.css
  }
)

echo "# ls dest/"
ls -l dest/

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

( set -x && cd dest/media/images/ && ./replace ../../index.html . >tmp && mv tmp ../../index.html )
set +x

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

true
