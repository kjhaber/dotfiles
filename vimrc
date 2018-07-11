set encoding=utf-8
scriptencoding utf-8
set shell=bash

" Setting to allow use with 'TerminalVim.app', a Mac AppleScript app that opens
" files double-clicked in Finder within vim in terminal.
let g:python_host_prog='/usr/local/bin/python2'
let g:python3_host_prog='/usr/local/bin/python3'

"auto-install vim-plug if not present on current machine (https://www.reddit.com/r/vim/comments/3thtrv/just_switched_to_vimplug_from_vundle/)
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Vim-Plug
call plug#begin('~/.vim/plugged')

Plug 'Chiel92/vim-autoformat'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'Olical/vim-enmasse'
Plug 'airblade/vim-gitgutter'
Plug 'aklt/plantuml-syntax'
Plug 'benmills/vimux'
Plug 'cespare/vim-toml'
Plug 'christoomey/vim-tmux-navigator'
Plug 'editorconfig/editorconfig-vim'
Plug 'elzr/vim-json'
Plug 'freitass/todo.txt-vim'
Plug 'fvictorio/vim-textobj-backticks'
Plug 'godlygeek/tabular'
Plug 'honza/vim-snippets'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-sneak'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-lastpat'
Plug 'kana/vim-textobj-underscore'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'
Plug 'kjhaber/vimwiki'
Plug 'leafgarland/typescript-vim'
Plug 'lifepillar/vim-mucomplete'
Plug 'machakann/vim-highlightedyank'
Plug 'mattn/calendar-vim'
Plug 'mhinz/vim-startify'
Plug 'moll/vim-node'
Plug 'morhetz/gruvbox'
Plug 'mrtazz/simplenote.vim'
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'plasticboy/vim-markdown'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'racer-rust/vim-racer'
Plug 'rking/ag.vim'
Plug 'mckinnsb/rust.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'sirver/ultisnips'
Plug 'skywind3000/asyncrun.vim'
Plug 'terryma/vim-expand-region'
Plug 'timonv/vim-cargo'
Plug 'tmux-plugins/vim-tmux'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tomasr/molokai'
Plug 'tomtom/tlib_vim'
Plug 'townk/vim-autoclose'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-scripts/closetag.vim'
Plug 'vim-scripts/zoomwintab.vim'
Plug 'w0rp/ale'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'Yggdroot/indentLine'

if filereadable($DOTFILE_LOCAL_HOME . '/vimrc-plugin-local')
  source $DOTFILE_LOCAL_HOME/vimrc-plugin-local
endif

call plug#end()

" Make updating plugins more convenient
command! PU PlugUpdate | PlugUpgrade

filetype plugin indent on
runtime macros/matchit.vim

set t_Co=256
colorscheme molokai
augroup colors
  autocmd FileType vimwiki colorscheme gruvbox
augroup END

set background=dark
set guifont=Inconsolata:h12
let g:airline_powerline_fonts = 1

set laststatus=2
if $TERM_PROGRAM =~# 'iTerm'
  let &t_SI = '\<Esc>]50;CursorShape=1\x7' " Vertical bar in insert mode
  let &t_EI = '\<Esc>]50;CursorShape=0\x7' " Block in normal mode
endif

if has('mouse_sgr')
    set ttymouse=sgr
endif
set mouse=a
set clipboard=unnamed

nmap <Leader>l :set list!<CR>
set listchars+=tab:»\ ,eol:¶,space:⋅,trail:✗

set whichwrap+=<,>,h,l,[,]

set title
let &titleold=$USER . '@' . hostname() . ' | ' . fnamemodify(getcwd(), ':t')
set ruler

" set autochdir
command CDC cd %:p:h

set number
set relativenumber

" highlight line with cursor
" https://stackoverflow.com/questions/14068751/how-to-hide-cursor-line-when-focus-in-on-other-window-in-vim
augroup CursorLine
    au!
    au VimEnter * setlocal cursorline
    au WinEnter * setlocal cursorline
    au BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

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
set splitbelow
set splitright

syntax enable

" Use both \ and space as leader
" I still have some habits for \, and space doesn't show up for showcmd
let g:mapleader='\\'
map <Space> <Leader>

" from https://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
nnoremap <Leader>o :CtrlP<CR>
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P

" make quick macros easier
" workflow is:
" 1) `qq` to start macro (register q)
" 2) do stuff
" 3) `q` to stop recording
" 4) `Shift-Q` to replay
nmap Q @q

" <Leader>P during a visual selection will replace the selection with
" current clipboard without changing current clipboard like 'd' or 'c' usually
" does.  In this case <Leader>p and <Leader>P do the same thing, unlike in
" other modes.
vmap <Leader>p "_d"+P
vmap <Leader>P "_d"+P

nmap <Leader><Leader> V
nmap <Leader><Space> V

" used with vim-expand-region plugin
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" turn off search highlight (two-h mapping is to avoid wait for timeout)
nnoremap <Leader>h :nohlsearch<CR>
nnoremap <Leader>hh :nohlsearch<CR>

