# Bitwarden SSH integration
if test -S "$HOME/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock"
     set -Ux SSH_AUTH_SOCK "$HOME/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock"
 end
