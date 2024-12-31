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
" call plug#begin('~/.vim/plugged')
" call SourceNvimDotfile('plugins.vim')
" call SourceLocalNvimDotfile('plugins.vim')
" call plug#end()

" See LUA_PATH in ~/.zshenv (:h package.path)
lua require("plugins")


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
nmap <leader><leader> :call LeaderReset()<cr>
nmap <leader><space> :call LeaderReset()<cr>


" Replace smart quotes with plain quotes
function! StripSmartQuotes()
    " save last search & cursor position
    let l:save=winsaveview()
    silent! %substitute/‘/'/ge
    silent! %substitute/’/'/ge
    silent! %substitute/“/"/ge
    silent! %substitute/”/"/ge
    call winrestview(l:save)
endfunction
nnoremap <Leader>sq :call StripSmartQuotes()<CR>


" Strips trailing whitespace at the end of lines
function! StripTrailingWhitespaces()
    " save last search & cursor position
    let l:save=winsaveview()
    silent! %substitute/\s\+$//e
    " Remove carriage return characters (^M) if present too
    silent! %substitute/\r//e
    call winrestview(l:save)
endfunction
nnoremap <Leader>ss :call StripTrailingWhitespaces()<CR>


" Toggle between number and nonumber (show always enables relative number,
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


" Toggle between absolute number and relativenumber
function! ToggleNumberRel()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunction
nmap <Leader>nr :call ToggleNumberRel()<CR>


" Toggle paste mode quickly
function! TogglePaste()
  set paste!
  echo 'Paste mode ' . (&paste ? 'enabled' : 'disabled')
endfunction
nnoremap <Leader>\ :call TogglePaste()<CR>
nnoremap <Space>\ :call TogglePaste()<CR>


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

" Toggle listing hidden characters
nmap <Leader>cc :set list!<CR>

" Paste from clipboard
nmap <Leader>p "+p
nmap <Leader>P "+P

" Paste over visual selection without clobbering clipboard
vmap <Leader>p "_dP


" shortcuts for splits similar to my bindings for tmux
nnoremap <Leader>- :split<CR>
nnoremap <Leader>\| :vsplit<CR>
nnoremap <Leader>.. :Explore<CR>
nnoremap <Leader>.- :Sexplore<CR>
nnoremap <Leader>.\| :Vexplore<CR>


" Init a markdown code block
nnoremap <Leader>` i```<CR><CR>```<ESC>ki
nnoremap <Leader>`<Space> i```<CR><CR>```<ESC>ki
nnoremap <Leader>`p i```<CR><CR>```<ESC>k"+p
vnoremap <Leader>` "zc```<CR>```<ESC>k"zp



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

