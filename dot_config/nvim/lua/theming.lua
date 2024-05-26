-- Indent Guide options
--
-- https://github.com/kdheepak/tabline.nvim
--
vim.g.indent_guides_color_change_percent = 5
vim.g.indent_guides_enable_on_vim_startup = 1
vim.g.indent_guides_exclude_filetypes = { 'md' }

vim.opt.sessionoptions:append( { 'tabpages', 'globals' } ) -- store tabpages and globals in session
