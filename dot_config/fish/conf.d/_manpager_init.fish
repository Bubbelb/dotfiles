if type -q bat
  set --erase -U MANPAGER
  set -Ux MANPAGER env\ BATMAN_IS_BEING_MANPAGER=yes\ bash\ (which batman)
  set -Ux MANROFFOPT -c
  set --erase -U MANROFFOPT
end
