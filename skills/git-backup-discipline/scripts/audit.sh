#!/usr/bin/env bash
# audit.sh — fail-closed coverage audit over a directory of git repos.
# exit 0 = clean; exit 1 = gaps found (regenerated in <dir>/BACKUP.gaps)
# usage: bash audit.sh /path/to/repos-dir [--json]
#   --json : machine-readable JSON to stdout (root/gapCount/gaps[]); human line still to BACKUP.gaps
#            for cron/CI consumers that want structured results without parsing text
set -uo pipefail
JSON=0
ARGS=()
for a in "$@"; do
  if [ "$a" = "--json" ]; then JSON=1; else ARGS+=("$a"); fi
done
[ ${#ARGS[@]} -gt 0 ] || { echo "usage: audit.sh /path/to/repos-dir [--json]" >&2; exit 2; }
ROOT="${ARGS[0]}"
OUT="$ROOT/BACKUP.gaps"
: > "$OUT"
NOW=$(date +%s)
GAPS=0
JSON_GAPS=""
gap() { # gap TYPE REPO [DETAIL]
  echo "$1 $2${3:+ ($3)}" >> "$OUT"
  GAPS=$((GAPS+1))
  local jd=""
  if [ -n "${3:-}" ]; then
    jd=${3//\\/\\\\}; jd=${jd//\"/\\\"}
    jd=",\"detail\":\"$jd\""
  fi
  JSON_GAPS="${JSON_GAPS:+$JSON_GAPS,}{\"type\":\"$1\",\"repo\":\"$2\"$jd}"
}
# portable ISO8601 -> epoch (GNU date -d / BSD date -j -f / python3 fallback)
iso_to_epoch() {
  if date -u -d "$1" +%s >/dev/null 2>&1; then
    date -u -d "$1" +%s
  elif date -j -u -f "%Y-%m-%dT%H:%M:%S" "${1%%.*}" +%s >/dev/null 2>&1; then
    date -j -u -f "%Y-%m-%dT%H:%M:%S" "${1%%.*}" +%s
  elif command -v python3 >/dev/null 2>&1; then
    python3 -c "import datetime,sys;print(int(datetime.datetime.fromisoformat(sys.argv[1].replace('Z','+00:00')).timestamp()))" "$1" 2>/dev/null || echo 0
  else
    echo 0
  fi
}
# portable repo discovery: BSD find lacks -printf/-print0 on -type d negation,
# so walk with a depth-limited glob-style loop and emit NUL-separated repo roots.
list_repos() {
  if find "$ROOT" -maxdepth 0 >/dev/null 2>&1 && find /dev/null -printf '' >/dev/null 2>&1; then
    # .git may be a dir (normal repo) or a file (linked worktree / submodule)
    find "$ROOT" -maxdepth 3 \( -name .git -type d -o -name .git -type f \) -printf '%h\0' 2>/dev/null
  else
    # portable fallback (BSD/macOS find): walk the tree, emit NUL-separated repo roots
    python3 - "$ROOT" <<'PYEOF'
import os, sys
root = sys.argv[1]
out = []
for dirpath, dirnames, filenames in os.walk(root):
    if dirpath != root and ('.git' in dirnames or '.git' in filenames):
        out.append(dirpath)
    dirnames[:] = [d for d in dirnames if d != '.git']
for p in out:
    sys.stdout.write(p + '\0')
PYEOF
  fi
}
while IFS= read -r -d '' repo; do
  if [ ! -f "$repo/BACKUP.manifest.yml" ]; then
    gap NO-MANIFEST "$repo"; continue
  fi
  BRANCH=$(git -C "$repo" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "?")
  HEAD_SHA=$(git -C "$repo" rev-parse HEAD 2>/dev/null || echo "?")
  REMOTE_SHA=$(git -C "$repo" ls-remote origin -h "refs/heads/$BRANCH" 2>/dev/null | cut -f1)
  if [ -z "$REMOTE_SHA" ]; then
    gap NO-REMOTE-STATE "$repo" "branch=$BRANCH"
  elif [ "$REMOTE_SHA" != "$HEAD_SHA" ]; then
    gap UNPUSHED "$repo" "head=${HEAD_SHA:0:7} remote=${REMOTE_SHA:0:7}"
  fi
  if [ -n "$(git -C "$repo" status --porcelain 2>/dev/null)" ]; then
    gap UNCOMMITTED-CHANGES "$repo"
  fi
  LV=$(sed -n 's/^last_verified:[[:space:]]*//p' "$repo/BACKUP.manifest.yml" 2>/dev/null | head -1)
  # strip surrounding quotes (yaml allows quoted scalars; unquoted parsing would false-positive UNPARSEABLE)
  LV=${LV%\"}; LV=${LV#\"}; LV=${LV%\'}; LV=${LV#\'}
  LV=${LV:-never}
  if [ "$LV" = "never" ]; then
    gap NEVER-VERIFIED "$repo"
  else
    LV_EPOCH=$(iso_to_epoch "$LV")
    if [ "$LV_EPOCH" -le 0 ]; then
      gap UNPARSEABLE-VERIFIED "$repo" "last=$LV"
    elif [ $((NOW - LV_EPOCH)) -gt $((7*86400)) ]; then
      gap STALE-VERIFIED "$repo" "last=$LV"
    fi
  fi
done < <(list_repos)
if [ "$JSON" -eq 1 ]; then
  printf '{"root":"%s","gapCount":%d,"gaps":[%s]}\n' "$ROOT" "$GAPS" "$JSON_GAPS"
else
  echo "audit: $GAPS gap(s) -> $OUT"
fi
[ "$GAPS" -eq 0 ]
