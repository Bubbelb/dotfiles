#!/usr/bin/env sh

CMDIR="$(chezmoi data | yq -r '.chezmoi.sourceDir')"

GITPULLURL="$(git -C ${CMDIR} remote get-url origin)"
GITPUSHURL="$(git -C ${CMDIR} remote get-url --push origin)"

if echo "{GITPULLURL}" | grep -q '^https:' ; then
    GITUSER="$(echo "${GITPULLURL}" | sed 's_^https\?://.*/\([^/]\+\)/[^/]\+\.git$_\1_')"
    GITREPO="$(echo "${GITPULLURL}" | sed 's_^https\?://.*/[^/]\+/\([^/]\+\)\.git$_\1_')"
    GITHOST="$(echo "${GITPULLURL}" | sed 's_^https\?://\([^/]\+\)/.*\.git$_\1_')"
    GITPROTO="$(echo "${GITPULLURL}" | sed 's_^\(https\?\)://.*\.git$_\1_')"
elif echo "${GITPULLURL}" | grep -q '^git@' ; then
    GITUSER="$(echo "${GITPULLURL}" | sed -e 's_^git@[^:]\+:\(.\+\)/[^/]\+\.git$_\1_' -e 's_^.*/__')"
    GITREPO="$(echo "${GITPULLURL}" | sed 's_^git@[^:]\+.*/\([^/]\+\)\.git$_\1_')"
    GITHOST="$(echo "${GITPULLURL}" | sed 's_^git@\([^:]\+\)\+:.*\.git$_\1_')"
    GITPROTO="https"
else
    echo "ERROR: GIT TRAMSPORT PROTOCOL NOT KNOWN!" >&2
    exit 1
fi


git -C ${CMDIR} remote set-url origin "${GITPROTO}://${GITHOST}/${GITUSER}/${GITREPO}.git"
git -C ${CMDIR} remote set-url origin --push "git@${GITHOST}:${GITUSER}/${GITREPO}.git"

