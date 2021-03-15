" colorcolumn for bde style consistency
set colorcolumn=80

" disable autocommenting for all filetypes and sessions
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" show spaces/tabs
set list
set lcs=tab:\|\
set lcs+=space:·

if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
      set termguicolors
endif

" leader key {{{1
let mapleader="\<space>"
let maplocalleader="\<space>"
" }}}1

" terminal mapping
tnoremap <ESC> <C-\><C-n>

" nvim is always nocompatible -> better safe than sorry
set nocompatible

set termguicolors

" Disable highlights with <leader><cr>
map <silent> <leader><cr> :noh<cr>

" enable syntax highlighting
filetype plugin on
syntax enable

" enable filetype plugins
filetype plugin on
filetype indent on

" more characters will be sent ot the screen for redrawing
set ttyfast

" time waited for key press(es) to complete.
" It makes for a faster key response
set timeout
set timeoutlen=50

" make backspace behave properly in insert mode
" NOTE: Not necessary in nvim it seems
" set backspace=indent,eol,start

" a better menu in command mode
set wildmenu
set wildmode=longest:full,full

" hide buffesr instead of closing them even if they contain unsaved changed
set hidden

" disable softwrap for lines
set nowrap

" always display status line
set laststatus=2

" enable numbers
set number " relativenumber

" highlight current line
set cursorline

" new splits will be at the bottom or to the right of the screen
set splitbelow
set splitright

" always set autoindenting on
set autoindent
set smartindent

" while searching shows per character typed
set incsearch

" do you want to highlight searches? I don't personally
" Looking to find a better way in the future though
set nohlsearch

" searches are case sensitive unless they contain at least one capital letter
set ignorecase
set smartcase

" background
set background=dark

" colorscheme
" colorscheme NeoSolarized
colorscheme nord

" clipboard
set clipboard^=unnamed

" command history
set history=500

" easy mapping for executing shell commands
nnoremap ! :!

" mouse enable
set mouse=a

" detects changes to current file
set autoread

" don't redraw while executing macros (for performance)
set lazyredraw

" for regex, turn magic on
set magic

" show matching brackets when hovering
set showmatch

" no annoying sounds
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" set utf8 as standard encoding
set encoding=utf8
scriptencoding utf8

" use unix as the standard file type
set ffs=unix,dos,mac

" Turn backup off, since most stuff is in git
set nobackup
set nowb
set noswapfile

" be smart when using tabs
set expandtab
set smarttab
set tabstop=4
set shiftwidth=4

" set 7 lines to the cursor when moving vertically
set so=7

" Return to last edit position when opening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" tells vim to automatically change dir to the pwd of the current file
autocmd BufEnter * if expand("%:p:h") !~ "^/tmp" | silent! lcd %:p:h | endif

" remap tabs when going through selection lists
" inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
" inoremap <expr> <tab> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"

" smart way to move between splits
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-h> <C-w>h
map <C-l> <C-w>l

" increase/decrease split size
" vertical splits
" NOTE: you will probably need to change these mappings.
" These were set for usage using the Bloomberg keyboard
" Open a terminal and type the combindation that you want for resizing panes.
" The first one increases the vertical size of the split with Alt-', it just
" turns out that what is below is how my computer interprets that input.
map <silent> ‘ :vert resize +5<cr>
map <silent> “ :vert resize -5<cr>
" horizontal splits
map <silent> æ :resize +5<cr>
map <silent> … :resize -5<cr>

" I like to move around buffers this way
map gn :bn<CR>
map gp :bp<CR>
map gd :bd<CR>