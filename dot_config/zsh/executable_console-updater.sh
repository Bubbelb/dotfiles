#!/bin/zsh

# Check if updates are needed config files, present in the dotfiles filelist file.

# Set refresh interval in days
_ZSH_APPDIR="${ZSH_APPDIR:-${HOME}/.local/share/zsh}"
DF_REFRESH_INT_DAYS=7
DF_HOSTKEY='bubbel.org ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCkOQurjeklf5OR9OgZlqlDMyUz1Fb3RFeK1gxczceV0u7EHtvdUW3/Wd5ldSUzT8ZvLTsMaltpOWI+I9zdYQ8E='
DF_DATEFILE="${_ZSH_APPDIR}/sync-timestamp"
DF_NVIM_UPDATE="${_ZSH_APPDIR}/nvim-update-timestamp"
DF_REMOTE_PATH='bbl@bubbel.org:/'
DF_SSH_ID="${HOME}/.ssh/id_rsa_dotfiles"
DF_FILELIST="${HOME}/.config/zsh/dotfiles"
DF_SYNCLOG="${_ZSH_APPDIR}/dotfiles-sync.log"

mkdir -p "${_ZSH_APPDIR}"

#Write message to log.
#Usage: logmsg "category" "Message" or
#       <command> | logmsg "category"
#Be sure to enclose both category and Message with quotes, when using spaces.
logmsg() {
    if [[ -n "${2}" ]] ; then
        echo "${2}" | logmsg "${1}"
    else
        if ! [[ -f ${DF_SYNCLOG} ]] ; then
            printf "DATE                [    PID] (category) - message\n" > ${DF_SYNCLOG}
        fi
        FIRSTLINE='-  '
        while read LOGLINE ; do
            printf '%s [%7s] (%s) %s%s\n' \
                                            "$(date '+%Y-%m-%d %H:%M:%S')" \
                                            "$$" \
                                            "${1}" \
                                            "${FIRSTLINE}" \
                                            "${LOGLINE}" \
                                            >> "${DF_SYNCLOG}"
            FIRSTLINE='>> '
        done
    fi
} # logmsg

# Do the actual update...
dotfiles_filesync() {
    [[ "${1}" == '-q' ]] || print -Pf "%sDotfiles syncing:%s\n" "%B%F{green}" "%f%b"
    if [[ $(date '+%s' -r ${DF_DATEFILE}) -lt $(date '+%s' --date="${DF_REFRESH_INT_DAYS} days ago") ]] ; then
        logmsg "pre-sync" "It's time for a filesync..."
        logmsg "pre-sync" "---------------------------"
        if [[ ! -f ${DF_FILELIST} ]] ; then
            print -Pf "  %sRetrieving dotfiles filelist... %s" "%F{yellow}" "%f"
            logmsg "first-sync" "No filelist found. Retrieving..."
            rsync \
            --quiet \
            --rsh="ssh -i ${DF_SSH_ID} -o 'IdentitiesOnly yes'" \
            "${DF_REMOTE_PATH}.config/zsh/$(basename ${DF_FILELIST})" ${DF_FILELIST} | logmsg "first-sync"
            RESULT=$?
            if [[ ${RESULT} -gt 0 ]] && [[ ${RESULT} -ne 30 ]] ; then
                print -Pf "  %sRETRIEVAL FAILED, STOPPING UPDATE!%s\n" "%F{red}" "%f"
                logmsg "first-sync" "Error ${RESULT} during initial sync. Exiting."
                return 1
            else
                print -Pf "  %sRetrieval OK.%s\n" "%F{green}" "%f"
            fi
        fi
        PRE_SYNCLIST=$(date "+%s" --reference="${DF_FILELIST}")
        print -Pf "  %sUpdating dotfiles... %s" "%F{yellow}" "%f"
        logmsg "rsync" "Starting dotfiles sync."
        rsync \
            --recursive \
            --perms \
            --times \
            --backup \
            --executability \
            --delay-updates \
            --timeout=3 \
            --compress \
            --update \
            --ignore-missing-args \
            --stats \
            --include-from=${DF_FILELIST} \
            --rsh="ssh -i ${DF_SSH_ID} -o 'IdentitiesOnly yes'" \
                "${DF_REMOTE_PATH}" \
                "${HOME}/" | logmsg "rsync"
        RESULT=$?
        if [[ ${RESULT} -gt 0 ]] && [[ ${RESULT} -ne 30 ]] ; then
            print -Pf "  %sUPDATE ERROR!%s\n" "%F{red}" "%f"
            return 1
        else
            if [[ ${PRE_SYNCLIST} -ne $(date "+%s" --reference="${DF_FILELIST}") ]] ; then
                print -Pf "  %sSynclist updated. Will re-sync.%s\n\n" "%F{magenta}" "%f"
                logmsg "post-rsync" "Synclist file updated. Will rerun sync now."
                dotfiles_filesync
                return $?
            else
                print -Pf "  %sUpdate OK.%s\n" "%F{green}" "%f"
                touch "${DF_DATEFILE}"
                return 1
            fi
        fi
    else
        [[ "${1}" == '-q' ]] || print -Pf "  %sNo sync needed.%s\n" "%F{green}" "%f"
        return 0
    fi
}

