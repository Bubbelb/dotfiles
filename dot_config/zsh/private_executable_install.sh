#!/bin/sh
DF_REMOTE_PATH='bbl@bubbel.org:/'
DF_SSH_ID="${HOME}/.ssh/id_rsa_dotfiles"
DF_HOSTKEY='bubbel.org ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCkOQurjeklf5OR9OgZlqlDMyUz1Fb3RFeK1gxczceV0u7EHtvdUW3/Wd5ldSUzT8ZvLTsMaltpOWI+I9zdYQ8E='
DF_SYNCSCRIPT="${HOME}/.config/zsh/console-updater.sh"
ARCH_APPLIST="pacutils trash-cli lf rsync tmux bat ripgrep exa\
              fd rsync git neovim python-neovim gcc zsh zsh-autosuggestions \
              zsh-completions zsh-history-substring-search zsh-syntax-highlighting openssh fzf"
DEB_APPLIST="trash-cli lf rsync tmux bat ripgrep fd-find rsync exa\
             git neovim python3-neovim gcc zsh zsh-autosuggestions \
             zsh-syntax-highlighting openssh-client fzf"
UPLIST=""

if ! [ -f "${DF_SSH_ID}" ] ; then
    echo "ERROR: Missing the private SSH key."
    echo "       Should be here: ${DF_SSH_ID}"
    exit 1
fi

if [ -f /usr/bin/pacman ] ; then
    for UPTST in ${ARCH_APPLIST}; do
        if ! pacman -Qsq | grep -Fxq "${UPTST}" ; then
            UPLIST="${UPLIST} ${UPTST}"
	fi
    done
    if [ $(echo "${UPLIST}" wc -w) -gt 0 ] ; then
        echo "Installing packages. Sudo needed."
        sudo pacman -Sq --needed --noconfirm ${UPLIST}
        RESULT=$?
    else
        RESULT=0
    fi
elif [ -f /usr/bin/apt-get ] ; then
    for UPTST in ${DEB_APPLIST}; do
        if ! dpkg-query -f '${binary:Package}\n' -W | grep -Fxq "${UPTST}" ; then
            UPLIST="${UPLIST} ${UPTST}"
	fi
    done
    if [ $( echo "${UPLIST}" | wc -w) -gt 0 ] ; then
        echo "Installing packages. Sudo needed."
        sudo apt-get install --no-install-recommends --yes ${UPLIST}
        RESULT=$?
    else
        RESULT=0
    fi
fi

if [ "${RESULT}" -ne 0 ]
then
    echo "Something wrong with update. Quitting."
    exit 1
fi

echo '---------------------------------'
echo 'Setting up ssh'
mkdir -p "${HOME}/.ssh"
if [ -f "${HOME}/.ssh/known_hosts" ] ; then
    touch "${HOME}/.ssh/known_hosts"
fi
if ! grep -Fqx "${DF_HOSTKEY}" "${HOME}/.ssh/known_hosts" ; then
    echo "${DF_HOSTKEY}" >> "${HOME}/.ssh/known_hosts"
fi

chmod 600 "${DF_SSH_ID}"

mkdir -p "${HOME}/.config/zsh"

echo "Copy update file..."
rsync -v \
    --rsh="ssh -i ${DF_SSH_ID} -o 'IdentitiesOnly yes'" \
    "${DF_REMOTE_PATH}.config/zsh/$(basename ${DF_SYNCSCRIPT})" ${DF_SYNCSCRIPT}
RESULT=$?
if [ ${RESULT} -gt 0 ] && [ ${RESULT} -ne 30 ] ; then
    echo "Oops something wrong. Quitting. Can rerun anytime."
else
    echo "No Problemo."
    echo "Running initial dotfile sync."
    ${HOME}/.config/zsh/console-updater.sh dotf_forcesync

if [ "$(basename $(getent passwd ${USER} | sed 's/.*://'))" != 'zsh' ] ; then
    echo "Setting up default shell."
    chsh -s /bin/zsh ${USER}
    echo "NOTE: Logout/Login to effectuate new shell."
fi
    echo "Done. Switching to zsh."
#    exec zsh
fi
