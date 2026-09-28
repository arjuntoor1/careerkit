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
