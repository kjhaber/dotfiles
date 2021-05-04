
" Set dotfile_home and dotfile_local_home as Vim variables in case vim is
" launched outside normal shell (e.g. TerminalVim.app helper)
let g:dotfile_home = $DOTFILE_HOME
if empty(g:dotfile_home)
  let g:dotfile_home = $HOME . '/.config/dotfiles'
endif
let g:dotfile_local_home = $DOTFILE_LOCAL_HOME
if empty(g:dotfile_local_home)
  let g:dotfile_local_home = $HOME . '/.config/dotfiles-local'
endif

" Load files conditionally.  This allows separating the core configuration
" that is the same on all machines from environment-specific config (like
" OS-specific, work vs home config, etc.).
exec 'source ' . g:dotfile_home . '/vim/source-if-readable.vim'

call SourceLocalDotfile('vimrc-local.before')

set encoding=utf-8
scriptencoding utf-8
set nomodeline
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

Plug 'AndrewRadev/linediff.vim'
Plug 'Chiel92/vim-autoformat'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'Olical/vim-enmasse'
Plug 'airblade/vim-gitgutter'
Plug 'airblade/vim-rooter'
Plug 'aklt/plantuml-syntax'
Plug 'benmills/vimux'
Plug 'blueyed/vim-diminactive'
Plug 'cespare/vim-toml'
Plug 'chikamichi/mediawiki.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'dense-analysis/ale'
Plug 'editorconfig/editorconfig-vim'
Plug 'elzr/vim-json'
Plug 'freitass/todo.txt-vim'
Plug 'fvictorio/vim-textobj-backticks'
Plug 'godlygeek/tabular'
Plug 'honza/vim-snippets'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-sneak'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-lastpat'
Plug 'kana/vim-textobj-underscore'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'
Plug 'vimwiki/vimwiki'
Plug 'machakann/vim-highlightedyank'
Plug 'mattn/calendar-vim'
Plug 'mhinz/vim-startify'
Plug 'moll/vim-node'
Plug 'morhetz/gruvbox'
Plug 'mrtazz/simplenote.vim'
Plug 'mustache/vim-mustache-handlebars'
Plug 'mxw/vim-jsx'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'pangloss/vim-javascript'
Plug 'plasticboy/vim-markdown'
Plug 'prabirshrestha/async.vim'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
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
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/closetag.vim'
Plug 'vim-scripts/zoomwintab.vim'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'Yggdroot/indentLine'

call SourceLocalDotfile('vimrc-local.plugin')

call plug#end()

" Make updating plugins more convenient
command! PU PlugUpdate | PlugUpgrade

filetype plugin indent on
runtime macros/matchit.vim

set t_Co=256
if has("termguicolors")
  set termguicolors
endif

" Set Vim-specific sequences for RGB colors
" (This seems to be needed for vim to display colors in my setup, neovim is
" fine without it)
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

colorscheme molokai
" slight adjustment to relative line number color (too lazy to fork molokai)
autocmd ColorScheme * highlight LineNr guifg=#758088

augroup colors
  autocmd FileType vimwiki colorscheme gruvbox
augroup END

set background=dark
set guifont=Inconsolata:h12

set laststatus=2
if $TERM_PROGRAM =~# 'iTerm' && has("nvim")
  let &t_SI = '\<Esc>]50;CursorShape=1\x7' " Vertical bar in insert mode
  let &t_EI = '\<Esc>]50;CursorShape=0\x7' " Block in normal mode
endif

if has('mouse_sgr')
    set ttymouse=sgr
endif
set mouse=a
set clipboard=unnamed

" Use both \ and space as leader
" I still have some habits for \, and space doesn't show up for showcmd
let g:mapleader='\\'
map <Space> <Leader>

set listchars+=tab:»\ ,eol:¶,space:⋅,trail:✗
nmap <Leader>c :set list!<CR>
nmap <Space>c :set list!<CR>

set whichwrap+=<,>,h,l,[,]

set title
let &titleold=$USER . '@' . hostname() . ' | ' . fnamemodify(getcwd(), ':t')
set ruler

" Instead of `set autochdir`, shortcut to 'cd currentdir'
command! CDC cd %:p:h

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
highlight ColorColumn guibg=#102535
set splitbelow
set splitright
set scrolloff=6
set updatetime=250
set foldlevelstart=20

" make macros run faster by disabling redraw during execution
set lazyredraw

" Neovim-specific options
if has("nvim")
  " Show result of :s command while typing
  set inccommand=nosplit
endif

syntax enable

" from https://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
nnoremap <Leader>o :CtrlP<CR>
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P

" Toggle paste mode quickly
nnoremap <Leader>\ :call TogglePaste()<CR>
nnoremap <Space>\ :call TogglePaste()<CR>
function! TogglePaste()
  set paste!
  echo 'Paste mode ' . (&paste ? 'enabled' : 'disabled')
