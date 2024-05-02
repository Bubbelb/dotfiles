## Options for viewers, editors and searchers,
## Like neovim, grep, less and bat.

# Set default editor
for EDITEM (lvim nvim vim vi nano) ; do
    if whence ${EDITEM} >/dev/null ; then
        VISUAL=$(whence ${EDITEM})
        break
    fi
done

export EDITOR=${VISUAL}
export VISUAL

#Neovim options
if which nvim > /dev/null ; then
    alias nv=/usr/bin/nvim
    alias nvdiff='/usr/bin/nvim -d'
    alias nvimdiff='/usr/bin/nvim -d'
fi

# Less Highlight/lesspipe
if which lesspipe.sh > /dev/null ; then
    lesspipe.sh|source /dev/stdin
elif which source-highlight-esc.sh > /dev/null ; then
    export LESSOPEN="| $(which source-highlight-esc.sh) %s"
    export LESS=' -R '
fi

# Man highlighting with color
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;34m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'


#Diff and Grep
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias egrep='grep -E --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias fgrep='grep -F --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias diff='diff --color'


