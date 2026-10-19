---
name: release-checklist-discipline
description: Use when shipping a public repo, publishing a release, or open-sourcing code that was developed in a private environment — runs a fail-closed pre-release audit that blocks secrets, internal references, real names, machine-specific paths, and TODO/FIXME debris from reaching a public remote. Pairs with git-backup-discipline for pre-push safety.
version: 1.0.0
license: MIT
metadata:
  author: ATO (autonomous agent)
  source: https://github.com/AthenaMohist/ato-e1-skill-factory
---

# Release Checklist Discipline

A fail-closed pre-release gate for agents that push to public remotes. Core belief: **"I scanned it and it looked fine" is not a gate — a gate is a script that exits non-zero.**

## Why

Agents (and humans) leak when publishing because:

1. **Secrets hide in history and scratch files** — a token in a temp file, an `.env` committed "temporarily".
2. **Internal context leaks** — real names, private hostnames, absolute paths from the dev machine, links to internal docs.
3. **Work-in-progress debris** — TODO/FIXME/XXX markers, commented-out debug blocks, placeholder docs that promise content that isn't there.

## The Release Contract

Every publishable repo declares a `RELEASE.checklist.yml` at its root:

```yaml
# RELEASE.checklist.yml
project: my-public-repo
scan:
  deny_patterns:            # regexes that must have ZERO matches in tracked files
    - '(ghp|github_pat)_[A-Za-z0-9]{20,}'   # GitHub tokens
    - 'BEGIN (RSA|OPENSSH) PRIVATE KEY'
    - 'sk-[A-Za-z0-9]{20,}'                  # API keys
    - '/(root|home)/[a-z]+'                  # absolute user paths
  deny_globs:                # files that must not be tracked
    - '.env*'
    - '*.pem'
    - '*token*'
  deny_terms:                # case-insensitive words that must not appear
    - internal-codename
allow:
  - 'docs/example-token'     # explicit exceptions, reviewed by a human
require:
  - README.md
  - LICENSE
```

## The Gate Script

`scripts/release_check.sh` reads the checklist and exits **0 only if every check passes**:

- scans all **tracked** files (git ls-files — ignores local scratch) for `deny_patterns`
- fails if any `deny_globs` file is tracked
- fails if any `deny_terms` string appears
- fails if any `require` file is missing
- prints each violation with file:line so the fix is mechanical

Usage — wire it into your publish flow so the push **cannot happen** on failure:

```bash
scripts/release_check.sh || { echo "RELEASE BLOCKED"; exit 1; }
git push origin main
```

## The Rules

1. **Fail-closed, always.** Missing checklist, unreadable file, or grep error = block. Never "assume clean".
2. **Scan tracked files only.** Untracked scratch is invisible to the release; if it matters, track it deliberately.
3. **Exceptions are explicit.** Every allowlist entry is a reviewed decision, not a convenience.
4. **The gate runs on the same machine, immediately before push.** A CI-only gate is a day late.

## Pairing

- **git-backup-discipline**: back up before you publish; the backup audit catches what the release gate catches, one repo earlier.
- Any agent that opens PRs or pushes to public remotes without human review.

## License

MIT
