" spell check
set spelllang=en,cjk
nnoremap <silent> <C-s> :set spell!<CR>

" prevent --INSERT-- from showing which conflicts with your statusline
set noshowmode

" colorcolumn for bde style consistency
set colorcolumn=80

" disable autocommenting for all filetypes and sessions
" autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" fillchars between splits
set fillchars+=vert:\|
" set fillchars+=stl:\=
" set fillchars+=stlnc:\=

" show spaces/tabs
set list
set lcs=tab:\|\
set lcs+=space:·
set lcs+=eol:↲

if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
    lua require'bufferline'.setup{}
endif

" leader key {{{1
let mapleader="\<space>"
let maplocalleader="\<space>"
" }}}1

" terminal mapping
tnoremap <ESC> <C-\><C-n>
au TermOpen * setlocal nonumber

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

" more characters will be sent to the screen for redrawing
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
" set autoindent
set smartindent

" while searching shows per character typed
set incsearch

" do you want to highlight searches? I don't personally
" Looking to find a better way in the future though
" set nohlsearch

" searches are case sensitive unless they contain at least one capital letter
set ignorecase
set smartcase

" search visual selection
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" background
set background=dark

" colorscheme
if len(g:ITERM2_PRESET) != 0
    execute printf('colorscheme %s', g:ITERM2_PRESET)
else
    colorscheme space_vim_theme
endif

" clipboard
set clipboard^=unnamed

if has('wsl')
    let g:clipboard = {
          \   'name': 'wslclipboard',
          \   'copy': {
          \      '+': '/mnt/c/tools/neovim/Neovim/bin/win32yank.exe -i --crlf',
          \      '*': '/mnt/c/tools/neovim/Neovim/bin/win32yank.exe -i --crlf',
          \    },
          \   'paste': {
          \      '+': '/mnt/c/tools/neovim/Neovim/bin/win32yank.exe -o --lf',
          \      '*': '/mnt/c/tools/neovim/Neovim/bin/win32yank.exe -o --lf',
          \   },
          \   'cache_enabled': 1,
          \ }
endif

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
let g:shouldChangePWD=0
function! ChangePWDToggleLogic() abort
    " Handle the toggle
    if g:shouldChangePWD
        autocmd! ChangePWD BufEnter *
    else
        augroup ChangePWD
            au!
            autocmd BufEnter * if expand("%:p:h") !~ "^/tmp" | silent! lcd %:p:h | endif
        augroup END
        if expand("%:p:h") !~ "^/tmp" | silent! lcd %:p:h | endif
    endif
endfunction

function! ToggleShouldChangePWD( shouldToggle, ... ) abort
    " Handle the toggle
    call ChangePWDToggleLogic()

    " If we should toggle
    if ( a:shouldToggle == v:true )
        let g:shouldChangePWD=!g:shouldChangePWD
    endif

    " If the user specified to immediately cancel the ChangePWD functionality
    " " NOTE: a:0 is # of extra args, a:1 is the first extra arg
    if (a:0 == 1 && a:1 == v:true)
        let g:shouldChangePWD=0
        autocmd! ChangePWD BufEnter *
    else
        " Let the user know that the toggle occurred
        echo 'Nvim will ' . (g:shouldChangePWD ? 'now ' : 'not ') . 'change to the pwd of the most recently opened file.'
    endif
endfunction

function! SetShouldChangePWD( newVal ) abort
    " The way ChangePWDToggleLogic works, I have to set it to the opposite val
    " first.
    let g:shouldChangePWD=!a:newVal
    call ChangePWDToggleLogic()
    let g:shouldChangePWD=a:newVal
endfunction

" Commands to toggle ChangePWD functionality. Mostly called at startup.
command! ToggleChangePWD :call ToggleShouldChangePWD( v:true )
command! ToggleChangePWDAndImmediatelyTurnOff :call ToggleShouldChangePWD( v:true, v:true)

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
map gdd :bd<CR>

" Terminal opening commands
command! TT :tabnew | term
command! ST :sp | term
command! VT :vsp | term

" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <silent><leader>0 :tablast<cr>

" Open Org directory
" TODO: Edit my configs in current buffer
function! OpenLocation( name ) abort
    " Set that it changes to the pwd of the opened file.
    call SetShouldChangePWD( 1 )
    let l:defaultVal = '~/.zshrc'
    let result = get(
                \ { 
                    \ 'zshrc' : '~/.zshrc',
                    \ 'nvim' : '~/.config/nvim/init.vim',
                    \ 'org' : '~/Desktop/what-ive-learned/README.org'
                    \ },
                \ a:name,
                \ l:defaultVal)
    execute 'edit ' . result
    " Deactivate so it doesn't do it again
    call SetShouldChangePWD( 0 )
endfunction

command! OpenZsh :silent! call OpenLocation( 'zshrc' )
command! OpenConfig :silent! call OpenLocation( 'nvim' )
command! OpenOrg :silent! call OpenLocation( 'org' )

let g:org_agenda_files=['~/Desktop/what-ive-learned/*.org', '~/Desktop/what-ive-learned/projects/*.org']
let g:org_export_emacs="/usr/local/bin/emacs"
let g:org_todo_keywords = [['TODO(t)', 'LOOKINTO(l)', '|', 'DONE(d)'],
  \ ['REPORT(r)', 'BUG(b)', 'KNOWNCAUSE(k)', '|', 'FIXED(f)'],
  \ ['CANCELED(c)']]

" whichkey
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

" send make command only if a valid Makefile exists in the root of the repo.
function! Makeit() abort
    if filereadable(getcwd() . '/Makefile')
        execute ':silent !~/.dotfiles/self_scripts/tmux-build-workflow ' . getcwd() . ' make'
    endif
endfunction

command! Makeit :call Makeit()
