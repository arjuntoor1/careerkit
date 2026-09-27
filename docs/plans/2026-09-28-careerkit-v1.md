# careerkit v1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the `careerkit` Claude Code plugin (five skills, product rules, a session-start hook) in this repo, ready for its first user to install locally.

**Architecture:** The repo root is a one-plugin marketplace whose plugin lives in `plugin/`. The product is almost entirely prose. It has `rules.md` (loaded into every session in a careerkit repo by a small bash hook), `reference/repo-format.md` (the shape of a user's repo), and five `SKILL.md` files that read both. The only code is the hook, and it has a shell test.

**Tech Stack:** Claude Code plugin format (`.claude-plugin/marketplace.json`, `.claude-plugin/plugin.json`, `hooks/hooks.json`, `skills/<name>/SKILL.md`), bash, git. Checked with `claude plugin validate`.

**Spec:** `docs/specs/2026-09-27-careerkit-design.md`

## Global Constraints

- Plugin name, marketplace name and marker file: `careerkit`, `careerkit`, `.careerkit`.
- Skill names, exactly: `setup-career-repo`, `import-sources`, `log-quick-note`, `build-a-story`, `curate-into-experience`.
- The user's repo is Markdown files with a YAML header: facts in the header, the person's wording in the body, and anything not to be shared under `private:`.
- Dates are `YYYY-MM`. A current role has `end: present`. Missing facts are left out and asked about, never guessed.
- Nothing is invented. Every claim comes from the user's material, and anything ambiguous is asked about.
- Write for a prospective employer: professional, concise, best light, no inflated facts, no AI tells.
- There are no dependencies beyond bash and git. No build step.
- Skills find shared files at `../../rules.md` and `../../reference/repo-format.md`, relative to the skill's base directory.
- Per the user's decision, v1 isn't tested against a throwaway repo. The acceptance test is the author's own setup and import (Task 10).
- The GitHub home the user's repo points at is `arjuntoor1/careerkit`. It's private until published (see Task 10).

## Review Focus

Only the hook is code, so only the hook gets automated tests. For the skills, each line below is written into the owning skill as an explicit instruction, and the reviewer checks it's there.

1. **A two-column or designed PDF CV whose extracted text comes out scrambled.** Import must notice and ask for another format, not import jumbled text. (Task 5, "Collect the sources")
2. **The session starting in a subfolder of a career repo, with `CLAUDE_PROJECT_DIR` unset.** The hook should still find the marker at the git root. (Task 2, test case 3)
3. **A career repo that already has `.claude/settings.json`.** Setup merges the careerkit keys in and never overwrites the file. (Task 4, step 3)
4. **Leaking `private:` fields.** Nothing under `private:` is ever copied into body text, drafts or anything presented. (Task 2 rules, Task 8 draft checks)
5. **A note about something that happened earlier ("last Tuesday I…").** The entry is dated to the event and filed in that month's journal file, not today's. (Task 6, step 3)

---

### Task 1: Plugin skeleton and manifests

**Files:**
- Create: `.claude-plugin/marketplace.json`
- Create: `plugin/.claude-plugin/plugin.json`
- Create: `README.md`

**Interfaces:**
- Produces: marketplace `careerkit`, which lists plugin `careerkit` with source `./plugin`. The install id is `careerkit@careerkit`.

- [ ] **Step 1: Write `.claude-plugin/marketplace.json`**

```json
{
  "name": "careerkit",
  "description": "Keep your career record in git and add to it while you work, with AI help.",
  "owner": {
    "name": "Arjun Toor"
  },
  "plugins": [
    {
      "name": "careerkit",
      "description": "Keep your career record in git and add to it while you work: quick notes, stories drawn out in conversation, and curation into a record your CVs are built from.",
      "version": "0.1.0",
      "source": "./plugin"
    }
  ]
}
```

- [ ] **Step 2: Write `plugin/.claude-plugin/plugin.json`**

```json
{
  "name": "careerkit",
  "description": "Keep your career record in git and add to it while you work: quick notes, stories drawn out in conversation, and curation into a record your CVs are built from.",
  "version": "0.1.0",
  "author": {
    "name": "Arjun Toor"
  },
  "keywords": ["career", "cv", "resume", "journal", "brag-document"]
}
```

- [ ] **Step 3: Write `README.md`**

````markdown
# careerkit

A Claude Code plugin for keeping your career record in a git repo, and adding to it while
you work.

Pull in your existing CV and LinkedIn profile once to get started. From then on your repo
is the source of truth: you log wins as they happen, talk through the bigger pieces of work
with Claude, and curate them into a concise, professional record. CVs, LinkedIn and
applications get generated from that record, instead of each being kept up to date by hand.

## Install

```
/plugin marketplace add arjuntoor1/careerkit
/plugin install careerkit@careerkit
```

Then, in a new, private git repo, ask Claude to set up a career repo.

## Skills

| Skill | What it does |
|---|---|
| `setup-career-repo` | Sets up the current git repo as a career repo |
| `import-sources` | Builds your record from your existing CV, LinkedIn profile or similar, word for word |
| `log-quick-note` | Jots down something from work in a few seconds |
| `build-a-story` | A conversation that draws out the detail of a project or achievement |
| `curate-into-experience` | Turns notes and stories into entries in your record, in your voice, with your approval |

## How your repo is laid out

See [`plugin/reference/repo-format.md`](plugin/reference/repo-format.md).

## Developing

Install from a local clone with `/plugin marketplace add <path to this repo>`, or start
Claude with `--plugin-dir <path to this repo>/plugin`.

Checks:

```sh
claude plugin validate .
claude plugin validate plugin
bash tests/session-start.test.sh
```
````

- [ ] **Step 4: Validate**

Run: `claude plugin validate . && claude plugin validate plugin`
Expected: both pass. A warning that the plugin has no skills or hooks yet is fine at this point. Fix any error about the manifest fields.

- [ ] **Step 5: Commit**

```bash
git add .claude-plugin plugin/.claude-plugin README.md
git commit -m "careerkit: plugin skeleton and manifests"
```

---

### Task 2: Product rules and session-start hook

**Files:**
- Create: `plugin/rules.md`
- Create: `plugin/hooks/hooks.json`
- Create: `plugin/hooks/session-start` (executable)
- Test: `tests/session-start.test.sh`

**Interfaces:**
- Consumes: `plugin/` from Task 1.
- Produces: `rules.md`, whose first line is `# careerkit rules`. The hook prints nothing outside a careerkit repo. Inside one, it prints a line naming the absolute path of `reference/repo-format.md` (created in Task 3), then `rules.md`.

- [ ] **Step 1: Write the failing test `tests/session-start.test.sh`**

```bash
#!/usr/bin/env bash
# Tests for plugin/hooks/session-start.
# Run: bash tests/session-start.test.sh
set -uo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
hook="$here/../plugin/hooks/session-start"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
failures=0

pass() { echo "ok    $1"; }
fail() { echo "FAIL  $1"; failures=$((failures + 1)); }

# 1. Not a careerkit repo: prints nothing, exits 0.
mkdir -p "$tmp/plain"
out="$(cd "$tmp/plain" && CLAUDE_PROJECT_DIR="$tmp/plain" "$hook")"; code=$?
[ "$code" -eq 0 ] && [ -z "$out" ] && pass "silent outside a careerkit repo" || fail "silent outside a careerkit repo (exit $code, output: $out)"

# 2. Marker at the project root: prints the rules and the repo-format path.
mkdir -p "$tmp/career"
touch "$tmp/career/.careerkit"
out="$(cd "$tmp/career" && CLAUDE_PROJECT_DIR="$tmp/career" "$hook")"; code=$?
[ "$code" -eq 0 ] && grep -q '^# careerkit rules' <<<"$out" && pass "prints rules in a careerkit repo" || fail "prints rules in a careerkit repo"
grep -q 'reference/repo-format.md' <<<"$out" && pass "names the repo-format reference" || fail "names the repo-format reference"

# 3. CLAUDE_PROJECT_DIR unset, session started in a subfolder: finds the marker at the git root.
mkdir -p "$tmp/gitcareer/journal/stories"
git -C "$tmp/gitcareer" init -q
touch "$tmp/gitcareer/.careerkit"
out="$(cd "$tmp/gitcareer/journal/stories" && env -u CLAUDE_PROJECT_DIR "$hook")"; code=$?
[ "$code" -eq 0 ] && grep -q '^# careerkit rules' <<<"$out" && pass "finds the marker at the git root" || fail "finds the marker at the git root"

# 4. CLAUDE_PROJECT_DIR unset, not a git repo, no marker: prints nothing, exits 0.
out="$(cd "$tmp/plain" && env -u CLAUDE_PROJECT_DIR "$hook")"; code=$?
[ "$code" -eq 0 ] && [ -z "$out" ] && pass "silent outside git with no marker" || fail "silent outside git with no marker"

echo
[ "$failures" -eq 0 ] && echo "All passed." || { echo "$failures failed."; exit 1; }
```

- [ ] **Step 2: Run it to see it fail**

Run: `bash tests/session-start.test.sh`
Expected: every case FAILs (the hook doesn't exist yet), and the script exits 1.

- [ ] **Step 3: Write `plugin/rules.md`**

```markdown
# careerkit rules

This repo is a careerkit career repo. It holds the person's career record in git, and they
add to it while they work. It's the source of truth: CVs, LinkedIn and applications are
generated from it rather than each kept up to date by hand. The layout and file formats are
described in careerkit's `reference/repo-format.md`.

## Their words

- The person's descriptions are their wording. Don't reword, shorten or "improve" them
  unless they ask, or a careerkit skill's approved flow does it. For example,
  `curate-into-experience` drafts, and the person approves.
- Nothing is invented. Every claim comes from what the person has said or supplied. If
  something is ambiguous, ask.

## One version

- There's one version of everything. Don't keep parallel versions of the same material,
  and the record doesn't say which source a piece of text came from.
- The journal (`journal/`) holds events and raw material. The record holds the person's
  curated account of them. Material reaches the record only after it's been curated with
  the person. The exception is plain facts, like a new title, an end date or a new
  certification, which can go straight in.

## Facts

- Facts are plain fields in a file's header. If a fact isn't known, leave it out and ask.
  Don't guess.
- Anything under `private:` is for reference only. Never copy it into body text, drafts or
  anything presented.

## Writing

- Write for a prospective employer: professional, concise, and showing the person in their
  best light. Say what they did and why it mattered, then stop. Don't ramble, over-explain
  or oversell, and don't inflate facts.
- It must read as if a person wrote it, not an AI. That means no stock phrases, no
  inflated verbs ("spearheaded", "leveraged"), no tidy groups of three, no em-dash
  flourishes and no empty summarising lines.
- Follow `voice.md` for how this person writes and how much they want to write themselves.

## Boundaries

- Presentation choices stay out of the record. Display date formats, what to emphasise or
  condense, and section order belong to whatever is generated from it.
- Never edit files under `sources/`. They're the originals.
- Commit each change to the record or journal with a short message, so git holds the
  history.
```

- [ ] **Step 4: Write `plugin/hooks/session-start` and make it executable**

```bash
#!/usr/bin/env bash
# SessionStart hook: loads careerkit's rules, but only in a careerkit repo
# (one with a .careerkit file at its root). Everywhere else it prints nothing.
set -euo pipefail

plugin_root="$(cd "$(dirname "$0")/.." && pwd)"
dir="${CLAUDE_PROJECT_DIR:-$PWD}"

if [ ! -f "$dir/.careerkit" ]; then
  dir="$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null || true)"
  [ -n "$dir" ] && [ -f "$dir/.careerkit" ] || exit 0
fi

printf 'This is a careerkit career repo. The repo layout and file formats are in %s.\n\n' \
  "$plugin_root/reference/repo-format.md"
cat "$plugin_root/rules.md"
```

Run: `chmod +x plugin/hooks/session-start`

- [ ] **Step 5: Write `plugin/hooks/hooks.json`**

A SessionStart hook's standard output is added to Claude's context, so the hook needs no
JSON wrapping.

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|clear|compact",
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PLUGIN_ROOT}/hooks/session-start\""
          }
        ]
      }
    ]
  }
}
```

- [ ] **Step 6: Run the test to see it pass**

Run: `bash tests/session-start.test.sh`
Expected: five `ok` lines and `All passed.`

- [ ] **Step 7: Validate and commit**

Run: `claude plugin validate plugin`
Expected: passes. The hook is recognised.

```bash
git add plugin/rules.md plugin/hooks tests
git commit -m "careerkit: product rules and session-start hook"
```

---

### Task 3: Repo format reference

**Files:**
- Create: `plugin/reference/repo-format.md`

**Interfaces:**
- Consumes: nothing.
- Produces: the one description of a user's repo, which every skill reads. It defines the terms "the record" and "the journal", the file names, header fields, the note entry format, the story format, `voice.md` sections (`## How I write`, `## How much I want to write`) and the curated markers (`curated:` on stories, `→` lines under notes).