endfunction

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

" Reset on 'space-space'.  nopaste, turn off highlight.  Inspired by clipboard
" paste sometimes leaving vim in paste mode.
nmap <Leader><Leader> :nohlsearch<CR>:set nopaste<CR>:echo ''<CR>
nmap <Leader><Space> :nohlsearch<CR>:set nopaste<CR>:echo ''<CR>

" used with vim-expand-region plugin
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" turn off search highlight (two-h mapping is to avoid wait for timeout)
nnoremap <Leader>h :nohlsearch<CR>
nnoremap <Leader>hh :nohlsearch<CR>

nnoremap <Leader>ss :call StripTrailingWhitespaces()<CR>
nnoremap <Leader>sq :call StripSmartQuotes()<CR>

" shortcuts for splits similar to my bindings for tmux
nnoremap <Leader>- :Sexplore<CR>
nnoremap <Leader>\| :Vexplore<CR>
nnoremap <Leader>. :Explore<CR>

" indent the entire file
nnoremap <Leader>=  gg=G

" run make command
nnoremap <Leader>m :Make<CR>

" fugitive shortcuts
" inspired by https://www.reddit.com/r/vim/comments/21f4gm/best_workflow_when_using_fugitive/
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gc :Git commit<CR>
nnoremap <Leader>gd :Gdiff<CR>
nnoremap <Leader>ge :Gedit<CR>
nnoremap <Leader>gl :silent! Glog<CR>:bot copen<CR>
nnoremap <Leader>gm :Gmove<Space>
nnoremap <Leader>gp :Ggrep<Space>
nnoremap <Leader>gr :Gread<CR>
nnoremap <Leader>gs :Git<CR>
nnoremap <Leader>gw :Gwrite<CR><CR>

" gitgutter
nnoremap <Leader>hr :GitGutterUndoHunk<CR>
nnoremap <Leader>hs :GitGutterStageHunk<CR>
nnoremap <Leader>hb :GitGutterPrevHunk<CR>
nnoremap <Leader>hf :GitGutterNextHunk<CR>

" update Gitgutter signs on file save
autocmd BufWritePost * GitGutter

" rooter
let g:rooter_patterns = ['pom.xml', 'build.xml', 'package.json', '.git']

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
endfunction
nmap <Leader>nn :call ToggleNumber()<CR>

" toggle between absolute number and relativenumber
function! ToggleNumberRel()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunction
nmap <Leader>nr :call ToggleNumberRel()<CR>

" strips trailing whitespace at the end of files
function! StripTrailingWhitespaces()
    " save last search & cursor position
    let l:save=winsaveview()
    silent! %substitute/\s\+$//e
    call winrestview(l:save)
endfunction

function! StripSmartQuotes()
    " save last search & cursor position
    let l:save=winsaveview()
    silent! %substitute/‘/'/ge
    silent! %substitute/’/'/ge
    silent! %substitute/“/"/ge
    silent! %substitute/”/"/ge
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
nnoremap <Leader>tt :NERDTreeToggle<CR>

" vim-jsx options
let g:jsx_ext_required = 0

hi StatusLine gui=bold guifg=#ffffff guibg=#3a3a3a
hi User1 gui=bold guifg=#ff2b70 guibg=#3a3a3a
hi User2 gui=none guifg=#ff2b70 guibg=#3a3a3a

" start of default statusline
set statusline=
set statusline+=%<\       "cut at start
set statusline+=%t\       "tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'},\  "file encoding
set statusline+=%{&ff}]\  "file format
set statusline+=%y\       "filetype
set statusline+=%r        "read only flag

"modified flag
set statusline+=%1*%{getbufvar(bufnr('%'),'&mod')?'[+]':''}%*

set statusline+=%#warningmsg#
set statusline+=%*

set statusline+=%=      "left/right separator
" set statusline+=%{fugitive#statusline()}\  "current git branch
set statusline+=%{v:register}\             "currently active register
set statusline+=%c,     "cursor column
set statusline+=%l/%L\  "cursor line/total lines
set statusline+=(%P)    "percent through file
set statusline+=%2*%{GitBranchStatusline()}%*  "current git branch

function! GitBranchStatusline()
  let w:branch = FugitiveHead()
  if (w:branch == '')
    return ''
  else
    return ' [' . w:branch . '] '
  endif
endfunction

" vim-autoformat
nmap <Leader>ff :Autoformat<CR>

