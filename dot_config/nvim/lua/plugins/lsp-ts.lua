-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- LSP / Treesitter plugins
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
return {
    -- LSP, DAP installer
    { 'VonHeikemen/lsp-zero.nvim',        branch = 'v3.x' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { 'L3MON4D3/LuaSnip' },
    {
        'petertriho/cmp-git',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        opts = {
            ensure_installed = { all },
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            rainbow = {
                enable = true,
                query = 'rainbow-parens',
                extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
                max_file_lines = nil, -- Do not enable for files with more than n lines, int
            },
        },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)
        end,
        dependencies = {
            'HiPhish/rainbow-delimiters.nvim',
        },
    },
    { 'nvim-treesitter/nvim-treesitter-refactor' }, -- Refactor (Highlighting, smart rename, navigation)
    {
        'HiPhish/rainbow-delimiters.nvim',        -- Highlight paranthesis pairs in their own colour.
    },
    {
        'cuducos/yaml.nvim',
        opts = {
            ft = { "yaml" }, -- optional
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-telescope/telescope.nvim" -- optional
        },
        config = function()
            yaml = require('yaml_nvim')
        end,
    },
    -- Comment plugin
    {
        'numToStr/Comment.nvim',
        lazy = false,
        config = function()
            require('Comment').setup()
        end,
    },
    -- ==============================================================
    -- Add LSP extra's
    -- ==============================================================
    {
        'nvimdev/lspsaga.nvim',
        config = function()
            require('lspsaga').setup({})
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter', -- optional
            'nvim-tree/nvim-web-devicons', -- optional
        }
    },
    -- ==============================================================
    -- ==============================================================
}
