# Ein Experiment!

...mit cloudflare pages: [lauf-goethe-lauf.de](https://lauf-goethe-lauf.de)

* w3c validator ist grün
* https://pagespeed.web.dev alle Kategorien 100%
* index.html alles inline, mit brotli compression ca. 10K
```
user@box:~$ URL='https://www.lauf-goethe-lauf.de/'

# 47k plain
user@box:~$ curl --silent "$URL" | wc -c
47189

# 11k mit brotli-Kompression
user@box:~$ curl --silent --header 'Accept-Encoding: br,gzip,deflate' "$URL" | wc -c
10865

# Ladezeit: 0.2 sekunden (rendering <1 sec)
user@box:~$ time curl --silent --header 'Accept-Encoding: br,gzip,deflate' "$URL" >/dev/null 
real	0m0,183s

```

### TODO
* https://community.cloudflare.com/t/browser-language-detection-and-redirect/427408/2
* https://developer.mozilla.org/en-US/docs/Web/API/Navigator/languages
* https://vdelacou.medium.com/deploy-multi-language-static-html-on-cdn-a5dd7e229146
* CSS: external URL: https://christianoliff.com/blog/styling-external-links-with-an-icon-in-css/
* GoogleFonts Download: https://gwfh.mranftl.com/fonts
* CSS inline: https://developer.chrome.com/docs/lighthouse/performance/render-blocking-resources?utm_source=lighthouse&utm_medium=lr&hl=de


### Texte
"Mit Eurer Teilnahme und Euren Spenden unterstützt Ihr die wichtige Arbeit von Forschung,
 Diagnostik Therapie seltener Krebserkrankungen aller Altersgruppen. Der Reinerlös kommt
 zu 100% der Deutschen Sarkom-Stiftung zugute."

"Plötzlich steht alles still, der Weg verschwindet im Nebel, doch Stillstand ist keine Option."

"Werdet Teil eines einmaligen Laufabenteuers auf Goethes Spuren. Entlang des neu inszenierten 
 Goethe-Erlebnisweges setzt Ihr ein Zeichen im Kampf gegen Krebs."


### pressemappe:

cd GIT/v2/media
$ ZIPFILE='pressemappe_lauf-goethe-lauf.de-bilder.zip'
$ zip "$ZIPFILE" originals/flyer-* originals/foto-*
$ scp "$ZIPFILE" data.lauf-goethe-lauf.de:/var/www/data.lauf-goethe-lauf.de/html/

