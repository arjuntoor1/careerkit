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
