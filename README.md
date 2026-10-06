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
| `import-sources` | Builds your record from your existing CV, LinkedIn profile or similar, redrafted in your voice |
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
