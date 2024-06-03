-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Theming, colors
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
return {
    -- ==============================================================
    -- Theme selection
    -- ==============================================================
    {
        'nvim-tree/nvim-web-devicons',
        opts = {
            override = {
                zsh = {
                    icon = "",
                    color = "#428850",
                    name = "Zsh"
                },
            },
            default = true,
        },
    }, -- Colors and icons to use
    -- ==============================================================
    -- Switch dark/light theme on light/day times
    -- ==============================================================
    {
        'JManch/sunset.nvim',
        lazy = false,
        priority = 1000,
        opts = {
            latitude = 52.54258,   -- north is positive, south is negative
            longitude = 4.66164,   -- east is positive, west is negative
            sunrise_offset = 1200, -- offset the sunrise by this many seconds
            sunset_offset = -1200, -- offset the sunset by this many seconds
            day_callback = function()
                vim.o.background = 'light'
                require('NeoSolarized').setup({ style = 'light', transparent = false, terminal_colors = true })
                vim.cmd.colorscheme('NeoSolarized')
            end,
            night_callback = function()
                vim.o.background = 'dark'
                require('NeoSolarized').setup({ style = 'dark', transparent = false, terminal_colors = true })
                vim.cmd.colorscheme('NeoSolarized')
            end,

        },
        dependencies = {
            {
                'Tsuzat/NeoSolarized.nvim', -- Gruvbox theme set
                lazy = false,
                opts = {
                    style = 'dark',
                    transparent = false,
                    terminal_colors = true,
                },
                config = function()
                    vim.cmd.colorscheme('NeoSolarized')
                end,
            },
        },
    },
    -- ==============================================================
    -- Configure tab and statusline
    -- ==============================================================
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            options = {
                icons_enabled = true,
                theme = 'NeoSolarized',
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                disabled_filetypes = {}
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch' },
                lualine_c = { { 'filename', file_status = true, path = 2 } },
                lualine_x = { 'fileformat', 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { { 'filename', file_status = true, path = 2 } },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {
                lualine_a = {
                    {
                        'buffers',
                        show_filename_only = false,
                        hide_filename_extension = false,
                        show_modified_status = true,
                        mode = 0, -- 0: Shows buffer name
                        -- 1: Shows buffer index
                        -- 2: Shows buffer name + buffer index
                        -- 3: Shows buffer number
                        -- 4: Shows buffer name + buffer number

                        max_length = vim.o.columns * 4 / 5, -- Maximum width of buffers component,
                        -- it can also be a function that returns
                        -- the value of `max_length` dynamically.
                        filetype_names = {
                            TelescopePrompt = 'Telescope',
                            dashboard = 'Dashboard',
                            packer = 'Packer',
                            fzf = 'FZF',
                            alpha = 'Alpha'
                        }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )
                        symbols = {
                            modified = ' ●', -- Text to show when the buffer is modified
                            alternate_file = '#', -- Text to show to identify the alternate file
                            directory = '', -- Text to show when the buffer is a directory
                        },

                    }
                },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = { 'tabs' }
            },
            extensions = {}
        },
    },
    -- ==============================================================
    -- Place indent guides on the left
    -- ==============================================================
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            local ftman = vim.bo.filetype == 'man'
            local ftdash = vim.bo.filetype == 'dashboard'
            if not ftdash and not ftman then
                local highlight = {
                    "RainbowRed",
                    "RainbowYellow",
                    "RainbowBlue",
                    "RainbowOrange",
                    "RainbowGreen",
                    "RainbowViolet",
                    "RainbowCyan",
                }

                local hooks = require "ibl.hooks"
                -- create the highlight groups in the highlight setup hook, so they are reset
                -- every time the colorscheme changes
                hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
                    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
                    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
                    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
                    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
                    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
                    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
                end)

                require("ibl").setup { indent = { highlight = highlight } }
            end
        end,
        main = "ibl",
        opts = {},
    },
    -- ==============================================================
    -- Manipulate surrounding quotes, brackets, etc.
    -- ==============================================================
    { 'tpope/vim-surround' },
    -- ==============================================================
    -- ==============================================================
}
