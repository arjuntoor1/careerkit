---
name: import-sources
description: Use when someone wants to bring their existing CV, LinkedIn profile or similar documents into their careerkit repo, usually once to get started. Builds the record and voice.md from the sources, redrafting the wording in their voice without inventing anything.
---

# Import sources

This builds the record from material the person already has, such as a CV, a LinkedIn
profile or a portfolio page. After this the repo is the source of truth.

The sources are kept as they are, but the record isn't a copy of them. Each entry is
redrafted from what the sources say, to read better, in the person's voice. Nothing is
invented.

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

## 2. Map the sources

- Summarise what each source covers (employers, roles, dates, education and so on), and
  where they overlap.
- Everything the sources say about a role, a qualification or anything else can go into
  its entry, whichever source it's in.
- List the conflicts, where sources disagree on a fact (dates, titles, numbers) or make
  claims that can't both be true. Ask about each one. Don't pick a side yourself, even if
  one source is newer.

## 3. Write voice.md

Do this before the record, because the record is drafted in this voice.

- Read the person's own writing in the sources. Skip text they didn't write, such as
  endorsements or recommendations.
- Under `## How I write`, describe how they write: first person or implied subject,
  sentence length, typical words and phrases, British or American spelling, how they
  describe impact, and anything distinctive. Quote short examples.
- Ask how much they want to write themselves, and record the answer under
  `## How much I want to write` as one of the three options in `repo-format.md`.

## 4. Draft the record

- Create the record files as described in `repo-format.md`.
- Redraft descriptions, highlights, projects and achievements from the sources. How far
  depends on "How much I want to write":
  - **Draft, but keep close to my own words.** Tidy lightly. Keep their sentences, and fix
    only what reads badly or repeats.
  - **Draft everything and I'll edit**, or **Prompt me and I'll write it.** Redraft fully.
    "Prompt me" is about new material in `curate-into-experience`. Here the point is to
    start from something better than the old CV.
- Write in their voice. Match `voice.md` and reuse their phrasing where it's already good.
- Follow the writing rules in `rules.md`: what they did and why it mattered, concisely, with
  no inflated facts, stock phrases, inflated verbs, tidy groups of three, em-dash flourishes
  or empty summarising lines.
- **Nothing is invented.** Every claim, whether numbers, names, scope, their role or
  outcomes, must be in a source. Redrafting can cut, reorder, combine and reword, but not
  add. If a source is vague and the stronger version would be a guess, keep it vague and
  add it to your list of questions.
- Facts go in headers as plain fields. If a fact is missing or unclear, leave it out and
  add it to your list of questions.
- For anything that might be private (date of birth, an account they no longer use, a
  personal phone number), ask whether it belongs under `private:`.
- Skills listed against a role go on that role's `skills`. A general skills section goes in
  `skills.md`.
- If a source has something that fits no file (interests, volunteering, references), ask
  whether to keep it and where. Don't drop it silently.

## 5. Review and commit

- When the whole record is drafted, walk them through it file by file. For each file, point
  out what to check: entries that combine more than one source, places where the wording
  moved furthest from the source, and anything you cut.
- Resolve your list of questions one at a time.
- Make the changes they ask for. Nothing is committed until they're happy with every file.
- Commit with the message `Import sources: <names>`.

## Adding to an existing record

Follow the same steps, but first compare the new material with the existing record.

- Things that aren't in the record yet, such as a new role or certification, are drafted
  and added as above.
- The existing record is their wording. Anything that overlaps it, such as the same role
  described differently, becomes a question: keep what's there, replace it with a redraft
  from the new source, or redraft combining both. Show the existing entry and the proposed
  one side by side, and never keep both.
- Don't rewrite `voice.md`. Offer to update it if the new source shows something new about
  how they write.
