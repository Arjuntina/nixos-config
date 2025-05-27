#! /usr/bin/env bash

# Script description: Launch a tmux session with a name or attach to an existing session with the "tm s" command

# The name of the session should be the first input to the expression
# This is already checked to be nonempty in the .zshrc file, so we don't need to check for that here
SESSION="$1"

# Check if the session already exists
# the 2>/dev/null at the end apparently directs the error to /dev/null if the session can't be found -- therefore, the error message won't be printed to the terminal! (should look into and learn more thoroughly)
if tmux has-session -t "$SESSION" 2>/dev/null; then
    tmux attach-session -t "$SESSION"
else
    tmux new-session -s "$SESSION"
fi


