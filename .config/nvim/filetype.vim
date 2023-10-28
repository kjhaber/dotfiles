" Runs during filetype detection.  Must be symlinked to vim user runtime
" directory (~/.config/nvim/filetype.vim). See `:help new-filetype`.

if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
  " Set .md files in vimwiki dir to use filetype=vimwiki.
  " This keeps 'filetype detect' from changing filetype of .md files in
  " vimwiki directory to markdown. (netrw calls `filetype detect` when it
  " is opened, e.g. when using `:Vexplore`.)  Can't use $VIMWIKI_DIR
  " in this autocmd pattern because vim resolves symlinks in
  " the file path before matching against the filename pattern
  " (see `:h autocmd`).
  autocmd BufRead,BufNewFile */vimwiki/*.md set filetype=vimwiki
augroup END

