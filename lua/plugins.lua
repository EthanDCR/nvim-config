-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

 use {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
-- or                            , branch = '0.1.x',
  requires = { {'nvim-lua/plenary.nvim'} }
} 


use { "ellisonleao/gruvbox.nvim" }

 use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

-- use('mbbill/undotree')

-- this is lsp.
use {'williamboman/mason.nvim'}
use {'williamboman/mason-lspconfig.nvim'}
use {'neovim/nvim-lspconfig'}  -- core LSP configuration
use {'hrsh7th/nvim-cmp'}        -- for autocompletion
use {'hrsh7th/cmp-nvim-lsp'}    -- for LSP-based autocompletion sources


-- snippets and bracket pairs.
use {'L3MON4D3/LuaSnip'}
use {'saadparwaiz1/cmp_luasnip'}
use {'windwp/nvim-autopairs'}
use {'windwp/nvim-autopairs'}

-- Add these to your existing plugins
use {'hrsh7th/cmp-buffer'}  -- Buffer completions
use {'hrsh7th/cmp-path'}    -- Path completions

use {'rafamadriz/friendly-snippets'}  -- Collection of snippets
use {'hrsh7th/cmp-buffer'}           -- Make sure this is included
use {'hrsh7th/cmp-path'}             -- Make sure this is included




-- bufferline plugin.
use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}


 end)



