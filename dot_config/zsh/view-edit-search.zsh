## Options for viewers, editors and searchers,
## Like neovim, grep, less and bat.

# Set default editor
for EDITEM (nvim vim vi nano) ; do
    if whence ${EDITEM} >/dev/null ; then
        VISUAL=$(whence ${EDITEM})
        break
    fi
done

export EDITOR=${VISUAL}
export VISUAL

# Neovim options
if which nvim > /dev/null ; then
    alias nv=/usr/bin/nvim
    alias nvdiff='/usr/bin/nvim -d'
    alias nvimdiff='/usr/bin/nvim -d'
fi

# Set Less to RAW. i.e. do not escape control characters, like colour, etc.
export LESS=' -R '

# Man highlighting with color
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;34m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'


#Diff and Grep
# Ignore this if busybox grep is used.
if [[ "$(readlink $(which grep 2>/dev/null) | sed 's_.*/__')" != 'busybox' ]] ; then
    alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
    alias egrep='grep -E --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
    alias fgrep='grep -F --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
fi
readlink diff >/dev/null 2>&1 && alias diff='diff --color'

# Systemd Journal options (set bat as pager)
export SYSTEMD_COLORS='false'
export SYSTEMD_PAGERSECURE='true'
export SYSTEMD_PAGER='bat -l syslog -p'

