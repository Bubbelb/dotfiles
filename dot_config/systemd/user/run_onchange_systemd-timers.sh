#!/usr/bin/env bash

# Hash values to trigger update of services
# Hashes:
#   {{ include "chezmoi-update.service" | sha256sum }} chezmoi-update.service
#   {{ include "chezmoi-update.timer" | sha256sum }} chezmoi-update.timer
#   {{ include "fish-plugin-update.service" | sha256sum }} fish-plugin-update.service
#   {{ include "fish-plugin-update.timer" | sha256sum }} fish-plugin-update.timer
#   {{ include "neovim-plugin-update.service" | sha256sum }} neovim-plugin-update.service
#   {{ include "neovim-plugin-update.timer" | sha256sum }} neovim-plugin-update.timer
#   {{ include "yazi-pkg-update.service" | sha256sum }} yazi-pkg-update.service
#   {{ include "yazi-pkg-update.timer" | sha256sum }} yazi-pkg-update.timer

TIMERS_TEST=( chezmoi-update.timer \
              fish-plugin-update.timer \
              neovim-plugin-update.timer \
              yazi-pkg-update.timer )

systemctl --user daemon-reload

for TIMER_TEST in ${TIMERS_TEST[@]} ; do
    if [[ "$(systemctl is-enabled ${TIMER_TEST})" != "enabled" ]]
    then
        systemctl enable --quiet ${TIMER_TEST}
    fi

    if [[ "$(systemctl is-active ${TIMER_TEST})" == "active" ]]
    then
        systemctl restart --quiet ${TIMER_TEST}
    else
        systemctl start --quiet ${TIMER_TEST}
    fi
done

