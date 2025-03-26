# CD Commands
alias -- -='cd -'
alias ...=../..
alias ....=../../..
alias .....=../../../..
alias ......=../../../../..
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

#ls enhancements
if [[ -x /usr/bin/exa ]] ; then
  alias la='eza --long --group --all'
  alias ll='eza --long --group'
  alias ls='eza'
  alias la.s='eza --long --group --all --sort size'
  alias la.t='eza --long --group --all --sort time'
  alias la.d='eza --long --group --all --only-dirs'
else
  alias la='ls -la'
  alias ll='ls -l'
  alias la.s='ls -larS'
  alias la.t='ls -lart'
  alias la.d='ls -lad'
fi

#Misc
alias mkdir='mkdir -pv'
alias which-command=whence
alias ip='ip -c=auto'

#normalize batcat and fd on debian systems (e.g. alias to 'bat')
[[ -x /usr/bin/batcat ]] && alias bat='batcat'
[[ -x /usr/bin/fdfind ]] && alias fd='fdfind'

#Shell Proxy Host
alias jssh='ssh -J bubbel.org'

# Start Distrobox bbsh on ssh connection
function essh() { ssh -t $1 '~/.local/bin/dbe' }
function bsh() { [[ -x /bin/bash ]] && ssh -t $(hostname) /bin/bash $* || ssh -t $(hostname) /bin/sh $* }

if ( whence python > /dev/null || whence python3 > /dev/null ) ; then
    alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'
    alias urlencode='python3 -c "import sys, urllib.parse as ul; print (ul.quote_plus(sys.argv[1]))"'
fi

if [[ -f /etc/bbsh ]] ; then
    alias hsudo='distrobox-host-exec sudo'
    alias hbash='distrobox-host-exec bash'
    alias hapt='distrobox-host-exec apt'
    alias hapt-get='distrobox-host-exec apt-get'
    alias hsapt='distrobox-host-exec sudo apt'
    alias hsapt-get='distrobox-host-exec sudo apt-get'
    alias hpacman='distrobox-host-exec pacman'
    alias hspacman='distrobox-host-exec sudo pacman'
fi

# Bat additions
if [[ -x /usr/bin/bat ]] ; then
    alias batl='/usr/bin/bat -l log'
    alias batx='/usr/bin/bat -l xml'
    alias baty='/usr/bin/bat -l yaml'
    alias batj='/usr/bin/bat -l json'
    alias batt='/usr/bin/bat -l toml'
    alias bati='/usr/bin/bat -l ini'
elif [[ -x /usr/bin/batcat ]] ; then
    alias batl='/usr/bin/batcat -l log'
    alias batx='/usr/bin/batcat -l xml'
    alias baty='/usr/bin/batcat -l yaml'
    alias batj='/usr/bin/batcat -l json'
    alias batt='/usr/bin/batcat -l toml'
    alias bati='/usr/bin/batcat -l ini'
fi

