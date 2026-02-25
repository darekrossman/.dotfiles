#!/usr/bin/env bash

set -euo pipefail

right_cmd="${1:-codex}"

if [[ -z "${TMUX:-}" ]]; then
  echo "This script must be run from inside a tmux session."
  exit 1
fi

current_pane="$(tmux display-message -p "#{pane_id}")"
current_window="$(tmux display-message -p "#{window_id}")"
current_path="$(tmux display-message -p "#{pane_current_path}")"

# Keep only the active pane so this always creates a predictable 3-pane layout.
while IFS= read -r pane_id; do
  if [[ "$pane_id" != "$current_pane" ]]; then
    tmux kill-pane -t "$pane_id"
  fi
done < <(tmux list-panes -t "$current_window" -F "#{pane_id}")

bottom_pane="$(tmux split-window -v -d -p 25 -t "$current_pane" -c "$current_path" -P -F "#{pane_id}")"
right_pane="$(tmux split-window -h -d -p 30 -t "$current_pane" -c "$current_path" -P -F "#{pane_id}")"

tmux send-keys -t "$current_pane" "nvim" C-m
tmux send-keys -t "$right_pane" "$right_cmd" C-m

tmux select-pane -t "$current_pane"
