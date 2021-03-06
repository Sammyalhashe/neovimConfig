scriptencoding utf-8
let s:cache = {'branch': ''}

augroup custom_statusline
  autocmd!
  autocmd VimEnter * silent! call FugitiveDetect(expand('<afile>')) | let s:cache.branch = fugitive#head()
  autocmd BufEnter,WinEnter * setlocal statusline=%!Statusline()
  autocmd BufLeave,WinLeave * setlocal statusline=%f\ %y\ %m
  autocmd User FugitiveChanged let s:cache.branch = fugitive#head()
  autocmd VimEnter,ColorScheme * call s:set_statusline_colors()
augroup END

function! s:set_statusline_colors() abort
  let s:normal_bg = synIDattr(hlID('Normal'), 'bg')
  let s:normal_fg = synIDattr(hlID('Normal'), 'fg')
  let s:warning_fg = synIDattr(hlID(g:colors_name ==? 'gruvbox' && &background ==? 'dark' ? 'GruvboxYellow' : 'WarningMsg'), g:colors_name ==? 'gruvbox' && &background ==? 'dark' ? 'fg' : 'bg')
  " let s:error_fg = synIDattr(hlID('ErrorMsg'), &background ==? 'dark' ? 'bg' : 'fg')
  let s:error_fg = synIDattr(hlID('ErrorMsg'), 'bg')

  silent! exe 'hi StItem guibg='.s:normal_fg.' guifg='.s:normal_bg.' gui=NONE'
  silent! exe 'hi StSep guifg='.s:normal_fg.' guibg=NONE gui=NONE'
  silent! exe 'hi StErr guibg='.s:error_fg.' guifg='.s:normal_bg.' gui=bold'
  silent! exe 'hi StErrSep guifg='.s:error_fg.' guibg=NONE gui=NONE'
  if g:colors_name ==? 'gruvbox' && &background ==? 'dark'
      silent! exe 'hi StWarn guibg='.s:warning_fg.' guifg='.s:normal_bg.' gui=bold'
  else
      silent! exe 'hi StWarn guibg='.s:warning_fg.' guifg='.s:normal_bg.' gui=bold'
  endif
  silent! exe 'hi StWarnSep guifg='.s:warning_fg.' guibg=NONE gui=NONE'
  silent! exe 'hi Statusline guifg=NONE guibg='.s:normal_bg.' gui=NONE cterm=NONE'
endfunction

function! s:sep(item, ...) abort
  let l:opts = get(a:, '1', {})
  let l:before = get(l:opts, 'before', ' ')
  let l:sep_color = get(l:opts, 'sep_color', '%#StSep#')
  let l:color = get(l:opts, 'color', '%#StItem#')

  return l:before.l:sep_color.'█'.l:color.a:item.l:sep_color.'█%*'
  " let l:msep = "█"
  " let l:lsep = "\ue0c3"
  " let l:rsep = "\ue0b8"
  " return l:before.l:sep_color. l:lsep . ' ' . l:msep . l:color.a:item.l:sep_color. l:rsep . '%*'
endfunction


function! s:rsep(item, ...) abort
  let l:opts = get(a:, '1', {})
  let l:before = get(l:opts, 'before', ' ')
  let l:sep_color = get(l:opts, 'sep_color', '%#StSep#')
  let l:color = get(l:opts, 'color', '%#StItem#')

  return l:before.l:sep_color.'█'.l:color.a:item.l:sep_color.'█%*'
  " let l:msep = "█"
  " let l:lsep = "\ue0ba"
  " " let l:lsep = "\u2221"
  " let l:rsep = "\ue0c1"
  " return l:before.l:sep_color. l:lsep . l:msep . l:color.a:item.l:sep_color . l:msep . l:rsep . '%*'
endfunction

function! s:sep_if(item, condition, ...) abort
  if !a:condition
    return ''
  endif
  let l:opts = get(a:, '1', {})

  return s:sep(a:item, l:opts)
endfunction


function! s:rsep_if(item, condition, ...) abort
  if !a:condition
    return ''
  endif
  let l:opts = get(a:, '1', {})
  return s:rsep(a:item, l:opts)
endfunction

let s:st_err = {'color': '%#StErr#', 'sep_color': '%#StErrSep#'}
let s:st_warn = {'color': '%#StWarn#', 'sep_color': '%#StWarnSep#'}
let s:st_mode = {'color': '%#StMode#', 'sep_color': '%#StModeSep#'}

