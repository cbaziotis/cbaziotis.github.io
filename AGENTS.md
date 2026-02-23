# AGENTS.md

## Overview
Personal academic website built on **Jekyll** using the **al-folio** theme. Deployed via GitHub Pages.

## Architecture

### Key Directories
- `_pages/` - Main site pages (about.md, publications.md, cv.md, etc.). Uses `index` frontmatter for nav order.
- `_bibliography/papers.bib` - **Primary publication source**. BibTeX entries rendered via `jekyll-scholar`.
- `_news/` - News announcements (use `inline: true` for compact homepage display).
- `_layouts/` - Templates. `bib.html` controls publication rendering.
- `_includes/` - Reusable components (header, footer, social links).
- `_data/coauthors.yml` - Maps coauthor last names to URLs for auto-linking.
- `_sass/` - SCSS styling. `_themes.scss` for colors, `_base.scss` for typography.
- `assets/img/` - Images including publication thumbnails referenced in `papers.bib`.

### Data Flow
1. `papers.bib` → `jekyll-scholar` → `_layouts/bib.html` → Publications page
2. Entries with `selected={true}` appear on homepage via `_includes/selected_papers.html`
3. Coauthor names auto-link if present in `_data/coauthors.yml`

## Development

### Setup (Ruby 2.7.2 required)
```bash
./dev_env_setup.sh          # Installs rbenv, Ruby 2.7.2, bundler, dependencies
bundle exec jekyll serve    # Local server at localhost:4000
```

### Deployment
```bash
./bin/deploy    # Deploys to gh-pages branch
```

## Common Tasks

### Adding a Publication
Edit `_bibliography/papers.bib`. Required fields:
```bibtex
@inproceedings{key-2024-name,
    abbr = {VENUE},
    title = "...",
    author = "Last, First and ...",
    booktitle = "...",
    year = "2024",
    pdf = "https://...",
    image = "/assets/img/...",
    selected = {true},
    abstract = "...",
    blog = "...",
    code = "...",
}
```
- `abbr` — badge displayed on the publication card
- `pdf` — external URL or local file path under `/assets/pdf/`
- `image` — thumbnail shown on the card
- `selected = {true}` — include entry on the homepage
- `blog` / `code` — optional buttons on the card

### Adding a News Item
Create `_news/announcement_N.md`:
```markdown
---
layout: post
date: YYYY-MM-DD HH:MM:SS-0400
inline: true
---
News content here.
```

### Adding a Page
Create in `_pages/` with frontmatter:
```markdown
---
layout: page
permalink: /slug/
title: Page Title
index: N
nav: true
---
```
`index` controls navigation order.

## Configuration
- `_config.yml` — site settings, scholar config, feature toggles
- `scholar.last_name` — used to bold/italicise the site owner's name in publication lists
- `scholar.style: apa` — citation format
- Feature flags: `enable_math`, `enable_darkmode`, `enable_mansory`

## Conventions
- Publication years listed on `publications.md` must match the `years:` array in that page's frontmatter
- Images for publications: place in `assets/img/`, reference as `/assets/img/filename.png`
- PDF slides: place in `assets/pdf/`, reference in BibTeX as `slides = "filename.pdf"`
- Coauthor links: add `LastName: url: https://...` entries to `_data/coauthors.yml`

