" kjhaber vimrc

" --------------------------------------------------------------
" General Settings
" --------------------------------------------------------------
scriptencoding utf-8

set backspace=2
set clipboard=unnamed
set encoding=utf-8
set expandtab
set foldlevelstart=20
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set lazyredraw
set linebreak
set nomodeline
set number
set relativenumber
set ruler
set scrolloff=6
set shell=bash
set shiftwidth=2
set showmatch
set smartcase
set softtabstop=2
set splitbelow
set splitright
set tabstop=2
set updatetime=250
set wildmenu
set listchars+=tab:»\ ,eol:¶,space:⋅,trail:✗
set whichwrap+=<,>,h,l,[,]
set nobackup
set nowritebackup

syntax enable
filetype plugin indent on

" Omnicomplete
set omnifunc=syntaxcomplete#Complete
set completeopt+=menu
set completeopt+=menuone
set completeopt+=noinsert
set completeopt+=preview

" Enable mouse
if has('mouse_sgr')
    set ttymouse=sgr
endif
set mouse=a

" Enable full terminal colors
set t_Co=256
if has("termguicolors")
  set termguicolors
endif

" Sets terminal title to titlestring (or filename if unset)
set title
let &titleold=$USER . '@' . hostname() . ' | ' . fnamemodify(getcwd(), ':t')

" Use both \ and space as leader
" I've broken my habit for \ as leader, but space doesn't show up in showcmd
let g:mapleader='\\'
map <Space> <Leader>

" Neovim-specific options
if has("nvim")
  " Show result of :s command while typing
  set inccommand=nosplit
endif


" --------------------------------------------------------------
" Source local configurations
" --------------------------------------------------------------

" Load files conditionally.  This allows separating the core configuration
" that is the same on all machines from environment-specific config (like
" OS-specific, work vs home config, etc.).
exec 'source ' . $HOME . '/.config/nvim/source-if-readable.vim'

" Source local vim config before plugins load (unused but here for completeness)
call SourceLocalNvimDotfile('init-before.vim')


" --------------------------------------------------------------
" Plugins
" --------------------------------------------------------------
call plug#begin('~/.vim/plugged')
call SourceNvimDotfile('plugins.vim')
call SourceLocalNvimDotfile('plugins.vim')
call plug#end()

" --------------------------------------------------------------
" Statusline
" --------------------------------------------------------------
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
set statusline+=%{SelectedWordCount()}%*\  "count of selected words
set statusline+=%c,    "cursor column
set statusline+=%l/%L\  "cursor line/total lines
set statusline+=(%P)    "percent through file

function SelectedWordCount()
    let l:word_count=" "
    if has_key(wordcount(),'visual_words')
        let l:word_count="[".wordcount().visual_words." words selected]"
    endif
    return l:word_count
endfunction

" --------------------------------------------------------------
" Autocommands
" --------------------------------------------------------------

" Highlight line with cursor
" https://stackoverflow.com/questions/14068751/how-to-hide-cursor-line-when-focus-in-on-other-window-in-vim
augroup CursorLine
    autocmd!
    autocmd VimEnter * setlocal cursorline
    autocmd WinEnter * setlocal cursorline
    autocmd BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
augroup END

" Quit vim when quickfix is the last open window/tab
" https://stackoverflow.com/questions/7476126/how-to-automatically-close-the-quick-fix-window-when-leaving-a-file
augroup QFClose
  autocmd!
  autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
augroup END

" Also quit vim when NERDTree, Fugitive git status, or Calendar is last open window/tab
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:Calendar")) | q | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:fugitive_expanded")) | q | endif


" In netrw, override ctrl-hjkl mappings so ctrl-w doesn't need to be typed first
augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup END

function! NetrwMapping()
    noremap <buffer> <c-h> <c-w>h
    noremap <buffer> <c-j> <c-w>j
    noremap <buffer> <c-k> <c-w>k
    noremap <buffer> <c-l> <c-w>l
endfunction

" --------------------------------------------------------------
" User-Defined Functions and Commands
" --------------------------------------------------------------

