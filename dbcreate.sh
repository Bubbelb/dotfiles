# Install bbsh

[bbsh]
additional_packages="bat eza fd lf ncdu plocate ripgrep trash-cli rsync"
additional_packages="btop ncurses neofetch chezmoi cosign"
additional_packages="fzf fzf-tmux fzf-zsh-plugin"
additional_packages="neovim github-cli py3-pynvim tree-sitter-cli"
additional_packages="gcc make nodejs npm yarn"
additional_packages="python3 py3-pip"
additional_packages="clipboard wl-clipboard"
additional_packages="zsh zsh-autosuggestions zsh-completions zsh-histdb zsh-history-substring-search zsh-pcre zsh-shift-select zsh-syntax-highlighting"
additional_packages="gzip zstd unzip"
image=docker.io/alpine:latest
init=false
init_hooks="apk update;"
init_hooks="apk upgrade;"
init_hooks="ln -fs /bin/sh /usr/bin/sh;"
init_hooks="ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman;"
init_hooks="ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak;"
init_hooks="ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker;"
init_hooks="ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree;"
init_hooks="ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/transactional-update;"
nvidia=false
pull=true
root=false
replace=true
start_now=true