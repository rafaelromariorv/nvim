" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif



call plug#begin('~/.config/nvim/autoload/plugged')

	" status bar
	Plug 'itchyny/lightline.vim'
	
	" Themes
	Plug 'morhetz/gruvbox'
	Plug 'nordtheme/vim'
	
	Plug 'nvim-tree/nvim-tree.lua'
	Plug 'nvim-tree/nvim-web-devicons'
	
	" code autocomplete
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	
	" language
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

	" nav
	Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.4' }

	" terminal
	Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}

call plug#end()
