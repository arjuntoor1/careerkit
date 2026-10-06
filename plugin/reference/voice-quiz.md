# Voice quiz

A short quiz that writes `voice.md` from the person's own choices. Skills that create
`voice.md` run it.

## How to run it

- Say what it's for in one line: their record will be drafted in the style they pick, and
  they can change `voice.md` any time.
- Ask one question at a time. Use a multiple-choice question tool if you have one, with each
  option's example shown as its preview. Otherwise list the options with their examples and
  ask them to pick.
- Every option rewrites the same example achievement, so they compare like for like. Use
  the examples below as they are.
- They can always answer in their own words, or say they have no preference. A "no
  preference" answer leaves that point out of `voice.md`.
- If the skill running the quiz has their writing to hand (a CV, say), mark the option
  closest to it as "(closest to your CV)", or whatever the source is. Don't pre-select it.

## The example

All examples describe one achievement: they rebuilt a squad's release pipeline, build
times fell from 40 minutes to 8, the squad went from weekly to daily releases, and it ran
on GitHub Actions and Docker.

## The questions

### 1. Person

- **First person:** "I rebuilt the release pipeline for the checkout squad, so they could
  release daily instead of weekly."
- **Implied subject:** "Rebuilt the release pipeline for the checkout squad, so they could
  release daily instead of weekly."
- **Mixed:** first person in summaries and role descriptions, implied subject in bullets.
  "I lead the platform team's delivery work." / "Rebuilt the release pipeline for the
  checkout squad."

### 2. Length and detail

- **Short:** "Rebuilt the checkout squad's release pipeline, cutting builds from 40 minutes
  to 8."
- **Fuller, with the why:** "Rebuilt the checkout squad's release pipeline. Slow builds had
  them batching changes into a weekly release, and with builds down from 40 minutes to 8
  they now release daily."

### 3. Impact

- **Numbers:** "Cut build times by 80% and moved the squad from weekly to daily releases."
- **Outcomes and adoption:** "The squad now releases the same day a change is approved, and
  two other squads have moved onto the same pipeline."
- **Whatever the material has:** numbers when there are numbers, outcomes otherwise.

### 4. Tone

- **Understated:** "Rebuilt the release pipeline, which let the squad move to daily
  releases."
- **Confident:** "Rebuilt the release pipeline and moved the squad to daily releases."

### 5. Spelling

- **British:** "containerised", "organisation", "programme".
- **American:** "containerized", "organization", "program".

### 6. Technologies

- **Inline, in brackets:** "Rebuilt the release pipeline (GitHub Actions, Docker)."
- **Kept high-level:** "Rebuilt the release pipeline." The stack goes in the header's
  `technologies` only.
- **Named in the sentence:** "Rebuilt the release pipeline on GitHub Actions, with
  containerised builds in Docker."

### 7. How much they want to write

The three options in `repo-format.md`:

- **Draft everything and I'll edit.**
- **Draft, but keep close to my own words.**
- **Prompt me and I'll write it.**

### 8. Words and phrases (open, optional)

"Any words or phrases you like using, or never want to see?" Skip it if they have nothing.

## Writing voice.md

- Each answer to questions 1 to 6 becomes one bullet under `## How I write`, with the
  chosen example quoted, e.g. `- Implied subject in bullets: "Rebuilt the release
  pipeline…"`. An answer in their own words is recorded in their words.
- Question 7 goes under `## How much I want to write`, as one of the three options.
- Question 8 becomes a bullet under `## How I write`, e.g. `- Never "passionate" or
  "synergy".`
- Show the file before writing it.
