function fish_command_not_found
    # "In a container" check
    if grep -qsFx 'name="bbsh"' /run/.containerenv
        distrobox-host-exec $argv
    else
        __fish_default_command_not_found_handler $argv
    end
end
