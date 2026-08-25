#!/usr/bin/env bash

PKGS_ARCH=( \
    bat bat-extras eza fd ripgrep trash-cli rsync file sshfs yazi curl most ouch \
    mediainfo ffmpeg poppler 7zip zoxide imagemagick chafa \
    btop ncurses fastfetch chezmoi lazygit \
    fzf ncdu \
    neovim github-cli python-pynvim tree-sitter-cli \
    gcc make nodejs npm yarn dotnet-host dotnet-runtime \
    python python-pip \
    wl-clipboard libnotify \
    fish fisher jq shfmt \
    docker openssl socat ldns mosh kitty-terminfo \
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

ONLY_REPORT=0
CHEZMOI_REPO=Bubbelb

SCRIPT_NAME=term_config.sh

function arch-install-pkg() {
    MLIST=($(comm -23 <(echo "${PKGS_ARCH[@]}" | tr -s ' ' $'\n' | sort -u) <(pacman -Qsq | sort)))
    if [[ "${ONLY_REPORT}" == 0 ]] ; then
        if [[ "${#MLIST[@]}" -gt 0 ]] ; then
            echo "Missing packages. Installing them."
            if [[ ${DO_SUDO} -eq 1 ]] ; then
                sudo pacman -S --noconfirm ${MLIST[@]}
            else
                pacman -S --noconfirm ${MLIST[@]}
            fi
            MLIST=($(comm -23 <(echo "${PKGS_ARCH[@]}" | tr -s ' ' $'\n' | sort -u) <(pacman -Qsq | sort)))
            if [[ "${#MLIST[@]}" -gt 0 ]] ; then
                echo "Not all packages installed as planed."
                return 1
            fi
        else
            echo "All packages are accounted for."
        fi
    elif [[ "${#MLIST[@]}" -gt 0 ]] ; then
        echo "Warning. Missing packages for complete shell experience. Run ${SCRIPT_NAME} to update."
    fi
}

function alpine-install-pkg() {
    REPORTCOUNT=0
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
        if [[ "${ONLY_REPORT}" == 0 ]] ; then
            if [[ "${#MLIST[@]}" -gt 0 ]] ; then
                echo "Missing packages from repo '${ANAME}'. Installing them."
                if [[ -z "${AREPO}" ]] ; then
                    if [[ ${DO_SUDO} -eq 1 ]] ; then
                        sudo apk add ${MLIST[@]}
                    else
                        apk add ${MLIST[@]}
                    fi
                else
                    if [[ ${DO_SUDO} -eq 1 ]] ; then
                        sudo apk add --no-cache --repository="${AREPO}" ${MLIST[@]}
                    else
                        apk add --no-cache --repository="${AREPO}" ${MLIST[@]}
                    fi
                fi
                MLIST=($(comm -23 <(echo "${ALIST[@]}" | tr -s ' ' $'\n' | sort -u) <(apk list -q | sort)))
                if [[ "${#MLIST[@]}" -gt 0 ]] ; then
                    echo "Not all packages installed as planed."
                    return 1
                fi
            else
                echo "All packages are accounted for."
            fi
        else
            ((REPORTCOUNT+=${#MLIST[@]}))
        fi
    done

    if [[ "${ONLY_REPORT}" == 0 ]] && [[ "${REPORTCOUNT}" -gt 0 ]] ; then
        echo "Warning. Missing packages for complete shell experience. Run ${SCRIPT_NAME} to update."
    fi
}

function deb-install-pkg() {
    echo "Not yet implemented."
    return 1
}

function chezmoi_oneshot() {
    sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --one-shot ${CHEZMOI_REPO}
}

function chezmoi_init() {
    [[ -d ${HOME}/.local/bin ]] || mkdir -p ${HOME}/.local/bin
    sh -c "$(curl -fsLS https://get.chezmoi.io)" -- -b ${HOME}/.local/bin init --apply ${CHEZMOI_REPO}
}

function install-pkg() {
    if [[ "${ONLY_REPORT}" == "0" ]] ; then
        echo "Checking missing packages and installing them..."
    fi
    ran_ok=0
    case "$(print_dist)" in
        arch )
            arch-install-pkg && ran_ok=1 ;;
        debian )
            deb-install-pkg && ran_ok=1 ;;
        alpine )
            alpine-install-pkg && ran_ok=1 ;;
        * )
            if [[ "${ONLY_REPORT}" == "0" ]] ; then
                echo "Error, no package manager found. (apt-get, apk, pacman). Can't continue."
                echo "Consider using '-o', or '-i'."
            else
                echo "Package manager not found."
            fi
            ;;
    esac

    if [[ "${ran_ok}" == "1" ]] \
            && [[ "${ONLY_REPORT}" == "0" ]] \
            && [[ ! -f /etc/term-config ]]
    then
        if [[ ${DO_SUDO} -eq 1 ]] ; then
            sudo touch /etc/term-config
        else
            touch /etc/term-config
        fi
    fi
    [[ "${ran_ok}" == "1" ]]
    return $?
}