# Upload new dotfiles. Use -f to force upload of all, even older.
function dotf_upload() {
    if [[ $1 == '-f' ]] ; then
        cat ${DF_FILELIST} | while read DOTFILES_UP ; do
            touch -c "${HOME}/${DOTFILES_UP}"
        done
    fi
    rsync \
        --recursive \
        --perms \
        --times \
        --executability \
        --delay-updates \
        --timeout=3 \
        --compress \
        --update \
        --verbose \
        --stats \
        --ignore-missing-args \
        --delete \
        --rsh="ssh -i ${DF_SSH_ID} -o 'IdentitiesOnly yes'" \
        --exclude="*~" \
        --include-from=${DF_FILELIST} \
        --exclude="*" \
            "${HOME}/" \
            "${DF_REMOTE_PATH}"
}

# Force an immediate update of dotfiles, optionally also for nvim.
function dotf_forcesync() {
    print -Pf "%sForce update of dotfiles...%s\n" "%F{yellow}" "%f"
    touch --date="400 days ago" ${DF_DATEFILE}
    dotfiles_filesync
}

function bline() {
    print -Pf "%s%s%s\n" "%F{blue}" "$(printf "%0.s${2:--}" {1..${1:-30}})" "%f"
}

function nvim_lazy_update() {
    [[ -f "${DF_NVIM_UPDATE}" ]] || touch --date="400 days ago" ${DF_NVIM_UPDATE}
    if [[ $(date '+%s' -r ${DF_NVIM_UPDATE}) -lt $(date '+%s' --date="1 day ago") ]] ; then
        (nvim --headless "+Lazy! sync" +qa && nvim --headless -c 'autocmd User MasonUpdateAllComplete quitall' -c 'MasonUpdateAll' && touch "${DF_NVIM_UPDATE}") & disown >/dev/null
    fi
}

#Ensure SSH hostkey is in place (e.g. remote host is trusted)
mkdir --mode=0600 --parents "${HOME}/.ssh"
[[ -f "${HOME}/.ssh/known_hosts" ]] || touch "${HOME}/.ssh/known_hosts"
grep -qF "${DF_HOSTKEY}" "${HOME}/.ssh/known_hosts" || echo "${DF_HOSTKEY}" >> "${HOME}/.ssh/known_hosts"

[[ -f "${DF_DATEFILE}" ]] || touch --date="400 days ago" ${DF_DATEFILE}

case "${1}" in
    dotf_upload)
        dotf_upload ${2}
        exit
    ;;
    dotf_forcesync)
        dotf_forcesync ${2}
        exit
    ;;
    tmux_init)
        #nvim_lazy_update
        QTIMEOUT=''
        bline 78
        dotfiles_filesync && QTIMEOUT='-t 16'
        bline 78
        RESULT=$?
        ~/.config/zsh/os_data.zsh
        eval "read -s ${QTIMEOUT} '?Press enter to quit...'"
        (sleep .5 ; tmux move-window -r ; sleep .5) & disown ; exit
    ;;
    *)
        #nvim_lazy_update
        dotfiles_filesync -q || bline 40
    ;;
esac

