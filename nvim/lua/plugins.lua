require("lazy").setup({
  -- Basic utilities
  'tpope/vim-surround',
  'pangloss/vim-javascript',
  'ryanoasis/vim-devicons',
  'preservim/vimux',
  'voldikss/vim-floaterm',

  -- Themes
  'nordtheme/vim',
  'navarasu/onedark.nvim',
  { 'catppuccin/nvim', name = 'catppuccin' },

  -- Git
  'lewis6991/gitsigns.nvim',
  'f-person/git-blame.nvim',

  -- Language support
  { 'fatih/vim-go', build = ':GoUpdateBinaries' },
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

  -- Icons
  'kyazdani42/nvim-web-devicons',
  'nvim-tree/nvim-web-devicons',

  -- LSP
  'neovim/nvim-lspconfig',
  'williamboman/nvim-lsp-installer',
  { 'williamboman/mason.nvim', build = ':MasonUpdate' },
  'williamboman/mason-lspconfig.nvim',
  'iftheshoefritz/solargraph-rails',

  -- Telescope
  'nvim-lua/plenary.nvim',
  'nvim-telescope/telescope.nvim',
  'nvim-telescope/telescope-file-browser.nvim',

  -- Completion
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/vim-vsnip',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'onsails/lspkind-nvim',

  -- Navigation
  'rmagatti/goto-preview',
  'nvim-tree/nvim-tree.lua',
  'karb94/neoscroll.nvim',

  -- UI
  'nvim-lualine/lualine.nvim',
  'b0o/incline.nvim',
  'startup-nvim/startup.nvim',
  'rcarriga/nvim-notify',

  -- Utilities
  'numToStr/Comment.nvim',
  { 'toppair/peek.nvim', build = 'deno task --quiet build:fast' },

  -- AI assistants
  'zbirenbaum/copilot.lua',
  'zbirenbaum/copilot-cmp',
  'supermaven-inc/supermaven-nvim',
  'folke/snacks.nvim',
  'folke/sidekick.nvim',

  -- Markdown
  'MeanderingProgrammer/render-markdown.nvim',

  -- Dependencies
  'MunifTanjim/nui.nvim',
  'nvim-neotest/nvim-nio',
}, {
  -- Lazy.nvim configuration
  ui = {
    border = "rounded",
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