function! Statusline() abort
  let l:mode = s:mode_statusline()
  let l:statusline = s:sep(l:mode, extend({'before': ''}, s:st_mode))
  let l:git_status = s:git_statusline()
  let l:statusline .= s:sep_if(l:git_status, !empty(l:git_status))
  let l:statusline .= s:sep(s:get_path(), &modified ? s:st_err : {})            "File path
  let l:statusline .= s:sep_if(' + ', &modified, s:st_mode)                      "Modified indicator
  let l:statusline .= s:sep_if(' - ', !&modifiable, s:st_err)                   "Modifiable indicator
  " let l:statusline .= s:sep(WebDevIconsGetFileFormatSymbol() . "\u2765")            		"File format
  let l:statusline .= s:sep_if('%w', &previewwindow)                            "Preview indicator
  let l:statusline .= s:sep_if('%r', &readonly)                                 "Read only indicator
  let l:statusline .= s:sep_if('%q', &buftype ==? 'quickfix')                   "Quickfix list indicator
  let l:statusline .= '%='                                                      "Start right side layout
  let l:anzu = exists('*anzu#search_status') ? anzu#search_status() : ''
  let l:statusline .= s:sep_if(l:anzu, !empty(l:anzu))                          "Search status
  let l:ft = &filetype
  let l:statusline .= s:rsep_if(l:ft . ' ' . luaeval('require("nvim-web-devicons").get_icon("", "' . &ft .'", { default = true })') . ' ', !empty(l:ft))  "Filetype
  if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
      let l:statusline .= s:rsep("\u26d4 " . luaeval("vim.lsp.diagnostic.get_count(0, [[Error]])"), s:st_err)
      let l:statusline .= s:rsep("\u26A0 " . luaeval("vim.lsp.diagnostic.get_count(0, [[Warning]])"), s:st_warn)
  end
  let l:statusline .= s:rsep(': %c', s:st_mode)                                "Column number
  let l:statusline .= s:rsep(': %l/%L', s:st_mode)                              "Current line number/Total line numbers
  let l:statusline .= s:rsep('%p%%', s:st_mode)                                  "Percentage
  let l:err = s:ale_status('error')
  let l:warn = s:ale_status('warning')
  let l:statusline .= s:rsep_if(l:err, !empty(l:err), s:st_err)
  let l:statusline .= s:rsep_if(l:warn, !empty(l:warn), s:st_warn)
  let l:statusline .= '%<'
  return l:statusline
endfunction


function! s:ale_status(type) abort
  if !exists('g:loaded_ale')
    return ''
  endif

  let l:count = ale#statusline#Count(bufnr(''))
  let l:errors = l:count.error + l:count.style_error
  let l:warnings = l:count.warning + l:count.style_warning

  if a:type ==? 'error' && l:errors
    return printf('%d E', l:errors)
  endif

  if a:type ==? 'warning' && l:warnings
    return printf('%d W', l:warnings)
  endif

  return ''
endfunction

function! s:git_statusline() abort
  if !exists('b:gitgutter')
    return s:with_icon(s:cache.branch, "\ue0a0")
  endif
  let [l:added, l:modified, l:removed] = get(b:gitgutter, 'summary', [0, 0, 0])
  let l:result = l:added == 0 ? '' : ' +'.l:added
  let l:result .= l:modified == 0 ? '' : ' ~'.l:modified
  let l:result .= l:removed == 0 ? '' : ' -'.l:removed
  let l:result = join(filter([s:cache.branch, l:result], {-> !empty(v:val) }), '')
  return s:with_icon(l:result, "\ue0a0")
endfunction

function! s:mode_statusline() abort
  let l:mode = mode()
  call s:mode_highlight(l:mode)
  let l:modeMap = {
  \ 'n'  : 'NORMAL',
  \ 'i'  : 'INSERT',
  \ 'R'  : 'REPLACE',
  \ 'v'  : 'VISUAL',
  \ 'V'  : 'V-LINE',
  \ 'c'  : 'COMMAND',
  \ '' : 'V-BLOCK',
  \ 's'  : 'SELECT',
  \ 'S'  : 'S-LINE',
  \ '' : 'S-BLOCK',
  \ 't'  : 'TERMINAL',
  \ }

  return get(l:modeMap, l:mode, 'UNKNOWN')
endfunction

function! s:mode_highlight(mode) abort
  if a:mode ==? 'i'
    hi StMode guibg=#83a598 guifg=#3c3836
    hi StModeSep guifg=#83a598 guibg=NONE
  elseif a:mode =~? '\(v\|V\|\)'
    hi StMode guibg=#fe8019 guifg=#3c3836
    hi StModeSep guifg=#fe8019 guibg=NONE
  elseif a:mode ==? 'R'
    hi StMode guibg=#8ec07c guifg=#3c3836
    hi StModeSep guifg=#8ec07c guibg=NONE
  else
    silent! exe 'hi StMode guibg='.s:normal_fg.' guifg='.s:normal_bg.' gui=NONE'
    silent! exe 'hi StModeSep guifg='.s:normal_fg.' guibg=NONE gui=NONE'
  endif
endfunction

function! s:with_icon(value, icon) abort
  if empty(a:value)
    return a:value
  endif
  return a:icon.' '.a:value
endfunction

function! s:get_path() abort
  let l:path = expand('%')
  if isdirectory(l:path)
    return '%F'
  endif

  let l:path = substitute(expand('%'), '^'.getcwd(), '', '')

  if len(l:path) < 40
    return '%f'
  endif

  return pathshorten(l:path)
endfunction
