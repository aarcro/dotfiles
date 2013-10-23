" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %

" Load pathogen - package mangement for vim
call pathogen#infect()

"The default leader is '\', but many people prefer ',' as it's in a standard location
let mapleader = ','

colors desert
set ts=4
set sw=4
set et
set ai
syntax on
set hlsearch

:function! Go_wide()
:% s/,/ /g
:set ts=40
:set nowrap
:set ss=5
:endfunction

nnoremap <C-p> :set invpaste paste?<CR>
set pastetoggle=<C-p>
set showmode

" Only in python files
au BufRead,BufNewFile *.py,*.pyw highlight OverLength ctermbg=red ctermfg=white guibg=#592929
au BufRead,BufNewFile *.py,*.pyw match OverLength /\%80v.\+/
" Add breakpoints
map <Leader>b Oimport pdb; pdb.set_trace() # BREAKPOINT<C-c>

" better for html
au BufRead,BufNewFile *.html,*.js set ts=2|set sw=2

" Making it so ; works like : for commands. Saves typing and eliminates :W style typos due to lazy holding shift.
nnoremap ; :

"clearing highlighted search
nmap <silent> <leader>/ :nohlsearch<CR>

" Change Working Directory to that of the current file
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h

map <C-h> :tabp<CR>
map <C-l> :tabn<CR>
imap <C-h> <esc>:tabp<CR>
imap <C-l> <esc>:tabn<CR>
map <C-n> :tabnew 
map <leader>n :tabnew<CR>:CtrlP<CR>
map <leader>o :CtrlP<CR>

set showtabline=2

:function! Fixquote()
:% s/“/\&ldquo;/g
:% s/”/\&rdquo;/g
:% s/’/\&rsquo;/g
:endfunction

" Sort a paragraph (like a block of imports)
map <leader>s vip:sort<cr>

" ctrlp stuff
let g:ctrlp_max_height = 30
let g:ctrlp_working_path_mode = 'ra'

" Common files to ignore
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=*/coverage/*
" I don't want to see all the migrations
set wildignore+=*/migrations/*

" jedi settings
" If you have errors about jedi at startup: pip install jedi
" leader-n is new a ctrlp tab, lets use leader-a for all usages
let g:jedi#usages_command = "<leader>a"
