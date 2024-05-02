--- LSP client config
-- TODO: Install packages for aupporting lsp installer plugin.
--       Packages npm, yarn, python-pip and unzip are needed (at least)
--       For Archlinux run: pacman --needed -S npm yarn python-pip unzip
-- Install Lanuage Servers
-- require("nvim-lsp-installer").setup {}
-- local lsp = require "lspconfig"
-- local coq = require "coq"
--
-- lsp.tsserver.setup{}
-- lsp.tsserver.setup(coq.lsp_ensure_capabilities{})
-- vim.cmd('COQnow -s')
-- Inintalize Language Server Clients
-- lspconfig = require'lspconfig'
-- local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
--
-- lspconfig.ansiblels.setup{capabilities = capabilities} -- Needs: npm install -g @ansible/ansible-language-server
-- lspconfig.bashls.setup{capabilities = capabilities} -- Needs: npm i -g bash-language-server
-- lspconfig.html.setup{capabilities = capabilities} -- Needs: npm i -g vscode-langservers-extracted
-- lspconfig.jsonls.setup{capabilities = capabilities} -- Needs: npm i -g vscode-langservers-extracted
-- lspconfig.pylsp.setup{capabilities = capabilities} -- Needs: pip3 install 'python-language-server[all]'
-- lspconfig.sqlls.setup{capabilities = capabilities} -- Needs: npm i -g sql-language-server
-- lspconfig.tsserver.setup{capabilities = capabilities} -- Needs: npm install -g typescript typescript-language-server
-- lspconfig.yamlls.setup{capabilities = capabilities} -- Needs: yarn global add yaml-language-server

-- Signs (of errors/warnings) to the gutter
vim.fn.sign_define("LspDiagnosticsSignError", {text="🔴", texthl="LspDiagnosticsError"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text="🟠", texthl="LspDiagnosticsWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text="🔵", texthl="LspDiagnosticsInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text="🟢", texthl="LspDiagnosticsHint"})

-- Setup nvim-cmp.
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
--
-- -- LSP Saga
-- local keymap = vim.keymap.set
--
-- -- Lsp finder find the symbol definition implement reference
-- -- if there is no implement it will hide
-- -- when you use action in finder like open vsplit then you can
-- -- use <C-t> to jump back
-- keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
--
-- -- Code action
-- keymap({"n","v"}, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })
--
-- -- Rename
-- keymap("n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true })
--
-- -- Peek Definition
-- -- you can edit the definition file in this flaotwindow
-- -- also support open/vsplit/etc operation check definition_action_keys
-- -- support tagstack C-t jump back
-- keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })
--
-- -- Show line diagnostics
-- keymap("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })
--
-- -- Show cursor diagnostic
-- keymap("n", "<leader>cd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { silent = true })
--
-- -- Diagnsotic jump can use `<c-o>` to jump back
-- keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
-- keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })
--
-- -- Only jump to error
-- keymap("n", "[E", function()
--   require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
-- end, { silent = true })
-- keymap("n", "]E", function()
--   require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
-- end, { silent = true })
--
-- -- Outline
-- keymap("n","<leader>o", "<cmd>LSoutlineToggle<CR>",{ silent = true })
--
-- -- Hover Doc
-- keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
--
-- -- Float terminal
-- keymap("n", "<A-d>", "<cmd>Lspsaga open_floaterm<CR>", { silent = true })
-- -- if you want pass somc cli command into terminal you can do like this
-- -- open lazygit in lspsaga float terminal
-- keymap("n", "<A-d>", "<cmd>Lspsaga open_floaterm lazygit<CR>", { silent = true })
-- -- close floaterm
-- keymap("t", "<A-d>", [[<C-\><C-n><cmd>Lspsaga close_floaterm<CR>]], { silent = true })
--

