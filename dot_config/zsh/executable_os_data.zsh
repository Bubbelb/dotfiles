#!/bin/zsh

typeset OS_Value
typeset PR_COL_LABEL='%F{green}'
typeset PR_COL_VALUE='%F{cyan}'
typeset PR_COL_LINE='%F{magenta}'
typeset PR_LEN_LINE=78
typeset PR_CHR_LINE='-'
typeset PR_PRI_SPLIT=':'
typeset PR_SEC_SPLIT=' '
typeset PR_COL_SPLIT='%F{grey}%B'
typeset VALUE_OK='%F{green}'
typeset VALUE_WARN='%F{yellow}'
typeset VALUE_ERR='%F{red}'
typeset ENDPAUSE="${1}"

# _hl_off "<color string>" "<string>"
#
# Concatenate color string and second string and create appropriate value
# to set any highlights off. e.g. If bold is on (%B), at the end of the
# string a Bold off (%b) will be added.
# Note: When the original string ends in a single '%' an extra '%' will be added at
# the end, thus forcing a % sign.
function _hl_off() {
    print -f "%s%s%s" \
        "${1}" \
        "$(echo "${2}" | sed 's/\([^\%]\%\)$/\1%/')" \
        "${(L)$(echo "${1}${2}" | grep -Eo '%[BUSFK]' | tr -d '\n')}"
}

