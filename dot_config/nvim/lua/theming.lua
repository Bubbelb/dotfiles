-- Set location for correct sunset
--
-- https://github.com/Hoffs/theme-sunset.nvim

vimx.g.theme_sunset_location_latitude = '52.3673008'
vimx.g.theme_sunset_location_longtitude = '4.8998197'

-- Indent Guide options
--
-- https://github.com/kdheepak/tabline.nvim
--
vimx.g.indent_guides_color_change_percent = 5
vimx.g.indent_guides_enable_on_vim_startup = 1
vimx.g.indent_guides_exclude_filetypes = { 'md' }

vimx.opt.sessionoptions:append( { 'tabpages', 'globals' } ) -- store tabpages and globals in session
