# Real example output

Captured from actual `release_check.sh` runs against a fixture repo
(one commit: `README.md`, `LICENSE`, and the example `RELEASE.checklist.yml`
copied from `examples/`; the dirty repo adds a seeded fake token, `.env`,
`server.pem`, `docs/notes.md`, and no `LICENSE`). Nothing here is
hand-written prose — every output line below is verbatim script output.

## Scenario 1 — clean repo (exit 0)

`$ release_check.sh`

```
RELEASE OK: all checklist checks passed (3 tracked files scanned)
```

All checks pass, so the push is allowed to proceed.

## Scenario 2 — dirty repo (exit 1, blocked)

`$ release_check.sh` — the fixture README seeds a **fake** GitHub token
(`ghp_Ab…ef12` is the script's own masking, not a real credential), tracks
`.env` and `server.pem`, hides the term `internal-codename` in docs, and
omits the required `LICENSE`:

```
VIOLATION deny_pattern [(ghp|github_pat)_[A-Za-z0-9]{20,}]:
README.md:1:token ghp_Abcdef1234567890Abcdef12 here
VIOLATION deny_glob [.env*]: tracked file(s)
.env
VIOLATION deny_glob [*.pem]: tracked file(s)
server.pem
VIOLATION deny_term [internal-codename]:
docs/notes.md:1:contact internal-codename
VIOLATION require: missing LICENSE
RELEASE BLOCKED: violations above — fix before pushing
```

Exit 1, push blocked, with file:line citations for every violation.

## Scenario 3 — no checklist (exit 1, fail-closed)

`$ release_check.sh` in a repo with no `RELEASE.checklist.yml`:

```
RELEASE BLOCKED: no checklist found: RELEASE.checklist.yml
```

A missing contract never means "skip the gate" — it blocks.

## Scenario 4 — empty repo (exit 1, fail-closed)

`$ release_check.sh` in a fresh git repo with a checklist but no commits:

```
RELEASE BLOCKED: no tracked files — nothing to release?
```

## Exit-code summary

| Scenario | Exit | Meaning |
|----------|------|---------|
| Clean repo | 0 | push allowed |
| Dirty repo | 1 | blocked, violations printed with file:line |
| Missing checklist | 1 | fail-closed — the gate never silently passes |
| Empty repo | 1 | fail-closed |