nnoremap <Leader>ss :call StripTrailingWhitespaces()<CR>

" shortcuts for splits similar to my bindings for tmux
nnoremap <Leader>- :Sexplore<CR>
nnoremap <Leader>\| :Vexplore<CR>

" indent the entire file
nnoremap <Leader>=  gg=G

" run make command
nnoremap <Leader>m :Make<CR>

" fugitive shortcuts
" inspired by https://www.reddit.com/r/vim/comments/21f4gm/best_workflow_when_using_fugitive/
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gc :Gcommit<CR>
nnoremap <Leader>gd :Gdiff<CR>
nnoremap <Leader>ge :Gedit<CR>
nnoremap <Leader>gl :silent! Glog<CR>:bot copen<CR>
nnoremap <Leader>gm :Gmove<Space>
nnoremap <Leader>gp :Ggrep<Space>
nnoremap <Leader>gr :Gread<CR>
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gw :Gwrite<CR><CR>

" gitgutter
" (Could swear these mappings used to work. Maybe conflicting with my other
" <Leader>h mappings, or a recent gitgutter change.)
nnoremap <Leader>hr :GitGutterUndoHunk<CR>
nnoremap <Leader>hs :GitGutterStageHunk<CR>

" update Gitgutter signs on file save
autocmd BufWritePost * GitGutter

" Normally <ctrl-L> forces a redraw of the terminal, but I've mapped that to
" change between vim splits and tmux panes.  <Leader>l alone does a `:set list`
" to show/hide hidden characters, so I'm setting <Leader>k as my shortcut to
" redraw the screen (which I end up wanting regularly when I do a command-K to
" clear the buffer in iTerm -- ctrl-k is also the tmux redraw shortcut.).
nnoremap <Leader>k :redraw!<CR>

" stop that window from popping up
map q: :q

" Quit vim when quickfix is the last open window/tab
" https://stackoverflow.com/questions/7476126/how-to-automatically-close-the-quick-fix-window-when-leaving-a-file
aug QFClose
  au!
  au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
aug END

" Also quit vim when NERDTree or Calendar is last open window/tab
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:Calendar")) | q | endif

" Convert '%%' to '%:h<Tab>', for use with :edit to expand path of current buffer
" (from Practical Vim book)
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'


" toggle between number and nonumber (show always enables relatvie number,
" my preferred default)
function! ToggleNumber()
    if(&number == 1)
        set nonumber
        set norelativenumber
    else
        set number
        set relativenumber
    endif
endfunc
nmap <Leader>nn :call ToggleNumber()<CR>

" toggle between absolute number and relativenumber
function! ToggleNumberRel()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc
nmap <Leader>nr :call ToggleNumberRel()<CR>

" strips trailing whitespace at the end of files
function! StripTrailingWhitespaces()
    " save last search & cursor position
    let l:save=winsaveview()
    silent! %substitute/\s\+$//e
    call winrestview(l:save)
endfunction

" Insert today's numeric ISO 8601 date (https://xkcd.com/1179/) and
" remain in insert mode. (Mnemonic: <leader>DateToday)
nnoremap <Leader>dt a<CR><ESC>:.-1put =strftime('%Y-%m-%d')<CR>k<ESC>J<ESC>Ji

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
nnoremap <Leader>t :NERDTreeToggle<CR>

" The Silver Searcher
" (transitioning to fzf + ripgrep, commenting for now)
" let g:ctrlp_use_caching = 0
" if executable('ag')
"   " Use ag over grep
"   set grepprg=ag\ --nogroup\ --nocolor

"   " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
"   let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

"   " ag is fast enough that CtrlP doesn't need to cache
" endif

"nmap <Leader>/ :Ag<Space>


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
set statusline+=%*

