LFCD="${HOME}/.config/lf/lfcd.sh"
[[ -f "$LFCD" ]] && source "${LFCD}"

bindkey -s '^f' 'lfcd\n'

