if status --is-interactive ; and set -q SSH_TTY ; and ! test "$TMUX_AT_LOGIN" = 0 ; and ! set -q TMUX
    exec tmux new -A -s Default
end

## Run fastfetch as welcome message
function fish_greeting
    fastfetch
end

# Set settings for https://github.com/franciscolourenco/done
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low

## Environment setup
# Apply .profile: use this to put fish compatible .profile stuff in
if test -f ~/.fish_profile
  source ~/.fish_profile
end

# Set VI keybindings
set -g fish_key_bindings fish_vi_key_bindings

# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

# Setup yazi prompt plugin specs for fish. Based on Tide prompt.
function _tide_item_yazi
    set -l upid (cat /proc/$fish_pid/status | string match -er '^PPid:' | string replace -r '^.*:\s+' '' | string trim)
    while cat /proc/$upid/comm | string match -qr '^.*/?fish$'
      set upid (cat /proc/$upid/status | string match -er '^PPid:' | string replace -r '^.*:\s+' '' | string trim)
    end
    if cat /proc/$upid/comm | string match -qr '^.*/?yazi$'
      _tide_print_item yazi $tide_yazi_icon
    end
end

set -U tide_yazi_bg_color CCFFE5
set -U tide_yazi_color CCFF00
set -U tide_yazi_icon '🦆'
funcsave -q _tide_item_yazi

if ! contains 'yazi' $tide_left_prompt_items
    set -Up tide_left_prompt_items
end

## Functions
# Functions needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

# Fish command history
function history
    builtin history --show-time='%F %T '
end

if not test -f $HOME/.config/fish/functions/fisher.fish ; and not set -q running_fisher_install
    set --local -x running_fisher_install on
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
end

theme_gruvbox dark medium
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

function tconf
  tide configure  \
                    --auto \
                    --style=Rainbow \
                    --prompt_colors='True color' \
                    --show_time='24-hour format' \
                    --rainbow_prompt_separators=Angled \
                    --powerline_prompt_heads=Sharp \
                    --powerline_prompt_tails=Flat \
                    --powerline_prompt_style='Two lines, character and frame' \
                    --prompt_connection=Solid \
                    --powerline_right_prompt_frame=No \
                    --prompt_connection_andor_frame_color=Lightest \
                    --prompt_spacing=Sparse \
                    --icons='Many icons' \
                    --transient=No
end

zoxide init fish | source
