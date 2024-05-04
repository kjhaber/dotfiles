
" Diff ranges of lines in same file (rarely used)
Plug 'AndrewRadev/linediff.vim'

" TypeScript syntax highlighting
Plug 'HerringtonDarkholme/yats.vim'

" Text object for portions of a variable name (iv, av) - snake or camel case
Plug 'Julian/vim-textobj-variable-segment'

" Prerequisite for something, I can't remember
Plug 'MarcWeber/vim-addon-mw-utils'

" Edit all lines in quickfix list (run `:EnMasse`)
Plug 'Olical/vim-enmasse'

" Display git changes of lines in left gutter
Plug 'airblade/vim-gitgutter'
" update signs on file save
autocmd BufWritePost * GitGutter
nnoremap <Leader>hr :GitGutterUndoHunk<CR>
nnoremap <Leader>hs :GitGutterStageHunk<CR>
nnoremap <Leader>hb :GitGutterPrevHunk<CR>
nnoremap <Leader>hf :GitGutterNextHunk<CR>

" Changes vim working directory to project root
Plug 'airblade/vim-rooter'
let g:rooter_patterns = ['pom.xml', 'build.xml', 'package.json', '.git']

" PlantUML syntax highlighting
Plug 'aklt/plantuml-syntax'

" Dims inactive windows to make active stand out visually
Plug 'blueyed/vim-diminactive'

" TOML syntax highlighting (rarely used)
Plug 'cespare/vim-toml'

" MediaWiki syntax highlighting (rarely used)
Plug 'chikamichi/mediawiki.vim'

" Allows ctrl-h/j/k/l to work for both vim splits and tmux panes
Plug 'christoomey/vim-tmux-navigator'

" Applies project-specific editor-agnostic settings
Plug 'editorconfig/editorconfig-vim'

" JSON syntax highlighting
Plug 'elzr/vim-json'
let g:vim_json_syntax_conceal = 0

" Text object for backticks (yi`)
Plug 'fvictorio/vim-textobj-backticks'

" Format delimited text as table (rarely used)
Plug 'godlygeek/tabular'
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

" Snippet contents - used by coc.nvim
Plug 'honza/vim-snippets'

" Smart inserts closing parentheses
Plug 'itmammoth/doorboy.vim'

" Smithy syntax highlighting
Plug 'jasdel/vim-smithy'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Search filenames with Ctrl-p
nnoremap <C-p> :FZF<CR>

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

" Search file contents with <leader>/
nmap <Leader>/ :Rg<CR>
nmap <Leader>// :Rg<CR>
nmap <Leader>/b :Buffers<CR>
nmap <Leader>/f :Files<CR>
nmap <Leader>/h :History<CR>
nmap <Leader>/l :Lines<CR>
nmap <Leader>/t :Rg<CR>

" Jump to text with `s` plus two letters
" Use ; and , to find next/prev match
Plug 'justinmk/vim-sneak'

" Text object for the entire doc (ae, ie) - ie skips leading/trailing lines
" (rarely used)
Plug 'kana/vim-textobj-entire'

" Text object for last searched pattern (a/, i/) (rarely used)
Plug 'kana/vim-textobj-lastpat'

" Text object for text between underscores (a_, i_) (rarely used)
Plug 'kana/vim-textobj-underscore'

" Text object for entire line (al, il)
Plug 'kana/vim-textobj-line'

" Prerequisite for textobj plugins
Plug 'kana/vim-textobj-user'

" Shortcuts for bullet lists
Plug 'kjhaber/vim-bullet-shortcuts'

" Shortcuts for plantuml files
Plug 'kjhaber/vim-plantuml-shortcuts'

" Personal wiki/diary
Plug 'vimwiki/vimwiki'
call SourceNvimDotfile('vimwiki-settings.vim')

" When yanking text, makes yanked region blink
Plug 'machakann/vim-highlightedyank'
let g:highlightedyank_highlight_duration = 300

" Displays calendar in left pane, integrates with vimwiki diary
Plug 'mattn/calendar-vim'

" Customized and functional default starting screen
Plug 'mhinz/vim-startify'
let g:startify_list_order = ['files', 'dir', 'bookmarks', 'sessions', 'commands']
let g:startify_bookmarks = [ {'.': '.'}, {'t': '$VIMWIKI_DIR/TODO.md'}, {'w': '$VIMWIKI_DIR/index.md'}, {'c': '$CONFIG_DIR'}, {'l': '$CONFIG_LOCAL_DIR'} ]
nmap <Leader>; :Startify<CR>

