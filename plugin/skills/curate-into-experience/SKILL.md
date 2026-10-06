---
name: curate-into-experience
description: Use when someone in a careerkit repo wants to turn their journal notes or stories into their career record, e.g. "add the collector story to my experience" or "curate my notes from this quarter". Drafts record entries in their voice from their own material, and writes nothing without their approval.
---

# Curate into experience

This turns journal material into the person's record. It's where raw material becomes the
concise, professional entries that CVs are built from.

First read `../../rules.md`, `../../reference/repo-format.md` (relative to this skill's
base directory), and `voice.md`.

If there's no `voice.md` (for example, they skipped the quiz at setup and never imported a
CV), run the quiz in `../../reference/voice-quiz.md` and write `voice.md` from it. If they'd
rather not, ask only how much they want to write themselves, using the three options in
`repo-format.md`, and offer to create `voice.md` with just that answer.

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
