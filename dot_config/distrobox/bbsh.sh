#!/bin/sh

function install_ouch() {
	if ! [[ -f /usr/local/bin/ouch ]] ; then 
		wget -qO- "$(wget -qO- https://api.github.com/repos/ouch-org/ouch/releases/latest \
			| jq -r '.assets[] | select( .name | match("'$(uname -m)'-unknown-linux-musl\.tar\.gz$") | .browser_download_url' \
		    | tar xz -C /usr/local/bin/ --strip-components=2
	fi
}

function install_bat_extras() {
	if ! [[ -f /usr/local/bin/batman ]] ; then
		mkdir -p /tmp/bat-extras
		wget -qO- "$(wget -qO- https://api.github.com/repos/eth-p/bat-extras/releases/latest | jq -r '.tarball_url')" \
			| tar -xz -C /tmp/bat-extras --strip-components=1 && \
				/tmp/bat-extras/build.sh --prefix=/usr/local/bin/ --install
	fi
}
		

# Main

install_bat_extras && \
install_ouch && \
touch /etc/bbsh_post_install.done
