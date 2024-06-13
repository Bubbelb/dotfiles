if [ $(id -nu) == "bbl" ] ; then
    do_bb_init_updates() {
        echo "## Chezmoi Update: Pulling latest from GitHub"
        chezmoi git pull

        # get a list of files to update that don't have local changes
        FILES=$(chezmoi status | awk '/^ / {print $2}')

        echo -e "\n## Chezmoi Update: Updating files without local changes"

        for f in $FILES; do
          chezmoi apply ~/${f}
        done

        echo -e "\n## Chezmoi Update: Files with local changes that need adding"
        chezmoi status 1>&2

        echo -e "\n## Neovim: Update Plugins"
        nvim --headless "+Lazy! sync" +qa
        echo -e "\n## Neovim: Update Language Servers (Mason)"
        nvim --headless "+MasonUpdate" +qa
        echo -e "\n## Neovim: Update TreeSitter Languages"
        nvim --headless "+TSUpdateSync" +qa

        echo
        if [ ~/.local/bin/distrobox ] ; then
              ~/.local/bin/check-interval -n distrobox-update -i 168 -c 'echo "Distrobox: Update distrobox User install" \
              curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --prefix ~/.local'
        fi
    }
    cat < /dev/null > /dev/tcp/google.com/80 2>&1 > /dev/null && do_bb_init_updates &
else
	echo "## Switching to user 'bbl'"
	sudo -u bbl "$0" "$*"
fi
exit 0