function chezmoi_regular() {
    if command -v chezmoi >/dev/null ; then
		if [[ -f "${HOME}/.local/share/chezmoi/.git/index" ]] ; then
			echo "Chezmoi already initialized. Only updating."
			chezmoi update --apply
		else
			echo "Chezmoi needs to be initialized."
			chezmoi init --ssh --apply Bubbelb
		fi
    else
        echo "Error: Chezmoi not found. Consider -i, -o, pr -p" >&2
	fi
}

function print_dist() {
    if command -v pacman >/dev/null  ; then
        echo "arch"
    elif command -v apt-get >/dev/null ; then
        echo "debian"
    elif command -v apk >/dev/null ; then
        echo "alpine"
    elif command -v rpm >/dev/null ; then
        echo "rpm"
    else
        echo "unknown"
    fi
}

function show_help() {
    cat << EOF
    Terminal Configurer. Setup everything for desired terminal beviour.

    Usage:
        term-config.sh [-o|-i|-p|-c|-r|-h]

    Parameters:
        -o  Do a one-shot Chezmoi sync, without installing Chezmoi
        -i  Install and initialize Chezmoi into homedir (~/.local/bin)
        -p  Package Install (Needs sudo)
        -P  Package Install as root (Without sudo)
        -c  Initialize/Update Chezmoi, using installed package
        -r  Report about missing packages
        -h  Show this help.

    Notes:
     - When no parameter is given, options -p and -c are assumed.
     - The script will only act on the first parameter given. The rest is ignored.
     - After installing packages, a file '/etc/term-config' is created to tell chezmoi
        the complete set of packages is installed and the full set of configurations
        can be applied.
     - Only the option with no parameters will ask for confirmation to proceed.
     - For '-P', user must be root. For any other option, a normal user (UID>=1000) is required.
EOF
}

function print_header() {
    echo -e "${SCRIPT_NAME} - Terminal configuration. '${SCRIPT_NAME} -h' for help.\n" >&2
}

# Main routine

if [[ "$1" == "-P" ]] && [[ $UID -ne 0 ]]
then
    print_header
    echo "Error: The -P option requires that this script be run as root." >&2
    exit 2
elif [[ "$1" != "-P" ]] && [[ $UID -lt 1000 ]]
then
    print_header
    echo "Error: This option only works as a generic user. See -h for help." >&2
    exit 3
fi

if [[ -z "$1" ]] ; then
    print_header
    read -p "Are you sure to install terminal packages and configure chezmoi? (y/n): " -n 1 -s ANSWER
    if [[ "${ANSWER^}" == "Y" ]] ; then
        echo -e "Yes\n"
        ONLY_REPORT=0
        install-pkg
        chezmoi_regular
    else
        echo -e "No\n"
    fi
else
    case "$1" in
        '-o' ) print_header ; chezmoi_oneshot ;;
        '-i' ) print_header ; chezmoi_init ;;
        '-p' ) print_header ; DO_SUDO=1 ; ONLY_REPORT=0 ; install-pkg ;;
        '-P' ) DO_SUDO=0 ; ONLY_REPORT=0 ; install-pkg ;;
        '-c' ) print_header ; chezmoi_regular ;;
        '-r' ) ONLY_REPORT=1 ; install-pkg ;;
        '-h' ) show_help ;;
        * ) print_header ; echo "Unknown parameter." ;;
    esac
fi
