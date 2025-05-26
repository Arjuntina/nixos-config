#! /usr/bin/env bash

# Launch a tmux session with a name or attach to a session with the "tm s" command
if [ -z "$1" ]; then
    echo "Usage: tm s <session-name>"
    exit 1
fi

# The name of the session should be the first input to the expression
SESSION="$1"

# Check if the session already exists
if tmux has-session -t="$SESSION" 2>/dev/null; then
    tmux attach-session -t="$SESSION"
else
    tmux new-session -s "$SESSION"
fi
