if type -q bat
  set -Ux MANPAGER "bat -plman"
  set -Ux MANROFFOPT -c
  abbr -a --position anywhere -- --help '--help | bat -plhelp'
  abbr -a --position anywhere -- -h '-h | bat -plhelp'
end
