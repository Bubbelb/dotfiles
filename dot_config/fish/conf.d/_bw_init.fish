# Bitwarden SSH integration
if test -S "~/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock"
     set -Ux SSH_AUTH_SOCK "~/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock"
 end
