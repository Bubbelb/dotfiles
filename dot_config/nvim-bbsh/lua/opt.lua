-- Basic options

vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.langremap = false
vim.opt.shada = "'50,/200,:200,<500,s500,:200,h"
vim.opt.mouse = 'a'
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.termguicolors = true
vim.opt.modeline = true
vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.wrap = false
vim.opt.showmode = true
vim.opt.clipboard = 'unnamed'
vim.opt.sessionoptions = {'blank', 'buffers', 'curdir', 'folds', 'help', 'tabpages', 'winsize', 'winpos', 'terminal'}
vim.opt.completeopt = {'menuone', 'noinsert', 'noselect'}
vim.opt.shortmess = vim.opt.shortmess + { c = true }

vim.g.completion_enable_auto_popup = 0

-- Undo/Swap/Backup

SWAPDIR = os.getenv("HOME") .. "/.local/share/nvim/swap/"
BACKUPDIR = os.getenv("HOME") .. "/.local/share/nvim/backup/"
UNDODIR = os.getenv("HOME") .. "/.local/share/nvim/undo/"

if vim.fn.isdirectory(SWAPDIR) == 0 then
	vim.fn.mkdir(SWAPDIR, "p", "0o700")
end

if vim.fn.isdirectory(BACKUPDIR) == 0 then
	vim.fn.mkdir(BACKUPDIR, "p", "0o700")
end

if vim.fn.isdirectory(UNDODIR) == 0 then
	vim.fn.mkdir(UNDODIR, "p", "0o700")
end

vim.opt.directory = SWAPDIR
vim.opt.backupdir = BACKUPDIR
vim.opt.undodir = UNDODIR
vim.opt.swapfile = true
vim.opt.backup = true
vim.opt.undofile = true


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

-- Setup the spell checker
vim.opt.spell = true
vim.opt.spelllang = 'en_gb'

-- Toggle Diagnostics
vim.g.diagnostics_active = true
function _G.toggle_diagnostics()
  if vim.g.diagnostics_active then
    vim.g.diagnostics_active = false
    vim.lsp.diagnostic.clear(0)
    vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
  else
    vim.g.diagnostics_active = true
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
      }
    )
  end
end

vim.api.nvim_set_keymap('n', '<leader>xD', ':call v:lua.toggle_diagnostics()<CR>',  {noremap = true, silent = true})

if not ( vim.env.NVIM_SHELL == '' ) then
    vim.o.shell=vim.env.NVIM_SHELL
end
