-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Yazi as File Explorer
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
return {
    {
      "mikavilpas/yazi.nvim",
      version = "*",
      event = "VeryLazy",
      keys = {
        { "<Leader>yy", "<cmd>Yazi toggle<cr>", desc = "Toggle Yazi" },
        { "<Leader>yd", "<cmd>Yazi cwd<cr>", desc = "Yazi in cwd" },
        { "<Leader>yf", "<cmd>Yazi<cr>", desc = "Yazi at current file" },
      },
      opts = {
        open_for_directories = false,
        keymaps = {
          show_help = "<f1>",
        },
      },
      init = function()
        vim.g.loaded_netrwPlugin = 1
      end,
      dependencies = {
        { "nvim-lua/plenary.nvim", lazy = true },
      },
    },
}
