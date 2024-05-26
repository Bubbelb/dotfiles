--- LSP client config
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
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
-- Signs (of errors/warnings) to the gutter
vimx.fn.sign_define("LspDiagnosticsSignError", {text="🔴", texthl="LspDiagnosticsError"})
vimx.fn.sign_define("LspDiagnosticsSignWarning", {text="🟠", texthl="LspDiagnosticsWarning"})
vimx.fn.sign_define("LspDiagnosticsSignInformation", {text="🔵", texthl="LspDiagnosticsInformation"})
vimx.fn.sign_define("LspDiagnosticsSignHint", {text="🟢", texthl="LspDiagnosticsHint"})

