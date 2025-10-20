source $__fish_config_dir/c-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
#
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
    tide configure  --auto \
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

