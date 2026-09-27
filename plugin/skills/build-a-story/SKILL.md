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
