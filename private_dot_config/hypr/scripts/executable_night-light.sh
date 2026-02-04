#!/usr/bin/env bash
set -euo pipefail

# pick ONE:
CMD_WLSUNSET=(wlsunset -t 3400 -g 0.90)   # warmer temp, slight dim
CMD_GAMMASTEP=(gammastep -O 3400)         # set temp immediately

if pgrep -x wlsunset >/dev/null; then
  pkill -x wlsunset
  exit 0
fi

if pgrep -x gammastep >/dev/null; then
  pkill -x gammastep
  exit 0
fi

# prefer wlsunset if installed, otherwise gammastep
if command -v wlsunset >/dev/null; then
  "${CMD_WLSUNSET[@]}" &
elif command -v gammastep >/dev/null; then
  "${CMD_GAMMASTEP[@]}" &
else
  echo "Install wlsunset or gammastep first." >&2
  exit 1
fi

