--- LSP client config
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })
end)

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