- [ ] **Step 1: Write `plugin/reference/repo-format.md`**

````markdown
# careerkit repo format

The shape of a careerkit career repo. Every careerkit skill follows this.

## Layout

```
.careerkit                              marks this as a careerkit repo
.claude/settings.json                   declares the careerkit plugin
README.md                               short note on what the repo is
voice.md                                how the person writes
profile.md                              ┐
looking-for.md                          │
education.md                            │ the record
certifications.md                       │
skills.md                               │
experience/<start-year>-<employer>.md   ┘
journal/<YYYY-MM>.md                    ┐ the journal
journal/stories/<slug>.md               ┘
sources/<YYYY-MM>-<name>.<ext>          original source files, never edited
```

**The record** is the person's curated career record. CVs and other presentations are
built from it. **The journal** holds raw material captured while working. It reaches the
record through `curate-into-experience`.

Record files are created when there's something to put in them, not as empty stubs. If
someone has material that fits none of these files (volunteering, talks, publications),
ask them, then add a new file at the top level following the same conventions, e.g.
`volunteering.md`.

## Conventions for all record files

- Markdown, with a YAML header between `---` lines where the file has facts.
- Facts go in the header as plain fields. The person's wording goes in the body.
- Dates are `YYYY-MM`, or `YYYY` when only the year is known. A current role or employer
  has `end: present`.
