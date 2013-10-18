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

:function! Fixquote()
:% s/“/\&ldquo;/g
:% s/”/\&rdquo;/g
:% s/’/\&rsquo;/g
:endfunction
