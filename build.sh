#!/bin/sh
#
# v2

mkdir -p dest
cp -R v2 dest
exit 0


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

mkdir -p dest

cp -v flyer-crop-32cols-960wide-opti.png dest/1.png
cp -v goethe.ico dest/1.ico

{
echo '<!DOCTYPE html>'
echo "<html lang=de>"

echo "<head><title>Lauf Goethe!</title>"
echo '<link rel="icon" href="1.ico" type="image/x-icon">'
echo '<link rel=icon href=data:,>'
echo '<meta charset="utf-8">'
echo '<meta name="keywords" content="Staffellauf, Lauf, Fitness, Weimar, Gro&szligkochberg, Großkochberg, Groskochberg, Benefiz, Wohltätigkeit, Spendenlauf, Veranstaltung">'

# https://stackoverflow.com/questions/6169666/how-to-resize-an-image-to-fit-in-the-browser-window
cat <<EOF
<style>
body {
 background-color: #00b1f1;
}
* {
 margin: 0;
 padding: 0;
}
.imgbox {
 display: grid;
 height: 100%;
}
.center-fit {
 max-width: 100%;
 max-height: 100vh;
 margin: auto;
}
</style>
EOF

OE='&ouml;'
AE='&auml;'
SZ='&szlig;'

echo "</head>"

echo "<body>"
echo "<b>Hinweis</b>: Hier entsteht die Website zu einem unvergesslichen Laufabenteuer...<br>"
echo "<div class=container>"
echo "<details>"
echo "<summary>Impressum &amp; Kontakt</summary>"
echo "<div>"

cat <<EOF
<pre>

Veranstalter: Dr. Barbara K${OE}llner, David Bauer

Anschrift:    David Bauer
              Ernst-Th${AE}lmannstra${SZ}e 12
              99423 Weimar

Telefon:      0159 / 067 681 55

E-Mail:       info@lauf-goethe-lauf.de

ORGA-Team:    Dr. Barbara K${OE}llner, David Bauer, Dr. Hendrik Schr${OE}ter
</pre>
EOF

echo "</div>"
echo "</details>"
echo "</div>"

cat <<EOF
<div class='imgbox'>
 <img src='1.png' alt='Veranstaltungsdatum 24.08.2024' class='center-fit'>
</div>
EOF

echo "<a href='https://www.sarkome.de'>Deutsche Sarkom-Stiftung</a>"
echo "</body></html>"

} >"dest/index.html"

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
