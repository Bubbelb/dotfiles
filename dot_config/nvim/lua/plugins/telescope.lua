-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Telescope support
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
return {
	{ 'nvim-lua/plenary.nvim' },
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope-fzf-native.nvim',
			"coffebar/neovim-project",
		},
		config = function()
			require("telescope").setup()
			require('telescope').load_extension('fzf')
			require('telescope').load_extension('projects')
			require'telescope'.extensions.projects.projects{}
		end
	},
	{
		'LukasPietzschmann/telescope-tabs',
		dependencies = {
			'nvim-telescope/telescope.nvim'
		},
	},
}