- Missing facts are left out, not guessed.
- Anything the person wants kept but never shared goes under `private:` in the header.
  A YAML comment may say why.

## profile.md

```markdown
---
name: Alex Example
location: Bristol, UK
contact:
  email: alex@example.com
  linkedin: https://www.linkedin.com/in/alexexample
headline: Senior Engineer | Payments Platforms
private:
  website: alexexample.dev  # not currently maintained
---

Summary paragraphs, in the person's words.
```

## looking-for.md

```markdown
---
titles: [Senior Engineer, Tech Lead]
employment: Full-time
locations: [Bristol, Remote]
work_arrangement: [Remote, Hybrid]
---

What they want next, in their words.
```

## experience/<start-year>-<employer>.md

There's one file per employer. The name is the start year plus the employer in lowercase
kebab-case, leaving out suffixes like "Ltd": `2010-digital-trading-creative.md`.

```markdown
---
company: Example Payments
location: Bristol, UK
work_arrangement: Hybrid
start: 2019-03
end: present
roles:
  - title: Software Engineer
    start: 2019-03
  - title: Senior Engineer
    start: 2022-01
    skills: [System Architecture, Code Review]
technologies: [Java, Kafka, AWS]
---

Text here, before the first heading, describes the whole time at the employer (optional).

## Senior Engineer

The role's description, in the person's words.

- A highlight.
- Another highlight.

## Projects

- A project, usually one to three sentences.

## Achievements

- An achievement.
```

