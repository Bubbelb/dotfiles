return {
    {
        'willothy/flatten.nvim',
        config = true,
        lazy = false,
        priority = 1001,
    },
    {
        'nat-418/scamp.nvim',
    },
    {
        'chentoast/marks.nvim',
        lazy = false,
        opts = {
            default_mappings = true,
            signs = true,
            mappings = {},
            builtin_marks = { "'", "<", ">", "." },
        },
    },
    {
        'gorbit99/codewindow.nvim',
        keys = {
          { "<Leader>mo", "<cmd>lua require('codewindow').open_minimap()<cr>", desc = "Open MiniMap" },
          { "<Leader>mc", "<cmd>lua require('codewindow').close_minimap()<cr>", desc = "Close MiniMap" },
          { "<Leader>mf", "<cmd>lua require('codewindow').toggle_focus()<cr>", desc = "(Un-)Focus MiniMap" },
          { "<Leader>mm", "<cmd>lua require('codewindow').toggle_minimap()<cr>", desc = "Toggle MiniMap" },
        },
        config = function()
             local codewindow = require('codewindow')
             codewindow.setup()
        --     codewindow.apply_default_keybinds()
         end,
    },
}
