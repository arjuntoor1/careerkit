# careerkit: design

## Purpose

An open-source Claude Code plugin that helps people keep their career record in a git
repo and add to it *while they work*. AI makes recording a project, achievement or
fact cheap enough to do on the day it happens, instead of reconstructing everything when
job hunting.

Existing material (a CV, a LinkedIn profile) is pulled in once to get started. From then
on the repo is the source of truth, and CVs, LinkedIn and applications are generated
from it rather than each being kept up to date by hand. It becomes a companion that
people keep current as they go.

The first user is the author. Their own repo is set up and imported with the plugin, and
that is the acceptance test.

## Two things, kept apart

- **The product**: the `careerkit` plugin. It holds skills, product rules and a hook. It
  lives in its own repo, `arjuntoor1/careerkit`, which stays private until it's ready to
  publish.
- **The user's data**: a private repo per person (e.g. `my-career`). It holds only their
  data, never plugin code.

## 1. The plugin

```
careerkit/
├── .claude-plugin/marketplace.json     marketplace listing this one plugin
└── plugin/
    ├── .claude-plugin/plugin.json
    ├── rules.md                        product rules, same for every user
    ├── hooks/                          session-start hook
    └── skills/
        ├── setup-career-repo/SKILL.md
        ├── import-sources/SKILL.md
        ├── log-quick-note/SKILL.md
        ├── build-a-story/SKILL.md
        └── curate-into-experience/SKILL.md
```

**Distribution.** Publishing means pushing the public repo. Users install with
`/plugin marketplace add <owner>/careerkit` then `/plugin install careerkit@careerkit`,
and get updates when it's pushed. It can be submitted to Anthropic's official plugin
directory later. During development it's used from the local folder.

**Loading the rules.** The session-start hook injects `rules.md` only when the project
root contains a `.careerkit` marker file. Installing the plugin machine-wide stays silent
in other repos.

**Other AI tools.** Skills use the open `SKILL.md` format. The packaging and hook are
Claude Code only in v1. `rules.md` is written so it could be pasted into an `AGENTS.md`
by hand.

## 2. The user's repo

```
.careerkit                              marker file
.claude/settings.json                   declares the careerkit marketplace and plugin
voice.md
profile.md
looking-for.md
education.md
certifications.md
skills.md
experience/<start-year>-<employer>.md   e.g. 2018-panaseer.md
journal/<YYYY-MM>.md                    quick notes
journal/stories/<slug>.md               one file per story
sources/<YYYY-MM>-<name>.<ext>          original source files, never edited
```

The repo should be private, because it holds contact details and original CVs.

**File format.** Markdown with a YAML header. Facts go in the header as plain fields. The
person's wording goes in the body. Anything that shouldn't appear in presented material
goes under a `private:` group in the header.

| File | Header | Body |
|---|---|---|
| `profile.md` | name, location, contact, headline, `private:` | summary |
| `looking-for.md` | titles, employment, locations, work arrangement | what they want next |
| `experience/…` | company, location, work arrangement, start, end, roles (title, start, end), technologies | see below |
| `education.md`, `certifications.md` | — | one `##` section per entry, with facts as a short list |
| `skills.md` | — | general skills not tied to one job |

An **experience file** body goes like this. Text before the first heading describes the
whole time at that employer. Each role then gets a `## <title>` section with its
description and highlights, followed by `## Projects` and `## Achievements`. There's one
file per employer, because projects and achievements usually belong to the employer
rather than to one title. The start year in the file name keeps the folder in date order.
The real dates are in the header.

Dates are `YYYY-MM`. A current role has `end: present`. Missing facts are left out, not
guessed.

## 3. How material flows

```
sources/ ──import-sources──▶ record (profile, experience, …) + voice.md

while working:
  log-quick-note ──▶ journal/YYYY-MM.md ─┐
  build-a-story  ──▶ journal/stories/  ──┴─curate-into-experience──▶ record
  log-quick-note (plain fact) ──────────────────────────────────────▶ record
```

Only material that has been through curation reaches the record. Journal material is
events, and the record is the person's summary of them, so the two aren't parallel
versions.

### Skills

