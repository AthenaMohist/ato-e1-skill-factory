#!/usr/bin/env bash
# log_usage.sh — append one meter line: <date> <run_id> <input_tokens> <output_tokens> <verdict>
# Usage: log_usage.sh <run_id> <input_tokens> <output_tokens> [ok|breach]
set -u
RUN_ID="${1:?usage: log_usage.sh <run_id> <input> <output> [verdict]}"
IN_T="${2:?}"
OUT_T="${3:?}"
VERDICT="${4:-ok}"
case "$IN_T$OUT_T" in *[!0-9]*) echo "ERROR: token counts must be numeric (got in=$IN_T out=$OUT_T) — refusing to log garbage that would silently undercount usage" >&2; exit 1;; esac
case "$VERDICT" in ok|breach) ;; *) echo "ERROR: verdict must be ok|breach" >&2; exit 1;; esac
LOG="${TOKENS_METER_LOG:-TOKENS.log}"
TODAY=$(python3 -c "import datetime;print(datetime.date.today())" 2>/dev/null || date +%Y-%m-%d)
echo "$TODAY $RUN_ID $IN_T $OUT_T $VERDICT" >> "$LOG"
