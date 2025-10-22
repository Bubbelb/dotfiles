#!/bin/bash
IFS=$'\n'

system_app_dirs=("/var/lib/flatpak/exports/share/applications" "/usr/share/applications")
user_app_dirs=("${HOME}/.local/share/flatpak/exports/share/applications" "${HOME}/.local/share/applications")

ini_file="${HOME}/.config/multilaunch.conf"

category="${1}"

if [[ -z "${category}" ]] ; then
    echo "Supply category as parameter."
    echo "Categories are defined in '${ini_file}'."
    exit 2
elif ! grep -qxF "[${category}]" ${ini_file} ; then
    echo "Category '${1}' not found in '${ini_file}'."
    exit 1
fi

if [[ -x '/usr/bin/zenity' ]] ; then
    zenity --info --text "Starting application group '${category}'." &
    ZENPID=$!
else
    ZENPID=0
fi

sleep 0.8

applist=$(cat "${ini_file}" <(echo '[]') | grep -v '^\s*$\|^\s*#' | grep -FA 9999 -- "[${category}]" | tail -n +2 | grep -B 9999 -m 1 '^\s*\[.*\?\]\s*$' | head -n -1 | sed -e 's/^\s*//' -e 's/\s*$//')

system_app_dir_ok=()
for adir in ${system_app_dirs[@]} ; do
    [[ -d ${adir} ]] && system_app_dir_ok+=("${adir}")
done

user_app_dir_ok=()
for adir in ${user_app_dirs[@]} ; do
    [[ -d ${adir} ]] && user_app_dir_ok+=("${adir}")
done

for line in ${applist[@]} ; do
    user_app=($(grep -l '^\s*Name\s*=\s*'${line}'\s*#\?' $(find ${user_app_dir_ok[@]} -name '*.desktop' -type f -or -type l)))
    system_app=($(grep -l '^\s*Name\s*=\s*'${line}'\s*#\?' $(find ${system_app_dir_ok[@]} -name '*.desktop' -type f -or -type l)))
    if [[ ${#user_app[@]} -gt 0 ]] ; then
        echo -e "Starting user app: '${line}' (file: '$(basename ${user_app[0]}))"
        if [[ ${#user_app[@]} -gt 1 ]] ; then
            echo " [only the first entry out of ${#user_app[@]}]."
        else
            echo ""
        fi
        gtk-launch "$(basename ${user_app[0]})"
    elif [[ ${#system_app[@]} -gt 0 ]] ; then
        echo -e "Starting system app: '${line}' (file: '$(basename ${system_app[0]}))"
        if [[ ${#system_app[@]} -gt 1 ]] ; then
            echo " [only the first entry out of ${#system_app[@]}]."
        else
            echo ""
        fi
        gtk-launch "$(basename ${system_app[0]})"
    else
        echo "Warning: No app with name '${line}' found. Skipped."
    fi
    sleep 0.8
done

[[ ${ZENPID} -gt 0 ]] && kill ${ZENPID}
