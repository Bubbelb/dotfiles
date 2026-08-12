-- Run full NeoVIM only when in bbsh, or beets container.
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

if file_exists("/etc/nvimhost") then
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
      },
      rocks = {
          enabled = false,
      },
    }
    require("lazy").setup("plugins", opts)
    require('opt')
    require('mappings')
    require('lsp')
    require('nvim-cmp')

else
    vim.cmd('source ' .. vim.fn.stdpath("config") .. '/init-basic.vim')

end
