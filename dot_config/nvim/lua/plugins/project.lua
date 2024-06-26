return {
    {
        "coffebar/neovim-project",
        opts = {
            projects = { -- define project roots
                "~/Projects.priv/*",
                "~/Projects.umcu/*",
           },
        dashboard_mode = true,
        },
        keys = {
            { "<Leader>pd", "<cmd>Telescope neovim-project discover<cr>", desc = "Project Discover (Find)" },
            { "<Leader>ph", "<cmd>Telescope neovim-project history<cr>",  desc = "Project History (Find)" },
            { "<Leader>pp", "<cmd>NeovimProjectLoadRecent<cr>",           desc = "Project Load Previous" },
            { "<Leader>pi", "<cmd>NeovimProjectLoadHist<cr>",             desc = "Project History (Dir)" },
            { "<Leader>pl", "<cmd>NeovimProjectLoad<cr>",                 desc = "Project Load (Dir)" },
        },
        init = function()
            -- enable saving the state of plugins in the session
            vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
        end,
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope.nvim" },
            { "Shatur/neovim-session-manager" },
        },
        lazy = false,
        priority = 100,
    },
}