" (not really related to the autoformat plugin, but related to formatting)
nmap <Leader>fi mzgg=G`z

" ALE
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'css': ['prettier'],
\   'html': ['tidy'],
\   'java': [],
\   'javascript': ['eslint', 'prettier'],
\   'ruby': ['rubocop'],
\   'rust': ['rustfmt'],
\   'typescript': ['eslint', 'prettier']
\}
let g:ale_linters = {
\   'java': [],
\   'rust': ['cargo']
\}
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')
let g:ale_rust_rls_toolchain = 'stable'

nmap <Leader>aa :ALEToggle<CR>
nmap <Leader>af :ALEFix<CR>

" vim-markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
let g:indentLine_fileTypeExclude = ['markdown']
nnoremap ** :exe "normal ysiW*"<cr>
vmap * S*
nnoremap __ :exe "normal ysiW_"<cr>
vmap _ S_

" vim-racer
let g:racer_cmd = '~/.cargo/bin/racer'
let g:racer_experimental_completer = 1
let $RUST_SRC_PATH='~/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/src/rust/src'

" rust.vim
let g:rustfmt_autosave = 1
let g:rust_clip_command = 'pbcopy'

" vim-startify
let g:startify_list_order = ['files', 'dir', 'bookmarks', 'sessions', 'commands']
let g:startify_bookmarks = [ {'.': '.'}, {'d': '$VIMWIKI_DIARY_DIR/TODO.mdwiki'}, {'v': '~/.vimrc'}, {'z': '~/.zshrc'}, {'t': '~/.tmux.conf'}, {'s': '~/.ssh/config'} ]
let g:startify_commands = [ {'S': 'enew | SimplenoteList'} ]
nmap <Leader>; :Startify<CR>

" vimwiki
let g:vimwiki_list = [{'path': '$VIMWIKI_DIR', 'syntax': 'markdown', 'ext': '.mdwiki'}]
let g:vimwiki_global_ext = 0
let g:vimwiki_url_maxsave = 0
let g:vimwiki_use_mouse = 1
let g:vimwiki_auto_chdir = 1
let g:vimwiki_hl_cb_checked = 2
let g:vimwiki_conceallevel = 0
autocmd FileType vimwiki let g:indentLine_enabled = 0
nmap <Leader>w<Space>w <Plug>VimwikiMakeDiaryNote
nmap <Leader>w<Space>y <Plug>VimwikiMakeYesterdayDiaryNote
nmap <Leader>w<Space>i <Plug>VimwikiDiaryGenerateLinks

" Copy todo item to journal item (relies on mark t to indicate top of Todo
" section)
nnoremap <Leader>wj :execute "normal! yy`tkkp" <bar> :s/\v\[.\] // <bar> :nohlsearch<CR>

" Mappings to quickly access todo wiki and write it into daily diary
nmap <Leader>wt :edit $VIMWIKI_DIR/diary/TODO.mdwiki<CR>
nmap <Leader>w<Space>t :read $VIMWIKI_DIR/diary/TODO.mdwiki<CR>

" vimwiki filetype sometimes changes to 'conf' when splitting window
nmap <Leader>wf set filetype=vimwiki<CR>

" Initialize my daily diary entry
" -- creates two sections, 'JOURNAL' and 'TODO'
" -- creates mark j for Journal section
" -- creates mark t for Todo section
command! InitDiary execute "normal! ggi## JOURNAL<cr>* <esc>mji<cr><cr><cr>## TODO<esc>mto* [ ] <cr><esc>kA"

" Initialize PlantUml document
command! InitUml execute "normal! ggi@startuml<cr><cr>title<cr><cr>@enduml<cr><esc>kkkA "

" Init a markdown code block
nnoremap <Leader>` i```<CR><CR>```<ESC>ki
nnoremap <Leader>`<Space> i```<CR><CR>```<ESC>ki
nnoremap <Leader>`p i```<CR><CR>```<ESC>k"+p
vnoremap <Leader>` "zc```<CR>```<ESC>k"zp

" UML Arrow Swap: change position of arrow in PlantUML doc
call SourceDotfile('vim/plantuml-arrow-swap.vim')

" calendar.vim
nmap <Leader>wc :Calendar<CR><C-w>5>0t

" Enable vim-highlightedyank plugin
map y <Plug>(highlightedyank)
let g:highlightedyank_highlight_duration = 300

" omnicomplete
set omnifunc=syntaxcomplete#Complete
set completeopt+=menu
set completeopt+=menuone
set completeopt+=noinsert
set completeopt+=preview

" toggle completion with ctrl-space (even in normal mode)
" inoremap <expr> <silent> <C-Space> (pumvisible() ? "\<Esc>" : "\<C-\>\<C-O>:ALEComplete\<CR>")
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : \"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
nnoremap <silent> <C-Space> a<C-\><C-o>:ALEComplete<CR>

