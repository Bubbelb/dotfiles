#!/usr/bin/env bash

# Update all browser shortcuts in ~/.local/share/applications/<browser name>.desktop
# Update the StartWMClass value to the same as the Icon value.

declare -A BROWSER_TITLES
BROWSER_TITLES=(
                 ['chrome']='Google Chrome' \
                 ['chromium']='Chromium' \
                 ['ungoogled_chromium']='Ungoogled Chromium' \
                 ['brave']='Brave' \
                 ['edge']='MS Edge' \
                 ['vivaldi']='Vivaldi' \
                 ['opera']='Opera'
             )

declare -A BROWSERS_NATIVE
BROWSERS_NATIVE=(
                 ['chrome']='chrome' \
                 ['chromium']='chromium' \
                 ['ungoogled_chromium']='ungoogled_chromium' \
                 ['brave']='brave' \
                 ['edge']='edge' \
                 ['vivaldi']='vivaldi' \
                 ['opera']='opera' \
             )

declare -A BROWSERS_FLATPAK
BROWSERS_FLATPAK=(
                 ['chrome']='com.google.Chrome.flextop' \
                 ['chromium']='org.chromium.Chromium.flextop.chrome'] \
                 ['ungoogled_chromium']='io.github.ungoogled_software.ungoogled_chromium.flextop.chrome'  \
                 ['brave']='com.brave.Browser' \
                 ['edge']='com.microsoft.Edge.flextop.msedge' \
                 ['vivaldi']='com.vivaldi.Vivaldi.flextop.vivaldi' \
                 ['opera']='com.opera.Opera.flextop' \
             )

function getinival() {
    infile="${1}"
    key="${2}"

    seg_start="$(($(cat "${infile}" <(echo '[zzz]') | grep -n -m 1 '^\[Desktop Entry\]\s*\(#.*\)\?$' | sed 's/:.*//')+1))"
    seg_length="$(($(cat "${infile}" <(echo '[zzz]') | tail -n +${seg_start} | grep -n -m 1 '^\s*\[' | sed 's/:.*//')+1))"

    cat "${infile}" <(echo '[zzz]') | \
        tail -n +${seg_start} | \
        head -n ${seg_length} | \
        grep -v "^\s*\(#.*\)\?$" | \
        grep -m 1 '^\s*'${key}'\s*=\s*' | \
        sed -e 's/^\s*'${key}'\s*=\s*//' -e 's/\s*#.*//'
    #
    # Action per line:
    #  cat      -- Get the file, add extra heading, [zzz] at end to ease selection process.
    #      tail -- Skip all before, and including the first line that is '[Desktop Entry]'
    #      head -- Remove all the subsequent headings and content
    #      grep -- Remove empty end comment-only lines
    #      grep -- Find the specified key, only the first entry
    #      sed  -- Show only the value
}

function help_show() {

    echo "$(basename $0 .sh) - Update Desktop registrations for Browser Shortcuts/PWA's."
    echo
    echo "Usage: $(basename $0) [-f|-F] [-n|-N] [-b|-B <...>]"
    echo
    echo "Note: Lowercase parameter enables, Uppercase disables parameter."
    echo "Note: Per default all browsers and variants are selected."
    echo
    echo "    -f/-F Enable/Disable Flatpak browsers"
    echo "    -n/-N Enable/Disable native (OS installed) browsers"
    echo "    -b/-B Select/Deselect specific browsers. List is comma-separated. Deselection takes precedence."
    echo
    echo "Available browsers:"
    for I in "${!BROWSER_TITLES[@]}" ; do
        printf "  - %s (%s)\n" "${I}" "${BROWSER_TITLES[${I}]}"
    done

    exit
}

# MAIN

DO_FLATPAK=1
DO_NATIVE=1
INCL_BROWSERS=()
EXCL_BROWSERS=()

