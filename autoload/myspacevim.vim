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

" ==============================================================
function! myspacevim#before() abort
  set clipboard=unnamedplus
  set colorcolumn=80
  set mat=2
  set tags+=tags

  inoremap ii <ESC>
  inoremap <ESC> <NOP>

  vnoremap ii <ESC>
  vnoremap <ESC> <NOP>

  inoremap ww <ESC>:w!<CR>
  vnoremap ww <ESC>:w!<CR>
  nnoremap nww <ESC>:w!<CR>

  nnoremap qq <ESC>:q!<CR>
  noremap nt <ESC>:tabnew<CR>
  noremap nT <ESC>:tabnew#<CR>

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

  " Material theme
  " Background should be set to #050715
  let g:material_style='oceanic'
  " let g:airline_theme='material'
  autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
  " syntax color scheme modifiers
  autocmd VimEnter * highlight String guifg=#80cbc4 guibg=None
  autocmd VimEnter * highlight Normal guifg=#ffb62c guibg=None

  autocmd VimEnter * highlight LineNr guifg=#3d7184
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

  let b:ale_fixers = {'php': ['php', 'phpcs']}
  let b:ale_linters = {'php': ['php', 'phpcs']}

  let g:ale_set_highlights = 0
  let g:ale_echo_cursor = 1
  let g:ale_fix_on_save = 1

  " resize file explorer
  nnoremap a{ <ESC>:vertical resize +20<CR>
  nnoremap a} <ESC>:vertical resize -20<CR>

  " PHP CS
    " If php-cs-fixer is in $PATH, you don't need to define line below
    let g:php_cs_fixer_path = "php-cs-fixer" " define the path to the php-cs-fixer.phar

    " If you use php-cs-fixer version 1.x
    let g:php_cs_fixer_level = "symfony"                   " options: --level (default:symfony)
    let g:php_cs_fixer_config = "default"                  " options: --config
    " If you want to define specific fixers:
    "let g:php_cs_fixer_fixers_list = "linefeed,short_tag" " options: --fixers
    "let g:php_cs_fixer_config_file = '.php_cs'            " options: --config-file
    " End of php-cs-fixer version 1 config params

    " If you use php-cs-fixer version 2.x
    let g:php_cs_fixer_rules = "@PSR2"          " options: --rules (default:@PSR2)
    "let g:php_cs_fixer_cache = ".php_cs.cache" " options: --cache-file
    "let g:php_cs_fixer_config_file = '.php_cs' " options: --config
    " End of php-cs-fixer version 2 config params

    let g:php_cs_fixer_php_path = "php"               " Path to PHP
    let g:php_cs_fixer_enable_default_mapping = 1     " Enable the mapping by default (<leader>pcd)
    let g:php_cs_fixer_dry_run = 0                    " Call command with dry-run option
    let g:php_cs_fixer_verbose = 0                    " Return the output of command if 1, else an inline information.
  " -- END PHP CS --
  let g:UltiSnipsEditSplit="vertical"
  

  "  Telescope
  " Find files using Telescope command-line sugar.
	nnoremap ;ff <cmd>Telescope find_files<cr>
	nnoremap ;gg <cmd>:Grepper<cr>
	nnoremap ;md <cmd>:Glow<cr>
	nnoremap <leader>fg <cmd>Telescope live_grep<cr>
	nnoremap <leader>fb <cmd>Telescope buffers<cr>
	nnoremap <leader>fh <cmd>Telescope help_tags<cr>

	" Using lua functions
	nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
	nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
	nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
	nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

	" nvim-hlslens
	noremap <silent> n <Cmd>execute('normal! ' . v:count1 . 'n')<CR>
				\<Cmd>lua require('hlslens').start()<CR>
	noremap <silent> N <Cmd>execute('normal! ' . v:count1 . 'N')<CR>
				\<Cmd>lua require('hlslens').start()<CR>
	noremap * *<Cmd>lua require('hlslens').start()<CR>
	noremap # #<Cmd>lua require('hlslens').start()<CR>
	noremap g* g*<Cmd>lua require('hlslens').start()<CR>
	noremap g# g#<Cmd>lua require('hlslens').start()<CR>

	" highlight default link HlSearchLensCur IncSearch
	" highlight default link HlSearchLens WildMenu
	" highlight default link HlSearchCur IncSearch

	" use : instead of <Cmd>
	nnoremap <silent> <leader>l :nohlsearch<CR>
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

