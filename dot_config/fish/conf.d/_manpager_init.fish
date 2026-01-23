if type -q bat
  set -Ux MANPAGER "bat -plman"
  set -Ux MANROFFOPT "-c"
  set -Ux BAT_PAGER "less -RFK"
  abbr -a --position anywhere -- --help '--help | bat -plhelp'
  abbr -a --position anywhere -- -h '-h | bat -plhelp'
end
