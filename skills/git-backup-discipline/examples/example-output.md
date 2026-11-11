# Example: real audit output (`audit.sh ~/projects`)

What you get on day one. Three repos under `~/projects`: one enrolled and
healthy (`blog`), one enrolled but stale and with a drifted remote (`website`),
one not enrolled at all (`scratch-notes`). `audit.sh` exits **1** — any gap
fails closed, so a cron job or CI step notices.

Text report (written to `~/projects/BACKUP.gaps`, summary to stderr):

```text
audit: 3 gap(s) -> ~/projects/BACKUP.gaps
STALE-VERIFIED ~/projects/website (last=2026-09-01T02:00:00Z)
REMOTE-MISMATCH ~/projects/website (manifest=git@github.com:you/website.git origin=https://github.com/you/website-moved.git)
NO-MANIFEST ~/projects/scratch-notes
```

Same audit with `--json`, for scripts that parse instead of read:

```json
{"root":"/home/you/projects","gapCount":3,"gaps":[
 {"type":"STALE-VERIFIED","repo":"/home/you/projects/website","detail":"last=2026-09-01T02:00:00Z"},
 {"type":"REMOTE-MISMATCH","repo":"/home/you/projects/website","detail":"manifest=git@github.com:you/website.git origin=https://github.com/you/website-moved.git"},
 {"type":"NO-MANIFEST","repo":"/home/you/projects/scratch-notes"}]}
```

A clean run prints `audit: 0 gap(s)` and exits 0.

Other gap types you may see: `UNPUSHED` (local HEAD ahead of the verified
remote SHA), `UNCOMMITTED-CHANGES` (dirty worktree), `REMOTE-UNREACHABLE`
(transport/auth failure, with git's error text), `DETACHED-HEAD` (no branch
ref to verify), `UNPARSEABLE-VERIFIED` (bad `last_verified` timestamp).
