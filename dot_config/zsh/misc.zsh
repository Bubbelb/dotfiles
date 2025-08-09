#Update path with user bindir
typeset -U path
[[ -d "${HOME}/.local/bin" ]] && path+=("${HOME}/.local/bin")
export PATH

# Fish-like highlighting
if [[ -f '/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' ]] ; then
  source '/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
fi

setopt banghist               # Treat the '!' character specially during expansion.
setopt extendedhistory        # Write the history file in the ":start:elapsed;command" format.
setopt incappendhistory       # Write to the history file immediately, not when the shell exits.
setopt sharehistory           # Share history between all sessions.
setopt histexpiredupsfirst    # Expire duplicate entries first when trimming history.
setopt histignorealldups      # Delete old recorded entry if new entry is a duplicate.
setopt histfindnodups         # Do not display a line previously found.
setopt histignorespace        # Don't record an entry starting with a space.
setopt histreduceblanks       # Remove superfluous blanks before recording entry.
unsetopt histverify           # Do execute immediately upon history expansion.
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt autopushd              # Automatically push old $PWD on dir stack

#Enable bat as manpager, when installed
if [[ -f /usr/bin/bat ]] ; then
  if [[ -f /usr/bin/col ]] ; then
      export MANPAGER="sh -c 'col -bx | bat -l man -p --theme=ansi'"
  else
      export MANPAGER='bat -l man -p --theme=ansi'
  fi
  export MANROFFOPT="-c"
  alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
elif [[ -f /usr/bin/batcat ]] ; then
  if [[ -f /usr/bin/col ]] ; then
      export MANPAGER="sh -c 'col -bx | batcat -l man -p --theme=ansi'"
  else
      export MANPAGER='batcat -l man -p --theme=ansi'
  fi
  export MANROFFOPT="-c"
  alias -g -- --help='--help 2>&1 | batcat --language=help --style=plain'
fi

# override the above, when using nvim.
if [[ -f /etc/bbsh ]] ; then
  export MANPAGER='nvim +Man!'
fi

#Completion
autoload -Uz compinit
compinit -d "${ZSH_APPDIR}/zcompdump"

zstyle ':completion:*' completer _expand _complete _ignored _match _approximate _prefix
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' rehash true
zstyle :compinstall filename "${ZDOTDIR}/.zshrc"

#Reset Help
autoload -Uz run-help
alias run-help >/dev/null && unalias run-help
alias help=run-help

#Modules
autoload -Uz colors
colors

#Search History
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

setopt appendhistory autocd extendedglob glob_subst
unsetopt beep nomatch
bindkey -v
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey "^[." insert-last-word
autoload -Uz copy-earlier-word
zle -N copy-earlier-word
bindkey "^[m" copy-earlier-word

# Set Terminal Emulator title
case $TERM in
  (*xterm* | rxvt)

    # Write some info to terminal title.
    # This is seen when the shell prompts for input.
    function precmd {
        if [[ $SSH_TTY ]] ; then
            print -Pn "\e]0;[%n@%m] %(1j,%j job%(2j|s|); ,)%~\a"
        else
            print -Pn "\e]0;[zsh%L] %(1j,%j job%(2j|s|); ,)%~\a"
        fi
    }
    # Write command and args to terminal title.
    # This is seen while the shell waits for a command to complete.
    function preexec {
        if [[ $SSH_TTY ]] ; then
            printf "\033]0;[%s@%s] %s\a" "$USER" "$HOST" "$1"
        else
            printf "\033]0;%s\a" "$1"
        fi
    }
  ;;
esac

# SSH Completion using ssh config and known_hosts
function _ssh {
    SHC=( $(for A in $(grep "^Host\s\+" ${HOME}/.ssh/config | sed 's/^Host\s\+//') ; do [[ ${A} =~ '\!|\*' ]] || echo ${A} ; done | sort -u) )
    SHK=( $(grep -ve "^@revoked|^@cert-authority|^[\|]" ${HOME}/.ssh/known_hosts | sed -e 's/\s.*//' -e 's/,/\n/g' -e 's/.*\[//' -e 's/\]:.*//' | sort -u) )
    _arguments '*::arg:->args'
    _values 'args' ${SHC[@]} ${SHK[@]}
}

compdef _ssh ssh

if [[ -x $(which fzf) ]] ; then
    # Options to fzf command
    export FZF_COMPLETION_OPTS=''

    # Use fd (https://github.com/sharkdp/fd) instead of the default find
    # command for listing path candidates.
    # - The first argument to the function ($1) is the base path to start traversal
    # - See the source code (completion.{bash,zsh}) for the details.
    _fzf_compgen_path() {
      if [[ -x /usr/bin/fdfind ]] ; then
          fdfind --hidden --follow --exclude ".git" . "$1"
      else
          fd --hidden --follow --exclude ".git" . "$1"
      fi
    }

    # Use fd to generate the list for directory completion
    _fzf_compgen_dir() {
      if [[ -x /usr/bin/fdfind ]] ; then
          fdfind --type d --hidden --follow --exclude ".git" . "$1"
      else
          fd --type d --hidden --follow --exclude ".git" . "$1"
      fi
    }

    # Advanced customization of fzf options via _fzf_comprun function
    # - The first argument to the function is the name of the command.
    # - You should make sure to pass the rest of the arguments to fzf.
    _fzf_comprun() {
      local command=$1
      shift

      case "$command" in
        cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
        export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
        ssh)          fzf --preview 'dig {}'                   "$@" ;;
        *)            if [[ -x /usr/bin/batcat ]] ; then
                        fzf --preview 'batcat -n --color=always {}' "$@"
                      else
                        fzf --preview 'bat -n --color=always {}' "$@"
                      fi ;;
      esac
    }
    source "${ZDOTDIR}/fzf-zsh-completion.sh"
    bindkey '^I' fzf_completion
    zstyle ':completion:*' fzf-search-display true
    if [[ -x /usr/bin/batcat ]] ; then
        zstyle ':completion::*:ls::*' fzf-completion-opts --preview='eval batcat --color=always -n {1}'
    else
        zstyle ':completion::*:ls::*' fzf-completion-opts --preview='eval bat --color=always -n {1}'
    fi
fi

#OS Data
bindkey -s '^S' '~/.config/zsh/os_data.zsh\n'

# Goldwarden integration
if [[ -d /home/$USER/.var/app/com.quexten.Goldwarden/data ]] ; then
  alias goldwarden='flatpak run --command=goldwarden com.quexten.Goldwarden'
  SSH_AUTH_SOCK=~/.var/app/com.quexten.Goldwarden/data/ssh-auth-sock
fi
