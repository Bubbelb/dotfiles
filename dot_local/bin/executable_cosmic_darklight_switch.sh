#!/usr/bin/env bash
file="$HOME/.config/cosmic/com.system76.CosmicTheme.Mode/v1/is_dark"

case "$([[ -f "${file}" ]] && cat "${file}")" in
    true ) echo "false" > $file ;;
    false ) echo "true" > $file ;;
esac
