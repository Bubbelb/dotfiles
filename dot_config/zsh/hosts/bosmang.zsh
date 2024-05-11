# Per host aliases/functions and variabeles

# To-Do file handling
function sdo() {
    if [[ -f ~/TODO.md ]] ; then
        echo "=========== TODO ============== "
        mdcat ~/TODO.md
        echo "=============================== "
        echo "sdo: show this, edo: edit this. "
        echo "=============================== "
    else
        echo "~/TODO.md not found."
        echo "Issue command 'edo' to create one."
    fi
}
alias edo='nvim ~/TODO.md'
#
# CD to ansible folders
alias AP='cd ~/ansible/prod'
alias AD='cd ~/ansible/dev'
alias AT='cd ~/ansible/tst'

alias play='ansible-playbook'
function a-p() {
    ANSIBLE_FORCE_COLOR=1 ansible-playbook $* | sed 's/\\n/\n/g'
}

# Connect to given ssh host as ansible user
alias abssh='ssh -l ansboss'

# Use docker through SSH on mhost
alias doch='docker -H '\''ssh://ansboss@mhost'\'
alias dochps='docker -H '\''ssh://ansboss@mhost'\'' ps --format "table {{ .Names }}\t{{ .Image }}\t{{ .Status }}"'
alias dochip='docker -H "ssh://ansboss@mhost" ps --filter="network=External" -q | xargs docker -H "ssh://ansboss@mhost" inspect --format "{{ .NetworkSettings.Networks.External.IPAddress }} {{ .Name }}" | sort | column -t'

# Use docker through SSH on bosmang
alias docb='docker -H '\''ssh://ansboss@bosmang'\'
alias docbps='docker -H '\''ssh://ansboss@bosmang'\'' ps --format "table {{ .Names }}\t{{ .Image }}\t{{ .Status }}"'
alias docbip='docker -H "ssh://ansboss@bosmang" ps --filter="network=External" -q | xargs docker -H "ssh://ansboss@bosmang" inspect --format "{{ .NetworkSettings.Networks.External.IPAddress }} {{ .Name }}" | sort | column -t'

# Nextcloud specific aliases
alias occtst='doch exec -it nextcloud-app_tst runuser -u www-data -- /usr/local/bin/php /var/www/html/occ'
alias occdev='doch exec -it nextcloud-app_dev runuser -u www-data -- /usr/local/bin/php /var/www/html/occ'
alias occ='doch exec -it nextcloud-app runuser -u www-data -- /usr/local/bin/php /var/www/html/occ'

# Reboot bosmang through ansible user
alias reboot='abssh -t bosmang sudo /usr/bin/systemctl reboot'
