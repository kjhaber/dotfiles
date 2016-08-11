set encoding=utf-8
scriptencoding utf-8
set shell=bash

execute pathogen#infect()
filetype plugin on
set omnifunc=syntaxcomplete#Complete
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-x><C-o>

set t_Co=256
colorscheme molokai
set background=dark
set guifont=Inconsolata:h12
let g:airline_powerline_fonts = 1

set laststatus=2
if $TERM_PROGRAM =~ "iTerm"
  let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
  let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
endif

if has('mouse_sgr')
    set ttymouse=sgr
endif
set mouse=a
set clipboard=unnamed

nmap <leader>l :set list!<CR>
set listchars+=tab:»\ ,eol:¶,space:⋅,trail:✗

set whichwrap+=<,>,h,l,[,]

set title
let &titleold=$USER . "@" . hostname() . " | " . fnamemodify(getcwd(), ':t')
set ruler

" set autochdir
command CDC cd %:p:h

set number
set relativenumber

set backspace=2
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

set wildmenu

set showmatch
set incsearch
set hlsearch
set ignorecase
set smartcase
set linebreak
set colorcolumn=81

syntax enable


let mapleader="\\"
nnoremap <leader><space> :nohlsearch<CR> " turn off search highlight
nnoremap <leader># :call ToggleNumber()<CR>
nnoremap <leader>@ :call ToggleNumberRel()<CR>
nnoremap <leader>} :call StripTrailingWhitespaces()<CR>

nnoremap <leader>e :Explore<CR>
nnoremap <leader>E :Explore

nnoremap <leader>s :Sexplore<CR>
nnoremap <leader>S :Sexplore

nnoremap <leader>v :Vexplore<CR>
nnoremap <leader>V :Vexplore

" " stop requiring shift key for commands (big source of command typos)
" nnoremap ; :
" vnoremap ; :

" Convert '%%' to '%:h<Tab>', for use with :edit to expand path of current buffer
" (from Practical Vim book)
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'


" toggle between number and nonumber
function! ToggleNumber()
    if(&number == 1)
        set nonumber
    else
        set number
    endif
endfunc

" toggle between number and relativenumber
function! ToggleNumberRel()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

" strips trailing whitespace at the end of files. this
" is called on buffer write in the autogroup above.
function! StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction

" go ahead and strip trailing whitespace on save too
autocmd BufWritePre * :%s/\s\+$//e


" http://vim.wikia.com/wiki/Moving_lines_up_or_down
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" netrw options
let g:netrw_altv=1  " open files on right

" vim-jsx options
let g:jsx_ext_required = 0

" syntastic options
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height=5
let g:syntastic_enable_signs = 1
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_style_error_symbol = '∆'
let g:syntastic_style_warning_symbol = '∆'

let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_json_checkers = ['jsonlint']

let g:vim_markdown_folding_disabled = 1

let g:startify_list_order = ['files', 'dir', 'bookmarks', 'sessions', 'commands']
let g:startify_bookmarks = [ {'.': '.'}, {'v': '~/.vimrc'}, {'z': '~/.zshrc'}, {'t': '~/.tmux.conf'}, {'s': '~/.ssh/config'} ]
let g:startify_commands = [ {'S': 'enew | SimplenoteList'} ]

" put Simplenote creds into separate file for simplenote.vim plugin
source ~/.simplenoterc

