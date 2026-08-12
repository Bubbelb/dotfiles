#!/usr/bin/env bash
PKGS_ARCH=( \
    bat eza fd ripgrep trash-cli rsync file sshfs yazi yazi-cli curl most ouch \
    mediainfo ffmpeg poppler poppler-utils 7zip zoxide imagemagick chafa chafa-fish-completion \
    btop ncurses fastfetch chezmoi cosign lazygit \
    fzf fzf-tmux fzf-fish-plugin \
    neovim github-cli py3-pynvim tree-sitter-cli \
    gcc make nodejs npm yarn dotnet-host dotnet8-runtime \
    python3 py3-pip \
    clipboard wl-clipboard wlroots libnotify \
    fish jq shfmt \
    docker-zsh-completion docker-cli docker-cli-compose openssl socat drill mosh kitty-terminfo \
    bzip2 gzip zstd unzip yq )

PKGS_ALPINE=( \
    bat eza fd ripgrep trash-cli rsync file fcron sshfs curl most \
    mediainfo ffmpeg poppler poppler-utils 7zip zoxide imagemagick chafa chafa-fish-completion \
    btop ncurses fastfetch chezmoi cosign lazygit \
    fzf fzf-tmux fzf-fish-plugin \
    neovim github-cli py3-pynvim tree-sitter-cli \
    gcc make nodejs npm yarn musl-dev dotnet-zsh-completion dotnet-host dotnet8-runtime \
    python3 py3-pip \
    clipboard wl-clipboard wlroots libnotify \
    fish jq shfmt \
    docker-zsh-completion docker-cli docker-cli-compose openssl socat drill mosh libcap-utils libcap-setcap kitty-terminfo \
    bzip2 gzip zstd unzip yq musl-locales )
PKGS_ALPINE_EDGE_MAIN=( lua5.5-libs )
PKGS_ALPINE_EDGE_COMMUNITY=( yazi yazi-cli )
PKGS_ALPINE_EDGE_TESTING=( ouch )

function arch-install-pkg() {
    echo "Checking missing packages and installing them..."
    MLIST=($(comm -23 <(echo "${PKGS_ARCH[@]}" | tr -s ' ' $'\n' | sort -u) <(pacman -Qsq | sort)))
    if [[ "${#MLIST[@]}" -gt 0 ]] ; then
        echo "Missing packages. Installing them."
        sudo pacman -S --noconfirm ${MLIST[@]}
    else
        echo "All packages are accounted for."
    fi
}

function alpine-install-pkg() {
    echo "Checking missing packages and installing them..."
    for cnt in {1..4} ; do
        case ${cnt} in
            1 ) ALIST=(${PKGS_ALPINE[@]})
                ANAME="stable"
                AREPO="" ;;
            2 ) ALIST=(${PKGS_ALPINE_EDGE_MAIN[@]})
                ANAME="edge/main"
                AREPO="https://dl-cdn.alpinelinux.org/alpine/edge/main" ;;
            3 ) ALIST=(${PKGS_ALPINE_EDGE_COMMUNITY[@]})
                ANAME="edge/community"
                AREPO="https://dl-cdn.alpinelinux.org/alpine/edge/community" ;;
            4 ) ALIST=(${PKGS_ALPINE_EDGE_TESTING[@]})
                ANAME="edge/testing"
                AREPO="https://dl-cdn.alpinelinux.org/alpine/edge/testing" ;;
        esac

        MLIST=($(comm -23 <(echo "${ALIST[@]}" | tr -s ' ' $'\n' | sort -u) <(apk list -q | sort)))
        if [[ "${#MLIST[@]}" -gt 0 ]] ; then
            echo "Missing packages from repo '${ANAME}'. Installing them."
            if [[ -z "${AREPO}" ]] ; then
                sudo apk add ${MLIST[@]}
            else
                apk add --no-cache --repository="${AREPO}" ${MLIST[@]}
            fi
        else
            echo "All packages are accounted for."
        fi
    done
}

function deb-install-pkg() {
    echo "Not yet implemented."
}

function main() {
    if command -v pacman 2>/dev/null ; then
        arch-install-pkg
    elif command -v apt-get 2>/dev/null ; then
        deb-install-pkg
    elif command -v apk 2>/dev/null ; then
        alpine-install-pkg
    fi

    if [[ -f "${HOME}/.local/share/chezmoi/.git/index" ]] ; then
        echo "Chezmoi already initialized. Only updating."
        chezmoi update --apply
    else
        echo "Chezmoi needs to be initialized."
        chezmoi init --apply Bubbelb
    fi
}

main $*
