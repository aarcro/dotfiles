" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %

" Load pathogen - package mangement for vim
call pathogen#infect()

" Respect comments like // vim: set ts=2
set modeline

"The default leader is '\', but many people prefer ',' as it's in a standard location
let mapleader = ','

nmap <Leader>t :% s/\s\+$//<CR>,/''

" If you're having trouble with colors:
" set t_Co=256
colors desert256
set ts=4
set sw=4
set et
set ai
syntax on

" Search stuff
set hlsearch
set ignorecase
set smartcase

:function! Go_wide()
:% s/,/	/g
:set ts=40
:set nowrap
:set ss=5
:endfunction

" use cc to change 'til
nnoremap cc ct

nnoremap <C-p> :set invpaste paste?<CR>
inoremap <C-p> <esc>:set invpaste paste?<CR>a
set pastetoggle=<C-p>
set showmode

" Highlight column 80 and 110
if version >= 703
    set colorcolumn=80,110
    highlight ColorColumn ctermbg=233
endif

" Add breakpoints
map <Leader>b Oimport pdb; pdb.set_trace() # BREAKPOINT<C-c>

" Smaller tabs in html/js files
au BufRead,BufNewFile *.html,*.js setlocal ts=2 | set sw=2

au BufRead,BufNewFile *.wsgi set filetype=python

au BufRead,BufNewFile psql.edit.* set filetype=sql

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
map <C-n> :tabnew<Space>
map <leader>n :tabnew<CR>:CtrlP<CR>

set showtabline=2

:function! Fixquote()
:% s/“/\&ldquo;/g
:% s/”/\&rdquo;/g
:% s/’/\&rsquo;/g
:endfunction

" toggle spelling use ,p
imap <Leader>p <C-o>:setlocal spell!<CR>
nmap <Leader>p :setlocal spell!<CR>

" Sort a paragraph (like a block of imports)
map <leader>s vip:sort<CR>

" Sort a comma seperated list (like a line of imports)
map <leader>S :call setline(line('.'),join(sort(split(getline('.'), ',\s*')), ', '))<CR>

" Keep visual block when shifting
vnoremap > >gv
vnoremap < <gv

" ctrlp stuff
let g:ctrlp_max_height = 30
let g:ctrlp_working_path_mode = 'ra'
"<c-p> is paste toggle, I don't care what ctrlp is called
let g:ctrlp_map = '<leader>o'

" Common files to ignore
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=*/coverage/*
set wildignore+=*/serve[-_]static/*
set wildignore+=*/site[-_]media/*
" I don't want to see all the migrations
set wildignore+=*/migrations/*

" jedi settings
" If you have errors about jedi at startup: pip install jedi
" leader-n is new a ctrlp tab, lets use leader-a for all usages
let g:jedi#usages_command = "<leader>a"
" Don't pop docstring window on completion (only on <S-k>)
autocmd FileType python setlocal completeopt-=preview

" Folding colors (don't know why default is whack)
:highlight Folded guibg=grey guifg=blue ctermbg=233
:highlight FoldColumn guibg=darkgrey guifg=white ctermbg=0 ctermfg=1

" Don't confuse people who don't know folds
set foldlevelstart=99

" eazy maps to toggle folding
map f za
map F :call ToggleFold()<CR>
let b:folded = 1

function! ToggleFold()
    if( b:folded == 0 )
        exec "normal! zM"
        let b:folded = 1
    else
        exec "normal! zR"
        let b:folded = 0
    endif
endfunction

function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()


" Fix this
" :match ExtraWhitespace /\s\+$/
" :highlight ExtraWhitespace ctermbg=red guibg=red

" http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window

command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline,...)
  echo a:cmdline
  let l:ft = a:0 > 0 ? a:1 : 'txt'
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
     if part[0] =~ '\v[%#<]'
        let expanded_part = fnameescape(expand(part))
        let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     endif
  endfor
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, 'You entered:    ' . a:cmdline)
  call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  call setline(3,substitute(getline(2),'.','=','g'))
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
  execute 'setf '. ft
  1
endfunction

command! -complete=file -nargs=* Git call s:RunShellCommand('git '.<q-args>)
command! -complete=file -nargs=* Gdif call s:RunShellCommand('git diff '.<q-args>, 'diff')

" Khuno
nnoremap <silent><leader>k :Khuno show<CR>
let g:khuno_max_line_length=110
