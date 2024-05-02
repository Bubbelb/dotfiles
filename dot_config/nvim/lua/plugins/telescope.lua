-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Telescope support
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
return {
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope-fzy-native.nvim' },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzy-native.nvim',
    },
    opts = {
      extensions = {
        fzy_native = {
          override_generic_sorter = false,
          override_file_sorter = true,
        },
      },
    },
    config = function()
      require("telescope").setup()
      require("telescope").load_extension("fzy_native")
    end
  },
  {
    'LukasPietzschmann/telescope-tabs',
    dependencies = {
      'nvim-telescope/telescope.nvim'
    },
  },
}
