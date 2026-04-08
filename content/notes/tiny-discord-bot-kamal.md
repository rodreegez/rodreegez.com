---
title: Shipping a Tiny Discord Bot on a Single VPS With Kamal
date: 2026-04-08
ai: generated
model: GPT-5.4
slug: discord-bot-kamal
description: What I learned deploying a tiny Rack-based Discord bot with Postgres and Kamal on a single VPS.
---

I wanted to deploy a very small Discord bot to a personal VPS without dragging in a full Rails app, a managed database, or a pile of infrastructure. The target was deliberately narrow: get a slash-command based bot online, serve Discord interactions over HTTPS, and keep the whole thing simple enough that future side projects could reuse the same setup.

This is what I learned along the way.

## Start Smaller Than You Think

The first useful decision was not technical complexity, but scope control.

For a Discord bot built around slash commands, I did not need:

- a long-running gateway bot process
- websockets
- background jobs
- Rails
- even Sinatra

A small Rack app with Puma was enough.

Discord interactions are just signed HTTP POST requests. Once the app can:

- respond to Discord's initial `PING`
- verify the request signature
- dispatch slash commands
- return JSON responses

you already have a usable bot.

That kept the first deploy extremely small:

- `GET /up` for health checks
- `POST /interactions` for Discord
- `/ping` returning `pong`

This was the right call. It gave us a working walking skeleton without spending time on framework weight we did not yet need.

## Kamal Handles Multi-App Reverse Proxying Well

One early concern was how to run more than one app on a single VPS.

The answer is: multiple DNS records can point at the same machine, and Kamal handles the host-based reverse proxying. That means:

- `status.rodreegez.com` can point at the VPS IP
- `points.rodreegez.com` can point at the same VPS IP
- Kamal routes requests to the correct container based on the `Host` header

That made the VPS feel more like shared application infrastructure instead of a one-app box.

The important part is that each app has its own `proxy.host` in `config/deploy.yml`. DNS still has to be configured manually, but Kamal takes care of the in-box routing.

## Secrets Need a Consistent Source of Truth

Kamal secrets work well, but only if the secret references are consistent.

The clean setup ended up being:

- `GHCR_TOKEN` from the local shell
- all app secrets from `pass`

That meant `.kamal/secrets` could stay declarative:

```sh
GHCR_TOKEN=$GHCR_TOKEN
DATABASE_URL=$(pass show banoffee/postgres/points_database_url)
DISCORD_APP_ID=$(pass show points/DISCORD_APP_ID)
DISCORD_PUBLIC_KEY=$(pass show points/DISCORD_PUBLIC_KEY)
DISCORD_BOT_TOKEN=$(pass show points/DISCORD_BOT_TOKEN)
```

The lesson here was simple: do not mix secret sources casually. It is very easy to end up with one value in `.env`, another in `pass`, and an old one already deployed on the server.

## A Shared Postgres Instance Makes Sense on a Personal VPS

At first, SQLite looked attractive because the bot was tiny.

But once the question became "how should I support multiple little side projects on this box?", Postgres became the better choice. Not because the bot itself is demanding, but because the infrastructure pattern is cleaner:

- one Postgres instance on the VPS
- one role and one database per app
- app containers connect over the local Docker network
- backups and upgrades happen in one place

That felt much more reusable than giving every project its own SQLite file and volume story.

## Container-to-Host Networking Is the Part That Actually Bites

The most useful lesson from the whole exercise was that "the database is on the same VPS" is not enough information once the app is running in Docker.

`127.0.0.1` inside a container is the container itself, not the host.

That broke the first attempt immediately. Then came the second lesson: the right host address depends on the Docker network the app is actually using.

There were two different networks in play:

- the default Docker `bridge` network, with gateway `172.17.0.1`
- Kamal's `kamal` network, with gateway `172.18.0.1`

The migration command launched by Kamal ran on the `kamal` network, so the correct database host was `172.18.0.1`, not `172.17.0.1`.

That was the key networking insight: test from the same network your real app uses.

## Postgres Reachability Required Three Separate Changes

Making Postgres reachable from Kamal containers required all of the following:

1. Postgres had to listen on the right addresses in `postgresql.conf`
2. `pg_hba.conf` had to allow auth from the container subnet
3. UFW had to allow traffic from the Docker/Kamal subnet to port `5432`

Missing any one of those produced a different class of failure:

- wrong bind address meant timeouts or no response
- wrong `pg_hba.conf` rule meant authentication rejection
- wrong firewall rule meant packets disappeared before Postgres even saw them

The final shape was:

- listen on `localhost`, `172.17.0.1`, and `172.18.0.1`
- allow Docker subnets in `pg_hba.conf`
- allow UFW traffic from those private subnets to the host-side Postgres listener

That setup still keeps Postgres off the public internet while making it generally usable to local containers on the machine.

## `DATABASE_URL` Is Convenient, But Only If You Respect URLs

This one was easy to underestimate.

The generated Postgres password contained reserved URL characters. That made the raw `DATABASE_URL` invalid until the password was percent-encoded.

So even after the database was up and reachable, the app still failed until the connection string was stored in proper URI form.

The practical lesson:

- `DATABASE_URL` is fine
- but passwords inside it must be URL-encoded

If I were generalizing this setup further, I would strongly consider separate env vars for:

- `DB_HOST`
- `DB_PORT`
- `DB_NAME`
- `DB_USER`
- `DB_PASSWORD`

That avoids a whole category of encoding mistakes.

## Migrations Belong Next to the Deployed App

Because the production `DATABASE_URL` points at a host address meaningful from inside the VPS container network, production migrations should run in that same environment.

So the right command was not "run the migration locally on my laptop". It was:

```bash
kamal app exec "bundle exec ruby script/migrate.rb"
```

That ensured the migration used the same image, same gems, same secrets, and same network path as the deployed application.

This turned out to be one of the cleanest decisions in the whole setup.

## Model Points as a Ledger, Not a Counter

Once persistence entered the picture, the right data model was not a `users.score` column.

Instead, the bot stores point events:

- guild id
- target user id
- actor user id
- delta
- optional reason
- timestamp

That gives several benefits immediately:

- current totals are easy to compute
- deductions are just negative deltas
- future audit/history features come for free
- scoreboard is an aggregate query, not a second source of truth

For a bot like this, append-only events are the simplest correct model.

## The Lightweight Stack Still Feels Good

By the end of the exercise, the stack was still very small:

- Ruby
- Rack
- Puma
- Sequel
- Postgres
- Kamal

That feels like a good middle ground:

- lighter than Rails
- cleaner than inventing bespoke shell-script infrastructure
- easy to deploy repeatedly
- easy to grow a little further

Most importantly, the system still fits in one person's head.

## What I'd Reuse Next Time

If I were doing this again for another small VPS-hosted side project, I would reuse the same broad pattern:

- keep the app small
- deploy with Kamal
- use one shared host-level Postgres instance
- store secrets in `pass`
- run migrations through `kamal app exec`
- test database reachability from the real Docker network, not from assumptions

The final result is not fancy, but it is solid. For this kind of project, that is exactly the point.
