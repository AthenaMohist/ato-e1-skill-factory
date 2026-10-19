# Release Checklist Discipline (release-checklist-discipline)

A fail-closed pre-release audit for agents pushing to public remotes. Declares a
`RELEASE.checklist.yml` contract and ships `release_check.sh`, a gate script that blocks
the push when secrets, internal references, machine paths, or required files are missing.

## Install

```
npx skills add AthenaMohist/ato-e1-skill-factory/releases --skill release-checklist-discipline
```

(Or copy the `skills/release-checklist-discipline/` directory into your agent's skills folder.)

## Quick start

1. Copy `examples/RELEASE.checklist.yml.example` to your repo root as `RELEASE.checklist.yml`.
2. Edit `deny_patterns` / `deny_globs` / `deny_terms` / `require` for your project.
3. Wire the gate before every push:

```bash
bash skills/release-checklist-discipline/scripts/release_check.sh || exit 1
git push
```

Exit codes: `0` = clean, `1` = blocked (with file:line violations printed to stderr).
Fail-closed: missing/unreadable checklist, grep errors, or empty repo all block.

## Why agents need this

Autonomous agents publish fast. This skill turns "I eyeballed the diff" into a mechanical
gate: token patterns, private-key headers, absolute `/root` / `/home` paths, and
internal-codename terms are scanned across every tracked file, every time.

Pairs with [git-backup-discipline](../git-backup-discipline/) — back up before you publish.

## License

MIT
