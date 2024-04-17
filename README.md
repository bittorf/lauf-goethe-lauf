# Ein Experiment!

...mit cloudflare pages: [lauf-goethe-lauf.de](https://lauf-goethe-lauf.de)

* w3c validator ist grün
* https://pagespeed.web.dev alle Kategorien 100%
* index.html alles inline, mit brotli compression ca. 10K
```
# 47k plain
user@box:~$ curl --silent https://www.lauf-goethe-lauf.de/ | wc -c
47189

# 11k mit brotli
user@box:~$ curl --silent --header 'Accept-Encoding: br,gzip,deflate' https://www.lauf-goethe-lauf.de/ | wc -c
10865

# 0.2 sekunden (rendering <1 sec)
bastian@ryzen:~$ time curl --silent --header 'Accept-Encoding: br,gzip,deflate' https://www.lauf-goethe-lauf.de/ >/dev/null 
real	0m0,183s

```

### TODO
* https://community.cloudflare.com/t/browser-language-detection-and-redirect/427408/2
* https://developer.mozilla.org/en-US/docs/Web/API/Navigator/languages
* https://vdelacou.medium.com/deploy-multi-language-static-html-on-cdn-a5dd7e229146
* CSS: external URL: https://christianoliff.com/blog/styling-external-links-with-an-icon-in-css/
* GoogleFonts Download: https://gwfh.mranftl.com/fonts
* CSS inline: https://developer.chrome.com/docs/lighthouse/performance/render-blocking-resources?utm_source=lighthouse&utm_medium=lr&hl=de
