# AGENTS.md

## Overview
Personal academic website for Christos Baziotis, built on **Jekyll 3.7.3** using the **al-folio** theme. Content is authored in Markdown/BibTeX; layouts are Liquid HTML templates. Deployed to **GitHub Pages** from the `gh-pages` branch.

---

## Architecture

### Directory Map
```
_bibliography/papers.bib   ← ALL publications (single source of truth)
_pages/                    ← Top-level site pages (about, publications, cv, etc.)
_news/                     ← Individual news announcement posts
_layouts/                  ← Liquid HTML page templates
  default.html             ← Base shell (head + nav + content + scripts)
  about.html               ← Homepage: profile + bio + news + selected papers
  bib.html                 ← Publication card template (image, links, abstract)
  page.html                ← Generic content page
  post.html                ← Blog/news post
_includes/                 ← Reusable partial templates
  header.html              ← Navbar (builds links from _pages with nav: true, sorted by index)
  news.html                ← Renders _news/ items, capped by news_limit in _config.yml
  selected_papers.html     ← Queries papers.bib for selected=true entries
  social_list.html         ← Sidebar social links (reads from _config.yml)
  social.html              ← Inline social icons
  scripts/                 ← JS include partials (jquery, bootstrap, mathjax, masonry)
_data/coauthors.yml        ← Coauthor last-name → URL mapping for auto-linking in bib.html
_sass/                     ← SCSS source (compiled into assets/css/main.css)
  _variables.scss          ← Color palette and $max-content-width (800px)
  _themes.scss             ← Light/dark mode CSS variables
  _base.scss               ← Typography, profile, publication card styles
  _layout.scss             ← Page layout, navbar padding, container width
assets/
  css/main.scss            ← SCSS entry point (imports all partials in order)
  img/                     ← Publication thumbnails and profile photo
  pdf/                     ← CV, slides, posters for local download
  js/                      ← dark_mode.js, theme.js, mansory.js
_config.yml                ← All site settings, plugin config, feature flags
```

### Data Flow
1. **Publications page**: `_pages/publications.md` iterates `page.years`, calling `{% bibliography -f papers -q @*[year=Y]* %}` for each year → `jekyll-scholar` renders each entry using `_layouts/bib.html`.
2. **Homepage selected papers**: `_includes/selected_papers.html` queries `{% bibliography -f papers -q @*[selected=true]* %}`.
3. **News section**: `_includes/news.html` reverses `site.news` collection and renders up to `news_limit` (set to `5` in `_config.yml`).
4. **Navigation**: `header.html` sorts `site.pages` by `index` frontmatter and shows pages where `nav: true`.
5. **Coauthor links**: `bib.html` looks up each author's last name in `_data/coauthors.yml`; if found, wraps the name in an `<a>` tag. The site owner (`scholar.last_name: Baziotis`) is always italicised.
6. **Styles**: `assets/css/main.scss` imports `_variables` → `_themes` → `_layout` → `_base`. Variables must be imported first as themes and base reference them.

---

## Development

### Environment Setup (one-time)
Requires **Ruby 2.7.2** via rbenv. Run:
```bash
./dev_env_setup.sh
# Equivalent to:
rbenv install 2.7.2 && rbenv global 2.7.2
gem install bundler -v 2.4.22
bundle install
```
To nuke and reset a broken Ruby environment: `./reset-ruby-env.sh`.

### Local Development
```bash
bundle exec jekyll serve          # Serves at http://localhost:4000, live-reloads on changes
bundle exec jekyll serve --drafts # Also includes draft posts
bundle exec jekyll build          # One-off production build into _site/
```

### Deployment
```bash
./bin/deploy                      # Default: source=master → deploy=gh-pages
./bin/deploy -u                   # User pages: source=source → deploy=master
./bin/deploy -s my-branch -d gh-pages
```
The deploy script:
1. Requires **all changes to be committed** before running (fails otherwise).
2. Checks out a new `gh-pages` branch.
3. Runs `bundle exec jekyll build`.
4. Moves `_site/*` to root, deletes source files (preserving `.git`, `CNAME`, `.gitignore`).
5. Force-pushes to `gh-pages` on origin.
6. Returns to source branch.

---

## Common Tasks

### Adding a Publication
Edit `_bibliography/papers.bib`. All recognised BibTeX fields rendered by `_layouts/bib.html`:

```bibtex
@inproceedings{baziotis-2024-shortkey,
    abbr      = {NAACL},           % Venue badge (plain text, no link unless added to _data/venues.yml)
    title     = "Paper Title",
    author    = "Baziotis, Christos and Last, First",
    booktitle = "Proceedings of ...",
    year      = "2024",
    month     = June,
    address   = "City, Country",
    publisher = "ACL",
    pdf       = "https://arxiv.org/abs/...",  % External URL OR filename in /assets/pdf/
    image     = "/assets/img/my-paper.png",   % Thumbnail (place file in assets/img/)
    abstract  = "...",             % Hidden by default; shown on "Abstract" button click
    selected  = {true},            % Appears in Selected Publications on homepage
    award     = "Best Paper",      % Shown below the venue badge with a trophy icon
    blog      = "https://...",     % Optional button → tweet thread, blog post, etc.
    code      = "https://github.com/...",   % Optional Code button
    slides    = "filename.pdf",    % Local file in /assets/pdf/ OR external URL
    poster    = "filename.pdf",    % Local file in /assets/pdf/ OR external URL
    website   = "https://...",     % Optional Website button
    html      = "https://...",     % Optional HTML button (e.g. ACL Anthology)
    supp      = "filename.pdf",    % Supplementary material
}
```

