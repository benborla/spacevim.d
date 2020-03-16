function! IPhpInsertUse()
  call PhpInsertUse()
  call feedkeys('a',  'n')
endfunction
autocmd FileType php inoremap <Leader>u <Esc>:call IPhpInsertUse()<CR>
autocmd FileType php noremap <Leader>u :call PhpInsertUse()<CR>

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
  autocmd VimEnter * set tabline=%!MyTabLine()  " custom tab pages line


let g:spacevim_custom_plugins = [
            \ ['arnaud-lb/vim-php-namespace', {'merged' : 0}],
            \ ['gcmt/taboo.vim', {'merged' : 0}],
            \ ['beyondwords/vim-twig', {'merged' : 0}],
            \ ['jwalton512/vim-blade', {'merged' : 0}],
            \ ['vim-airline/vim-airline', {'merged' : 0}],
            \ ['vim-airline/vim-airline-themes', {'merged' : 0}]            
            \ ]

 set guioptions-=e
 set sessionoptions+=tabpages,globals

 " tabline
let g:airline_theme='gruvbox'                                                                                                             
let g:airline_powerline_fonts = 1                                                                                                         
let g:airline_section_b = '%{getcwd()}' " in section B of the status line display the CWD                                                 

"TABLINE:                                                                                                                                 
let g:airline#extensions#tabline#enabled = 1           " enable airline tabline                                                           
let g:airline#extensions#tabline#show_close_button = 0 " remove 'X' at the end of the tabline                                            
let g:airline#extensions#tabline#tabs_label = ''       " can put text here like BUFFERS to denote buffers (I clear it so nothing is shown)
let g:airline#extensions#tabline#buffers_label = ''    " can put text here like TABS to denote tabs (I clear it so nothing is shown)      
let g:airline#extensions#tabline#fnamemod = ':t'       " disable file paths in the tab                                                    
let g:airline#extensions#tabline#show_tab_count = 0    " dont show tab numbers on the right                                                           
let g:airline#extensions#tabline#show_buffers = 0      " dont show buffers in the tabline                                                 
let g:airline#extensions#tabline#tab_min_count = 2     " minimum of 2 tabs needed to display the tabline                                  
let g:airline#extensions#tabline#show_splits = 0       " disables the buffer name that displays on the right of the tabline               
let g:airline#extensions#tabline#show_tab_nr = 1       " disable tab numbers                                                              
let g:airline#extensions#tabline#show_tab_type = 0     " disables the weird ornage arrow on the tabline
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_powerline_fonts = 1
endfunction


function! myspacevim#after() abort
  let g:neomake_javascript_eslint_maker =  {
        \ 'exe': 'npx',
        \ 'args': ['--quiet', 'eslint', '--format=compact'],
        \ 'errorformat': '%E%f: line %l\, col %c\, Error - %m,' .
        \   '%W%f: line %l\, col %c\, Warning - %m,%-G,%-G%*\d problems%#',
        \ 'cwd': '%:p:h',
        \ 'output_stream': 'stdout',
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


" Rename tabs to show tab number.
" (Based on http://stackoverflow.com/questions/5927952/whats-implementation-of-vims-default-tabline-function)
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
endif
