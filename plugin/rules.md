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
