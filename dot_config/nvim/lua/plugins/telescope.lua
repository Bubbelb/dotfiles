-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Telescope support
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
return {
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
    },
    config = function()
      require("telescope").setup()
      require('telescope').load_extension('fzf')

    end
  },
  {
    'LukasPietzschmann/telescope-tabs',
    dependencies = {
      'nvim-telescope/telescope.nvim'
    },
  },
}
