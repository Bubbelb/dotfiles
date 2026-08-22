if type -q batman
  set -Ux MANPAGER "batman"
  set -Ux MANROFFOPT "-c"
  set -Ux BATMAN_IS_BEING_MANPAGER yes
else if type -q most
  set -Ux MANPAGER "most"
  set -Ux MANROFFOPT "-c"
  set -Uu BATMAN_IS_BEING_MANPAGER
  function man
      MANWIDTH=(tput cols) /usr/bin/man $argv
  end
else if type -q less
  set -Ux MANPAGER "less --use-color -Dd+r -Du+b"
  set -gx MANROFFOPT "-P -c"
  set -Uu BATMAN_IS_BEING_MANPAGER
end

if type -q bat
  abbr --add --position anywhere -- --help '--help | bat -plhelp'
  abbr --add --position anywhere -- -h '-h | bat -plhelp'
else
    abbr --erase -h
    abbr --erase --help
end
