-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Which key
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
return {
  {
    "folke/which-key.nvim",
    config = function()
      vimx.o.timeout = true
      vimx.o.timeoutlen = 300
      require("which-key").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
  },
}
