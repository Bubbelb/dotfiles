return {
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },
    {
        "Djancyp/better-comments.nvim",
        lazy = false,
        config = function()
            require('better-comment').Setup({
                tags = {
                    {
                        name = "TODO",
                        fg = "white",
                        bg = "#0a7aca",
                        bold = true,
                        virtual_text = "",
                    },
                    {
                        name = "NEW",
                        fg = "white",
                        bg = "red",
                        bold = false,
                        virtual_text = "",
                    },
                }
            })
        end
    }
}

