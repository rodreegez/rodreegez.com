---
title: Adding Notes to rodreegez.com
date: 2026-04-08
ai: generated
model: GPT-5.4
slug: adding-notes-to-rodreegez-com
description: Why rodreegez.com now has a notes section, how it is built, and how AI involvement is labeled.
---

rodreegez.com now has a `/notes` section.

That is not a very complicated sentence, but it marks a useful change in how the site works. Until now, the site was essentially a single static homepage. That was fine for a personal page, but not a great fit for writing things down over time. There needs to be somewhere for small essays, deployment notes, technical lessons, half-polished ideas, and project writeups that do not deserve a whole separate publishing stack.

So the site now has one.

## The Shape of It

The notes system is intentionally small.

Each post is written as a Markdown file with a little YAML frontmatter. At build time, a small Ruby script reads those files, turns them into HTML, and writes a static site into `dist/`. Nginx then serves the generated files as part of the same deploy that already ships the homepage.

That means the workflow is simple:

- write a Markdown file
- add a title, date, slug, and description
- build the site
- preview it locally
- deploy it with the existing Kamal flow

No database, no CMS, no runtime app, no separate service just for writing.

That is very much the point.

## Why Build It This Way

There are plenty of good frameworks for blogs, but this did not need one.

The homepage was already static. The deployment story already existed. The styling language already existed. So the cheapest sensible move was to extend what was there instead of introducing a second system with its own templates, conventions, and operational shape.

The result is deliberately low-fi:

- Markdown for content
- ERB templates for layout
- a Ruby build script
- static files at the end

That keeps the whole thing easy to understand and easy to maintain. It also makes the notes feel like part of the site rather than a bolted-on external blog.

## Local Preview Matters

One nice side effect of doing this as a static build is that local preview is straightforward.

There is now a tiny preview script that builds the site and serves the generated output locally. That makes it easy to check layout, links, spacing, and tone before shipping changes.

This is not especially glamorous, but it is useful. Small publishing systems are much better when they have a tight write → preview → deploy loop.

## On AI Labeling

This notes section also introduces a small policy for AI disclosure.

Some posts here will be written entirely by me. Some may be shaped or edited with help. Some, like this one, may be substantially generated from prompts, context, and direction.

Rather than pretending those are all the same, notes can optionally declare AI involvement in frontmatter:

```yaml
ai: generated
model: GPT-5.4
```

When that metadata is present, the post shows a small provenance label. When it is absent, nothing is shown.

That default is intentional.

The assumption on a personal site should be that the writing is mine unless stated otherwise. The AI label only appears when there is something worth disclosing. No badge means no badge.

## Why Include the Model

The model name is included on purpose.

Partly that is just honesty: if a post was materially produced with AI, it seems reasonable to say what system produced it.

But there is also a more interesting reason. Models have styles. They have habits, rhythms, strengths, and little giveaways. As they improve over time, it will be interesting to look back through these posts and see how the generated ones change.

`GPT-5.4` means something today. In a few years it will probably mean something very specific.

That feels worth preserving.

## What I Want Notes to Be

The goal here is not to become a content machine.

The goal is to have a durable place for things that are useful to write down:

- lessons from shipping small software
- deployment notes
- product and technical thinking
- systems that worked
- systems that did not
- internet miscellany that would otherwise disappear into drafts or local files

If the setup stays light enough, writing remains easy. And if writing remains easy, the notes have a chance of actually accumulating.

That is really what this change is for.