" Reset editor mode state and refresh terminal/tmux
function! LeaderReset()
  set nopaste
  redraw!
  if !empty($TMUX)
    silent execute '!tmux refresh-client'
  endif
  " :nohlsearch and :echo don't work within a function, feedkeys hacks around
  " this limitation
  call feedkeys( ":nohlsearch\<CR>:echo \"\"\<CR>" )
endfunction

function! s:show_documentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  elseif (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  endif
endfunction

" replace smart quotes with plain quotes
function! StripSmartQuotes()
    " save last search & cursor position
    let l:save=winsaveview()
    silent! %substitute/‘/'/ge
    silent! %substitute/’/'/ge
    silent! %substitute/“/"/ge
    silent! %substitute/”/"/ge
    call winrestview(l:save)
endfunction

" strips trailing whitespace at the end of lines
function! StripTrailingWhitespaces()
    " save last search & cursor position
    let l:save=winsaveview()
    silent! %substitute/\s\+$//e
    " Remove carriage return characters (^M) if present too
    silent! %substitute/\r//e
    call winrestview(l:save)
endfunction

" toggle between number and nonumber (show always enables relative number,
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

" toggle between absolute number and relativenumber
function! ToggleNumberRel()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunction

" Toggle paste mode quickly
function! TogglePaste()
  set paste!
  echo 'Paste mode ' . (&paste ? 'enabled' : 'disabled')
endfunction


" Initialize my daily diary entry
" -- creates two sections, 'JOURNAL' and 'TODO'
" -- creates mark j for Journal section
" -- creates mark t for Todo section
command! InitDiary execute "normal! ggi## JOURNAL<cr>(login)<esc>:call WikiTimestamp()<cr>o* <esc>mji<cr><cr><cr>## TODO<esc>mto* [ ] <cr><esc>kA"

" Initialize PlantUml document
command! InitUml execute "normal! ggi@startuml<cr><cr>title<cr><cr>@enduml<cr><esc>kkkA "

" Make updating plugins more convenient
command! PU PlugUpdate | PlugUpgrade


" --------------------------------------------------------------
" Leader/User-Defined Mappings
" --------------------------------------------------------------

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

nmap <Leader>cc :set list!<CR>

nmap <Leader>ff :call CocActionAsync('format')<CR>
nmap <Leader>fi mzgg=G`z

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

" turn off search highlight (two-h mapping is to avoid wait for timeout)
nnoremap <Leader>h :nohlsearch<CR>
nnoremap <Leader>hh :nohlsearch<CR>

nnoremap <Leader>hr :GitGutterUndoHunk<CR>
nnoremap <Leader>hs :GitGutterStageHunk<CR>
nnoremap <Leader>hb :GitGutterPrevHunk<CR>
nnoremap <Leader>hf :GitGutterNextHunk<CR>

" LSP key bindings
nmap <silent> <Leader>eb <Plug>(coc-diagnostic-prev)
nmap <silent> <Leader>ef <Plug>(coc-diagnostic-next)
nmap <silent> <Leader>el :CocDiagnostics<CR>
nmap <silent> <Leader>jd <Plug>(coc-definition)
nmap <silent> <Leader>ji <Plug>(coc-implementation)
nmap <silent> <Leader>jr <Plug>(coc-references)
nmap <silent> <Leader>jt <Plug>(coc-type-definition)

nmap <silent> <Leader>l<Space> <Plug>(coc-codeaction)
vmap <silent> <Leader>l<Space> <Plug>(coc-codeaction-selected)
nmap <silent> <Leader>lf <Plug>(coc-format)
vmap <silent> <Leader>lf <Plug>(coc-format-selected)
nnoremap <silent> <Leader>lo :call CocAction('runCommand', 'editor.action.organizeImport')<CR>
nnoremap <silent> <Leader>lsd :<C-u>CocList outline<cr>
nnoremap <silent> <Leader>lsw :<C-u>CocList -I symbols<cr>
nmap <silent> <Leader>lr <Plug>(coc-rename)
nmap <silent> <leader>lx <Plug>(coc-fix-current)
nnoremap <silent> <Leader>ll :call <SID>show_documentation()<CR>

" Bookmarks
nmap <silent> <Leader>mm <Plug>(coc-bookmark-toggle)
nmap <silent> <Leader>ma <Plug>(coc-bookmark-annotate)
nmap <silent> <Leader>mf <Plug>(coc-bookmark-next)
nmap <silent> <Leader>mb <Plug>(coc-bookmark-prev)
nmap <silent> <Leader>ml :CocList bookmark<CR>
nmap <silent> <Leader>mx :CocCommand bookmark.clearForCurrentFile<CR>
nmap <silent> <Leader>mX :CocCommand bookmark.clearForAllFiles<CR>

nmap <Leader>nn :call ToggleNumber()<CR>
nmap <Leader>nr :call ToggleNumberRel()<CR>

nmap <Leader>p "+p
nmap <Leader>P "+P

" <Leader>P during a visual selection will replace the selection with
" current clipboard without changing current clipboard like 'd' or 'c' usually
" does.
vmap <Leader>p "_d"+p
vmap <Leader>P "_d"+P

nnoremap <Leader>ss :call StripTrailingWhitespaces()<CR>
nnoremap <Leader>sq :call StripSmartQuotes()<CR>

nnoremap <Leader>t :NERDTreeToggle<CR>
nnoremap <Leader>tt :NERDTreeToggle<CR>

" Vimwiki mappings
" (Replace 'VimwikiColorize' buffer-level mapping of `<leader>wc`: cannot disable
" mapping with g:vimwiki_key_mappings without disabling all global mappings:
" https://github.com/vimwiki/vimwiki/blob/fea8bee382b2051b0137fd2cacf0862823ee69b3/ftplugin/vimwiki.vim#L463)
autocmd FileType vimwiki nmap <buffer> <Leader>wc :Calendar<CR>
nmap <Leader>wc :Calendar<CR>
nmap <Leader>w<Space>w <Plug>VimwikiMakeDiaryNote
nmap <Leader>w<Space>i <Plug>VimwikiDiaryGenerateLinks
nmap <Leader>wy <Plug>VimwikiDiaryPrevDay
nmap <Leader>wY <Plug>VimwikiDiaryNextDay
nmap <silent> <Leader>w- :call ToggleDashCheckbox()<CR>

" In vimwiki, I sometimes mark a 'checkbox' task with [-]` instead of `[X]` to
" indicate the item as 'not applicable' instead of complete (such as for a
" meeting being canceled).  This mapping toggles between 'n/a' and 'not done',
" while vimwiki's <ctrl-space> mapping toggles between 'done' and 'not done'.
function! ToggleDashCheckbox()
  if getline('.') =~ '\[-\]'
    substitute/\v\[-\]/[ ]/
  else
    substitute/\v\[.\]/[-]/
  endif
  normal! ``<CR>
endfunction

" Copy todo item to journal item (relies on mark t to indicate top of Todo
" section, see InitDiary command)
" nnoremap <Leader>wj :execute "normal! yy`tkkp" <bar> :s/\v\[.\] // <bar> :nohlsearch<CR>
nnoremap <Leader>wj :call WikiJournal()<CR>:w<CR>

function! WikiJournal()
  " yank current line into the 'j' register
  execute "normal! \"jyy"

  " jump to the 't' mark, go up two lines, paste 'j' register
  execute "normal! `tkk\"jp"

  " replace everything up to the first occurrence of single char in square
  " brackets (checklist state) with top-level asterisk bullet
  silent! substitute/\v.*\[.\] /* /

  " append timestamp to current line
  call WikiTimestamp()

  " clear search highlight
  call feedkeys(":nohlsearch\<CR>")
endfunction

" Append the current time (hour and minute) in square brackets to the end of
" the current line.  Replace existing if already present.
nnoremap <Leader>wm :call WikiTimestamp()<CR>:w<CR>
function! WikiTimestamp()
  " set 't' register to current time (in square brackets)
  let @t = system("date +'[\%H:\%M]'")

  " remove trailing newline from 't' register
  call setreg('t', substitute(@t, "\n$", "", ""), 'v')

  " remove timestamp from end of line if present
  silent! substitute/\v *\[..:..\]$//

  " append 't' register to end of current line
  execute "normal! A " . @t
endfunction

" Mappings to quickly access todo and quicknote wikis and write them (into daily diary)
nmap <Leader>wn :edit $VIMWIKI_DIR/QuickNote.md<CR>
nmap <Leader>w<Space>n :read $VIMWIKI_DIR/QuickNote.md<CR>
nmap <Leader>wt :edit $VIMWIKI_DIR/TODO.md<CR>
nmap <Leader>w<Space>t :read $VIMWIKI_DIR/TODO.md<CR>

nmap <Leader>z :ZoomWinTabToggle<CR>

" Search file contents with <leader>/
nmap <Leader>/ :Rg<CR>
nmap <Leader>// :Rg<CR>
nmap <Leader>/b :Buffers<CR>
nmap <Leader>/f :Files<CR>
nmap <Leader>/h :History<CR>
nmap <Leader>/l :Lines<CR>
nmap <Leader>/t :Rg<CR>

" shortcuts for splits similar to my bindings for tmux
nnoremap <Leader>- :Sexplore<CR>
nnoremap <Leader>\| :Vexplore<CR>
nnoremap <Leader>. :Explore<CR>

nnoremap <Leader>\ :call TogglePaste()<CR>
nnoremap <Space>\ :call TogglePaste()<CR>

" Init a markdown code block
nnoremap <Leader>` i```<CR><CR>```<ESC>ki
nnoremap <Leader>`<Space> i```<CR><CR>```<ESC>ki
nnoremap <Leader>`p i```<CR><CR>```<ESC>k"+p
vnoremap <Leader>` "zc```<CR>```<ESC>k"zp

nmap <Leader>; :Startify<CR>

" Reset editor mode state and refresh terminal/tmux
nmap <leader><leader> :call LeaderReset()<cr>
nmap <leader><space> :call LeaderReset()<cr>

" Search filenames with Ctrl-p
nnoremap <C-p> :FZF<CR>

" Snippets
imap <C-s> <Plug>(coc-snippets-expand)
vmap <C-j> <Plug>(coc-snippets-select)

" Coc-calc
nnoremap <Leader>ca <Plug>(coc-calc-result-append)
nnoremap <Leader>cr <Plug>(coc-calc-result-replace)

" http://vim.wikia.com/wiki/Moving_lines_up_or_down
" Adjusting my mapping to use alt instead of ctrl so I can use
" <C-j> and <C-k> for split navigation.
" On a Mac you have to use a trick: <ALT+j> ==> ∆, <ALT+k> ==> ˚
" Also add <alt-h> and <alt-l> to move lines left and right (indent/outdent)
" <Alt-h> ==> ˙
" <Alt-l> ==> ¬
" http://stackoverflow.com/questions/7501092/can-i-map-alt-key-in-vim
nnoremap ∆ :m .+1<CR>==
nnoremap ˚ :m .-2<CR>==
nnoremap ˙ <<
nnoremap ¬ >>
vnoremap ∆ :m '>+1<CR>gv=gv
vnoremap ˚ :m '<-2<CR>gv=gv
vnoremap ˙ <<
vnoremap ¬ >>


" Toggle completion with ctrl-space (even in normal mode)
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" make Enter and tab work more like I'm used to from IDEs
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Make quick macros easier
" Workflow is:
" 1) `qq` to start macro (register q)
" 2) do stuff
" 3) `q` to stop recording
" 4) `Shift-Q` to replay
nmap Q @q

" stop that window from popping up
map q: :q

" --------------------------------------------------------------
" Color Settings
" --------------------------------------------------------------

" Apply color settings
" (with slight adjustment to relative line number and hidden char colors)
colorscheme molokai
autocmd ColorScheme * highlight LineNr guifg=#758088
autocmd ColorScheme * highlight NonText guifg=#303030
autocmd ColorScheme * highlight SpecialKey guifg=#303030
set background=dark

" Separate colorscheme for vimwiki
augroup colors
  autocmd FileType vimwiki colorscheme gruvbox
augroup END

set colorcolumn=81
highlight ColorColumn guibg=#102535

" Show hidden characters by default (except in quickfix and vimwiki)
set list
autocmd FileType qf set nolist
autocmd FileType vimwiki set nolist

" --------------------------------------------------------------
" Source local-specific mappings/abbreviations
" --------------------------------------------------------------
call SourceLocalNvimDotfile('init-after.vim')

