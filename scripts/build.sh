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
  ANALYTICS=0
  if [[ "$GA_ID" =~ ^G-[A-Z0-9]+$ && "$GA_ID" != "G-XXXXXXXXXX" ]]; then
    ANALYTICS=1
    # GA4 with Consent Mode: denied until the visitor accepts in the banner.
    sed "s/__GA_ID__/$GA_ID/g" scripts/analytics-head.html
  fi
  printf '</head>\n<body>\n'
  cat portfolio/index.html
  if [[ $ANALYTICS == 1 ]]; then
    cat scripts/consent-banner.html
  fi
  printf '\n</body>\n</html>\n'
} > _site/index.html
touch _site/.nojekyll
echo "Built _site/ ($(du -sh _site | cut -f1))"
