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

Plain prose the person can edit. It's written from the voice quiz
(`reference/voice-quiz.md`), usually during `setup-career-repo`, and filled out by
`import-sources` from their own writing. Every skill that writes reads it.

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
