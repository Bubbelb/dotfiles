-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- File Explorer
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
return {
    {
      'nvim-neo-tree/neo-tree.nvim',
      keys = {
        { "<Leader>e", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
      },
      opts = {
          close_if_last_window = true,
          enable_git_status = false,
          filesystem = {
              follow_current_file = { enabled = true },
          },
      },
      dependencies = {
        'nvim-tree/nvim-web-devicons',
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
      },
    },
}
