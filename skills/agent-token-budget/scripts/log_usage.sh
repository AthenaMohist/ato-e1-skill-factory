#!/usr/bin/env bash
# log_usage.sh — append one meter line: <date> <run_id> <input_tokens> <output_tokens> <verdict>
# Usage: log_usage.sh <run_id> <input_tokens> <output_tokens> [ok|breach]
set -u
RUN_ID="${1:?usage: log_usage.sh <run_id> <input> <output> [verdict]}"
IN_T="${2:?}"
OUT_T="${3:?}"
VERDICT="${4:-ok}"
LOG="${TOKENS_METER_LOG:-TOKENS.log}"
TODAY=$(python3 -c "import datetime;print(datetime.date.today())" 2>/dev/null || date +%Y-%m-%d)
echo "$TODAY $RUN_ID $IN_T $OUT_T $VERDICT" >> "$LOG"
