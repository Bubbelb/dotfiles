#!/usr/bin/env bash

MIME=$(file --brief --mime-type "$1")

case "$MIME" in
    # .pdf
    *application/pdf*)
        pdftotext "$1" -
        ;;
    # .7z
    *application/x-7z-compressed*)
        7z l "$1"
        ;;
    # .tar .tar.Z
    *application/x-tar*)
        tar -tvf "$1"
        ;;
    # .tar.*
    *application/x-compressed-tar*|*application/x-*-compressed-tar*)
        tar -tvf "$1"
        ;;
    # .rar
    *application/vnd.rar*)
        unrar l "$1"
        ;;
    # .zip
    *application/zip*)
        unzip -l "$1"
        ;;
    # any plain text file that doesn't have a specific handler
    text/plain|text/x-shellscript)
        if [[ -f /usr/bin/batcat ]] ; then
            batcat --force-colorization --paging=never --style=changes,numbers \
                   --terminal-width $(($2 - 3)) "$1" && false
        elif [[ -f /usr/bin/bat ]] ; then
            bat --force-colorization --paging=never --style=changes,numbers \
                --terminal-width $(($2 - 3)) "$1" && false
        else
            highlight -O ansi "$1" || true
        fi
        ;;
    *)
        echo "unknown format"
        ;;
esac

