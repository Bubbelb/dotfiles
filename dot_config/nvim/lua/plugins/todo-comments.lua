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
                        name = "FIX",
                        fg = "white",
                        bg = "#f44747",
                        bold = true,
                        virtual_text = "This is virtual Text from FIX",
                    },
                    {
                        name = "WARNING",
                        fg = "#FFA500",
                        bg = "",
                        bold = false,
                        virtual_text = "This is virtual Text from WARNING",
                    },
                    {
                        name = "?",
                        fg = "blue",
                        bg = "",
                        bold = true,
                        virtual_text = "",
                    },
                    {
                        name = "!",
                        fg = "#f44747",
                        bg = "",
                        bold = true,
                        virtual_text = "",
                    }
                }
            })
        end
    }
}

