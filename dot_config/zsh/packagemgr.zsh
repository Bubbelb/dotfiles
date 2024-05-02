# Set Updates for Archliux. pacman/yay/pikaur and flatpak
if [[ -x /usr/bin/pamac ]] ; then
    if [[ -x /usr/bin/flatpak ]] ; then
        alias pu='/usr/bin/pamac upgrade --no-confirm && /usr/bin/flatpak update --assumeyes && /usr/bin/flatpak uninstall --unused --assumeyes'
    else
        alias pu='/usr/bin/pamac upgrade --no-confirm'
    fi
elif [[ -x ~/.local/bin/updater ]] ; then
    alias pu='~/.local/bin/updater -y update'
else
    alias pu='/usr/bin/pacman -Suy --noconfirm'
fi

# Display unused flatpak data in ~/.var/app. Use -p, to show complete path.
# Usage example, remove unused data: flatpak-unused -p | xargs rm -rf
if [[ -x /usr/bin/flatpak ]] ; then
    function flatpak-unused() {
        [[ "$1" == "-p" ]] && PVAR="${HOME}/.var/app/" || PVAR=''
        comm -13 <(flatpak list --columns=application:f --all | tail -n +1 | sort) <(ls -1 ~/.var/app | sort) | awk '{print "'${PVAR}'"$0}'
    }
fi

