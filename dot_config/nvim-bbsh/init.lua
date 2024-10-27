-- Remove unused plugins
local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "vimball",
    "vimballPlugin"
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end

-- Bbootstrap Lazy package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Start Lazy Package manager
vim.g.mapleader = "\\"
opts = {
    checker = {
    -- automatically check for plugin updates
        enabled = true,
        concurrency = 6, ---@type number? set to 1 to check for updates very slowly
        notify = true, -- get a notification when new updates are found
        frequency = 259200, -- check for updates ecery 3 days
  },
}
require("lazy").setup("plugins", opts)
require('opt')
require('mappings')
require('lsp')
require('nvim-cmp')

-- For LSP to work (with LSP installer run:
-- pacman -S unzip python-pip npm yarn
--
-- For Telescope to function optionally run:
-- pacman -S fd ripgrep
--
-- Of course change according to distro...

