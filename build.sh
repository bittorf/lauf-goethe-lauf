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

cp -v flyer-crop-32cols-1920wide.webp dest/1.webp

{
echo '<!DOCTYPE html>'
echo "<html lang=de>"

echo "<head><title>Lauf Goethe!</title>"

# https://stackoverflow.com/questions/6169666/how-to-resize-an-image-to-fit-in-the-browser-window
cat <<EOF
<style>
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

echo "</head>"

echo "<body>"
echo "<div class=container>"
echo "<details>"
echo "<summary>Impressum &amp; Kontakt</summary>"
echo "<div>"

cat <<EOF
<pre>

Veranstalter: Dr. Barbara Köllner, David Bauer

Anschrift:    Dr. Barbara Köllner
              Neuer Herrenweg 10
              99428 Weimar

Telefon:      0159 / 067 681 55

E-Mail:       info@lauf-goethe-lauf.de

ORGA-Team:    Dr. Barbara Köllner, David Bauer, Dr. Hendrik Schröter
</pre>
EOF

echo "</div>"
echo "</details>"
echo "</div>"
echo "<div class='imgbox'>"
echo "<img class='center-fit' src='1.webp' alt='Veranstaltungsdatum 24.08.2024'>"
echo "</div>"
echo "</body></html>"

} >"dest/index.html"

echo "siehe $PWD/dest"
true
