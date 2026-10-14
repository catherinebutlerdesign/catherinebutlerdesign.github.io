#!/usr/bin/env bash
# Builds the deployable site in _site/ from portfolio/index.html.
# portfolio/index.html is a page fragment (no <html>/<head>), the same file
# published as the Claude artifact, so this wraps it in a full document.
set -euo pipefail
cd "$(dirname "$0")/.."
rm -rf _site && mkdir -p _site
cp -R portfolio/img _site/img
{
  cat <<'HEAD'
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="description" content="Catherine Butler, Senior Product Designer near Dublin. Complex B2B SaaS, made clear: case studies in subscription self-service, data trust, AI-assisted design systems and SquadCurve.">
<meta property="og:title" content="Catherine Butler — Senior Product Designer">
<meta property="og:description" content="Complex systems, made clear. Case studies in B2B SaaS, design systems and AI-assisted prototyping.">
<meta property="og:type" content="website">
<style>:root{color-scheme:light;padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}body{margin:0}img{max-width:100%}[hidden]{display:none!important}</style>
</head>
<body>
HEAD
  cat portfolio/index.html
  printf '\n</body>\n</html>\n'
} > _site/index.html
touch _site/.nojekyll
echo "Built _site/ ($(du -sh _site | cut -f1))"