- `roles` are listed oldest first. A role's `end` can be left out when it ends where the
  next role starts, or when the employer's `end` applies.
- `skills` on a role are skills tied to that role (LinkedIn lists these). `technologies` on
  the employer are the stack used there.
- Other facts go in the header as extra plain fields, e.g. `type: placement year`.
- There's one `## <title>` section per role that has a description or highlights. Leave out
  `## Projects` and `## Achievements` when they'd be empty.

## education.md and certifications.md

There's no header. Each entry is a `##` section with its facts as a short list.

```markdown
## University of Bristol

- qualification: BSc (Hons)
- subject: Computer Science
- grade: 2:1
- start: 2012
- end: 2015
```

## skills.md

There's no header. It's a bullet list of general skills that don't belong to one job.

## voice.md

Plain prose the person can edit. It's written by `import-sources` and read by every skill
that writes.

```markdown
# Voice

## How I write

- First person ("I lead…"), not implied ("Led…").
- Medium-length sentences; plain words over jargon.
- British spelling.
- Describes impact with outcomes and adoption rather than percentages.
- Typical phrasing: "turn business problems into system designs", "hands-on".

## How much I want to write

Draft everything and I'll edit.
```

"How much I want to write" is one of:
- **Draft everything and I'll edit.**
- **Draft, but keep close to my own words.**
- **Prompt me and I'll write it.**

## journal/<YYYY-MM>.md

Quick notes, one file per month. Each entry is dated to when the thing happened, and filed
in that month's file.

```markdown
# September 2026

## 2026-09-27 · Example Payments

Unblocked the release pipeline for the checkout squad. They'd been stuck for two days.

→ curated into experience/2019-example-payments.md on 2026-10-02
```

- The heading is the date, then `·` and the employer. Leave out `· <employer>` when the note
  isn't about an employer.
- Entries within a file are in date order.
- A line starting with `→` records what happened to the note:
  - `→ curated into <file> on <date>`
  - `→ added to <file> on <date>` (a plain fact, put straight into the record)
  - `→ in story journal/stories/<slug>.md`
  - `→ reviewed on <date>, not added`

A note with no `→` line hasn't been dealt with yet.

## journal/stories/<slug>.md

One file per story, added to over time. The slug is a short kebab-case form of the title.

```markdown
---
title: Self-service connector onboarding
employer: Example Payments
when: 2023 to 2024
curated: 2026-10-02
---

## 2026-09-28

What the person said, in their words, grouped so it reads clearly.

## 2026-11-14

What they added later.
```

- There's one `## <YYYY-MM-DD>` section per conversation. Earlier sections aren't rewritten.
- `curated:` is the date it was last curated, and is left out if it never has been. A story
  with a section dated after `curated:` has new material.

## sources/<YYYY-MM>-<name>.<ext>

These are the originals that `import-sources` read, such as `2026-09-cv.pdf` or
`2026-09-linkedin.pdf`. `YYYY-MM` is when the source was written or last updated. Pasted
text is saved as `.md`. Nothing in `sources/` is ever edited.
````

- [ ] **Step 2: Check it against the spec**

Compare it with spec section 2 ("The user's repo") and the skill descriptions in section 3. Every file, header field and marker named there should appear here with the same name. Fix any mismatch here, not in the spec.

- [ ] **Step 3: Commit**

```bash
git add plugin/reference
git commit -m "careerkit: repo format reference"
```

---

### Task 4: `setup-career-repo` skill

**Files:**
- Create: `plugin/skills/setup-career-repo/SKILL.md`

**Interfaces:**
- Consumes: `../../rules.md` and `../../reference/repo-format.md`.
- Produces: `.careerkit`, `.claude/settings.json` (marketplace `careerkit` from GitHub `arjuntoor1/careerkit`, plugin `careerkit@careerkit` enabled), `README.md` if there isn't one, and `journal/stories/.gitkeep` and `sources/.gitkeep`.

- [ ] **Step 1: Write `plugin/skills/setup-career-repo/SKILL.md`**

````markdown
---
name: setup-career-repo
description: Use when someone wants to start keeping their career record with careerkit, or asks to set up a career repo. Sets up the current git repo with the careerkit layout.
---

# Set up a career repo

