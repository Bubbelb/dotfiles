return {
    {
        "NeogitOrg/neogit",
        keys = {
            { "<Leader>go", "<cmd>Neogit<cr>",           desc = "Open the Neogit status buffer." },
            { "<Leader>gf", "<cmd>Neogit cwd=%:p:h<cr>", desc = "Uses the repository of the current file." },
            { "<Leader>gc", "<cmd>Neogit commit<cr>",    desc = "Open commit popup." },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",  -- required
            "sindrets/diffview.nvim", -- optional - Diff integration
            "nvim-telescope/telescope.nvim", -- optional
        },
        config = true
    }
}
