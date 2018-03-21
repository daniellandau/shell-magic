set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'


" My Bundles here:
"
" original repos on github
Bundle 'terryma/vim-multiple-cursors'
Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
" Bundle 'git://git.wincent.com/command-t.git'
" Bundle 'derekwyatt/vim-scala'
" Bundle 'xolox/vim-misc'
" Bundle 'xolox/vim-easytags'
" Bundle 'honza/vim-snippets'
" Bundle 'SirVer/ultisnips'
Bundle 'tpope/vim-repeat'
Bundle 'tomtom/tcomment_vim'
Bundle 'chrisbra/SudoEdit.vim'
" Bundle 'pangloss/vim-javascript'
" Bundle 'mxw/vim-jsx'
Bundle 'rbgrouleff/bclose.vim' 
" Bundle 'rainux/vim-vala'
call vundle#end() 

filetype plugin indent on     " required! 

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..
"
syntax on
set expandtab
set tabstop=2
set shiftwidth=2
set tags=./tags;
set mouse=
set hlsearch
set incsearch
set suffixesadd=.js,.jsx
set statusline=%F%m%r%h%w\ [type=%Y]\ [%{fugitive#statusline()}]\ [POS=%04l,%04v][%p%%]\ [lines=%L]
set laststatus=2
set foldmethod=indent
set foldlevel=1
set ignorecase
set smartcase
set smartindent
set background=dark

nmap <M-n> :cn
nmap <C-M-n> :cN

nmap <C-Tab> :tabn
nmap <S-C-Tab> :tabN


" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")


