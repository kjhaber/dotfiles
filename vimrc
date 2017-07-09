set encoding=utf-8
scriptencoding utf-8
set shell=bash

" Setting to allow use with 'TerminalVim.app', a Mac AppleScript app that opens
" files double-clicked in Finder within vim in terminal.
let g:python_host_prog="/usr/local/bin/python"
let g:python3_host_prog="/usr/local/bin/python3"

" Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

Plugin 'MarcWeber/vim-addon-mw-utils.git'
Plugin 'airblade/vim-gitgutter'
Plugin 'aklt/plantuml-syntax'
Plugin 'benmills/vimux'
Plugin 'cespare/vim-toml'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'editorconfig/editorconfig-vim.git'
Plugin 'elzr/vim-json'
Plugin 'freitass/todo.txt-vim'
Plugin 'godlygeek/tabular'
Plugin 'honza/vim-snippets'
Plugin 'justinmk/vim-sneak'
Plugin 'lifepillar/vim-mucomplete'
Plugin 'machakann/vim-highlightedyank'
Plugin 'mhinz/vim-startify'
Plugin 'moll/vim-node'
Plugin 'mrtazz/simplenote.vim.git'
Plugin 'mxw/vim-jsx.git'
Plugin 'pangloss/vim-javascript'
Plugin 'plasticboy/vim-markdown'
Plugin 'racer-rust/vim-racer'
Plugin 'rking/ag.vim'
Plugin 'mckinnsb/rust.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'sirver/ultisnips'
Plugin 'skywind3000/asyncrun.vim'
Plugin 'suan/vim-instant-markdown'
Plugin 'terryma/vim-expand-region'
Plugin 'timonv/vim-cargo'
Plugin 'tmux-plugins/vim-tmux'
Plugin 'tomasr/molokai'
Plugin 'tomtom/tlib_vim.git'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'vim-scripts/zoomwintab.vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'vimwiki/vimwiki'
Plugin 'Yggdroot/indentLine'

call vundle#end()


filetype plugin on
runtime macros/matchit.vim
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

" Use both \ and space as leader
" I still have some habits for \, and space doesn't show up for showcmd
let mapleader="\\"
map <Space> <leader>

" from https://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
nnoremap <leader>o :CtrlP<CR>
nnoremap <leader>w :w<CR>
vmap <leader>y "+y
vmap <leader>d "+d
nmap <leader>p "+p
nmap <leader>P "+P
vmap <leader>p "+p
vmap <leader>P "+P

nmap <leader><leader> V

" used with vim-expand-region plugin
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" turn off search highlight (two-h mapping is to avoid wait for timeout)
nnoremap <leader>h :nohlsearch<CR>
nnoremap <leader>hh :nohlsearch<CR>

nnoremap <leader># :call ToggleNumber()<CR>
nnoremap <leader>@ :call ToggleNumberRel()<CR>
nnoremap <leader>} :call StripTrailingWhitespaces()<CR>

" shortcuts for splits similar to my bindings for tmux
nnoremap <leader>- :Sexplore<CR>
nnoremap <leader>\| :Vexplore<CR>

" stop that window from popping up
map q: :q

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
" Adjusting my mapping to use alt instead of ctrl so I can use
" <C-j> and <C-k> for split navigation.
" On a Mac you have to use a trick: <ALT+j> ==> ∆, <ALT+k> ==> ˚
" http://stackoverflow.com/questions/7501092/can-i-map-alt-key-in-vim
nnoremap ∆ :m .+1<CR>==
nnoremap ˚ :m .-2<CR>==
vnoremap ∆ :m '>+1<CR>gv=gv
vnoremap ˚ :m '<-2<CR>gv=gv

" netrw options
let g:netrw_altv=1  " open files on right
let g:NERDTreeHijackNetrw = 0
nnoremap <leader>t :NERDTreeToggle<CR>

