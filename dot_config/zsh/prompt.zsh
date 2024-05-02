build_prompt () {
	RETVAL=$?
	prompt_status
	prompt_virtualenv
	prompt_context
	prompt_dir
	prompt_end
}

SEGMENT_SEPARATOR=$'\ue0b0'
RSEGMENT_SEPARATOR=$'\ue0b2'
CURRENT_BG=NONE
CURRENT_FG='black'
PROMPT='%{%f%b%k%}$(build_prompt) '

setopt transientrprompt
setopt prompt_subst

prompt_status () {
	local -a symbols
    if [[ -f "${DF_RESULTFILE}" ]] ; then
        case "$(cat ${DF_RESULTFILE})" in
            OK)
                symbols+="%{%F{6}%}O"
                ;;
            ERROR)
                symbols+="%{%F{1}%}E"
                ;;
        esac
        rm -f "${DF_RESULTFILE}"
    fi
	[[ $RETVAL -ne 0 ]] && symbols+="%{%F{1}%}\uf7d3"
	[[ $UID -eq 0 ]] && symbols+="%{%F{3}%}\ufaf5"
	[[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{6}%}\uf7d0"
	[[ -n "$symbols" ]] && prompt_segment 166 7 "$symbols"
}

prompt_virtualenv () {
	local virtualenv_path="$VIRTUAL_ENV"
	if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]
	then
		prompt_segment 4 0 "(`basename $virtualenv_path`)"
	fi
}

prompt_context () {
	if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]
	then
		prompt_segment 237 7 "%(!.%{%F{3}%}.)%B%n%b@%B%m%b"
	fi
}

prompt_dir () {
	prompt_segment 4 $CURRENT_FG '%~'
}

prompt_end () {
	if [[ -n $CURRENT_BG ]]
	then
		echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
	else
		echo -n "%{%k%}"
	fi
	echo -n "%{%f%}"
	CURRENT_BG=''
}

prompt_segment () {
	local bg fg
	[[ -n $1 ]] && bg="%K{$1}"  || bg="%k"
	[[ -n $2 ]] && fg="%F{$2}"  || fg="%f"
	if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]
	then
		echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
	else
		echo -n "%{$bg%}%{$fg%} "
	fi
	CURRENT_BG=$1
	[[ -n $3 ]] && echo -n $3
}

rprompt_mode () {
    local bg fg pmsg
    if [[ ${KEYMAP} == 'vicmd' ]] ; then
        bg="%K{166}"
        fg="%F{0}"
        pmsg='CMD'
    elif [[ ${KEYMAP} == 'main' ]] || [[ ${KEYMAP} == 'vvins' ]] ; then
        bg="%K{237}"
        fg="%F{7}"
        pmsg='INS'
    else
        bg="%k"
        fg="%f"
        pmsg=' '
    fi
    echo -n "%{%k%}%{${bg/K/F}%}${RSEGMENT_SEPARATOR}%{$bg%}%{$fg%} ${pmsg} %k%f"
}

function zle-line-init zle-keymap-select {
    RPROMPT="$(rprompt_mode)"
    RPS2=$RPS1
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select


