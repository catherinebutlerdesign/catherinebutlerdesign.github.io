#!/usr/bin/env bash
# Builds the deployable site in _site/ from portfolio/index.html.
# portfolio/index.html is a page fragment (no <html>/<head>), the same file
# published as the Claude artifact, so this wraps it in a full document.
set -euo pipefail
cd "$(dirname "$0")/.."

# GA4 measurement ID. While it is the placeholder, no analytics code ships.
GA_ID="${GA_ID:-G-6Y7QW5C0FW}"
rm -rf _site && mkdir -p _site
cp -R portfolio/img _site/img
{
  cat <<'HEAD'
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="description" content="Catherine Butler, Senior Product Designer based in Dublin. Complex B2B SaaS, made clear: case studies in subscription self-service, data trust, AI-assisted design systems and SquadCurve.">
<meta property="og:title" content="Catherine Butler — Senior Product Designer">
<meta property="og:description" content="Complex systems, made clear. Case studies in B2B SaaS, design systems and AI-assisted prototyping.">
<meta property="og:type" content="website">
<style>:root{color-scheme:light;padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}body{margin:0}img{max-width:100%}[hidden]{display:none!important}</style>
HEAD
  if [[ "$GA_ID" =~ ^G-[A-Z0-9]+$ && "$GA_ID" != "G-XXXXXXXXXX" ]]; then
    # Consent Mode with everything denied: no cookies are set and GA4 gets
    # cookieless pings only. Case studies are views inside one page, so each
    # is sent as a virtual path such as /case-studies/datahealth.
    cat <<GA
<script>
window.dataLayer = window.dataLayer || [];
function gtag(){ dataLayer.push(arguments); }
gtag('consent', 'default', { analytics_storage: 'denied', ad_storage: 'denied', ad_user_data: 'denied', ad_personalization: 'denied' });
gtag('set', 'ads_data_redaction', true);
gtag('js', new Date());
gtag('config', '${GA_ID}', { send_page_view: false });
(function () {
  var sent = false;
  function view(name, title) {
    sent = true;
    var home = !name || name === 'home';
    gtag('event', 'page_view', {
      page_location: location.origin + (home ? '/' : '/case-studies/' + name),
      page_title: home ? 'Home' : (title || name) + ' (case study)'
    });
  }
  document.addEventListener('portfolio:view', function (e) { view(e.detail.name, e.detail.title); });
  document.addEventListener('DOMContentLoaded', function () { if (!sent) view('home'); });
})();
</script>
<script async src="https://www.googletagmanager.com/gtag/js?id=${GA_ID}"></script>
GA
  fi
  printf '</head>\n<body>\n'
  cat portfolio/index.html
  printf '\n</body>\n</html>\n'
} > _site/index.html
touch _site/.nojekyll
echo "Built _site/ ($(du -sh _site | cut -f1))"
