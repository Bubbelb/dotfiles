return {
    {
      "okuuva/auto-save.nvim",
      -- version = '*',
      cmd = "ASToggle", -- optional for lazy loading on command
      event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
      keys = {
                { "<leader>sa", "<cmd>ASToggle<CR>", desc = "Toggle auto-save" },
      },
      opts = {
          enabled = false,
        -- your config goes here
        -- or just leave it empty :)
      },
    },
}
