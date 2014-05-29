" All system-wide defaults are set in $VIMRUNTIME/archlinux.vim (usually just
" /usr/share/vim/vimfiles/archlinux.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vimrc), since archlinux.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing archlinux.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages.
runtime! archlinux.vim

" If you prefer the old-style vim functionalty, add 'runtime! vimrc_example.vim'
" Or better yet, read /usr/share/vim/vim73/vimrc_example.vim or the vim manual
" and configure vim to your own liking!

set nocompatible
filetype off

call vundle#rc()

Bundle 'tomtom/tcomment_vim'
" Bundle 'Lokaltog/vim-easymotion'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-sensible'
" Bundle 'tpope/vim-eunuch'
" Bundle 'tpope/vim-sleuth'
" Bundle 'szw/vim-tags'
" Bundle 'taglist.vim'
" Bundle 'c.vim'
"Bundle 'ujihisa/neco-ghc'
"Bundle 'lukerandall/haskellmode-vim'
Bundle 'vim-scripts/YankRing.vim'
"Bundle 'tpope/vim-rsi'
Bundle 'rainux/vim-vala'
Bundle 'altercation/vim-colors-solarized'
Bundle 'kchmck/vim-coffee-script'
"Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle 'garbas/vim-snipmate'
Bundle 'honza/vim-snippets'
Bundle 'derekwyatt/vim-scala'
Bundle 'MarcWeber/vim-addon-mw-utils'

syntax on
set encoding=utf-8
"set showcmd                     " display incomplete commands
filetype plugin indent on       " load file type plugins + indentation

"" Whitespace
set nowrap                      " don't wrap lines
set softtabstop=4 shiftwidth=4      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

au BufRead,BufNewFile *.py let b:surround_45 = "\"\"\"\r\"\"\""
au BufRead,BufNewFile *.txt set wrap linebreak nolist

set mouse=a
"let g:haddock_browser="/usr/bin/firefox"
"let g:haddock_docdir="/usr/local/share/doc/ghc/html/"
"au BufEnter *.hs compiler ghc

" au BufEnter *.html ab cl class="clear-left"
" au BufEnter *.html ab r class="right"
" au BufEnter *.html ab b class="big"
" au BufEnter *.html ab m class="mid"

"au BufNewFile,BufRead,BufEnter *.cpp,*.hpp set omnifunc=omni#cpp#complete#Main

set tags=tags;/

autocmd VimLeave * call system("xsel -ib", getreg('+'))

set foldmethod=indent
set foldlevel=1

map zz za
