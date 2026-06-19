function fish_command_not_found
    # "In a container" check
    if grep -qsFx 'name="bbsh"' /run/.containerenv
        if distrobox-host-exec /usr/bin/env sh -c "command -v $argv[1]" &> /dev/null
            echo "Running '$argv[1]' on host OS." >&2
            distrobox-host-exec $argv
        else
            echo "Command '$argv[1]' not fond in bbsh nor host OS." >&2
            return 127
        end
    else
        __fish_default_command_not_found_handler $argv
    end
end
