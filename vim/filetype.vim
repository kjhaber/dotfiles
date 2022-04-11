" Runs during filetype detection.  Must be symlinked to vim user runtime
" directory (~/.config/nvim/filetype.vim). See `:help new-filetype`.

if exists("did_load_filetypes")
  finish
endif

" Ensures mdwiki files are set to 'vimwiki' filetype.  When opening
" explorer-splits from vimwiki (:Vexplore, :Sexplore), the filetype is
" sometimes changed to 'conf'.  This block prevents that behavior.
augroup filetypedetect
  au! BufRead,BufNewFile *.mdwiki setfiletype vimwiki
augroup END