while getopts ":vFnN:b:B" arg ; do
    case ${arg} in
        f ) DO_FLATPAK=1 ;;
        F ) DO_FLATPAK=0 ;;
        n ) DO_NATIVE=1 ;;
        N ) DO_NATIVE=0 ;;
        b ) INCL_BROWSERS+=($(echo "${OPTARG}" | sed -e 's/\s\+//g' -e 's/,/ /g')) ;;
        B ) EXCL_BROWSERS+=($(echo "${OPTARG}" | sed -e 's/\s\+//g' -e 's/,/ /g')) ;;
        h ) help_show ;;
        ? ) echo "Invalid parameter: '-${OPTARG}'" >&2
            help_show ;;
    esac
done

if [[ ${DO_NATIVE} -eq 0 ]] && [[ ${DO_FLATPAK} -eq 0 ]] ; then
    echo "Warning, flatpak, as wel as native application selection is disabled. Nothing to do." >&2
    exit 1
fi

if [[ ${#INCL_BROWSERS[@]} -lt 1 ]] ; then
    INCL_BROWSERS=("${!BROWSER_TITLES[@]}")
else
    for I in "${INCL_BROWSERS[@]}" ; do
        if [[ -z ${BROWSER_TITLES[${I}]} ]] ; then
            echo "Warning, included browser name ${I} not found. Skipping." >&2
            INCL_BROWSERS=("${INCL_BROWSERS[@]/${I}}")
        fi
    done
fi
for I in "${EXCL_BROWSERS[@]}" ; do
    if [[ -z "${BROWSER_TITLES[${I}]}" ]] ; then
        echo "Warning, excluded browser name ${I} not found. Skipping." >&2
    else
        INCL_BROWSERS=("${INCL_BROWSERS[@]/${I}}")
    fi
done

if [[ ${#INCL_BROWSERS[@]} -lt 1 ]] ; then
    echo "Warning, no apps found to process. Check included and/or excluded browsers." >&2
    exit 1
fi

BROWSERLIST=()
BROWSERLISTTITLES=()
for I in "${INCL_BROWSERS[@]}" ; do
    if [[ ${DO_NATIVE} -eq 1 ]] ; then
        BROWSERLIST+=("${BROWSERS_NATIVE[${I}]}")
        BROWSERLISTTITLES+=("${BROWSER_TITLES[${I}]}")
    fi
    if [[ ${DO_FLATPAK} -eq 1 ]] ; then
        BROWSERLIST+=("${BROWSERS_FLATPAK[${I}]}")
        BROWSERLISTTITLES+=("${BROWSER_TITLES[${I}]} (Flatpak)")
    fi
done

for J in $(seq 0 $((${#BROWSERLIST[@]}-1)) ) ; do
    if compgen -G ~/.local/share/applications/${BROWSERLIST[${J}]}-*.desktop > /dev/null ; then
        for dtfile in ~/.local/share/applications/${BROWSERLIST[${J}]}-*.desktop ; do
            name_ln="$(getinival "${dtfile}" "Name")"
            icon_ln="$(getinival "${dtfile}" "Icon")"
            wmclass_ln="$(getinival "${dtfile}" "StartupWMClass")"
            nodis_ln="$(getinival "${dtfile}" "NoDisplay")"
            if [[ "${icon_ln}" == "${wmclass_ln}" ]] ; then
                icon_chg="ok"
            else
                icon_chg="UPDATED"
                sed -i "s/^StartupWMClass\s*=\s*.*/StartupWMClass=${icon_ln}/" ${dtfile}
            fi
            if [[ -z "${nodis_ln}" ]] || [[ "${nodis_ln}" == "false" ]] ; then
                nodis_chk="ok"
            else
                nodis_chk="UPDATED"
                sed -i "s/^NoDisplay\s*=\s*true/NoDisplay=false/" ${dtfile}
            fi
            printf '%-30s: %-30s - icon %8s, nodisplay %8s\n' "${BROWSERLISTTITLES[${J}]}" "$(getinival "${dtfile}" "Name")" "${icon_chg}" "${nodis_chk}"
        done
    fi
done

