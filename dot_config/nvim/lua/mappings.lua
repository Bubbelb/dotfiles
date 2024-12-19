-- A central place to store all the custom mappings
--

--- Basic
vim.api.nvim_set_keymap('n', '<M-,>', ':bprevious<CR>', { noremap = true, silent = true, desc = "Go to Previous Tab" })
vim.api.nvim_set_keymap('n', '<M-.>', ':bnext<CR>', { noremap = true, silent = true, desc = "Go to Next Tab" })
vim.api.nvim_set_keymap('n', '<M-/>', ':bmodified<CR>', { noremap = true, silent = true, desc = "Go to Next Modified Tab" })
vim.api.nvim_set_keymap('n', '<Leader>q', ':q<CR>', { noremap = true, silent = true, desc = "Quit current buffer" })
vim.api.nvim_set_keymap('n', '<Leader>Q', ':qa<CR>', { noremap = true, silent = true, desc = "Quit all buffers" })
vim.api.nvim_set_keymap('n', '<C-x>', ':x<CR>', { noremap = true, silent = true, desc = "Quit & Save current buffer" })
vim.api.nvim_set_keymap('n', '<C-X>', ':xa<CR>', { noremap = true, silent = true, desc = "Quit & Save all buffers" })
vim.api.nvim_set_keymap('n', '<Leader>sh', ':lua toggle_hlsearch()<CR>', { noremap = true, silent = true, desc = "Turn off Search highlight" })
vim.api.nvim_set_keymap('n', '<Leader>sn', ':lua toggle_number()<CR>',
    { noremap = true, silent = true, desc = "Show/Hide Line Numbers" })
vim.api.nvim_set_keymap('n', '<Leader>sr', ':lua toggle_relativenumber()<CR>',
    { noremap = true, silent = true, desc = "Show/Hide Relative Line Numbers" })

-- LSP Client mappings
-- This is where you enable features that only work if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    vim.api.nvim_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', { noremap = true, silent = true, desc = "Keyword Help", buffer = event.buf })
    -- vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', { noremap = true, silent = true, desc = "Go to Definition", buffer = event.buf })
    -- vim.api.nvim_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', { noremap = true, silent = true, desc = "go to Declaration", buffer = event.buf })
    -- vim.api.nvim_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', { noremap = true, silent = true, desc = "Go to Implementation", buffer = event.buf })
    -- vim.api.nvim_set_keymap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', { noremap = true, silent = true, desc = "Go to Type definition", buffer = event.buf })
    -- vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', { noremap = true, silent = true, desc = "Go to Reference", buffer = event.buf })
    -- vim.api.nvim_set_keymap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', { noremap = true, silent = true, desc = "Show Function Signature Help", buffer = event.buf })
    -- vim.api.nvim_set_keymap('n', 'ge', '<cmd>lua vim.lsp.diagnostic.setloclist()<cr>', { noremap = true, silent = true, desc = "Show QuickFix", buffer = event.buf })
    -- vim.api.nvim_set_keymap({'n', 'v'}, '<Leader>F', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', { noremap = true, silent = true, desc = "Reformat", buffer = event.buf })
    -- vim.api.nvim_set_keymap('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', { noremap = true, silent = true, desc = "Rename definition", buffer = event.buf })
    -- vim.api.nvim_set_keymap('x', '<Leader>a', '<cmd>lua vim.lsp.buf.code_action()<cr>', { silent = true, desc = "Select Code Action", buffer = event.buf })
  end,
})

-- Telescope Support
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Show/Search files below CWD" })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Show/Search in files below CWD" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Show/Search in Buffers" })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Show/Search in Help Tags" })
vim.keymap.set('n', '<leader>ft', require('telescope-tabs').list_tabs, { desc = "Show/Search in Tabs" })

vim.keymap.set('t', '<C-t>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', { desc = "Toggle Terminal Window" })

vim.keymap.set('v', '<leader>t', "<CMD>'<,'>!column -t -s '|' -o '|'<CR>", { desc = "Make table of selection" })

-- Spell checker
vim.keymap.set('n', '<leader>sG', ':set spelllang=en_gb<cr>', { desc = 'Set Spell Checker Language to en-GB' })
vim.keymap.set('n', '<leader>sN', ':set spelllang=nl_nl<cr>', { desc = 'Set Spell Checker Language to nl-NL' })
vim.keymap.set('n', '<leader>sU', ':set spelllang=en_us<cr>', { desc = 'Set Spell Checker Language to en-US' })
vim.keymap.set('n', '<leader>sX', ':set spell!<cr>', { desc = 'Toggle Spell checker' })
vim.keymap.set('n', '<leader>sw', ':set wrap!<cr>', { desc = 'Toggle Line Wrap' })
vim.keymap.set('n', '<leader>ss', ':%s/\\s\\+$//<cr>', { desc = 'Remove all training spaces' })


-- Toggle functions (between on/off)
function toggle_number()
    vim.o.number = not vim.o.number
    vim.o.relativenumber = false
end

function toggle_relativenumber()
    vim.o.relativenumber = not vim.o.relativenumber
    vim.o.number = false
end

function toggle_hlsearch()
    vim.o.hlsearch = not vim.o.hlsearch
end
