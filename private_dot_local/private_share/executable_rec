#!/usr/bin/env bash
set -euo pipefail

DIR="$HOME/Videos/Recordings"
mkdir -p "$DIR"

# If already recording -> stop
if pgrep -x wf-recorder >/dev/null; then
  pkill -INT wf-recorder
  notify-send "Recording stopped"
  exit 0
fi

TS="$(date +%Y-%m-%d_%H-%M-%S)"
OUT="$DIR/rec_$TS.mp4"

# Select region, then record
GEOM="$(slurp)"
wf-recorder -g "$GEOM" -f "$OUT" & disown

# Copy path immediately (reliable)
printf "%s" "$OUT" | wl-copy
notify-send "Recording started" "Saved to: $OUT (path copied)"

