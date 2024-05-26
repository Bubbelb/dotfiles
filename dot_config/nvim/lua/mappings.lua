-- A central place to store all the custom mappings
--

--- Basic
vim.api.nvim_set_keymap('n', '<M-,>', ':bprevious<CR>', {noremap = true, silent = true, desc="Go to Previous Tab"})
vim.api.nvim_set_keymap('n', '<M-.>', ':bnext<CR>', {noremap = true, silent = true, desc="Go to Next Tab"})
vim.api.nvim_set_keymap('n', '<M-/>', ':bmodified<CR>', {noremap = true, silent = true, desc="Go to Next Modified Tab"})
vim.api.nvim_set_keymap('n', '<Leader>q', ':q<CR>', {noremap = true, silent = true, desc="Quit current buffer"})
vim.api.nvim_set_keymap('n', '<Leader>Q', ':qa<CR>', {noremap = true, silent = true, desc="Quit all buffers"})
vim.api.nvim_set_keymap('n', '<Leader>x', ':x<CR>', {noremap = true, silent = true, desc="Quit & Save current buffer"})
vim.api.nvim_set_keymap('n', '<Leader>X', ':xa<CR>', {noremap = true, silent = true, desc="Quit & Save all buffers"})
vim.api.nvim_set_keymap('n', '<Leader>H', ':noh<CR>', {noremap = true, silent = true, desc="Turn off Search highlight"})

-- LSP Client mappings
vim.api.nvim_set_keymap('n', 'gd',          [[<cmd>lua vim.lsp.buf.definition()<CR>]], {noremap = true, silent = true, desc="Go to Definition"})
vim.api.nvim_set_keymap('n', 'gi',          [[<cmd>lua vim.lsp.buf.implementation()<CR>]], {noremap = true, silent = true, desc="Go to Implementation"})
vim.api.nvim_set_keymap('n', 'gr',          [[<cmd>lua vim.lsp.buf.references()<CR>]], {noremap = true, silent = true, desc="Go to Reference"})
vim.api.nvim_set_keymap('n', 'gD',          [[<cmd>lua vim.lsp.buf.declaration()<CR>]], {noremap = true, silent = true, desc="go to Declaration"})
vim.api.nvim_set_keymap('n', 'ge',          [[<cmd>lua vim.lsp.diagnostic.setloclist()<CR>]], {noremap = true, silent = true, desc="Show QuickFix"})
vim.api.nvim_set_keymap('n', 'K',           [[<cmd>lua vim.lsp.buf.hover()<CR>]], {noremap = true, silent = true, desc="Keyword Help"})
vim.api.nvim_set_keymap('n', '<Leader>F',   [[<cmd>lua vim.lsp.buf.format {async = true}<CR>]], {noremap = true, silent = true, desc="Reformat Buffer"})
vim.api.nvim_set_keymap('v', '<Leader>F',   [[<cmd>lua vim.lsp.buf.format {async = true}<CR>]], {noremap = true, silent = true, desc="Reformat Visual"})
vim.api.nvim_set_keymap('n', '<Leader>rn',  [[<cmd>lua vim.lsp.buf.rename()<CR>]], {noremap = true, silent = true, desc="Rename definition"})

vim.api.nvim_set_keymap('x', '<Leader>a',   [[<cmd>lua vim.lsp.buf.code_action()<CR>]], {silent = true, desc="Select Code Action"})

-- Telescope Support
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {desc="Show/Search files below CWD"})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {desc="Show/Search in files below CWD"})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {desc="Show/Search in Buffers"})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {desc="Show/Search in Help Tags"})
vim.keymap.set('n', '<leader>ft', require('telescope-tabs').list_tabs, {desc="Show/Search in Tabs"})

