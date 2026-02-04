#!/usr/bin/env bash
set -euo pipefail

DIR="$HOME/Videos/Recordings"

if pgrep -x wf-recorder >/dev/null; then
  pkill -INT wf-recorder
  sleep 0.5
fi

LATEST="$(ls -t "$DIR"/*.mp4 2>/dev/null | head -n 1 || true)"
if [[ -z "${LATEST}" ]]; then
  notify-send "No recording found" "$DIR"
  exit 0
fi

# Copy as "file" (URI list). Many apps treat this like copying a file in a file manager.
printf "file://%s\n" "$LATEST" | wl-copy --type text/uri-list

notify-send "Recording stopped" "Copied file for pasting/upload: $(basename "$LATEST")"

