#!/bin/sh

# Update Neovim plugins and other shizzle.
# Usage: update-neovim.sh [(-i|--interval) interval] [--(no_)mason] [--(no_)lazy] [--(no_)ts] [--(no_)lsp]
#
# -i,--interval  Sets the update interval in hours. Default 168 (1 week)
# --mason,--no_mason : Enable/Disable Mason update
# --lazy,--no_lazy   : Enable/Disable plugin updates through Lazy plugin manager
# --ts,--no_ts       : Enable/Disable Tree-Sitter updates
#
# Note: All updates are enabled per default an can be turned off by the --no_... option.
# When explicitly specifying an update, all updates are off per-default, so you have to specify them.

# Silently exit if no neovim is found in the path.
if ! which nvim >/dev/null 2>&1 ; then
    exit
fi

# Status file to check when the latest update is done
UPD_STATUSFILE=~/.local/share/nvim/update_status
if [ -f "${UPD_STATUSFILE}" ] ; then
    UPD_SF_DATE="$(stat --format '%Y' "${UPD_STATUSFILE}")"
else
    UPD_SF_DATE="0"
fi

# Default values
D_INT=168 # Interval in Hours. Defaults to one week.

# Exclusive run values:
E_LAZY=false # Update plugins through Lazy plugin manager
E_MASON=false # Update LSP's through mason.
E_TS=false # Update Tree-Sitter.
EXCLUSIVE=false
# Read command-line paramters
PARAMETERS=$(getopt -q -l lazy,mason,ts,interval:,no_lazy,no_mason,no_ts -- i: "$@")
eval set -- "${PARAMETERS}"
if [ ! -z "${PARAMETERS}" ] ; then
    while [ "${1}" != '--' ] ; do
        case "${1}" in
            --lazy)  EXCLUSIVE=true ; E_LAZY=true ;;
            --mason) EXCLUSIVE=true ; E_MASON=true ;;
            --ts)    EXCLUSIVE=true ; E_TS=true ;;
            --no_lazy)  E_LAZY=false ;;
            --no_mason) E_MASON=false ;;
            --no_ts)    E_TS=false ;;
            -i|--interval) D_INT="${2}" ;;
        esac
    done
fi

if [ "$(( ( $(date '+%s') - ${UPD_SF_DATE} ) / 3600 ))" -gt "${D_INT}" ] ; then
   touch "${UPD_STATUSFILE}"
    # The real deal
    if [ "${E_LAZY}" == true ] || [ "${EXCLUSIVE}" == false ] ; then
        # Update Plugins
        nvim --headless "+Lazy! sync" +qa
    fi
    if [ "${E_MASON}" == true ] || [ "${EXCLUSIVE}" == false ] ; then
        # Update Mason
        nvim --headless "+MasonUpdate" +qa
    fi
    if [ "${E_TS}" == true ] || [ "${EXCLUSIVE}" == false ] ; then
        # Update Tree-Sitter
        nvim --headless "+TSUpdateSync" +qa
    fi
fi
