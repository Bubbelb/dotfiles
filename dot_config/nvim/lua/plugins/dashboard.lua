return {
    {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        opts = {
            config = {
                shortcut = {
                    -- action can be a function type
                    { desc = '🏗️  Projects', group = 'DashboardFooter', key = 'P', action = 'Telescope neovim-project discover' },
                },
                packages = { enable = false }, -- show how many plugins neovim loaded
                -- limit how many projects list, action when you press key or enter it will run this action.
                -- action can be a functino type, e.g.
                -- action = func(path) vim.cmd('Telescope find_files cwd=' .. path) end
                project = { enable = false },
                mru = { limit = 10, icon = '⏳', label = '  Recent files', cwd_only = false },
                footer = {}, -- footer
            },
        },
        -- config = function()
        --     require('dashboard').setup {
        --         -- config
        --     }
        -- end,
        dependencies = { { 'nvim-tree/nvim-web-devicons' } }
    },
}