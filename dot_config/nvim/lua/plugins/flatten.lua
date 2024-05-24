return {
    {
        'willothy/flatten.nvim',
        config = true,
        -- or pass configuration with
        -- opts = {  }
        -- Ensure that it runs first to minimize delay when opening file from terminal
        lazy = false,
        priority = 1001,
    },
    {
        'nat-418/scamp.nvim',
        config = function(_, opts)
            require("scamp").setup(opts)
        end,
        lazy = false,
    },
}
