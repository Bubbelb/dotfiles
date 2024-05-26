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

}
