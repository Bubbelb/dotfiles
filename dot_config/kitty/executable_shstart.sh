#!/usr/bin/env sh

# ShellSet: Sets the correct Shell implementation, based on environment and platform.

if command -v distrobox 2>&1 >/dev/null && \
    distrobox ls | cut -d '|' -f 2 | grep -Fw 'bbsh'
then
    exec distrobox enter bbsh -- tmux new-session -A
elif command -v tmux 2>&1 >/dev/null
then
    exec tmux new-session -A
else
    exec ${SHELL} -l
fi
