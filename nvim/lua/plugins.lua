local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')


Plug('tpope/vim-surround')

Plug('pangloss/vim-javascript')
Plug('ryanoasis/vim-devicons')
Plug('preservim/vimux')
Plug('voldikss/vim-floaterm')
-- Plug('airblade/vim-gitgutter')
Plug('nordtheme/vim')
Plug('lewis6991/gitsigns.nvim') 
Plug('fatih/vim-go', { ['do'] = ':GoUpdateBinaries' })
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
Plug('kyazdani42/nvim-web-devicons')
Plug('neovim/nvim-lspconfig')
Plug('williamboman/nvim-lsp-installer')
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')
Plug('nvim-telescope/telescope-file-browser.nvim')
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-vsnip')
Plug('hrsh7th/vim-vsnip')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline')
Plug('onsails/lspkind-nvim')
Plug('rmagatti/goto-preview')
Plug('nvim-tree/nvim-tree.lua')
--
Plug('karb94/neoscroll.nvim')
Plug('nvim-lualine/lualine.nvim')
Plug('romgrk/barbar.nvim')
Plug('b0o/incline.nvim')
Plug('startup-nvim/startup.nvim')


-- Plug('andweeb/presence.nvim')
Plug('numToStr/Comment.nvim')
Plug('rcarriga/nvim-notify')

Plug('navarasu/onedark.nvim')
Plug('toppair/peek.nvim', {['do'] = 'deno task --quiet build:fast' })
Plug('iftheshoefritz/solargraph-rails')
Plug('williamboman/mason.nvim', {['do'] = ':MasonUpdate'})
Plug('williamboman/mason-lspconfig.nvim')
Plug('catppuccin/nvim', { ['as'] = 'catppuccin' })


Plug('folke/snacks.nvim')

Plug('rhart92/codex.nvim')


Plug('MunifTanjim/nui.nvim')

Plug('nvim-neotest/nvim-nio')
Plug('nvim-tree/nvim-web-devicons')

vim.call('plug#end')
