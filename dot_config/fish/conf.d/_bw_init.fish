# Bitwarden SSH integration
if test -S "$HOME/.bitwarden-ssh-agent.sock"
     set -g --erase SSH_AUTH_SOCK
     set -Ux SSH_AUTH_SOCK "$HOME/.bitwarden-ssh-agent.sock"
 else if test -S "$HOME/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock"
     set -g --erase SSH_AUTH_SOCK
     set -Ux SSH_AUTH_SOCK "$HOME/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock"
 end
