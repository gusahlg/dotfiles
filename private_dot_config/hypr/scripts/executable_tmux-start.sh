#!/usr/bin/env sh
set -eu

session="${1:-}"

tmux start-server

# If a session name was provided, attach to it if it exists
if [ -n "$session" ] && tmux has-session -t "$session" 2>/dev/null; then
  exec tmux attach -t "$session"
fi

# Otherwise attach to whatever exists (this is what lets continuum restore win)
if tmux attach 2>/dev/null; then
  exit 0
fi

# If nothing exists yet, create the requested session (or a default)
if [ -n "$session" ]; then
  exec tmux new-session -s "$session"
else
  exec tmux new-session -s main
fi

