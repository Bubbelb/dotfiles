-- Basic options

vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.langremap = false
vim.opt.shada = "'50,/200,:200,<500,s500,:200,h"
vim.opt.mouse = 'a'
vim.opt.undofile = true
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.termguicolors = true
vim.opt.modeline = true
vim.opt.undofile = true
vim.opt.wrap = false
vim.opt.showmode = true    -- do not show default mode message (Use airline for this)
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
vim.opt.sessionoptions = {'blank', 'buffers', 'curdir', 'folds', 'help', 'tabpages', 'winsize', 'winpos', 'terminal'}
vim.opt.completeopt = {'menuone', 'noinsert', 'noselect'}
vim.opt.shortmess = vim.opt.shortmess + { c = true }

vim.g.completion_enable_auto_popup = 0

-- Remove trailing whitespaces upon save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = '%s/\\s\\+$//e',
})

-- Diagnostics signs
local signs = { Error = '⛔', Warn = "⚠️ ", Hint = "🔔", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl= hl, numhl = hl })
end

