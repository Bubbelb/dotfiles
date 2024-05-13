-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Theming, colors
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
return {
-- ==============================================================
-- Theme selection
-- ==============================================================
  {
    'nvim-tree/nvim-web-devicons',
    opts = {
      override = {
        zsh = {
          icon = "",
          color = "#428850",
          name = "Zsh"
        },
      },
      default = true,
    },
  }, -- Colors and icons to use
-- ==============================================================
-- Switch dark/light theme on light/day times
-- ==============================================================
  {
    'JManch/sunset.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      latitude = 52.3673, -- north is positive, south is negative
      longitude = 4.8998, -- east is positive, west is negative
      sunrise_offset = 10, -- offset the sunrise by this many seconds
      sunset_offset = -10, -- offset the sunset by this many seconds
    },
    dependencies = {
      {
        'luisiacc/gruvbox-baby', -- Gruvbox theme set
        lazy = false,
        config = function()
          vim.cmd([[colorscheme gruvbox-baby]])
        end,
      },
    },
  },
-- ==============================================================
-- Highlight indent levels
-- ==============================================================
  { "lukas-reineke/indent-blankline.nvim",
    main = 'ibl',
    opts = {},
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },
-- ==============================================================
-- Configure tab and statusline
-- ==============================================================
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      options = {
        icons_enabled = true,
        theme = 'gruvbox-baby',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {}
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch'},
        lualine_c = { {'filename', file_status = true, path = 2 } },
        lualine_x = {'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { {'filename', file_status = true, path = 2 } },
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {
        lualine_a = {
          {
            'buffers',
            show_filename_only = false,
            hide_filename_extension = false,
            show_modified_status = true,
            mode = 0, -- 0: Shows buffer name
                    -- 1: Shows buffer index
                    -- 2: Shows buffer name + buffer index
                    -- 3: Shows buffer number
                    -- 4: Shows buffer name + buffer number

            max_length = vim.o.columns * 4 / 5, -- Maximum width of buffers component,
                                                -- it can also be a function that returns
                                                -- the value of `max_length` dynamically.
            filetype_names = {
              TelescopePrompt = 'Telescope',
              dashboard = 'Dashboard',
              packer = 'Packer',
              fzf = 'FZF',
              alpha = 'Alpha'
            }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )
            symbols = {
              modified = ' ●',      -- Text to show when the buffer is modified
              alternate_file = '#', -- Text to show to identify the alternate file
              directory =  '',     -- Text to show when the buffer is a directory
            },

          }
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {'tabs'}
      },
      extensions = {}
    },
  },

}