function print_result() {
# print_result "<label>" "<value>" "[secondary value]..."
#
    local OLABEL OSPLIT

    OSPLIT="${PR_PRI_SPLIT}"
    OLABEL="${1}"
    echo "${2}" | while read LN ; do
        print -Pf "%s %s %s\n" \
            "$(_hl_off "${PR_COL_LABEL}" "${OLABEL}")" \
            "$(_hl_off "${PR_COL_SPLIT}" "${OSPLIT}")" \
            "$(_hl_off "${PR_COL_VALUE}" "${LN}")"
        OLABEL="$(printf '%*s' "${#OLABEL}")"
        OSPLIT="${PR_SEC_SPLIT:-${PR_PRI_SPLIT}}"
    done
}

function print_line() {
# print_line <length>
#
# Prints a single line of specified length
    print -Pf "%s\n" \
        "$(_hl_off "${PR_COL_LINE}" "$(head -c ${PR_LEN_LINE} /dev/zero | tr '\0' "${PR_CHR_LINE}")")"
}

#Read OS name
_get_OS() {
    if [[ -x /usr/bin/lsb_release ]] ; then
        /usr/bin/lsb_release -srd
    else
        DISTRIB_ID=''
        DISTRIB_RELEASE=''
        for file (/etc/lsb-release /usr/lib/os-release /etc/os-release  /etc/openwrt_release) {
            [[ -f "$file" ]] && source "$file" && break
        }
        printf '%s %s\n' "${NAME:-${DISTRIB_ID}}" "${VERSION_ID:-${DISTRIB_RELEASE}}"
    fi
}

_get_Mounts() {
    local MOUNTENTRY MOUNTDEV MOUNTCOL MOUNTPCT MOUNTOUT
    local -a MOUNTPRE

    MOUNTOUT=$( findmnt --real \
                        --list \
                        --output TARGET,SOURCE,FSTYPE,SIZE,USED,USE% \
                        --uniq \
                        --nofsroot | while read MOUNTENTRY ; do
                                        MOUNTDEV=$(echo "${MOUNTENTRY}" | awk '{print $2}')
                                        if ! ((${MOUNTPRE[(Ie)${MOUNTDEV}]})); then
                                            if [[ "${MOUNTENTRY:1,-1}" == "%" ]] ; then
                                                printf "%s\n" "${MOUNTENTRY}"
                                            fi
                                            MOUNTPRE+="${MOUNTDEV}"
                                        fi
                                    done | column --table )
    echo "${MOUNTOUT}" | while read MOUNTENTRY ; do
                             MOUNTPCT=$(echo "${MOUNTENTRY}" | awk '{print $NF}')
                             if [[ "${MOUNTPCT}" == "USE%" ]] ; then
                                 MOUNTCOL=""
                             elif [[ "${MOUNTPCT/\%/}" -gt 95 ]] ; then
                                 MOUNTCOL="${VALUE_ERR}"
                             elif [[ "${MOUNTPCT/\%/}" -gt 80 ]] ; then
                                 MOUNTCOL="${VALUE_WARN}"
                             else
                                 MOUNTCOL="${VALUE_OK}"
                             fi
                            printf "%s%s\n" "${MOUNTCOL}" "${MOUNTENTRY}"
                        done
}

_get_Packages(){
    if [[ -x /usr/bin/pacman ]] ; then
        UPG="$([[ -x /usr/bin/checkupdates ]] && printf "%'d" "$(checkupdates | wc -l)" || printf "%s" "Unknown")"
        printf "%'d Installed, %'d Orhaned, %s Upgradeable\n" \
            "$(pacman -Qsq | wc -l)" \
            "$(pacman -Qdtq | wc -l)" \
            "$([[ ${UPG} -gt 0 ]] && print "${VALUE_WARN}")${UPG}"
    elif [[ -x /usr/bin/dpkg ]] ; then
        printf "%'d Installed, %'d Residual config, %'d Upgradeable" \
            "$(dpkg-query -f '${binary:Package}\n' -W | wc -l)" \
            "$(dpkg --list | grep -E '^rc' | wc -l)" \
            "$(apt-get -q -y --ignore-hold \
                             --allow-change-held-packages \
                             --allow-unauthenticated \
                             -s dist-upgrade | \
                                grep '^Inst' | \
                                wc -l)"
    elif [[ -x /sbin/apk ]] ; then
        UPG="$(apk list --upgradeable| wc -l)"
        printf "%'d Installed, %'d Orhaned, %'d Upgradeable" \
            "$(apk list --installed| wc -l)" \
            "$(apk list --obsolete| wc -l)" \
            "$([[ ${UPG} -gt 0 ]] && print "${VALUE_WARN}")${UPG}"
    fi
}


# Main routine
() {
    print_line
    [[ ${UID} -eq 0 ]] && ROOT_COLOR='%F{red}%B' || ROOT_COLOR="${PR_COL_VALUE}"
    print_result 'User            ' "${ROOT_COLOR}${USER}"
    print_result 'Host, DNS Domain' "$(cat /proc/sys/kernel/hostname), $(cat /proc/sys/kernel/domainname)"
    print_result 'IP-addresses    ' "$(ip addr show dev $(ip route \
                                                       | grep '^default.*\smetric' \
                                                       | sed 's/^.*dev\s\+\(\S\+\).*/\1/') \
                                    | grep '^\s\+inet6\?\s\+' \
                                    | sed 's/^\s\+inet6\?\s\+\([^\/]\+\)\/\(\S\+\).*/\1 \/ \2/')"
    print_result 'Default gateways' "$((ip route ; ip -6 route) \
                                          | grep '^default.*\smetric' \
                                          | sed 's/^.*via\s\+\(\S\+\).*/\1/')"
    print_line

    print_result 'Time       ' "$(date '+%H:%M:%S')"
    print_result 'Uptime     ' "$(uptime -p)"
    print_result 'Distro     ' "$(_get_OS)"
    print_result 'Kernel     ' "$(uname -srm)"
    print_result 'Packages   ' "$(_get_Packages)"
    printf '\n'
    print_result 'Memory     ' "$( free --bytes | \
                              grep -E '^Mem:' | \
                              numfmt --to-unit=1M --grouping --field=2,3,4 | \
                              awk '{ print($2,"MB Total, ",$3,"MB Used, ",$4,"MB Free") }')"
    print_result 'Swap       ' "$( free --bytes | \
                              grep -E '^Swap:' | \
                              numfmt --to-unit=1M --grouping --field=2,3,4 | \
                              awk '{ print($2,"MB Total, ",$3,"MB Used, ",$4,"MB Free") }')"
    printf '\n'
    print_result 'filesystems' "$(_get_Mounts)"
    print_line

    print_result 'Shell' "$(getent passwd ${USER} | sed 's/.*://')"
    print_result 'Term ' "${TERM}"
    print_result 'Tmux ' "$([[ -z "${TMUX}" ]] && echo "No" || echo "Yes")"
    print_line
    if [[ "${ENDPAUSE}" == '-p' ]] ; then
        read -s "?Press enter to exit..."
    fi
}

