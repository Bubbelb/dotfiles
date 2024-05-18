-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- LSP / Treesitter
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
return {
-- LSP, DAP installer
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate', -- :MasonUpdate updates registry contents
    config = function(_, opts)
        require("mason").setup(opts)
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
        'williamboman/mason.nvim'
    },
  },
  {
    'neovim/nvim-lspconfig', -- Collection of configurations for built-in LSP client
    config = function(_, opts)
        for _, lspname in ipairs(opts) do
            require('lspconfig')[lspname].setup{}
        end
    end,
    opts = { 'ansiblels', 'bashls', 'pylsp', 'lua_ls' },
    dependencies = {
        'williamboman/mason-lspconfig.nvim'
    },
  },
  {
    'RubixDev/mason-update-all',
    cmd = { 'MasonUpdateAll' },
    config = function(_, opts)
        require('mason-update-all').setup(opts)
    end,
  },
--  {
--    'jay-babu/mason-null-ls.nvim',
--    event = { "BufReadPre", "BufNewFile" },
--    dependencies = {
--      'williamboman/mason.nvim',
--      'jose-elias-alvarez/null-ls.nvim',
--    },
--    lazy = false,
--  config = function(_,opts)
--    local null_ls = require 'null-ls'
--    null_ls.setup()
--
--    require ('mason-null-ls').setup({
--        ensure_installed = {'stylua', 'jq'},
--        handlers = {
--            function()
--            end, -- disables automatic setup of all null-ls sources
--            stylua = function(source_name, methods)
--              null_ls.register(null_ls.builtins.formatting.stylua)
--            end,
--            shfmt = function(source_name, methods)
--              -- custom logic
--              require('mason-null-ls').default_setup(source_name, methods) -- to maintain default behavior
--            end,
--        },
--    })
--  end,
--  },
-- LSP - Completion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
    },
    config = function(_, opts)
        require('cmp').setup(opts)
        local cmp = require'cmp'

        cmp.setup({
          snippet = {
              expand = function(args)
              vim.fn["vsnip#anonymous"](args.body)
            end,
          },
          window = {
            -- completion = cmp.config.window.bordered(),
            -- documentation = cmp.config.window.bordered(),
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'vsnip' },
          }, {
            { name = 'buffer' },
          })
        })
    end,
    lazy = false,

  },
  { 'hrsh7th/cmp-vsnip' },
  { 'hrsh7th/vim-vsnip' },
-- coq
--   {
--     'ms-jpq/coq_nvim',
--     branch = 'coq',
--     cmd = 'COQnow --shut-up',
--   },
--   {
--     'ms-jpq/coq.artifacts',
--     branch = 'artifacts',
--     dependencies = {
--       'ms-jpq/coq_nvim',
--     },
--   },

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
      'HiPhish/nvim-ts-rainbow2',
    },
  },
  { 'nvim-treesitter/nvim-treesitter-refactor' }, -- Refactor (Highlighting, smart rename, navigation)
  {
    'HiPhish/nvim-ts-rainbow2', -- Highlight paranthesis pairs in their own colour.
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
}
-- New LSP client LSPsaga
-- use({
--     "glepnir/lspsaga.nvim",
--     branch = "main",
--     config = function()
--         require('lspsaga').setup({})
--     end,
-- })