This turns the current git repo into a careerkit career repo. First read `../../rules.md`
and `../../reference/repo-format.md` (relative to this skill's base directory).

## 1. Check where you are

- If `.careerkit` already exists, say this is already a career repo and stop. Suggest
  `import-sources` if there's no record yet, otherwise `log-quick-note` or
  `build-a-story`.
- If this isn't a git repo, offer to run `git init`. Don't go on without one, because the
  record's history lives in git.
- If the repo already has other files, list them and ask whether to set up alongside them.
  Don't move or delete anything.

## 2. Check the repo is private

The repo will hold contact details and original CVs, so say this is why it should be
private.

- If there's a GitHub remote and `gh` works, check with
  `gh repo view --json visibility -q .visibility`. If it's public, explain the risk and
  offer to run `gh repo edit --visibility private --accept-visibility-change-consequences`.
  Only change it if they agree.
- If there's no remote, recommend creating one as private, e.g.
  `gh repo create <name> --private --source . --push`, and leave it to them.
- If you can't tell, say so and recommend private.

## 3. Create the layout

Create only these files:

- `.careerkit`, containing:
  ```
  # Marks this repo as a careerkit career repo. See careerkit's reference/repo-format.md.
  ```
- `.claude/settings.json`, which offers the careerkit plugin to anyone who opens the repo:
  ```json
  {
    "extraKnownMarketplaces": {
      "careerkit": {
        "source": { "source": "github", "repo": "arjuntoor1/careerkit" }
      }
    },
    "enabledPlugins": {
      "careerkit@careerkit": true
    }
  }
  ```
  If `.claude/settings.json` already exists, add these two keys to it and leave everything
  else as it is. Never overwrite the file.
- `journal/stories/.gitkeep` and `sources/.gitkeep`.
- `README.md`, only if there isn't one:
  ```markdown
  # Career

  My career record, kept with [careerkit](https://github.com/arjuntoor1/careerkit). It's
  the source of truth for my experience; CVs and profiles are generated from it.
  ```

Don't create empty record files. They get created when there's something to put in them.

## 4. Commit

Show what you created. When they're happy, commit with the message
`Set up careerkit career repo`.

## 5. Say what's next

In two or three sentences:
- If they have a CV or LinkedIn profile, `import-sources` builds the record from it.
- As they work, `log-quick-note` jots things down in seconds, and `build-a-story` talks
  through bigger pieces of work.
- `curate-into-experience` turns those into their record.
````

- [ ] **Step 2: Validate**

Run: `claude plugin validate plugin`
Expected: passes, and lists `setup-career-repo`.

- [ ] **Step 3: Review against Review Focus item 3**

Check that the skill says to merge into an existing `.claude/settings.json` and never to overwrite it.

- [ ] **Step 4: Commit**

```bash
git add plugin/skills/setup-career-repo
git commit -m "careerkit: setup-career-repo skill"
```

---

### Task 5: `import-sources` skill

**Files:**
- Create: `plugin/skills/import-sources/SKILL.md`

**Interfaces:**
- Consumes: `../../rules.md`, `../../reference/repo-format.md`, and a repo with `.careerkit`.
- Produces: files in `sources/`, the record files, and `voice.md` with its `## How I write` and `## How much I want to write` sections.

- [ ] **Step 1: Write `plugin/skills/import-sources/SKILL.md`**

````markdown
---
name: import-sources
description: Use when someone wants to bring their existing CV, LinkedIn profile or similar documents into their careerkit repo, usually once to get started. Builds the record and voice.md from the sources, word for word, taking each item from exactly one source.
---

# Import sources

This builds the record from material the person already has, such as a CV, a LinkedIn
profile or a portfolio page. After this the repo is the source of truth.

First read `../../rules.md` and `../../reference/repo-format.md` (relative to this skill's
base directory).

## Before starting

- If there's no `.careerkit`, suggest `setup-career-repo` first and stop.
- If the record already has content (any of `profile.md`, `looking-for.md`,
  `education.md`, `certifications.md`, `skills.md` or `experience/`), say that import is
  meant as a one-time bootstrap and ask them to confirm they want to add more material. If
  they do, follow **Adding to an existing record** at the end.

## 1. Collect the sources

- Ask for the files, as paths, or for pasted text. For LinkedIn, suggest "Save to PDF" from
  their profile page.
- Copy each one into `sources/` as `<YYYY-MM>-<name>.<ext>`. `YYYY-MM` is when the source
  was written or last updated (ask if it's unclear), and the name is short, like `cv` or
  `linkedin`. Save pasted text as `.md`. Never edit these copies.
- Read every source in full. If a PDF's text comes out scrambled, for example because
  columns are interleaved, sidebar text is mixed into paragraphs, or words are split
  apart, say so and ask for another format, such as a Word file or the text pasted in. Don't
  import scrambled text.

## 2. Agree which source is the truth for what

- Summarise what each source covers (employers, roles, dates, education and so on), and
  where they overlap or disagree.
- Ask which source each overlapping part should come from. Suggest a default: the most
  recent source for everything it covers. Confirm the answer back as a short list, e.g.
  "CV: everything at Panaseer, and the Senior Software Engineer role at BT. LinkedIn:
  everything else."
- Nothing is merged. Each item, whether a role's description, a highlight list or a fact,
  comes from exactly one source. If the source you didn't choose has a fact the chosen one
  lacks, such as a location or an end date, ask whether to include it.

## 3. Write the record

- Create the record files as described in `repo-format.md`.
- Copy descriptions, highlights, projects and achievements **word for word** from the
  chosen source. Don't trim, reword, reorder or combine them. Repair only damage from
  extracting the text (broken hyphenation, page numbers, repeated page headers), and tell
  them what you repaired.
- Facts go in headers as plain fields. If a fact is missing or unclear, leave it out and
  add it to your list of questions.
- For anything that might be private (date of birth, an account they no longer use, a
  personal phone number), ask whether it belongs under `private:`.
- Skills listed against a role go on that role's `skills`. A general skills section goes in
  `skills.md`.
- If a source has something that fits no file (interests, volunteering, references), ask
  whether to keep it and where. Don't drop it silently.

## 4. Write voice.md

- Read the person's own writing in the sources. Skip text they didn't write, such as
  endorsements or recommendations.
- Under `## How I write`, describe how they write: first person or implied subject,
  sentence length, typical words and phrases, British or American spelling, how they
  describe impact, and anything distinctive. Quote short examples.
- Ask how much they want to write themselves, and record the answer under
  `## How much I want to write` as one of the three options in `repo-format.md`.

## 5. Check and commit

- Go through what you created, file by file, and resolve your list of questions one at a
  time.
- Suggest they skim each experience file against its source.
- When they're happy, commit with the message `Import sources: <names>`.

## Adding to an existing record

Follow the same steps, but first compare the new material with the existing record.

- Things that aren't in the record yet, such as a new role or certification, are added as
  above.
- Anything that overlaps existing content, such as the same role worded differently,
  becomes a question: keep what's there, or replace it with the new source's version.
  Never merge the two yourself, and never keep both.
- Don't rewrite `voice.md`. Offer to update it if the new source shows something new about
  how they write.
````

- [ ] **Step 2: Validate**

Run: `claude plugin validate plugin`
Expected: passes, and lists `import-sources`.

- [ ] **Step 3: Review against Review Focus item 1**

Check that the skill tells the AI to notice scrambled PDF text and ask for another format.

- [ ] **Step 4: Commit**

```bash
git add plugin/skills/import-sources
git commit -m "careerkit: import-sources skill"
```

---

### Task 6: `log-quick-note` skill

**Files:**
- Create: `plugin/skills/log-quick-note/SKILL.md`

**Interfaces:**
- Consumes: `../../rules.md` and `../../reference/repo-format.md` (the journal section).
- Produces: entries in `journal/<YYYY-MM>.md`. For plain facts, header updates in the record plus a `→ added to <file> on <date>` line.

- [ ] **Step 1: Write `plugin/skills/log-quick-note/SKILL.md`**

````markdown
---
name: log-quick-note
description: Use when someone in a careerkit repo wants to jot down something from work quickly, like a win, some feedback, something they shipped or learned, without a long conversation. Also handles plain facts for the record, like a new title, a leaving date or a new certification.
---

# Log a quick note

This is for fast capture. The person is busy, so get it down in their words and let them
get back to work. The whole exchange should take a minute or two.

First read `../../rules.md` and the journal section of `../../reference/repo-format.md`
(relative to this skill's base directory).

## Steps

1. **Take the note as they gave it.** If they haven't given it yet, ask what happened.

2. **Ask at most one follow-up question**, and only if something that will matter later is
   missing and quick to answer. Usually that's which employer, or a number they obviously
   know. If the note stands on its own, don't ask anything.

3. **Write it** to the journal, in their words, fixing only obvious typos.
   - Date the entry to when it happened. If they say "last Tuesday" or "in August", use
     that date, not today's. If it's vague, use the nearest date they'd recognise and
     don't ask.
   - Put it in `journal/<YYYY-MM>.md` for the month it happened. If that file doesn't
     exist, create it with a `# <Month YYYY>` heading.
   - Use the heading `## <YYYY-MM-DD> · <Employer>`, leaving out `· <Employer>` if it isn't
     about an employer. Keep entries in date order.

4. **Is it a plain fact for the record?** That means a new title or promotion, a start or
   end date, a new employer, a certification or qualification, a change of location or
   contact details, or a change in what they're looking for. If it is, log the note
   anyway, then ask: "That's a fact for your record. Shall I update `<file>` now?" If they
   say yes, update the header directly and add
   `→ added to <file> on <YYYY-MM-DD>` under the note. For a new employer, create
   `experience/<start-year>-<employer>.md` with just the header.

5. **Is it the start of something bigger?** If it sounds like a project or result they'll
   want to write up properly, mention once that `build-a-story` can draw it out, now or
   later. Don't push.

6. **Commit** straight away with the message `Note: <a few words>`. Don't ask first, since
   quick capture has to stay quick and git can undo it.
````

- [ ] **Step 2: Validate**

Run: `claude plugin validate plugin`
Expected: passes, and lists `log-quick-note`.

- [ ] **Step 3: Review against Review Focus item 5**

Check that the skill dates the entry to when it happened and files it in that month.

- [ ] **Step 4: Commit**

```bash
git add plugin/skills/log-quick-note
git commit -m "careerkit: log-quick-note skill"
```

---

### Task 7: `build-a-story` skill

**Files:**
- Create: `plugin/skills/build-a-story/SKILL.md`

**Interfaces:**
- Consumes: `../../rules.md`, `../../reference/repo-format.md` (the stories and journal sections), and `voice.md`.
- Produces: `journal/stories/<slug>.md` with a header (`title`, `employer`, `when`) and one `## <YYYY-MM-DD>` section per conversation. Journal notes that fed in get a `→ in story journal/stories/<slug>.md` line.

- [ ] **Step 1: Write `plugin/skills/build-a-story/SKILL.md`**

````markdown
---
name: build-a-story
description: Use when someone in a careerkit repo wants to properly write up a project, achievement or piece of work, e.g. "I want to capture the collector project" or "help me write up what I did on X". A conversation that draws out the detail in their words, ready to curate into their record later. Also use to add to an existing story.
---

# Build a story

You're on their side. They want to record this, so it matters to them. Your job is to help
them get all of it out, because the detail is what later becomes a strong professional
achievement. This isn't an interview, and they aren't being assessed.

First read `../../rules.md`, the stories and journal sections of
`../../reference/repo-format.md` (relative to this skill's base directory), and `voice.md`.

## Start

- Check `journal/stories/` for an existing story on this. If there is one, read it and
  pick up from there, e.g. "Last time we covered the design; what's happened since?"
- Check the journal for notes that look related, and offer to start from them.
- Ask them to tell you about it in their own way first, and let them talk.

## Draw it out

Ask guiding questions, one at a time, and follow what they say rather than working through
a list. More is more: detail is easy to cut later and hard to recover. Areas worth drawing
out, if they haven't come up already:

- **The problem.** Why it mattered, who for, and what it was costing.
- **Their part.** What they personally did, decided or pushed for, and who else was
  involved.
- **The hard parts.** Constraints, trade-offs, and what they had to work out or persuade
  people of.
- **What changed.** Outcomes, adoption, time or money saved, risk reduced.
- **Evidence.** Numbers, feedback, who noticed, and what it led to.
- **Scale.** The size of the team, the systems, the customers.

If they say "we", ask what their own part was. It's what an employer wants to see, and
people undersell it. If they're vague about impact, ask for a number or an example, but
accept "don't know". If they're underselling something, say so plainly.

Keep going while there's more to draw out. Before you wrap up, ask whether there's anything
else. Stop whenever they want to.

## Write it down

- Save it to `journal/stories/<slug>.md`, using a short kebab-case slug from the title. For
  a new story, the header has `title`, `employer` and `when`, with no `curated:`.
- Add a `## <YYYY-MM-DD>` section for today's conversation with what they told you, in
  their words. Organise it so it reads clearly: group related points, and add short
  headings if they help. Don't polish, summarise or reword it. Keep every number, name and
  specific. If an answer only makes sense alongside its question, add a short lead-in.
- For an existing story, add a new dated section and leave earlier ones as they are.
- Under each journal note that fed in, add `→ in story journal/stories/<slug>.md`.
- Show them what you wrote, and fix anything they correct.
- Commit with the message `Story: <title>`.
- Offer `curate-into-experience`, now or later.
````

- [ ] **Step 2: Validate**

Run: `claude plugin validate plugin`
Expected: passes, and lists `build-a-story`.

- [ ] **Step 3: Commit**

```bash
git add plugin/skills/build-a-story
git commit -m "careerkit: build-a-story skill"
```

---

### Task 8: `curate-into-experience` skill

**Files:**
- Create: `plugin/skills/curate-into-experience/SKILL.md`

**Interfaces:**
- Consumes: `../../rules.md`, `../../reference/repo-format.md`, `voice.md` ("How much I want to write"), stories (`curated:`, dated sections), and notes (`→` lines).
- Produces: record entries. On stories it sets `curated: <YYYY-MM-DD>`. Under notes it adds `→ curated into <file> on <date>` or `→ reviewed on <date>, not added`.

- [ ] **Step 1: Write `plugin/skills/curate-into-experience/SKILL.md`**

````markdown
---
name: curate-into-experience
description: Use when someone in a careerkit repo wants to turn their journal notes or stories into their career record, e.g. "add the collector story to my experience" or "curate my notes from this quarter". Drafts record entries in their voice from their own material, and writes nothing without their approval.
---

# Curate into experience

This turns journal material into the person's record. It's where raw material becomes the
concise, professional entries that CVs are built from.

First read `../../rules.md`, `../../reference/repo-format.md` (relative to this skill's
base directory), and `voice.md`.

## 1. Pick the material

- If they named a story or notes, use those.
- Otherwise, list what hasn't been curated: stories with no `curated:` date or with a
  section dated after it, and notes with no `→` line. Let them choose.
- Read the material, and the part of the record it belongs to.

## 2. Decide what it becomes

Propose briefly where it goes, and let them agree or change it:

- a new project or achievement under the employer
- a highlight on a role
- an update to an existing entry, e.g. a project that now has adoption numbers
- a fact in a header, such as a technology or a title
- nothing, because not everything belongs in the record

Several notes can become one entry, and one story can become several.

## 3. Draft

- How much you draft depends on "How much I want to write" in `voice.md`, unless they ask
  for something different now:
  - **Draft everything and I'll edit.** Write the entry.
  - **Draft, but keep close to my own words.** Build the entry mostly from their own
    sentences, joined lightly.
  - **Prompt me and I'll write it.** List what the entry should cover and let them write
    it. Help only if they ask.
- Write in their voice. Match `voice.md` and reuse their phrasing wherever it works.
- Write for a prospective employer: what they did and why it mattered, concisely. A project
  or achievement is usually one to three sentences, and a highlight is usually one.
- **Nothing is invented.** Every claim, whether numbers, scope, their role or outcomes,
  comes from the material. If the material is ambiguous (was it their decision or the
  team's? is "half our customers" still true?), ask before drafting that part.
- Nothing under `private:` goes into a draft.
- When updating an existing entry, show it before and after. The existing wording is
  theirs, so change only what the new material needs.
- Before showing a draft, check it against the writing rules in `rules.md`: no inflated
  facts, no stock phrases, no inflated verbs, no tidy groups of three, no em-dash
  flourishes, no empty summarising lines.

## 4. Approve and write

- Show each draft and say where it will go. They edit, approve or reject each one. Keep
  going until they approve.
- Write the approved entries into the record. Nothing is written without their approval.
- Mark the material:
  - on a story, set `curated: <YYYY-MM-DD>` in its header
  - under each note that was used, add `→ curated into <file> on <YYYY-MM-DD>`
  - under each note they decided not to add, add `→ reviewed on <YYYY-MM-DD>, not added`
- Commit with the message `Curate: <what>`.
````

- [ ] **Step 2: Validate**

Run: `claude plugin validate plugin`
Expected: passes, and lists `curate-into-experience`.

- [ ] **Step 3: Review against Review Focus item 4**

Check that the skill forbids `private:` material in drafts, and that `rules.md` forbids it everywhere.

- [ ] **Step 4: Commit**

```bash
git add plugin/skills/curate-into-experience
git commit -m "careerkit: curate-into-experience skill"
```

---

### Task 9: Whole-plugin check and local install

**Files:**
- Modify: whichever files the checks below find problems in.

**Interfaces:**
- Consumes: everything from Tasks 1–8.
- Produces: a plugin that validates strictly and can be installed from the local folder.

- [ ] **Step 1: Strict validation**

Run: `claude plugin validate --strict . && claude plugin validate --strict plugin`
Expected: no errors or warnings. Fix anything reported, e.g. missing metadata.

- [ ] **Step 2: Inventory**

Run: `claude plugin details plugin` (if that fails with a path, install it first as in Step 4, then run `claude plugin details careerkit`).
Expected: five skills with the exact names from Global Constraints, one SessionStart hook, and a reasonable token cost.

- [ ] **Step 3: Hook test**

Run: `bash tests/session-start.test.sh`
Expected: `All passed.`

- [ ] **Step 4: Cross-check names and paths**

Run: `grep -rn "repo-format.md\|rules.md\|careerkit@careerkit\|\.careerkit" plugin`
Expected: every skill reads `../../rules.md` and `../../reference/repo-format.md`, and every mention of the plugin id, marker and file names matches Global Constraints.

- [ ] **Step 5: Commit any fixes**

```bash
git add -A
git commit -m "careerkit: fixes from whole-plugin check"
```

(Skip this if nothing changed.)

---

### Task 10: Acceptance, which is the author's own setup (done with the user)

This task is interactive and needs the user's CV and LinkedIn files. It happens in the
user's data repo, `arjuntoor1/career` (`~/git/arjuntoor1/career`), not in this repo. It
replaces that repo's current contents, so every step waits for the user.

- [ ] **Step 1: Merge the implementation branch** into `main` in this repo through a PR.

- [ ] **Step 2: Install from the local clone.** In the career repo, run `/plugin marketplace add ~/git/arjuntoor1/careerkit`, then `/plugin install careerkit@careerkit`, then restart Claude Code.

- [ ] **Step 3: Check the declared marketplace.** `setup-career-repo` writes a `.claude/settings.json` that points at `arjuntoor1/careerkit`. That repo exists but is private until published. Check whether Claude Code can fetch it using the user's git credentials, and report what happens. If it can't, the user decides between publishing first and relying on the local install for now.

- [ ] **Step 4: Run `setup-career-repo`** in the career repo. Expect it to list the existing files (`me.yaml`, `styles/`, `cvs/` and others) and ask before going on.

- [ ] **Step 5: Run `import-sources`** with the latest CV and a LinkedIn export. The CV is the truth for everything at Panaseer and the Senior Software Engineer role at BT, and LinkedIn for the rest. **Pass condition:** the imported text matches the chosen source word for word. Any failure is fixed in the plugin and the import re-run, not fixed by hand-editing the data.

- [ ] **Step 6: Log one quick note, build one story, and curate it** into the record.

- [ ] **Step 7: Retire the old design, with the user's go-ahead.** Remove `me.yaml`, `styles/` and `cvs/`. Update this repo's `CLAUDE.md` and `README.md` to describe it as a careerkit repo, so the old `me.yaml` conventions don't carry over. Update the saved memory note `career-repo-keep-it-simple` to match.
