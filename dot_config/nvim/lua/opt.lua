    -- Basic options

vimx.opt.hlsearch = true
vimx.opt.langremap = false
vimx.opt.shada = "'50,/200,:200,<500,s500,:200,h"
vimx.opt.mouse = 'a'
vimx.opt.undofile = true
vimx.opt.softtabstop = 4
vimx.opt.expandtab = true
vimx.opt.smarttab = true
vimx.opt.smartindent = true
vimx.opt.tabstop = 4
vimx.opt.shiftwidth = 4
vimx.opt.termguicolors = true
vimx.opt.modeline = true
vimx.opt.undofile = true       -- keep an undo file (undo changes after closing)
vimx.opt.wrap = false         -- don't automatically wrap on load
vimx.opt.showmode = true    -- do not show default mode message (Use airline for this)
vimx.opt.clipboard = 'unnamedplus' -- Use system clipboard
vimx.opt.sessionoptions = {'blank', 'buffers', 'curdir', 'folds', 'help', 'tabpages', 'winsize', 'winpos', 'terminal'}
vimx.opt.completeopt = {'menuone', 'noinsert', 'noselect'}
vimx.opt.shortmess = vimx.opt.shortmess + { c = true }

vimx.g.completion_enable_auto_popup = 0

-- Remove trailing whitespaces upon save
vimx.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = '%s/\\s\\+$//e',
})

-- Diagnostics signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vimx.fn.sign_define(hl, { text = icon, texthl= hl, numhl = hl })
end
