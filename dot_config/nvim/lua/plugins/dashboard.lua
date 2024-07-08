return {
    {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        opts = {
            config = {
                header = {'Bubbel',''},
                shortcut = {
                    -- action can be a function type
                    { desc = '🏗️  Projects', group = 'DashboardHeader', key = 'P', action = 'Telescope neovim-project discover' },
                    { desc = '⏳  Latest (Most recent accessed) Project', group = 'DashboardHeader', key = 'L', action = 'NeovimProjectLoadRecent' },
                    { desc = '⛑️  Update', group = 'DashboardFooter', key = 'U', action = 'Lazy sync | TSUpdateSync | MasonUpdate' },
                    { desc = '📛 Quit Dashboard', group = 'DashboardFooter', key = 'x', action = 'bd' },
                    { desc = '⏻  Quit Neovim', group = 'DashboardFooter', key = 'q', action = 'qa' },
                    { desc = '⚠️  Force Quit Neovim', group = 'DashboardFooter', key = 'Q', action = 'qa!' },
                },
                packages = { enable = false }, -- show how many plugins neovim loaded
                -- limit how many projects list, action when you press key or enter it will run this action.
                -- action can be a functino type, e.g.
                -- action = func(path) vim.cmd('Telescope find_files cwd=' .. path) end
                project = { enable = true },
                mru = { limit = 10, icon = '⏳', label = '  Recent files', cwd_only = false },
                footer = {}, -- footer
            },
        },
        -- config = function()
        --     require('dashboard').setup {
        --         -- config
        --     }
        -- end,
        keys = {
            { "<Leader>d", "<cmd>Dashboard<cr>", desc = "Show Dashboard"
            },
        },
        dependencies = { { 'nvim-tree/nvim-web-devicons' } }
    },
}
