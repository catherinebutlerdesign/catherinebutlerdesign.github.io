# catherinebutlerdesign.github.io

Portfolio of Catherine Butler, Senior Product Designer based in Dublin.
Live at **https://catherinebutlerdesign.github.io**.

## Structure

| Path | What it is |
| --- | --- |
| `portfolio/index.html` | The whole site: home page and four case studies, with all CSS and JS inline. It is a page fragment (no `<html>`/`<head>`), so the same file can also be published as a Claude artifact. |
| `portfolio/img/` | Screenshots and the portrait, referenced as `img/...`. |
| `scripts/build.sh` | Wraps the fragment in a full HTML document and writes the deployable site to `_site/`. |
| `.github/workflows/pages.yml` | Builds and deploys to GitHub Pages on every push to `main`. |

Case studies are views inside the one page, reached by hash: `#subscriptions`, `#datahealth`, `#designsystem`, `#squadcurve`.

## Analytics

GA4 is added by `scripts/build.sh`, only to the hosted site (never the Claude artifact).
Set the measurement ID in `GA_ID` at the top of that script; while it is the
placeholder `G-XXXXXXXXXX`, no analytics code ships. Consent Mode defaults every
storage type to denied, so no cookies are set. Each case study is reported as a
virtual page, `/case-studies/<name>`.

## Preview locally

```bash
./scripts/build.sh
python3 -m http.server 4317 --directory _site
```

Then open http://localhost:4317.
