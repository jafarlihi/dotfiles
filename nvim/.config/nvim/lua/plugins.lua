-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'easymotion/vim-easymotion'

  use 'vim-syntastic/syntastic'

  use {'neoclide/coc.nvim', branch = 'release'}
end)
