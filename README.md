# rodreegez.com

Static homepage + markdown notes, deployed with Kamal.

## Notes workflow

Write posts in:

- `content/notes/*.md`

Each post uses YAML frontmatter:

```md
---
title: My Post Title
date: 2026-04-08
ai: assisted
model: GPT-5.4
slug: my-post-title
description: One-line description for notes index and meta tags.
---

Markdown body here.
```

Scaffold a new note with:

```bash
bin/notes the future of developers in an ai world
```

That creates `content/notes/the-future-of-developers-in-an-ai-world.md` with the expected frontmatter and optional AI metadata commented out.

If `ai` is omitted, nothing is shown on the post — the default assumption is that the piece is yours unless stated otherwise.

If `date` is omitted or left blank, the build skips that note entirely. This is useful for drafts you want to keep in the repo without publishing.

## Build

```bash
bundle install
bin/build
```

Build output is written to `dist/`.

## Preview locally

```bash
bin/preview
```

This builds the site and serves `dist/` at `http://127.0.0.1:4000` by default.

Optional:

```bash
PORT=4567 HOST=0.0.0.0 bin/preview
```

## Deploy

Deployment continues to use the existing Kamal flow. The Docker image now builds the static site first, then copies the generated `dist/` output into nginx.
