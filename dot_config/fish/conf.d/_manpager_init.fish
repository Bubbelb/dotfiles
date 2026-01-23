if type -q most
  set -Ux MANPAGER "most"
  set -Ux MANROFFOPT "-c"
  function man
      MANWIDTH=(tput cols) /usr/bin/man $argv
  end
end

if type -q bat
  abbr -a --position anywhere -- --help '--help | bat -plhelp'
  abbr -a --position anywhere -- -h '-h | bat -plhelp'
end
