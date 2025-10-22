"
" ~/.vimrc
"

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Keep Plugin commands between vundle#begin/end.


" Lean & mean status/tabline for vim that's light as air.
Plugin 'vim-airline/vim-airline'

" Official theme repository for vim-airline.
Plugin 'vim-airline/vim-airline-themes'

" Vim Tmux Navigator
Plugin 'christoomey/vim-tmux-navigator'

" NERDTree - a file system explorer for the Vim editor.
Plugin 'preservim/nerdtree'

" Changes parentheses, brackets, quotes, XML tags, and more.
Plugin 'surround.vim'

" Async autocompletion and linting
Plugin 'prabirshrestha/asyncomplete.vim'
Plugin 'prabirshrestha/vim-lsp'
Plugin 'prabirshrestha/asyncomplete-lsp.vim'
Plugin 'prabirshrestha/asyncomplete-file.vim'
Plugin 'kg8m/asyncomplete-mocword.vim'
Plugin 'prabirshrestha/asyncomplete-buffer.vim'
Plugin 'prabirshrestha/async.vim'
Plugin 'keremc/asyncomplete-clang.vim'
Plugin 'Shougo/neco-vim'
Plugin 'prabirshrestha/asyncomplete-necovim.vim'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

syntax on

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all files set 'textwidth' to 78 characters.
  autocmd FileType * setlocal textwidth=78

  " Set indentation and textwidth
  autocmd FileType vim,toml,html,xml setlocal tabstop=2 shiftwidth=2
  autocmd FileType c,python,sh setlocal tabstop=4 shiftwidth=4

  " signcolumn breaks formatting of man pages
  autocmd FileType man setlocal signcolumn=no

  " Quickfix list
  autocmd FileType qf setlocal norelativenumber

  " otherwise formatoptions get overridden
  autocmd FileType * set formatoptions=q
augroup END

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

" General vim setup
set number          " Print the line number in front of each line.
set splitbelow      " put the new window below the current
set ignorecase      " the case of normal letters is ignored
set smartcase       " ignore case when the pattern contains lowercase letters only
set autowrite       " write to file when changing buffer
set hidden          " buffer becomes hidden when it is abandoned
set expandtab       " Use the appropriate number of spaces to insert a <Tab>
" set tabstop=4       " number of spaces a <TAB> stands for
" set shiftwidth=4    " number of spaces for each step of indent
set scrolloff=3     " Min number of screen lines to keep above and below the cursor.
set backupcopy=yes  " Preserves file birth time
" Time in milliseconds to wait for a key code or mapped key sequence to complete.
set timeoutlen=1500
set path+=.,~/**      " Provides tab-completion for all file related tasks
set path+=~/.config/**
set path+=~/.local/**
set path+=~/.vim/**
set path+=~/.ipython/**
set pumheight=10    " Autocompletion menu max height
set previewheight=12 " Default height for a preview window.
set cursorline      " highlight current line
set wildmenu        " on pressing <TAB> the possible matches are shown.
set encoding=utf-8  " encoding used inside Vim
set signcolumn=yes  " draw the signcolumn
" list of options for Insert mode completion
set completeopt=menuone,noinsert,noselect,preview
if exists('$TMUX')
  set ttymouse=xterm2 " vim mouse support inside tmux
endif
set tags=./tags;~/tags    " if tags file not found in cwd, look in parent dirs
" use interactive shell for external commands (loads .bashrc)
set shellcmdflag=-ic
set autoread " if a file has been changed outside of Vim read it again.
set linebreak " wrap long lines at a character in 'breakat'
set showbreak=>>>> " String to put at the start of lines that have been wrapped.

" Change leader key
let mapleader = ' '

" Change cursor shape depending on mode
let &t_SI = "\e[6 q" " start insert mode (bar cursor shape)
let &t_EI = "\e[2 q" " end insert or replace mode (block cursor shape)


" COLORSCHEMES:
colorscheme spx

" airline
source ~/.vim/airline_setup.vim

" asyncomplete
source ~/.vim/async-lsp.vim

" My functions
source ~/.vim/functions.vim

" My key bindings
source ~/.vim/bindings.vim

" This plugin displays a manual page in a nice way.
runtime ftplugin/man.vim
