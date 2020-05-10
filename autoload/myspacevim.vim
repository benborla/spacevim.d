function! IPhpInsertUse()
  call PhpInsertUse()
  call feedkeys('a',  'n')
endfunction

function! IPhpExpandClass()
    call PhpExpandClass()
    call feedkeys('a', 'n')
endfunction

function! UpdatePhpDocIfExists()
    normal! k
    if getline('.') =~ '/'
        normal! V%d
    else
        normal! j
    endif
    call PhpDocSingle()
    normal! k^%k$
    if getline('.') =~ ';'
        exe "normal! $svoid"
    endif
endfunction

function! myspacevim#before() abort

  " Disable backups and extra file creation
  set nowritebackup
  set noswapfile
  set nobackup

  " Material theme
  let g:material_style='oceanic'
  let g:airline_theme='material'
  autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE

  " Use Vim Airline for Tabline and Statusline
  call SpaceVim#layers#disable('core#statusline')
  call SpaceVim#layers#disable('core#tabline')
  "! Disable bookmark for airline as it is causing an error
  let g:airline#extensions#bookmark#enabled = 0
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#tabline#show_buffers = 0
  let g:airline#extensions#tabline#show_tabs = 1
  let g:airline#extensions#branch#enabled = 1
  let g:airline#extensions#hunks#enabled = 1
  let g:airline#extensions#whitespace#enabled = 0
  " Just show the filename (no path) in the tab
  let g:airline#extensions#tabline#fnamemod = ':t'
  let g:airline#extensions#tabline#show_tab_nr = 1
  let g:airline#extensions#tabline#show_tab_type = 2
  let g:airline#extensions#tabline#tabs_label = 't'

  set t_ZH=^[[3m
  set t_ZR=^[[23m

  set tags+=tags
  set clipboard=unnamedplus

  set colorcolumn=80
  set mat=2

  inoremap ii <ESC>
  inoremap <ESC> <NOP>

  vnoremap ii <ESC>
  vnoremap <ESC> <NOP>

  inoremap ww <ESC>:w!<CR>
  vnoremap ww <ESC>:w!<CR>
  nnoremap nww <ESC>:w!<CR>

  nnoremap q <ESC>:q!<CR>

  cnoremap ii <ESC>

  noremap <Up> <NOP>
  noremap <Down> <NOP>
  noremap <Left> <NOP>
  noremap <Right> <NOP>

  inoremap ;o <ESC>:TagbarToggle<CR>
  vnoremap ;o <ESC>:TagbarToggle<CR>
  nnoremap ;o <ESC>:TagbarToggle<CR>

  nnoremap j gj
  nnoremap k gk
  set guioptions-=e
  set sessionoptions+=tabpages,globals

  autocmd VimEnter * highlight LineNr guifg=#ffffff
  autocmd VimEnter * highlight CursorLine term=bold cterm=bold guibg=#2F4F4F
  autocmd VimEnter * highlight ColorColumn ctermbg=lightgrey guibg=#8B0000
  autocmd VimEnter * highlight Visual guifg=black guibg=Yellow gui=none
  autocmd VimEnter * highlight Comment guifg=#228B22 cterm=italic gui=italic

  autocmd FileType php inoremap <Leader>u <Esc>:call IPhpInsertUse()<CR>
  autocmd FileType php noremap <Leader>u :call PhpInsertUse()<CR>
  autocmd FileType php inoremap <Leader>e <Esc>:call IPhpExpandClass()<CR>
  autocmd FileType php noremap <Leader>e :call PhpExpandClass()<CR>
  autocmd FileType php inoremap <Leader>s <Esc>:call PhpSortUse()<CR>

  let g:php_namespace_sort_after_insert = 1
  let g:neomake_javascript_eslint_maker =  {
        \ 'exe': 'npx',
        \ 'args': ['--quiet', 'eslint', '--format=compact'],
        \ 'errorformat': '%E%f: line %l\, col %c\, Error - %m,' .
        \   '%W%f: line %l\, col %c\, Warning - %m,%-G,%-G%*\d problems%#',
        \ 'cwd': '%:p:h',
        \ 'output_stream': 'stdout'
        \ }

  let g:neomake_javascript_jsx_enabled_makers = ['eslint']
  let g:neoformat_enabled_javascript = ['npxprettier']

  let b:ale_fixers = {'javascript': ['prettier', 'standard'], 'php': ['php', 'phpcs']}
  let b:ale_linters = {'php': ['php', 'phpcs']}
  let g:ale_set_highlights = 0
  let g:ale_echo_cursor = 1
  let g:ale_fix_on_save = 1

  let g:pdv_template_dir = $HOME ."/.SpaceVim.d/snip"
  nnoremap <buffer> ;w :call pdv#DocumentCurrentLine()<CR>
  nnoremap <leader>h :call UpdatePhpDocIfExists()<CR>
  let g:spacevim_enable_clap = 1
endfunction

function! myspacevim#after() abort
endfunction