set statusline+=%=      "left/right separator
set statusline+=%{fugitive#statusline()}\  "current git branch
set statusline+=%{v:register}\             "currently active register
set statusline+=%c,     "cursor column
set statusline+=%l/%L\  "cursor line/total lines
set statusline+=(%P)    "percent through file


" vim-autoformat
nmap <Leader>ff :Autoformat<CR>

" (not really related to the autoformat plugin, but related to formatting)
nmap <Leader>fi mzgg=G`z

" ALE
let g:ale_lint_on_enter = 0
nnoremap [l :lprevious<CR>
nnoremap ]l :lnext<CR>
nmap <Leader>aa :ALEToggle<CR>
nmap <Leader>af :ALEFix<CR>
nmap <Leader>an <Plug>(ale_next_wrap)
nmap <Leader>ap <Plug>(ale_previous_wrap)

" vim-markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
nnoremap ** :exe "normal ysiW*"<cr>
vmap * S*
nnoremap __ :exe "normal ysiW_"<cr>
vmap _ S_

" vim-racer
let g:racer_cmd = '~/.cargo/bin/racer'
let $RUST_SRC_PATH='~/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/src/rust/src'

" vim-startify
let g:startify_list_order = ['files', 'dir', 'bookmarks', 'sessions', 'commands']
let g:startify_bookmarks = [ {'.': '.'}, {'d': '$TODO_DIR/todo.txt'}, {'v': '~/.vimrc'}, {'z': '~/.zshrc'}, {'t': '~/.tmux.conf'}, {'s': '~/.ssh/config'} ]
let g:startify_commands = [ {'S': 'enew | SimplenoteList'} ]

" Customize fortune messages that appear in Startify header
" (Idea is to put work personal goals/areas of improvement into
" personal-fortune as reminders to keep them front-and-center.)
if filereadable($DOTFILE_HOME . '/vim/personal-fortune.vim')
  execute 'source ' . fnameescape($DOTFILE_HOME . '/vim/personal-fortune.vim')
  if !empty(g:personal_fortune)
    " let g:startify_custom_header = 'startify#fortune#cowsay()'
    let g:startify_custom_header_quotes = g:personal_fortune
  endif
endif

" vimwiki
let g:vimwiki_list = [{'path': '$VIMWIKI_DIR', 'syntax': 'markdown', 'ext': '.mdwiki'}]
let g:vimwiki_global_ext = 0
let g:vimwiki_url_maxsave = 0
let g:vimwiki_use_mouse = 1
let g:vimwiki_auto_chdir = 1
nmap <Leader>w<Space>w <Plug>VimwikiMakeDiaryNote
nmap <Leader>w<Space>y <Plug>VimwikiMakeYesterdayDiaryNote
nmap <Leader>w<Space>i <Plug>VimwikiDiaryGenerateLinks

" Initialize my daily diary entry
" -- creates two sections, 'JOURNAL' and 'TODO'
" -- creates mark j for Journal section
" -- creates mark t for Todo section
command! InitDiary execute "normal! ggi## JOURNAL<cr>* <esc>mji<cr><cr><cr>## TODO<esc>mto* [ ] <cr><esc>kA"

" calendar.vim
nmap <Leader>wc :Calendar<CR><C-w>5>0t

" Enable vim-highlightedyank plugin
map y <Plug>(highlightedyank)
let g:highlightedyank_highlight_duration = 300

" omnicomplete and vim-mucomplete
set omnifunc=syntaxcomplete#Complete
set completeopt+=menuone
set completeopt+=noinsert
set completeopt+=preview
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-x><C-o>
" http://vim.wikia.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

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
let g:UltiSnipsExpandTrigger='<c-s>'
let g:UltiSnipsJumpForwardTrigger='¬'
let g:UltiSnipsJumpBackwardTrigger='˙'

" fzf
" Search filenames with Ctrl-p
" Search file contents with <leader>/
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

nnoremap <C-p> :FZF<CR>
nmap <Leader>/ :Ag<Space>
nmap <Leader>[b :Buffers<CR>
nmap <Leader>[f :Files<CR>
nmap <Leader>[h :History<CR>
nmap <Leader>[l :Lines<CR>
nmap <Leader>[[ :Lines<CR>
nmap <Leader>[t :Rg<CR>

" Tabularize
" 'align' mappings
nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a, :Tabularize /,<CR>
vmap <Leader>a, :Tabularize /,<CR>
nmap <Leader>a<Space> :Tabularize /<Space><CR>
vmap <Leader>a<Space> :Tabularize /<Space><CR>

" vimux
" from https://blog.bugsnag.com/tmux-and-vim/
nmap <Leader>vv :VimuxPromptCommand<CR>
nmap <Leader>vr :VimuxRunLastCommand<CR>
nmap <Leader>vi :VimuxInspectRunner<CR>
nmap <Leader>vz :VimuxZoomRunner<CR>
nmap <Leader>vq :VimuxCloseRunner<CR>

" vim-json
let g:vim_json_syntax_conceal = 0

" vim-lsp
if executable('typescript-language-server')
  augroup lsp_ts
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
        \ 'whitelist': ['typescript', 'javascript'],
        \ })
    autocmd FileType typescript setlocal omnifunc=lsp#complete
    autocmd FileType javascript setlocal omnifunc=lsp#complete
  augroup end
endif
nmap <Leader>ji :LspImplementation<CR>
nmap <Leader>jd :LspDefinition<CR>
nmap <Leader>jr :LspReferences<CR>
nmap <Leader>lf :LspDocumentFormat<CR>
vmap <Leader>lf :LspDocumentRangeFormat<CR>
nmap <Leader>ll :LspHover<CR>
nmap <Leader>lr :LspRename<CR>
nmap <Leader>lsd :LspDocumentSymbol<CR>
nmap <Leader>lwd :LspWorkspaceSymbol<CR>

" put Simplenote creds into separate file for simplenote.vim plugin
if filereadable($DOTFILE_LOCAL_HOME . '/simplenoterc')
  source $DOTFILE_LOCAL_HOME/simplenoterc
endif

" Define any local-specific mappings/abbreviations
if filereadable($DOTFILE_LOCAL_HOME . '/vimrc-local')
  source $DOTFILE_LOCAL_HOME/vimrc-local
endif