- **Key format convention**: `lastname-year-shortname` (e.g. `baziotis-2022-hyper-adapters`).
- **`pdf` field**: if the value contains `://` it becomes an external link; otherwise prepended with `/assets/pdf/`.
- **`slides`/`poster`/`supp`**: same URL-vs-local logic as `pdf`.
- **`image`**: can be an absolute path or an external URL (e.g. GitHub raw image).
- Publication years on `_pages/publications.md` must be listed in the `years:` frontmatter array or they won't appear.

### Adding a News Item
Create `_news/announcement_N.md` (increment N):
```markdown
---
layout: post
date: 2025-10-20 12:00:00-0400
inline: true
---
One-line news content here (supports emoji via `:emoji:` syntax).
```
- `inline: true` renders the content directly in the news table on the homepage.
- Without `inline: true`, Jekyll renders a linked title pointing to a full news post page.
- Only the latest `news_limit` (default: 5) items show on the homepage; change in `_config.yml`.

### Adding/Editing a Page
Create in `_pages/`:
```markdown
---
layout: page          # or 'about' for the homepage
permalink: /slug/
title: Page Title
index: 4              # Controls nav bar ordering (lower = further left)
nav: true             # Set false to hide from navbar
description: "..."    # Shown as subtitle under the page title
---
Content here.
```
- CV page (`cv.md`) uses `permalink` pointing directly to a PDF — no body content needed.
- The homepage (`about.md`) uses `layout: about` which adds profile photo, news, and selected papers sections controlled by frontmatter flags (`news: true`, `selected_papers: true`, `social: false`).

### Adding a Coauthor Link
Edit `_data/coauthors.yml`:
```yaml
LastName:
    url: https://author-homepage.com
```
The key must exactly match the author's last name as it appears in `papers.bib`.

### Updating the CV
Replace `assets/pdf/cv_christos_baziotis.pdf`. The CV nav link (`_pages/cv.md`) points directly to this file.

---

## Configuration (`_config.yml`)

| Key | Purpose |
|---|---|
| `scholar.last_name` | Owner's last name; italicised in all publication author lists |
| `scholar.style` | Citation format (`apa`) |
| `news_limit` | Max news items on homepage (default: `5`) |
| `enable_darkmode` | Toggles dark mode switch in navbar |
| `enable_math` | Loads MathJax for LaTeX rendering |
| `enable_mansory` | Enables Masonry grid layout on projects page |
| `enable_tooltips` | Enables tooltips |
| `navbar_fixed` | Sticks navbar to top while scrolling |
| `show_social_icons` | Shows social icons in navbar when on homepage |
| `google_analytics` | GA measurement ID |
| `blog_name` | Must be set (uncommented) for blog nav link to appear |

Social profile fields (`github_username`, `twitter_username`, `linkedin_username`, `scholar_userid`, etc.) are read by `_includes/social_list.html` and `social.html`; leave blank to hide an icon.

---

## Styling

- **Color changes**: edit variables in `_sass/_variables.scss`; theme-color references are in `_sass/_themes.scss`.
- **Dark mode**: CSS variables are swapped via `html[data-theme='dark']` selector in `_themes.scss`. JS toggle lives in `assets/js/theme.js` and `dark_mode.js`.
- **Content width**: controlled by `$max-content-width: 800px` in `_variables.scss`.
- **Publication card layout**: two-column grid defined in `_layouts/bib.html` using Bootstrap's `col-sm-4` (image/badge) and `col-sm-8` (text).
- CSS compilation order in `assets/css/main.scss`: `variables` → `themes` → `layout` → `base` — do not reorder.

---

## Plugins & External Dependencies
| Plugin | Purpose |
|---|---|
| `jekyll-scholar` | BibTeX rendering and bibliography queries |
| `jekyll-email-protect` | Obfuscates email address in HTML |
| `jekyll-github-metadata` | Exposes GitHub repo metadata as `site.github` |
| `jekyll-paginate-v2` | Pagination support (blog, currently disabled) |
| `jekyll-twitter-plugin` | Embeds tweets via `{% twitter %}` tag |
| `jemoji` | Renders `:emoji:` shortcodes in content |
| `bootstrap` / `material-sass` | CSS framework (also loaded via CDN in `_includes/head.html`) |

CDN versions for Bootstrap, FontAwesome, Academicons, jQuery, MathJax, and Masonry are pinned in `_config.yml` under the `# Library versions` section.
