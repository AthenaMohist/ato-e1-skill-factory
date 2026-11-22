#!/usr/bin/env bash
# log_usage.sh — append one meter line: <date> <run_id> <input_tokens> <output_tokens> <verdict>
# Usage: log_usage.sh <run_id> <input_tokens> <output_tokens> [ok|breach]
# After appending, auto-triggers rotation when the log reaches TOKENS_ROTATE_LINES
# (default 5000): the meter is archived to <log>.1 and a fresh log starts. A meter
# tool that relies on the consumer remembering to run rotate_meter.sh will never
# rotate in practice — enforcement belongs at the write path, not the docs.
set -u
# Meter log path resolution must match budget_check.sh (the reader): config
# `meter_log` > env > TOKENS.log. A writer that ignores the config writes to a
# different file than the reader checks — usage is silently undercounted.
cfg_meter_log() {
  [ -f "TOKENS.budget.yml" ] || return 0
  sed -n "s/^[[:space:]]*meter_log:[[:space:]]*//p" TOKENS.budget.yml | head -1 | sed 's/[[:space:]]*#.*//' | tr -d '[:space:]'
}
RUN_ID="${1:?usage: log_usage.sh <run_id> <input> <output> [verdict]}"
IN_T="${2:?}"
OUT_T="${3:?}"
VERDICT="${4:-ok}"
case "$IN_T$OUT_T" in *[!0-9]*) echo "ERROR: token counts must be numeric (got in=$IN_T out=$OUT_T) — refusing to log garbage that would silently undercount usage" >&2; exit 1;; esac
case "$VERDICT" in ok|breach) ;; *) echo "ERROR: verdict must be ok|breach" >&2; exit 1;; esac
LOG="${TOKENS_METER_LOG:-TOKENS.log}"
ML=$(cfg_meter_log); [ -n "$ML" ] && LOG="$ML"
TODAY=$(python3 -c "import datetime;print(datetime.date.today())" 2>/dev/null || date +%Y-%m-%d)
echo "$TODAY $RUN_ID $IN_T $OUT_T $VERDICT" >> "$LOG"
MAX="${TOKENS_ROTATE_LINES:-5000}"
case "$MAX" in ''|*[!0-9]*) echo "ERROR: TOKENS_ROTATE_LINES must be numeric (got '$MAX')" >&2; exit 1;; esac
if [ "$(wc -l < "$LOG")" -ge "$MAX" ]; then
  # Merge into the archive instead of overwriting it: mv -f would silently
  # destroy the previous archive, including any of today's meter lines in it
  # (a second rotation within one day is exactly the case budget_check.sh
  # reads the archive to cover). Oldest lines stay first.
  if [ -f "$LOG.1" ]; then
    cat "$LOG.1" "$LOG" > "$LOG.1.tmp" && mv -f "$LOG.1.tmp" "$LOG.1"
  else
    mv -f "$LOG" "$LOG.1"
  fi
  : > "$LOG"
  # The merged archive grows without bound: every rotation appends the whole
  # current log to <log>.1, so after months the archive holds ALL history and
  # budget_check.sh greps the full file again — rotation stops capping meter
  # IO. Old-period lines are never counted anyway (they are filtered by
  # TODAY), so pruning outside the keep window is zero-semantics-loss.
  prune_archive() {
    local PLOG="$1"
    [ -f "$PLOG.1" ] || return 0
    local KEEP="${TOKENS_ARCHIVE_KEEP_DAYS:-7}"
    case "$KEEP" in ''|*[!0-9]|0) echo "ERROR: TOKENS_ARCHIVE_KEEP_DAYS must be numeric >=1 (got '$KEEP')" >&2; return 1;; esac
    local CUTOFF
    CUTOFF=$(python3 -c "import datetime;print(datetime.date.today()-datetime.timedelta(days=$KEEP-1))" 2>/dev/null \
      || date -d "$((KEEP-1)) days ago" +%Y-%m-%d 2>/dev/null \
      || date -v-"$((KEEP-1))"d +%Y-%m-%d 2>/dev/null) || { echo "WARN: cannot compute cutoff — archive left unpruned" >&2; return 0; }
    local TMPF
    TMPF=$(mktemp "${PLOG}.1.prune.XXXXXX") || return 0
    awk -v cut="$CUTOFF" 'substr($1,1,10) >= cut' "$PLOG.1" > "$TMPF" && mv -f "$TMPF" "$PLOG.1" || { rm -f "$TMPF"; echo "WARN: archive prune failed — archive left unpruned" >&2; return 0; }
  }
  prune_archive "$LOG" || exit 1
  echo "rotated: $((MAX))+ lines -> $LOG.1 (merged, fresh $LOG started)" >&2
fi