" make Enter and tab work more like I'm used to from IDEs
inoremap <expr> <CR> (pumvisible() ? "\<C-y>" : "\<CR>")
inoremap <expr> <Tab> (pumvisible() ? "\<C-n>" : "\<Tab>")
inoremap <expr> <S-Tab> (pumvisible() ? "\<C-p>" : "\<S-Tab>")


" Change mapping of zoomwintab plugin (default is <C-w>o, but I want that to
" still have its default behavior of making current window the only open one)
let g:zoomwintab_remap = 0
nmap <C-w>z :ZoomWinTabToggle<CR>
nmap <C-w><C-z> :ZoomWinTabToggle<CR>
nmap <Leader>z :ZoomWinTabToggle<CR>

" asyncrun.vim
" Defines :Make to run makeprg async - improves fugitive.vim too
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

" fzf
" Search filenames with Ctrl-p
" Search file contents with <leader>/
nnoremap <C-p> :FZF<CR>
nmap <Leader>/ :Rg<CR>
nmap <Leader>// :Rg<CR>
nmap <Leader>/b :Buffers<CR>
nmap <Leader>/f :Files<CR>
nmap <Leader>/h :History<CR>
nmap <Leader>/l :Lines<CR>
nmap <Leader>/t :Rg<CR>

" https://github.com/junegunn/fzf.vim#example-advanced-ripgrep-integration
" Sort vimwiki diary by reverse path to make entries appear in chronological
" order (prefer recent results to random results in previous years)
let g:ripgrep_fzf_sort = ''
autocmd FileType vimwiki let g:ripgrep_fzf_sort = '--sortr path'

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case ' . g:ripgrep_fzf_sort . ' -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

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

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" coc.nvim
let g:coc_node_path = '/usr/local/bin/node'
let g:coc_global_extensions = [
\  'coc-css',
\  'coc-eslint',
\  'coc-git',
\  'coc-html',
\  'coc-json',
\  'coc-prettier',
\  'coc-python',
\  'coc-rls',
\  'coc-sh',
\  'coc-snippets',
\  'coc-solargraph',
\  'coc-tsserver',
\  'coc-vimlsp',
\  'coc-xml',
\  'coc-yaml',
\  'coc-yank'
\ ]

inoremap <silent><expr> <c-space> coc#refresh()

" LSP key bindings (mostly coc.nvim-based)
nmap <silent> <Leader>jd <Plug>(coc-definition)
nmap <silent> <Leader>jt <Plug>(coc-type-definition)
nmap <silent> <Leader>ji <Plug>(coc-implementation)
nmap <silent> <Leader>jr <Plug>(coc-references)
nmap <silent> <Leader>lr <Plug>(coc-rename)
nmap <silent> <Leader>lf <Plug>(coc-format)
vmap <silent> <Leader>lf <Plug>(coc-format-selected)
nmap <silent> <leader>lx <Plug>(coc-fix-current)
nmap <silent> <Leader>l<Space> <Plug>(coc-codeaction)
vmap <silent> <Leader>l<Space> <Plug>(coc-codeaction-selected)
nnoremap <silent> <Leader>ll :call <SID>show_documentation()<CR>
nnoremap <silent> <Leader>lsd :<C-u>CocList outline<cr>
nnoremap <silent> <Leader>lsw :<C-u>CocList -I symbols<cr>

nnoremap <Leader>loi :call CocAction('runCommand', 'editor.action.organizeImport')<CR>

nmap <silent> <Leader>jp <Plug>(ale_previous_wrap)
nmap <silent> <Leader>jn <Plug>(ale_next_wrap)


" Snippets
imap <C-s> <Plug>(coc-snippets-expand)
vmap <C-j> <Plug>(coc-snippets-select)
let g:coc_snippet_next = '<C-j>'
let g:coc_snippet_prev = '<C-k>'

" Bookmarks
nmap <silent> <Leader>mm <Plug>(coc-bookmark-toggle)
nmap <silent> <Leader>ma <Plug>(coc-bookmark-annotate)
nmap <silent> <Leader>mf <Plug>(coc-bookmark-next)
nmap <silent> <Leader>mb <Plug>(coc-bookmark-prev)
nmap <silent> <Leader>ml :CocList bookmark<CR>
nmap <silent> <Leader>mx :CocCommand bookmark.clearForCurrentFile<CR>
nmap <silent> <Leader>mX :CocCommand bookmark.clearForAllFiles<CR>

" change bullet list character
call SourceDotfile('vim/change-bullet.vim')

" put Simplenote creds into separate file for simplenote.vim plugin
call SourceLocalDotfile('simplenoterc')
let g:SimplenoteVertical=1
let g:SimplenoteFiletype='markdown'

" abbreviations
let g:AutoCloseExpandSpace = 0 " Make iabbrev work again with vim-autoclose
iabbrev Ketih Keith

" Define any local-specific mappings/abbreviations
call SourceLocalDotfile('vimrc-local.after')