" ==============================================================
function! myspacevim#before() abort
  set clipboard=unnamedplus
  set colorcolumn=80
  set mat=2
  set tags+=tags

  inoremap ii <ESC>
  inoremap <ESC> <NOP>

  vnoremap ii <ESC>
  vnoremap <ESC> <NOP>

  inoremap ww <ESC>:w!<CR>
  vnoremap ww <ESC>:w!<CR>
  nnoremap nww <ESC>:w!<CR>

  nnoremap qq <ESC>:q!<CR>
  noremap nt <ESC>:tabnew<CR>
  noremap nT <ESC>:tabnew#<CR>

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

  " Material theme
  " Background should be set to #050715
  let g:material_style='oceanic'
  " let g:airline_theme='material'
  autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
  " syntax color scheme modifiers
  autocmd VimEnter * highlight String guifg=#80cbc4 guibg=None
  autocmd VimEnter * highlight Normal guifg=#ffb62c guibg=None

  autocmd VimEnter * highlight LineNr guifg=#3d7184
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

  let b:ale_fixers = {'php': ['php', 'phpcs']}
  let b:ale_linters = {'php': ['php', 'phpcs']}

  let g:ale_set_highlights = 0
  let g:ale_echo_cursor = 1
  let g:ale_fix_on_save = 1

  " resize file explorer
  nnoremap a{ <ESC>:vertical resize +20<CR>
  nnoremap a} <ESC>:vertical resize -20<CR>

  " PHP CS
    " If php-cs-fixer is in $PATH, you don't need to define line below
    let g:php_cs_fixer_path = "php-cs-fixer" " define the path to the php-cs-fixer.phar

    " If you use php-cs-fixer version 1.x
    let g:php_cs_fixer_level = "symfony"                   " options: --level (default:symfony)
    let g:php_cs_fixer_config = "default"                  " options: --config
    " If you want to define specific fixers:
    "let g:php_cs_fixer_fixers_list = "linefeed,short_tag" " options: --fixers
    "let g:php_cs_fixer_config_file = '.php_cs'            " options: --config-file
    " End of php-cs-fixer version 1 config params

    " If you use php-cs-fixer version 2.x
    let g:php_cs_fixer_rules = "@PSR2"          " options: --rules (default:@PSR2)
    "let g:php_cs_fixer_cache = ".php_cs.cache" " options: --cache-file
    "let g:php_cs_fixer_config_file = '.php_cs' " options: --config
    " End of php-cs-fixer version 2 config params

    let g:php_cs_fixer_php_path = "php"               " Path to PHP
    let g:php_cs_fixer_enable_default_mapping = 1     " Enable the mapping by default (<leader>pcd)
    let g:php_cs_fixer_dry_run = 0                    " Call command with dry-run option
    let g:php_cs_fixer_verbose = 0                    " Return the output of command if 1, else an inline information.
  " -- END PHP CS --
  let g:UltiSnipsEditSplit="vertical"
  

  "  Telescope
  " Find files using Telescope command-line sugar.
	nnoremap ;ff <cmd>Telescope find_files<cr>
	nnoremap ;gg <cmd>:Grepper<cr>
	nnoremap ;md <cmd>:Glow<cr>
	nnoremap <leader>fg <cmd>Telescope live_grep<cr>
	nnoremap <leader>fb <cmd>Telescope buffers<cr>
	nnoremap <leader>fh <cmd>Telescope help_tags<cr>

	" Using lua functions
	nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
	nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
	nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
	nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

	" nvim-hlslens
	noremap <silent> n <Cmd>execute('normal! ' . v:count1 . 'n')<CR>
				\<Cmd>lua require('hlslens').start()<CR>
	noremap <silent> N <Cmd>execute('normal! ' . v:count1 . 'N')<CR>
				\<Cmd>lua require('hlslens').start()<CR>
	noremap * *<Cmd>lua require('hlslens').start()<CR>
	noremap # #<Cmd>lua require('hlslens').start()<CR>
	noremap g* g*<Cmd>lua require('hlslens').start()<CR>
	noremap g# g#<Cmd>lua require('hlslens').start()<CR>

	" highlight default link HlSearchLensCur IncSearch
	" highlight default link HlSearchLens WildMenu
	" highlight default link HlSearchCur IncSearch

	" use : instead of <Cmd>
	nnoremap <silent> <leader>l :nohlsearch<CR>
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
