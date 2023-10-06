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
echo "<html>"

echo "<head><title>Lauf Goethe!</title>"
echo "<style>"
echo "p {"
echo "  background-image: url('1.webp');"
echo "}"
echo "</style>"
echo "</head>"

echo "<body bgcolor=white>"
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

Telefon:      015906768155

E-Mail:       info@lauf-goethe-lauf.de

ORGA-Team:    Dr. Barbara Köllner, David Bauer, Dr. Hendrik Schröter
<pre>
EOF

echo "</div>"
echo "</details"
echo "</div>"

echo "<body></html>"

} >"dest/index.html"

echo "siehe $PWD/dest"
true
