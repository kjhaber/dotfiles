" vim-projectionist plugin event handler
"
" Sets up file alternate mappings based on file extensions using
" global-projections.json (in this directory). I want to be able to jump
" between implementation source file and test file without having to add a
" .projections.json to every project I work on.
"
" See `:help projectionist` and vim-projectionist plugin.

let g:global_projections_file = $HOME . '/.config/nvim/global-projections.json'

function! s:setProjections()
  let l:json = readfile(g:global_projections_file)
  let l:dict = projectionist#json_parse(l:json)
  call projectionist#append(getcwd(), l:dict)
endfunction

" This event is fired by vim-projectionist when detecting project configs
autocmd User ProjectionistDetect :call s:setProjections()

