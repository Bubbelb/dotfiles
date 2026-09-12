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

require("linemode-plus"):setup {
  date_mode = "custom",
  custom = {
    order = { "day", "month", "year" },
    separator = "-",
    year_digits = 4,
  }
}

require("yamb"):setup {
  -- Optional, the path ending with path seperator represents folder.
 --  bookmarks = bookmarks,
  -- Optional, recieve notification everytime you jump.
  jump_notify = true,
  -- Optional, the cli of fzf.
  cli = "fzf",
  -- Optional, a string used for randomly generating keys, where the preceding characters have higher priority.
  keys = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
  -- Optional, the path of bookmarks
  path = (ya.target_family() == "windows" and os.getenv("APPDATA") .. "\\yazi\\config\\bookmark") or
        (os.getenv("HOME") .. "/.local/share/yazi/bookmarks.list"),
}
