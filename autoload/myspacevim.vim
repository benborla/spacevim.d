function! IPhpInsertUse()
  call PhpInsertUse()
  call feedkeys('a',  'n')
endfunction

function! IPhpExpandClass()
    call PhpExpandClass()
    call feedkeys('a', 'n')
endfunction


function! myspacevim#before() abort

  autocmd VimEnter * set tabline=%!MyTabLine()
  set t_ZH=^[[3m
  set t_ZR=^[[23m

  set tags+=tags
  set clipboard=unnamedplus

  set colorcolumn=80
  set mat=2

  noremap ;tn <ESC>:set tabline=%!MyTabLine()<CR>

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

  set tabline=%!MyTabLine()
  autocmd VimEnter * highlight Comment cterm=italic gui=italic
  autocmd VimEnter * highlight Visual guifg=black guibg=Yellow gui=none

  autocmd FileType php inoremap <Leader>u <Esc>:call IPhpInsertUse()<CR>
  autocmd FileType php noremap <Leader>u :call PhpInsertUse()<CR>
  autocmd FileType php inoremap <Leader>e <Esc>:call IPhpExpandClass()<CR>
  autocmd FileType php noremap <Leader>e :call PhpExpandClass()<CR>
  autocmd FileType php inoremap <Leader>s <Esc>:call PhpSortUse()<CR>
  autocmd FileType php noremap <Leader>s :call PhpSortUse()<CR>

  hi TabLine      ctermfg=Black  ctermbg=Green     cterm=NONE
  hi TabLineFill  ctermfg=Black  ctermbg=Green     cterm=NONE
  hi TabLineSel   ctermfg=White  ctermbg=DarkBlue  cterm=NONE

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

endfunction


function! myspacevim#after() abort
  
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

if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let wn = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let s .= ' '
            let wn = tabpagewinnr(i,'$')

            let s .= '%#TabNum#'
            let s .= i
            " let s .= '%*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            if buftype == 'nofile'
                if file =~ '\/.'
                    let file = substitute(file, '.*\/\ze.', '', '')
                endif
            else
                let file = fnamemodify(file, ':p:t')
            endif
            if file == ''
                let file = '[No Name]'
            endif
            let s .= ' ' . file . ' '
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
        return s
    endfunction
    set stal=2
    set tabline=%!MyTabLine()
    set showtabline=1
    highlight link TabNum Special
    set tabpagemax=15
    hi TabLineSel term=bold cterm=bold ctermfg=16 ctermbg=229
    hi TabWinNumSel term=bold cterm=bold ctermfg=90 ctermbg=229
    hi TabNumSel term=bold cterm=bold ctermfg=16 ctermbg=229

    hi TabLine term=underline ctermfg=16 ctermbg=145
    hi TabWinNum term=bold cterm=bold ctermfg=90 ctermbg=145
    hi TabNum term=bold cterm=bold ctermfg=16 ctermbg=145
endif
