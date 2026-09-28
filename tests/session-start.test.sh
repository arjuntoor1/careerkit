#!/usr/bin/env bash
# Tests for plugin/hooks/session-start.
# Run: bash tests/session-start.test.sh
set -uo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
hook="$here/../plugin/hooks/session-start"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
failures=0

pass() { echo "ok    $1"; }
fail() { echo "FAIL  $1"; failures=$((failures + 1)); }

# 1. Not a careerkit repo: prints nothing, exits 0.
mkdir -p "$tmp/plain"
out="$(cd "$tmp/plain" && CLAUDE_PROJECT_DIR="$tmp/plain" "$hook")"; code=$?
[ "$code" -eq 0 ] && [ -z "$out" ] && pass "silent outside a careerkit repo" || fail "silent outside a careerkit repo (exit $code, output: $out)"

# 2. Marker at the project root: prints the rules and the repo-format path.
mkdir -p "$tmp/career"
touch "$tmp/career/.careerkit"
out="$(cd "$tmp/career" && CLAUDE_PROJECT_DIR="$tmp/career" "$hook")"; code=$?
[ "$code" -eq 0 ] && grep -q '^# careerkit rules' <<<"$out" && pass "prints rules in a careerkit repo" || fail "prints rules in a careerkit repo"
grep -q 'reference/repo-format.md' <<<"$out" && pass "names the repo-format reference" || fail "names the repo-format reference"

# 3. CLAUDE_PROJECT_DIR unset, session started in a subfolder: finds the marker at the git root.
mkdir -p "$tmp/gitcareer/journal/stories"
git -C "$tmp/gitcareer" init -q
touch "$tmp/gitcareer/.careerkit"
out="$(cd "$tmp/gitcareer/journal/stories" && env -u CLAUDE_PROJECT_DIR "$hook")"; code=$?
[ "$code" -eq 0 ] && grep -q '^# careerkit rules' <<<"$out" && pass "finds the marker at the git root" || fail "finds the marker at the git root"

# 4. CLAUDE_PROJECT_DIR unset, not a git repo, no marker: prints nothing, exits 0.
out="$(cd "$tmp/plain" && env -u CLAUDE_PROJECT_DIR "$hook")"; code=$?
[ "$code" -eq 0 ] && [ -z "$out" ] && pass "silent outside git with no marker" || fail "silent outside git with no marker"

echo
[ "$failures" -eq 0 ] && echo "All passed." || { echo "$failures failed."; exit 1; }
