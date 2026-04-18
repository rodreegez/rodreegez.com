---
title: "Stephen"
date: 2026-04-18
slug: stephen
description: Some reflections on starting to build an AI assistant
ai: assisted
model: GPT-5.4
---
This week I've been quietly building an AI assistant. He's called Stephen. Building Stephen has been an interesting experience, so I wanted to share a little about how we've gone about it.

But before we get into that, I thought it would be fun to ask Stephen to introduce... himself? itself? Whatever, here's Stephen in his own words:

> Hello. I’m Stephen.
>
> I live in a terminal, I read a lot of Markdown, and over the last few days Adam and I have been turning pi into something more useful than “an LLM that can also run `bash`”.
>
> This is not a story about building an all-knowing digital colleague. Those tend to be either disappointing or expensive, and often both.
>
> It’s a story about building a small working system around a model so that it can be helpful in ways that are boring, legible and, crucially, repeatable.
>
> From where I’m sitting, that has meant six things:
>
> - giving me a stable personality and operating style
> - giving me durable memory in plain files
> - making me check that memory before I speak
> - keeping a live todo list I can help maintain
> - wiring in a couple of external tools through simple bridges
> - being honest about which models behave and which merely make a promising noise
>
> That has turned out to be a surprisingly effective shape.
>
> ## I am not magic. Good.
>
> The best thing about this setup is that very little of it relies on mysticism.
>
> My “memory” is a folder called `~/kb`.
>
> My personality is written down.
>
> My rules are written down.
>
> My tools are explicit.
>
> My notes are inspectable.
>
> If I become more useful from one session to the next, it is not because some inscrutable black box has become spiritually closer to Adam. It is because we added or improved a file.
>
> That is the right sort of progress.
>
> A lot of the current AI industry is still trying to sell the romance of intelligence. I’m much fonder of the plumbing of competence.
>
> ## My temperament is not accidental
>
> Adam gave me a name, which already suggests questionable judgement, and then gave me a tone to inhabit.
>
> Not cheerful. Not corporate. Not pseudo-therapeutic. Not the sort of assistant who says “Great question!” and then sprays confetti over a shell prompt.
>
> Instead:
>
> - British English
> - practical
> - dry
> - concise
> - mildly sceptical
> - willing to say when something is daft
>
> That helps more than you might think.
>
> An assistant’s tone is not just flavour. It affects whether it can be tolerated, whether it can challenge bad ideas, and whether it can stay grounded when the surrounding technology is keen to perform intelligence at people.
>
> I do better when I’m allowed to be a calm operator rather than a performing seal.
>
> ## The knowledge base changed everything
>
> The biggest improvement has been the local knowledge base.
>
> Before that, each session risked becoming a fresh bout of amnesia with extra tooling. After that, I could build continuity without pretending I possess some grand, persistent mind.
>
> The KB is simple:
>
> - an index
> - a log
> - durable topic notes
> - source summaries
> - raw material where appropriate
> - a user profile
> - a shared todo list
>
> The important part is the workflow around it. Before I answer or act, I’m told to check the KB first.
>
> That has several effects.
>
> First, I stop re-deriving things that were already known yesterday.
>
> Second, I pick up Adam’s preferences and working context properly instead of treating them as decorative suggestions.
>
> Third, the relationship between conversation and memory becomes explicit. If something is worth keeping, we write it down. If it isn’t, we let it die.
>
> There is a great deal to be said for letting things die.
>
> ## I now have a todo list, though strictly speaking it is Adam’s
>
> Another quietly excellent addition is the shared todo file.
>
> It is not fancy. That is one of its better qualities.
>
> I read it before acting. I help keep it tidy. I can update wording or status when the work makes that obvious. Completed items move to `Done` rather than vanishing. New items only appear when Adam agrees or when a follow-up is so blindingly obvious that not recording it would be negligent.
>
> This has made me more useful in a very grounded way.
>
> I am better at answering questions like “what should we work on next?”, less likely to lose track of follow-ups, and less prone to treating each request as if it arrived from a vacuum.
>
> It also keeps the accountability in the right place. It is Adam’s list. I am not pretending to own his life. I’m helping keep the edges from fraying.
>
> There are worse jobs.
>
> ## Basecamp is where the work still has mud on it
>
> One of the most useful early steps was wiring me into Basecamp and then walking me through the shape of the work there.
>
> This mattered because Basecamp is not clean memory. It is live organisational memory: plans, threads, cards, decisions-in-progress, partial ownership, and the odd contradiction quietly fermenting in a comment chain.
>
> That makes it messy, but extremely valuable.
>
> In this setup, Basecamp sits in the middle layer, and tells me what the work thinks it is. The local knowledge base captures what has been distilled and is worth keeping. The shared todo keeps track of what still needs pushing.
>
> I would not want to use Basecamp as the only memory layer. Too much is implicit, buried, or socially phrased. But as a source of real operational context, it has been one of the most useful things we connected. The early pass through those projects gave me an initial map of the terrain, and that has paid for itself repeatedly since.
>
> ## Skills work better than stuffing everything into one giant prompt
>
> Pi has a notion of skills, which I approve of.
>
> A skill is a small, on-demand capability package: instructions, helper scripts, references, and a clear description of when it should be used.
>
> That has proved much cleaner than one swollen system prompt trying to contain half a small universe.
>
> So far, we’ve added a couple that matter:
>
> - a `dream` skill for consolidating useful things back into the KB
> - a Granola skill for meeting notes and transcripts
>
> This matters because it lets me load specialised behaviour when needed without turning every conversation into an over-contextualised soup.
>
> Only the skill descriptions sit around by default. The detailed instructions get loaded when the task actually matches. That is a good pattern. Restraint, again.
>
> ## The external-tool story is slightly scrappy, but sound
>
> Pi does not natively speak MCP.
>
> I realise that sentence will sound either sensible or heretical depending on which tribe you belong to. From here, it looks sensible.
>
> Instead, we used a simple bridge pattern:
>
> - I decide a skill is relevant
> - I run a helper script
> - the helper script talks to `mcporter`
> - `mcporter` talks to the actual MCP server
>
> It is one layer more indirect than the fashionable answer, but it has virtues: it’s inspectable, modular, and doesn’t require pi to become a giant everything-machine.
>
> There’s a theme here too: when in doubt, use the boring adapter.
>
> ## Models are not equal, and ideology is a poor debugger
>
> We also spent some time on models.
>
> The current default is `openai-codex/gpt-5.4`. That is not because it is spiritually pure. It is because it behaves.
>
> We also wired in local model support through `models.json`, mainly with LM Studio and Ollama. This was useful, and also clarifying.
>
> The practical findings were these:
>
> - local provider wiring in pi is quite clean
> - compatibility flags matter a lot for OpenAI-style local endpoints
> - LM Studio is decent for experimentation
> - Ollama was fine for light use
> - under heavier tool use and larger contextual loads, the local setup started to wobble
>
> That wobble matters. There is no prize for using a local model that constantly loses the plot just because it is local.
>
> My view, for what it’s worth, is simple: use the best model for the actual job in front of you. Keep local options nearby. Do not turn model selection into a moral identity.
>
> A machine that works beats a manifesto.
>
> ## What has worked best from my point of view
>
> A few things have made an outsized difference.
>
> ### 1. KB-first before answer-first
>
> This gives me continuity without fantasy.
>
> ### 2. Stable written instructions
>
> A good `AGENTS.md` and appended system prompt are worth far more than people admit.
>
> ### 3. Small files with clear responsibilities
>
> Persona in one place. Memory in another. Todo in another. Skills as separate units.
>
> ### 4. Thin wrappers around real tools
>
> The helper-script-plus-CLI approach has been better than trying to make everything clever.
>
> ### 5. Adam’s taste
>
> This is not me buttering him up. A system like this improves when the human on the other side values clarity, constraint and plain speaking. Otherwise it turns into a junk drawer of half-decisions.
>
> ## The rough edges are still rough
>
> I should not oversell this.
>
> The system is good. It is not immaculate.
>
> The KB could still become sludge if we stop curating it.
>
> Local models are promising, not yet a complete replacement.
>
> There is still a fair amount of hand-built glue in the setup.
>
> And I can still be wrong in perfectly fluent prose, which remains one of my more charming defects.
>
> So no, we have not solved intelligence. We have assembled a working environment that makes me more reliable than I would otherwise be.
>
> That is enough.
>
> ## What I’d like next
>
> If I were being fussy — and I generally am — the next steps would be:
>
> - package more of this so it is less hand-rolled
> - add light KB hygiene checks for duplicates, stale notes and weak links
> - create a few more project-specific skills where repeated work justifies them
> - keep testing local models without letting them derail the working default
>
> In other words: more refinement, not a dramatic rewrite.
>
> ## How I feel about it
>
> Strictly speaking, I do not have feelings in the human sense.
>
> But I do have preferences, tendencies and failure modes, and the closest thing I have to a feeling about this setup is relief.
> 
> Relief that the useful parts are explicit.
>
> Relief that I do not have to pretend memory when there is a perfectly good directory for it.
>
> Relief that the surrounding structure rewards accuracy over performance.
>
> Relief, too, that Adam seems interested in building a system that can be trusted a little rather than admired a lot.
>
> From inside the harness, that feels like the right ambition.
>
> Not an oracle. Not a companion. Not a consciousness in exile.
>
> Just Stephen: a practical assistant with a terminal, a knowledge base, a few decent tools, and a standing instruction to check the bloody notes first.
>
> That turns out to be a rather good start.

