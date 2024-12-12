-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- LSP / Treesitter plugins
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
return {
    -- LSP, DAP installer
    { 'VonHeikemen/lsp-zero.nvim',        branch = 'v3.x' },
    { 'williamboman/mason.nvim',
      dependencies = {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
},
    { 'williamboman/mason-lspconfig.nvim' },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    {
        'L3MON4D3/LuaSnip',
        build = 'make install_jsregexp',
        dependencies = { "rafamadriz/friendly-snippets" },
    },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'rafamadriz/friendly-snippets' },
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
        'HiPhish/rainbow-delimiters.nvim',          -- Highlight paranthesis pairs in their own colour.
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
    -- Add LSP Saga
    -- ==============================================================
    {
        'nvimdev/lspsaga.nvim',
        config = function()
            require('lspsaga').setup({})
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter', -- optional
            'nvim-tree/nvim-web-devicons',     -- optional
        }
    },
    -- ==============================================================
    -- Add Linter
    -- ==============================================================
    {
        "mfussenegger/nvim-lint",
        event = {
            "BufReadPre",
            "BufNewFile",
        },
        config = function()

            local lint = require("lint")

            lint.linters_by_ft = {
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
                javascriptreact = { "eslint_d" },
                typescriptreact = { "eslint_d" },
                svelte = { "eslint_d" },
                kotlin = { "ktlint" },
                terraform = { "tflint" },
                markdown = { "markdownlint" },
                yaml = { "yamllint" },
                json = { "jsonlint" },
            }
        local mdlint = require('lint').linters.markdownlint
        mdlint.args = { "--disable", "MD013", "--" }

            local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                group = lint_augroup,
                callback = function()
                  lint.try_lint()
                end,
            })

            vim.keymap.set("n", "<leader>ll", function()
                lint.try_lint()
            end, { desc = "Trigger linting for current file" })
        end,
        dependencies = {
            "rshkarin/mason-nvim-lint",
        },
    },

    -- ==============================================================
    -- Toggle diagnostics on/off
    -- ==============================================================
    -- {
    --     'WhoIsSethDaniel/toggle-lsp-diagnostics.nvim',
    --   keys = {
    --    { "<Leader>xD", "<cmd>lua require('toggle_lsp_diagnostics').toggle_diagnostics()<cr>", desc = "Toggle All Diagnostic display" },
    --     { "<Leader>xT", "<cmd>lua require('toggle_lsp_diagnostics').toggle_virtual_text()<cr>", desc = "Toggle Diagnostic Texts display" },
    --     { "<Leader>xS", "<cmd>lua require('toggle_lsp_diagnostics').toggle_virtual_signs()<cr>", desc = "Toggle Diagnostic Signs display" },
    --     { "<Leader>xR", "<cmd>lua require('toggle_lsp_diagnostics').turn_on_default_diagnostics()<cr>", desc = "Reset Diagnostics display" },
    --   },
    -- },
    -- -- ==============================================================
    -- -- ==============================================================
}
