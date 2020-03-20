function! IPhpInsertUse()
  call PhpInsertUse()
  call feedkeys('a',  'n')
endfunction

function! IPhpExpandClass()
    call PhpExpandClass()
    call feedkeys('a', 'n')
endfunction

function! myspacevim#before() abort
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
  autocmd VimEnter * highlight Comment cterm=italic gui=italic
  autocmd VimEnter * highlight Visual guifg=black guibg=Yellow gui=none
  let NERDTreeMapActivateNode='l'

 set guioptions-=e
 set sessionoptions+=tabpages,globals
  autocmd FileType php inoremap <Leader>u <Esc>:call IPhpInsertUse()<CR>
  autocmd FileType php noremap <Leader>u :call PhpInsertUse()<CR>
  autocmd FileType php inoremap <Leader>e <Esc>:call IPhpExpandClass()<CR>
  autocmd FileType php noremap <Leader>e :call PhpExpandClass()<CR>
  autocmd FileType php inoremap <Leader>s <Esc>:call PhpSortUse()<CR>
  autocmd FileType php noremap <Leader>s :call PhpSortUse()<CR>

  let g:php_namespace_sort_after_insert = 1
endfunction


function! myspacevim#after() abort
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
  
endfunction


function! Whitespace()
    if !exists('b:ws')
        highlight Conceal ctermbg=NONE ctermfg=240 cterm=NONE guibg=NONE guifg=#585858 gui=NONE
        highlight link Whitespace Conceal
        let b:ws = 1
    endif

    syntax clear Whitespace
    syntax match Whitespace / / containedin=ALL conceal cchar=·
    setlocal conceallevel=2 concealcursor=c
endfunction

augroup Whitespace
    autocmd!
    autocmd BufEnter,WinEnter * call Whitespace()
augroup END
