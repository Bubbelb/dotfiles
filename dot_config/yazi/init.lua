require("recycle-bin"):setup()
require("sshfs"):setup({
    host_paths = {
        homeassistant = "/homeassistant",
    },
})
require("fg"):setup({
    default_action = "menu", -- nvim, jump
})

Status:children_add(function(self)
	local h = self._current.hovered
	if h and h.link_to then
		return " -> " .. tostring(h.link_to)
	else
		return ""
	end
end, 3300, Status.LEFT)

Header:children_add(function()
	if ya.target_family() ~= "unix" then
		return ""
	end
	return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
end, 500, Header.LEFT)

require("bookmarks"):setup({
	last_directory = { enable = false, persist = false, mode="dir" },
	persist = "vim",
	desc_format = "full",
	file_pick_mode = "hover",
	custom_desc_input = false,
	show_keys = true,
	notify = {
		enable = false,
		timeout = 1,
		message = {
			new = "New bookmark '<key>' -> '<folder>'",
			delete = "Deleted bookmark in '<key>'",
			delete_all = "Deleted all bookmarks",
		},
	},
})

require("linemode-plus"):setup {
  date_mode = "custom",
  custom = {
    order = { "day", "month", "year" },
    separator = "-",
    year_digits = 4,
  }
}
