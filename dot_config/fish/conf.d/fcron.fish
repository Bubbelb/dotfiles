if pgrep fcron >/dev/null ; and type -q fcrontab ; and fcrontab -l 2>&1 | grep -Fq "INFO user $USER has no fcrontab."
    fcrontab $HOME/.config/fcrontab 2>/dev/null
end
