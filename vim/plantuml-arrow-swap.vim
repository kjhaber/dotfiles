" PlantUML Arrow Swap: change position of arrow in PlantUML doc
" e.g. "a --> b : comment" becomes "b <-- a : comment"
function! UmlArrowSwap()
  " swap "a --> b : comment" into "b --> a : comment"
  s/\v(\w+)\s+([-<>\.a-zA-Z0-9]+)\s+(\w+)(.*)/\3 \2 \1\4/

  " correct the arrow direction ( "-->" into "<--" )
  silent! s/\v\<([-\.a-zA-Z0-9]+)/\1\}/
  silent! s/\v([-\.a-zA-Z0-9]+)\>/\{\1/
  silent! s/\v(\{)([-\.a-zA-Z0-9]+)/<\2/
  silent! s/\v([-\.a-zA-Z0-9]+)(\})/\1>/

  " turn off search highlight after completing substitutions
  nohlsearch
endfunction

nmap <Leader>uas :call UmlArrowSwap()<CR>
vmap <Leader>uas :call UmlArrowSwap()<CR>

