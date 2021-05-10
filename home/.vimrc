" Load pathogen - package mangement for vim
call pathogen#infect()

" build help tags
Helptags

" Respect comments like // vim: set ts=2
set modeline

"The default leader is '\', but many people prefer ',' as it's in a standard location
let mapleader = ','

nmap <Leader>t :% s/\s\+$//<CR>,/''
nmap <Leader>cs :Coveragepy show<CR>
nmap <Leader>cr :Coveragepy report<CR>

" Take that TouchBar!
inoremap <Leader><Leader> <esc>
vnoremap <Leader><Leader> <esc>
inoremap <Leader><Leader><Leader> ,<esc>

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
    set colorcolumn=80,110,120
    highlight ColorColumn ctermbg=233
endif

" Add breakpoints
map <Leader>b :set paste<CR>Oimport pdb; pdb.set_trace() # BREAKPOINT<C-c>:set nopaste<CR>==
map <Leader>d :set paste<CR>O<pre> {% filter force_escape %} {% debug %} {% endfilter %}</pre>{# FIXME: DEBUG #}<C-c>:set nopaste<CR>


" Smaller tabs in html/js files
au BufRead,BufNewFile *.html,*.js setlocal ts=2 sw=2
au BufRead,BufNewFile *.wsgi set filetype=python
au BufRead,BufNewFile psql.edit.* set filetype=sql
au BufRead,BufNewFile *.jst set filetype=javascript

" Making it so ; works like : for commands. Saves typing and eliminates :W style typos due to lazy holding shift.
nnoremap ; :

"clearing highlighted search
nmap <silent> <leader>/ :nohlsearch<CR>

" Change Working Directory to that of the current file
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h

" Change tabs
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

" Toggle big scrolloff (keep cursor in the middle)
:nnoremap <Leader>zz :let &scrolloff=999-&scrolloff<CR>

" toggle spelling use ,p
" Not in insert!!!
" imap <Leader>p <C-o>:setlocal spell!<CR>
nmap <Leader>p :setlocal spell!<CR>

" Sort a paragraph (like a block of imports)
map <leader>s vip:sort i<CR>

" Sort a comma seperated list (like a line of imports)
map <leader>S :call setline(line('.'),join(sort(split(getline('.'), ',\s*')), ', '))<CR>

" Breakup long lines on commas
nmap <leader>c ^mc:s/, /,\r/g<CR>:nohlsearch<CR>V'c=k%i,<CR><ESC>

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
" node_modules are annoying too
set wildignore+=*/node_modules/*
" other venvs
set wildignore+=*/*_env/*

" jedi settings
" If you have errors about jedi at startup: pip install jedi
" leader-n is new a ctrlp tab, lets use leader-a for all usages
let g:jedi#usages_command = "<leader>a"
" Don't pop docstring window on completion (only on <S-k>)
autocmd FileType python setlocal completeopt-=preview
" Why do I have to do this ?!?!
autocmd FileType python so ~/.vim/bundle/vim-python-pep8-indent/indent/python.vim

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

" https://vi.stackexchange.com/q/4575/8338
function! Interleave()
    " retrieve last selected area position and size
    let start = line(".")
    execute "normal! gvo\<esc>"
    let end = line(".")
    let [start, end] = sort([start, end], "n")
    let size = (end - start + 1) / 2
    " and interleave!
    for i in range(size - 1)
        execute (start + size + i). 'm' .(start + 2 * i)
    endfor
endfunction

" Select your two contiguous, same-sized blocks, and use it to Interleave ;)
" from start of second block vip ,it
vnoremap <Leader>it <esc>:call Interleave()<CR>


command! -complete=file -nargs=* Git call s:RunShellCommand('git '.<q-args>)
command! -complete=file -nargs=* Gdif call s:RunShellCommand('git diff '.<q-args>, 'diff')

" SS - Super Serch - like /, but escapes everything
" http://vim.wikia.com/wiki/Searching_for_expressions_which_include_slashes
command! -nargs=1 SS let @/ = '\V'.escape(<q-args>, '/\')|normal! /<C-R>/<CR>

" Khuno
nnoremap <silent><leader>k :Khuno show<CR>
let g:khuno_max_line_length=120

" hardy - arduino
let g:hardy_arduino_path = '/Applications/Arduino.app/Contents/MacOS/Arduino'
nmap <Leader>av :ArduinoVerify<CR>
nmap <Leader>au :ArduinoUpload<CR>

" YankRing

let g:yankring_min_element_length = 2  " no single letters (Bad naugty x'er)
let g:yankring_max_display = 80        " Overfill default 30 width
let g:yankring_window_increment = 50   " <space> to toggle full big display
let g:yankring_window_use_horiz = 0    " Use vertical split
let g:yankring_manage_numbered_reg = 1 " YESSSS!!! YankRing take over number registers
let g:yankring_history_file = '.yankring_history_file' " Hidden please
let g:yankring_clipboard_monitor = 0   " No system pb integration

" o for next, i for prev - they seem in a handy place
let g:yankring_replace_n_pkey = '<C-v>'
let g:yankring_replace_n_nkey = '<C-b>'

" vim-terraform
let g:terraform_fmt_on_save = 1

" http://vim.wikia.com/wiki/Keep_your_cursor_centered_vertically_on_the_screen
