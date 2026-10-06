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

Apart from `voice.md` in step 4, create only these files:

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

## 4. Set their voice

Offer the voice quiz in `../../reference/voice-quiz.md`: a few quick questions about how
they like to write, which every skill that drafts for them follows. If they'd rather skip
it, `voice.md` gets written later by `import-sources` or `curate-into-experience`.

If they take it, run it as that file describes and write `voice.md`.

## 5. Commit

Show what you created. When they're happy, commit with the message
`Set up careerkit career repo`.

## 6. Say what's next

In two or three sentences:
- If they have a CV or LinkedIn profile, `import-sources` builds the record from it.
- As they work, `log-quick-note` jots things down in seconds, and `build-a-story` talks
  through bigger pieces of work.
- `curate-into-experience` turns those into their record.
