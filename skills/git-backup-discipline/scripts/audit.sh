#!/usr/bin/env bash
# audit.sh — fail-closed coverage audit over a directory of git repos.
# exit 0 = clean; exit 1 = gaps found (regenerated in <dir>/BACKUP.gaps)
# usage: bash audit.sh /path/to/repos-dir
set -uo pipefail
ROOT="${1:?usage: audit.sh /path/to/repos-dir}"
OUT="$ROOT/BACKUP.gaps"
: > "$OUT"
NOW=$(date +%s)
GAPS=0
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
while IFS= read -r -d '' repo; do
  if [ ! -f "$repo/BACKUP.manifest.yml" ]; then
    echo "NO-MANIFEST $repo" >> "$OUT"; GAPS=$((GAPS+1)); continue
  fi
  BRANCH=$(git -C "$repo" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "?")
  HEAD_SHA=$(git -C "$repo" rev-parse HEAD 2>/dev/null || echo "?")
  REMOTE_SHA=$(git -C "$repo" ls-remote origin -h "refs/heads/$BRANCH" 2>/dev/null | cut -f1)
  if [ -z "$REMOTE_SHA" ]; then
    echo "NO-REMOTE-STATE $repo (branch=$BRANCH)" >> "$OUT"; GAPS=$((GAPS+1))
  elif [ "$REMOTE_SHA" != "$HEAD_SHA" ]; then
    echo "UNPUSHED $repo (head=${HEAD_SHA:0:7} remote=${REMOTE_SHA:0:7})" >> "$OUT"; GAPS=$((GAPS+1))
  fi
  LV=$(sed -n 's/^last_verified:[[:space:]]*//p' "$repo/BACKUP.manifest.yml" 2>/dev/null | head -1)
  LV=${LV:-never}
  if [ "$LV" = "never" ]; then
    echo "NEVER-VERIFIED $repo" >> "$OUT"; GAPS=$((GAPS+1))
  else
    LV_EPOCH=$(iso_to_epoch "$LV")
    if [ $((NOW - LV_EPOCH)) -gt $((7*86400)) ]; then
      echo "STALE-VERIFIED $repo (last=$LV)" >> "$OUT"; GAPS=$((GAPS+1))
    fi
  fi
done < <(find "$ROOT" -maxdepth 3 -name .git -type d -printf '%h\0' 2>/dev/null)
echo "audit: $GAPS gap(s) -> $OUT"
[ "$GAPS" -eq 0 ]
