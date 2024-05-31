-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- File Explorer
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
return {
    -- {
    --   'nvim-neo-tree/neo-tree.nvim',
    --   keys = {
    --     {
    --       "<Leader>e",
    --       "<cmd>Neotree toggle<cr>",
    --       desc = "NeoTree"
    --     },
    --   },
    --   config = function()
    --     require("neo-tree").setup()
    --   end,
    --   dependencies = {
    --     'nvim-tree/nvim-web-devicons',
    --     "nvim-lua/plenary.nvim",
    --     "MunifTanjim/nui.nvim",
    --   },
    -- },
    {
        'nvim-tree/nvim-tree.lua',
        keys = {
            {
                "<Leader>e",
                "<cmd>NvimTreeToggle<cr>",
                desc = "NeoTree"
            },
        },
        opts = {
            sync_root_with_cwd = true,
            respect_buf_cwd = true,
            update_focused_file = {
                enable = true,
                update_root = true
            },
        },
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            "nvim-lua/plenary.nvim",
            -- "MunifTanjim/nui.nvim",
        },
    },
}
