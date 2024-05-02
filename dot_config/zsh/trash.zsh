#trash-cli support
if which trash-put >/dev/null ; then
    alias rm='print -Pf "%sThis is not the command you are looking for.%s\n" "%F{white}%B%K{red}" "%f%b%k"; false'
    alias tp=trash-put
fi
