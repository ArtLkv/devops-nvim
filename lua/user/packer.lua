vim.cmd [[packadd packer.nvim]]

-- Install Packer(when use :so), if isn't install.
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  PB = vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
end

return require('packer').startup(function(use)
  use { 'wbthomason/packer.nvim' } -- Package Manager
  use { 'Mofiqul/vscode.nvim' } -- VisualStudio Code Theme
  ---------------------------------------------------
  -- Require plugins
  use { 'nvim-lua/plenary.nvim' } -- Async support for NeoVim
  use { 'windwp/nvim-autopairs' } -- Auto add pair for brackets, tags and other
  use { 'ray-x/lsp_signature.nvim' } -- If LSP don't support signature, fix it 
  use { 'numToStr/Comment.nvim' } -- Comment System
  use { 'rcarriga/nvim-notify' } -- Notification System
  ---------------------------------------------------
  -- Core plugins
  use { 'nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' } } -- Text Parser
  use { 'nvim-telescope/telescope.nvim', tag = '0.1.1' } -- Fzf Finder(fzf and ripgrep require)
  use { 'nvim-tree/nvim-tree.lua' } -- File Manager
  use { 'neovim/nvim-lspconfig' } -- LSP
  use { 'hrsh7th/nvim-cmp' } -- Auto-Complete
  use { 'akinsho/toggleterm.nvim', tag='*' } -- Terminal Integration
  ---------------------------------------------------
  -- Auto-Complete plugins
  use { 'hrsh7th/cmp-nvim-lsp' } -- Add LSP support for Auto-Complete
  use { 'hrsh7th/cmp-buffer' } -- Add buffer as Auto-Complete source
  use { 'hrsh7th/cmp-path' } -- Add path hints as Auto-Complete source
  use { 'hrsh7th/cmp-emoji' } -- Add emoji support for Auto-Complete
  ---------------------------------------------------
  -- UI plugins
  use { 'nvim-tree/nvim-web-devicons' } -- Add file icons for NvimTree
  use { 'nvim-lualine/lualine.nvim' } -- Add status bar
  use { 'akinsho/bufferline.nvim', tag = "v3.*" } -- Add tabs support
  use { 'onsails/lspkind.nvim' } -- Add pictograms for built-in LSP
  ---------------------------------------------------
  -- Snippets plugins
  use { 'saadparwaiz1/cmp_luasnip' }
  use { 'L3MON4D3/LuaSnip' }
  use { 'rafamadriz/friendly-snippets' }
  ---------------------------------------------------

  if PB then
    require('packer').sync()
  end
end)