" The Silver Searcher
let g:ctrlp_use_caching = 0
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
endif

nmap <leader>/ :Ag<Space>


" vim-jsx options
let g:jsx_ext_required = 0

" start of default statusline
set statusline=
set statusline+=%<\       "cut at start
set statusline+=%t\       "tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}]\  "file format
set statusline+=%h        "help file flag
set statusline+=%m        "modified flag
set statusline+=%r        "read only flag
set statusline+=%y\       "filetype

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

set statusline+=%=      "left/right separator
set statusline+=%{v:register}\     "currently active register
set statusline+=%c,     "cursor column
set statusline+=%l/%L\  "cursor line/total lines
set statusline+=(%P)    "percent through file



" syntastic options
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height=5
let g:syntastic_enable_signs = 1
let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_style_error_symbol = '✗'
let g:syntastic_style_warning_symbol = '!'

let g:syntastic_css_checkers = ['csslint']
let g:syntastic_html_checkers = ['tidy']
let g:syntastic_less_checkers = ['lesshint']
let g:syntastic_java_checkers = ['javac']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_json_checkers = ['jsonlint']
let g:syntastic_rust_checkers = ['cargo']
let g:syntastic_sass_checkers = ['sass_lint']
let g:syntastic_scss_checkers = ['sass_lint']
let g:syntastic_xml_checkers = ['xmllint']

let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0

" vim-racer
let g:racer_cmd = "~/.cargo/bin/racer"
let $RUST_SRC_PATH="~/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/src/rust/src"

" vim-startify
let g:startify_list_order = ['files', 'dir', 'bookmarks', 'sessions', 'commands']
let g:startify_bookmarks = [ {'.': '.'}, {'v': '~/.vimrc'}, {'z': '~/.zshrc'}, {'t': '~/.tmux.conf'}, {'s': '~/.ssh/config'} ]
let g:startify_commands = [ {'S': 'enew | SimplenoteList'} ]

" vimwiki
let g:vimwiki_list = [{'path': '~/Documents/vimwiki'}]

" vim-instant-markdown: requires `sudo npm -g install instant-markdown-d`
let g:instant_markdown_autostart = 0
nmap <leader>md :InstantMarkdownPreview<CR>

" Enable vim-highlightedyank plugin
map y <Plug>(highlightedyank)
let g:highlightedyank_highlight_duration = 300

" vim-mucomplete
set completeopt+=menuone
set shortmess+=c

" Change mapping of zoomwintab plugin (default is <C-w>o, but I want that to
" still have its default behavior of making current window the only open one)
let g:zoomwintab_remap = 0
nmap <C-w>z :ZoomWinTabToggle<CR>
nmap <C-w><C-z> :ZoomWinTabToggle<CR>

" asyncrun.vim
" Defines :Make to run makeprg async - improves fugitive.vim too
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

" Ultisnips
" Ctrl-S for 'snippet'
" Alt-L for forward
" Alt-H for backward
" On a Mac you have to use a trick: <ALT+L> ==> ¬, <ALT+H> ==> ˙
let g:UltiSnipsExpandTrigger="<c-s>"
let g:UltiSnipsJumpForwardTrigger="¬"
let g:UltiSnipsJumpBackwardTrigger="˙"

" Tabularize
" 'align' mappings
nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>

" vimux
" from https://blog.bugsnag.com/tmux-and-vim/
" Prompt for a command to run
nmap <Leader>vp :VimuxPromptCommand<CR>

" Run last command executed by VimuxRunCommand
nmap <Leader>vl :VimuxRunLastCommand<CR>

" Inspect runner pane
nmap <Leader>vi :VimuxInspectRunner<CR>

" Zoom the tmux runner pane
nmap <Leader>vz :VimuxZoomRunner<CR>

" vim-json
let g:vim_json_syntax_conceal = 0

" put Simplenote creds into separate file for simplenote.vim plugin
source ~/.simplenoterc

