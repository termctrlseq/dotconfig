"
" ~/.vimrc
"

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

" General setup
set autoread        " if a file has been changed outside of Vim read it again.
set autowrite       " write to file when changing buffer
set backupcopy=yes  " Preserves file birth time
set completeopt=menuone,noinsert,noselect,preview " ins mode completion
set cursorline      " highlight current line
set dictionary=spell " when spell is set use it for keyword completion
set encoding=utf-8  " encoding used inside Vim
set expandtab       " Use the appropriate number of spaces to insert a <Tab>
set hidden          " buffer becomes hidden when it is abandoned
set ignorecase      " the case of normal letters is ignored
set linebreak       " wrap long lines at a character in 'breakat'
set number          " Print the line number in front of each line.
set path+=.,~/**    " Provides tab-completion for all file related tasks
set path+=~/.config/**
set path+=~/.ipython/**
set path+=~/.local/**
set path+=~/.vim/**
set previewheight=12 " Default height for a preview window.
set pumheight=10    " Autocompletion menu max height
set scrolloff=3     " Min number of lines to keep above and below the cursor.
set shellcmdflag=-ic " use interactive shell for external commands
set shiftwidth=4    " number of spaces for each step of indent
set shortmess+=scF
set showbreak=>>>>  " String at the start of lines that have been wrapped.
set signcolumn=yes  " draw the signcolumn
set smartcase       " ignore case when pattern contains lowercase letters only
set splitbelow      " put the new window below the current
set tabstop=4       " number of spaces a <TAB> stands for
set tags=./tags;~/tags " if tags file not found in cwd, look in parent dirs
set timeoutlen=1500 " Time in msec to wait for a key sequence to complete.
if exists('$TMUX')
  set ttymouse=xterm2 " vim mouse support inside tmux
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all files set 'textwidth' to 78 characters.
  autocmd FileType * setlocal textwidth=78

  " Set indentation and textwidth
  autocmd FileType vim,tmux,toml,html,xml setlocal tabstop=2 shiftwidth=2
  autocmd FileType c,python,sh setlocal tabstop=4 shiftwidth=4

  " signcolumn breaks formatting of man pages
  autocmd FileType man setlocal signcolumn=no

  " Quickfix list
  autocmd FileType qf setlocal norelativenumber

  " otherwise formatoptions get overridden
  autocmd FileType * set formatoptions=q

  " Kitty
	autocmd Filetype kitty setlocal commentstring=#\ %s
augroup END

" Change leader key
let mapleader = ' '

" Change cursor shape depending on mode
let &t_SI = "\e[6 q" " start insert mode (bar cursor shape)
let &t_EI = "\e[2 q" " end insert or replace mode (block cursor shape)

" Reset cursor color
if expand('%:p:h') == '/tmp'
  silent !echo -ne "\e]112\a"
endif

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

" The matchit plugin makes the % command work better
packadd! matchit
" This plugin displays a manual page in a nice way.
runtime ftplugin/man.vim
" Commenting and un-commenting text.
packadd! comment
" Auto exec :nohlsearch after 'updatetime' or getting into insert mode.
packadd! nohlsearch
set hlsearch
set updatetime=2000
" briefly highlights the affected region of the last yank command.
packadd! hlyank