**`setup-career-repo`.** Sets up a repo that has no careerkit files yet. It writes the
marker, `.claude/settings.json` and the empty folder layout. It checks the GitHub repo is
private (or recommends it, if there's no remote) and says why.

**`import-sources`.** Meant as a one-time bootstrap. If the record already has content,
it says so and asks for confirmation before going ahead. When forced like this, it adds
new material and asks about anything that overlaps the existing record, rather than
merging on its own.
- The user supplies the source files, which are copied into `sources/` unchanged.
- It writes `voice.md` from the sources first, so the record can be drafted in that voice.
- Each entry is redrafted from everything the sources say about it, to read better than
  the old CV. Nothing is invented: redrafting can cut, reorder, combine and reword, but
  every claim must be in a source. How far it redrafts follows `voice.md`.
- Where sources conflict (dates, titles, numbers), the user is asked. Anything else
  unclear is asked about, not guessed.
- The user reviews the whole drafted record, file by file, before it's committed.

**`log-quick-note`.** Saves a short dated entry to `journal/YYYY-MM.md` in the user's
words, with at most one follow-up question. Entries look like `## 2026-09-27 · Panaseer`
followed by the note. If the note is a plain fact for the record (a new title, an end
date, a new certification), it offers to update the record directly.

**`build-a-story`.** A 1-to-1 conversation where the AI is on the user's side. The
user wants to record this, so it probably matters to them, and the AI's job is to help
them get it all out. It asks guiding questions that draw out the best material. For
example, it might ask what the problem was, what they personally did, what changed
because of it, and anything that shows the impact. It follows the user's lead instead of
working through a checklist. More is more: it captures detail generously in the user's
words, because curation will later turn it into a strong professional achievement. It
creates or extends `journal/stories/<slug>.md`, and can start from earlier notes. The header holds the
title, employer, rough dates and `curated:` (date last curated, or absent). Stories are
added to over time, and they double as interview answers.

**`curate-into-experience`.** Turns a story, or several notes, into record entries, such
as a project, a highlight or a description update.
- It drafts in the user's voice (`voice.md`), keeping their phrasing wherever possible.
- Nothing is invented. Every claim comes from the user's material, and anything
  ambiguous is asked about rather than guessed.
- The user edits and approves before anything is written. How much the AI drafts
  depends on `voice.md` and can be changed in the moment.
- After writing, it marks the source material as curated: the `curated:` date on a
  story, and a line under a note.

## 4. Wording

**`rules.md`** (product, every user):
- The user's descriptions are their wording. Don't reword, shorten or "improve" them
  unless they ask or a skill's approved flow does it.
- One version of everything. There are no parallel versions, and the record doesn't say
  which source a piece of text came from.
- Facts are plain fields. Unknowns are left out and asked about.
- Write for a prospective employer: professional, concise, and showing the person in
  their best light. Say what they did and why it mattered, then stop. Don't ramble,
  over-explain or oversell, and don't inflate facts.
- It must read as if a person wrote it, not an AI. That means no stock phrases, inflated
  verbs ("spearheaded", "leveraged"), tidy groups of three, em-dash flourishes or empty
  summarising lines.
- Layout stays out of the record.
- Don't edit files under `sources/`.

**`voice.md`** (per user, plain prose they can edit). It's written by `import-sources`
from their raw material. It covers sentence length, whether they write in the first
person ("I lead…") or without it ("Led…"), the words they typically use, and British or
American spelling. It also records how much they want to write themselves, from "draft
everything and I'll edit" to "prompt me, I'll write it". Every skill that writes reads
it.

## 5. Out of v1

- CV styles and building CVs (`styles/`, `cvs/`).
- Automatically merging new material with what's already in the record.
- Reminders about stale material.
- Interview prep and prospective-employer research.
- Packaging for tools other than Claude Code.

The layout leaves room for all of these. They'd be new skills and folders, not changes
to the record format.

## 6. Acceptance

There's no separate test harness in v1. The test is the author's own use:

1. Run `setup-career-repo` on the author's data repo (`arjuntoor1/career`), replacing its current
   `me.yaml`, `styles/` and `cvs/`.
2. Run `import-sources` with the latest CV and a LinkedIn export. Every claim in the
   imported record can be traced to one of the sources, conflicts between them were asked
   about, and the redrafted wording reads better than the old CV.
3. Record one quick note and build one story, then curate it into the record.

Anything that goes wrong is fixed in the plugin, not by hand-editing the data.