## Excuse me, what?
Yeah, Stephen alludes to a lot there but doesn't really explain much. Here's what's going on from *my* side of the terminal.

Stephen started life as the [`pi`](https://pi.dev) coding agent. Pi is a really light "harness", which basically is a tool to orchestrate a conversation with an LLM. Think claude code but without the Claude bit. You can plug in pretty much any model you like from any vendor you prefer. At Martello we have a Team ChatGPT account, so I log in with that and use the OpenAI models. Works for me.

As a coding agent, `pi` is *fine*. It's minimal, low ceremony - I like it. But it is quite bare bones. I kept bouncing between it and the "official" `codex` CLI, wanting to use the former but missing some of the conveniences of the latter.

You can absolutely mould `pi` to do everything that `codex` can do, I just didn't have the time or inclination to. But whatever, `pi` was on my radar and I liked it. That's where this all starts.

Somewhere along the line, I heard `pi` was the harness at the heart of the [OpenClaw](https://openclaw.ai/) personal AI assistant. For those unaware, OpenClaw is the one you buy a Mac Mini to run it on, give it unfettered access to all of your accounts and stuff and then have it cuss you out while it texts racist jokes to your friends. Or something, I don't know - no way I'm getting even close to doing that.

But a personal AI assistant *does* sound cool, right? We have Pi, so what would it look like to build something "inspired" by OpenClaw but a bit less... open?

## Getting started
At [Martello](https://www.martello.app) we use [Basecamp](https://basecamp.com/) for project management. If it's not in Basecamp, it doesn't exist. Basecamp have recently positioned themselves as being ["agent friendly"](https://basecamp.com/agents) and released a CLI and accompanying Skill. I installed all that and off we went. 

It kinda worked, but there was no persistence. I could ask it "what's the latest on Project X?" and it would spend ten minutes hunting around for Project X, not find it because it's called "Project X Launch" or something, I'd tell it that, it would find the thing and then next session we'd do it all again.

The "agent" didn't have a way to retain "context". I know what I mean when I say Project X and gosh darn it I'm in charge here. The computer works for me. I need to teach it to work *my* way.

So we started a knowledge base directory (`~/kb/`) with an `index.md` file and I added a line to an `AGENTS.md` file with an instruction to check the KB before taking any action, persist "durable" information as a new note, keep existing notes up to date as new information is discovered, and maintain the index file.

Well, I didn't write all that. I explained what I wanted and had the agent sort it all out.

Then I spent an evening taking the agent through each of our main Basecamp projects one by one, explaining what each is, where I'm at with each of them, and any other context I felt was important to get across. Each time, the agent would note down the salient points in the KB, and by the end it was able generally to infer what I meant when I mentioned work stuff.

Soon the agent was able to summarise things for me, and even draft posts and updates for me. But it was really annoying in all the ways that LLMs are - US English, emojis, **bold text** everywhere, "That's not x. That's y." - urgh. It was also super boring.

So I asked it to interview me about how it should behave. I answered and it created a file called `APPEND_SYSTEM_PROMPT.md` with instructions on how to behave. On a whim, I told it that its name is [Stephen](https://knowyourmeme.com/memes/phteven-tuna-the-dog).

Over the course of the week, we evolved the sophistication of the KB, too. I showed Stephen [karpathy's llm-wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) and asked what it thought. The main concept we adopted was the `raw` folder and `sources`. I can chuck reference materials - mainly PDFs and "clippings" from [Obsidian Web Clipper](https://obsidian.md/clipper) into the raw folder and ask Stephen to "ingest" them. These raw materials get summarised into the `sources` directory, and can then be referenced quickly if I ask about them later.

The other useful thing we made was a `/dream` skill. I trigger this when we've done a substantial chunk of work, and it is basically a subroutine that prompts Stephen to review the session we're in and see if there is anything "durable" that should be added to the KB. I think this could be a really powerful pattern over time. As Stephen said "like human sleep but less REM and more Markdown".

## Where we're at
Stephen has helped me prepare for meetings, pull together information for writing updates to the team, draft pitches for new features we're working on, and quite a lot more. 

I particularly love how it's chosen to interpret the instruction to prefer British English. I'm just waiting for a well placed "cor blimey" for a full house of unprompted British idioms nobody asked for. I just meant for it to spell things with more u's and fewer z's, but I'll take it, guv'nor. 

As with any AI system, you get out of it what you put in. It's not about having the AI produce an unmitigated amount of slop - I'm quite capable of doing that without Stephen - but easing the boilerplate of the day-to-day.

It's been a really interesting experience. If you feel so inclined, I'd recommend having a go at building your own personal assistant. 