" JSX syntax highlighting and indenting
Plug 'MaxMEllon/vim-jsx-pretty'
let g:jsx_ext_required = 0

" Navigate node/js `require` statements with `gf` (rarely used)
Plug 'moll/vim-node'

" Color scheme (used with vimwiki)
Plug 'morhetz/gruvbox'

" Mustache template syntax highlighting, motions (rarely used)
Plug 'mustache/vim-mustache-handlebars'

" Text object for Ruby blocks (ar, ir) (rarely used)
Plug 'nelstrom/vim-textobj-rubyblock'

" LSP and auto-completion tool
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call SourceNvimDotfile('coc-settings.vim')

" JavaScript syntax highlighting and indenting
Plug 'pangloss/vim-javascript'

" Markdown syntax highlighting
Plug 'plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
let g:indentLine_fileTypeExclude = ['markdown']
vnoremap * S*
vnoremap _ S_
" disable vim-markdown open-url feature in favor of open-browser plugin
map <Plug> <Plug>Markdown_OpenUrlUnderCursor

" Prerequisite for certain async plugins
Plug 'prabirshrestha/async.vim'

" Rust syntax highlighting
Plug 'rust-lang/rust.vim'
let g:rustfmt_autosave = 1
let g:rust_clip_command = 'pbcopy'

" Open project tree view buffer on left
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
let g:NERDTreeHijackNetrw = 0
let g:NERDTreeShowHidden = 1
nnoremap <Leader>t :NERDTreeToggle<CR>
nnoremap <Leader>tt :NERDTreeToggle<CR>

" Replace netrw for file browser (see oil-settings.vim)
Plug 'stevearc/oil.nvim'

" Repeat 'v' key to grow visual selection (<ctrl-v> to shrink)
Plug 'terryma/vim-expand-region'
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" tmux.conf syntax highlighting
Plug 'tmux-plugins/vim-tmux'

" Color scheme (primary)
Plug 'tomasr/molokai'

" Prerequisite for something...
Plug 'tomtom/tlib_vim'

" Filetype-aware comment toggling (gcc)
Plug 'tpope/vim-commentary'

" Git interface within vim
Plug 'tpope/vim-fugitive'
nnoremap <Leader>gb :Git blame<CR>
nnoremap <Leader>gc :Git commit<CR>
nnoremap <Leader>gd :Gdiff<CR>
nnoremap <Leader>gp :Ggrep<Space>
nnoremap <Leader>gs :Git<CR>

" Allows repeating plugin commands with . 
Plug 'tpope/vim-repeat'

" Mappings to add/remove parens, brackets, etc around text objects
Plug 'tpope/vim-surround'

" Jump to/from 'alternate files' e.g. implemenation/test source files
Plug 'tpope/vim-projectionist'
call SourceNvimDotfile('vim/projectionist-settings.vim')
nmap <silent> <Leader>ja :A<CR>

" Shortcuts for common Ex commands
" (e.g. ]q == :cnext, [q == :cprevious, ]a == :next, [b == :bprevious 
Plug 'tpope/vim-unimpaired'

" Open file in browser (dependency of plantuml-previewer.vim)
Plug 'tyru/open-browser.vim'
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" Ruby syntax highlighting and formatting
Plug 'vim-ruby/vim-ruby'

" Toggle expanding current split to full window 
Plug 'vim-scripts/zoomwintab.vim'
let g:zoomwintab_remap = 0
nmap <Leader>z :ZoomWinTabToggle<CR>

" Display plantuml image output in browser with live updating
Plug 'weirongxu/plantuml-previewer.vim'
au FileType plantuml let g:plantuml_previewer#plantuml_jar_path =
      \ trim(system('plantuml --jarpath'))

" Show git status flags in NERDTree
Plug 'Xuyuanp/nerdtree-git-plugin'

" Shows vertical lines at indent levels
Plug 'Yggdroot/indentLine'

" Extend % to jump to matching html tags
runtime macros/matchit.vim

" netrw options
let g:netrw_altv=1    " open files on right
let g:netrw_nogx = 1  " disable netrw's gx mapping in favor of open-browser.vim
