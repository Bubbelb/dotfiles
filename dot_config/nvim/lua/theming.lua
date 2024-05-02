-- Set location for correct sunset
--
-- https://github.com/Hoffs/theme-sunset.nvim

vim.g.theme_sunset_location_latitude = '52.3673008'
vim.g.theme_sunset_location_longtitude = '4.8998197'

-- Indent Guide options
--
-- https://github.com/kdheepak/tabline.nvim
--
vim.g.indent_guides_color_change_percent = 5
vim.g.indent_guides_enable_on_vim_startup = 1
vim.g.indent_guides_exclude_filetypes = { 'md' }

vim.opt.sessionoptions:append( { 'tabpages', 'globals' } ) -- store tabpages and globals in session
