-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- File Explorer
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    keys = {
      {
        "<Leader>tt",
        "<cmd>Neotree toggle<cr>",
        desc = "NeoTree"
      },
    },
    config = function()
      require("neo-tree").setup()
    end,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
  },
}

