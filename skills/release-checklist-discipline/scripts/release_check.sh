#!/usr/bin/env bash
# release_check.sh — fail-closed pre-release gate.
# Reads RELEASE.checklist.yml (path via $1 or ./RELEASE.checklist.yml) and exits 0
# only if every check passes. Missing checklist / unreadable file / grep error = block.
set -u

CHECKLIST="${1:-RELEASE.checklist.yml}"

fail() { echo "RELEASE BLOCKED: $*" >&2; exit 1; }

[ -f "$CHECKLIST" ] || fail "no checklist found: $CHECKLIST"
[ -r "$CHECKLIST" ] || fail "checklist unreadable: $CHECKLIST"

command -v git >/dev/null || fail "git not available"
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || fail "not inside a git work tree"
git ls-files >/dev/null || fail "git ls-files failed"
[ -n "$(git ls-files)" ] || fail "no tracked files — nothing to release?"

viol=0

# --- collect checklist fields with a tiny flat-list parser ---
python3 - "$CHECKLIST" <<'PYEOF' > "$$.fields" || fail "checklist parse failed"
import sys, re
text = open(sys.argv[1]).read()
stack = []  # (indent, section-name)
for raw in text.splitlines():
    line = raw.split('#', 1)[0].rstrip()
    if not line.strip():
        continue
    indent = len(line) - len(line.lstrip())
    m = re.match(r'^(\w+):\s*$', line.strip())
    if m:
        while stack and stack[-1][0] >= indent:
            stack.pop()
        stack.append((indent, m.group(1)))
        continue
    m = re.match(r'^-\s+(.+)$', line.strip())
    if m and stack:
        val = m.group(1).strip().strip("'\"")
        print(f"{stack[-1][1]}\t{val}")
PYEOF
[ -s "$$.fields" ] || fail "checklist has no parsable entries"

ALLOWED="$(awk -F'\t' '$1=="allow"{print $2}' "$$.fields")"
# scan target = tracked files minus the checklist itself minus allow-listed paths
SCAN_TARGETS="$(git ls-files | grep -vxF "$CHECKLIST" | grep -vxF -f <(printf '%s\n' "$ALLOWED" | grep -v '^$') 2>/dev/null)"
[ -n "$SCAN_TARGETS" ] || SCAN_TARGETS="/dev/null"

while IFS=$'\t' read -r key value; do
  case "$key" in
    deny_patterns)
      # grep each scan target individually (per-file rc semantics, no xargs aggregation traps)
      hits=$(printf '%s\n' "$SCAN_TARGETS" | while IFS= read -r f; do grep -nE -- "$value" "$f" 2>/dev/null | sed "s|^|$f:|"; done)
      if [ -n "$hits" ]; then
        echo "VIOLATION deny_pattern [$value]:" >&2; echo "$hits" >&2; viol=1
      fi
      ;;
    deny_globs)
      hits=$(git ls-files | grep -E "^$value\$" 2>/dev/null); rc=$?
      [ "$rc" -le 1 ] || fail "grep error on glob: $value"
      if [ -n "$hits" ]; then
        echo "VIOLATION deny_glob [$value]: tracked file(s)" >&2; echo "$hits" >&2; viol=1
      fi
      ;;
    deny_terms)
      hits=$(printf '%s\n' "$SCAN_TARGETS" | while IFS= read -r f; do grep -niF -- "$value" "$f" 2>/dev/null | sed "s|^|$f:|"; done)
      if [ -n "$hits" ]; then
        echo "VIOLATION deny_term [$value]:" >&2; echo "$hits" >&2; viol=1
      fi
      ;;
    require)
      git ls-files | grep -qxF "$value" || { echo "VIOLATION require: missing $value" >&2; viol=1; }
      ;;
  esac
done < "$$.fields"
rm -f "$$.fields"

[ "$viol" -eq 0 ] || fail "violations above — fix before pushing"

echo "RELEASE OK: all checklist checks passed ($(git ls-files | wc -l) tracked files scanned)"
exit 0
