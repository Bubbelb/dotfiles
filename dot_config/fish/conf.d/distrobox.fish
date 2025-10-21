if status --is-interactive ; and test -f /run/.containerenv ; and grep -q 'name="bbsh"' /run/.containerenv
    test -z "$USER" && set -gx USER (id -un 2> /dev/null)
    test -z "$UID"  && set -gx UID (id -ur 2> /dev/null)
    test -z "$EUID" && set -gx EUID (id -u  2> /dev/null)
    set -gx SHELL (getent passwd "$USER" | cut -f 7 -d :)

    test -z "$XDG_RUNTIME_DIR" && set -gx XDG_RUNTIME_DIR /run/user/(id -ru)
    test -z "$DBUS_SESSION_BUS_ADDRESS" && set -gx DBUS_SESSION_BUS_ADDRESS unix:path=/run/user/(id -ru)/bus

    # Ensure we have these two variables from the host, so that graphical apps
    # also work in case we use a login session
    if test -z $XAUTHORITY
        set -gx XAUTHORITY (host-spawn sh -c "printf "%s" \$XAUTHORITY")
        # if the variable is still empty, unset it, because empty it could be harmful
        test -z $XAUTHORITY ; and set -e XAUTHORITY
    end
    if test -z $XAUTHLOCALHOSTNAME
        set -gx XAUTHLOCALHOSTNAME (host-spawn sh -c "printf "%s" \$XAUTHLOCALHOSTNAME")
        test -z $XAUTHLOCALHOSTNAME ; and set -e XAUTHLOCALHOSTNAME
    end
    if test -z $WAYLAND_DISPLAY
        set -gx WAYLAND_DISPLAY (host-spawn sh -c "printf "%s" \$WAYLAND_DISPLAY")
        test -z $WAYLAND_DISPLAY ; and set -e WAYLAND_DISPLAY
    end
    if test -z $DISPLAY
        set -gx DISPLAY (host-spawn sh -c "printf "%s" \$DISPLAY")
        test -z $DISPLAY ; and set -e DISPLAY
    end

    # This will ensure we have a first-shell password setup for an user if needed.
    # We're going to use this later in case of rootful containers
    if test -e /var/tmp/.$USER.passwd.initialize
        echo "⚠️  First time user password setup ⚠️ "
        trap "echo; exit" INT
        passwd && rm -f /var/tmp/.$USER.passwd.initialize
        trap - INT
    end
end

if test -f /run/.containerenv ; and grep -q 'name="bbsh"'; and fcrontab -l 2>&1 | grep -Fq "INFO user $USER has no fcrontab." ; and type -q fcrontab
    function edfc
        sleep 1
        cat $HOME/.config/fcrontab > $argv
    end
    VISUAL=edfc fcrontab -e
end
