-- Configure the LSP (Language Servers. Run Mason to get it working. This makes use of
-- the plugins installed in the plugins/ directory.
--
-- LSP client config
local cmp = require('cmp')

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({}),
})

-- to learn how to use mason.nvim
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
    handlers = {
        function(server_name)
            vim.lsp.config(server_name).setup({})
        end,
    }
})

-- (Super)-Tab completion
local luasnip = require("luasnip")
local cmp = require("cmp")

cmp.setup({
    mapping = {
        ['<CR>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                if luasnip.expandable() then
                    luasnip.expand()
                else
                    cmp.confirm({
                        select = true,
                    })
                end
            else
                fallback()
            end
        end),

        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
})

-- Signs (of errors/warnings) to the gutter
vim.fn.sign_define("LspDiagnosticsSignError", { text = "🔴", texthl = "LspDiagnosticsError" })
vim.fn.sign_define("LspDiagnosticsSignWarning", { text = "🟠", texthl = "LspDiagnosticsWarning" })
vim.fn.sign_define("LspDiagnosticsSignInformation", { text = "🔵", texthl = "LspDiagnosticsInformation" })
vim.fn.sign_define("LspDiagnosticsSignHint", { text = "🟢", texthl = "LspDiagnosticsHint" })

-- LuaSnip Friendly Snippet support
require("luasnip.loaders.from_vscode").lazy_load()
-- require('lspconfig').lua_ls.setup({
-- vim.lsp.config({
--   settings = {
--     Lua = {
--       diagnostics = {
--         globals = {'vim'}
--       }
--     }
--   }
-- })

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)
