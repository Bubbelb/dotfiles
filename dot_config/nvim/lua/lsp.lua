-- Configure the LSP (Language Servers. Run Mason to get it working. This makes use of
-- the plugins installed in the plugins/ directory.
--
-- LSP client config
--[[ local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })
end) ]]
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
            require('lspconfig')[server_name].setup({})
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
require('lspconfig').lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = {
        globals = {'vim'}
      }
    }
  }
})

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- -- This is where you enable features that only work
-- -- if there is a language server active in the file
-- vim.api.nvim_create_autocmd('LspAttach', {
--   callback = function(event)
--     local opts = {buffer = event.buf}
--
--     vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
--     vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
--     vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
--     vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
--     vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
--     vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
--     vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
--     vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
--     vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
--     vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
--   end,
-- })

-- LSP Client mappings
-- This is where you enable features that only work if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local opts = {buffer = event.buf}
    vim.api.nvim_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', { noremap = true, silent = true, desc = "Keyword Help", opts })
    vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', { noremap = true, silent = true, desc = "Go to Definition", opts })
    vim.api.nvim_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', { noremap = true, silent = true, desc = "go to Declaration", opts })
    vim.api.nvim_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', { noremap = true, silent = true, desc = "Go to Implementation", opts })
    vim.api.nvim_set_keymap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', { noremap = true, silent = true, desc = "Go to Type definition", opts })
    vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', { noremap = true, silent = true, desc = "Go to Reference", opts })
    vim.api.nvim_set_keymap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', { noremap = true, silent = true, desc = "Show Function Signature Help", opts })
    vim.api.nvim_set_keymap('n', 'ge', '<cmd>lua vim.lsp.diagnostic.setloclist()<cr>', { noremap = true, silent = true, desc = "Show QuickFix", opts })
    vim.api.nvim_set_keymap({'n', 'v'}, '<Leader>F', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', { noremap = true, silent = true, desc = "Reformat", opts })
    vim.api.nvim_set_keymap('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', { noremap = true, silent = true, desc = "Rename definition", opts })
    vim.api.nvim_set_keymap('x', '<Leader>a', '<cmd>lua vim.lsp.buf.code_action()<cr>', { silent = true, desc = "Select Code Action", opts })
  end,
})

