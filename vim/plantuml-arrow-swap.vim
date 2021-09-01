" PlantUML utility functions

" reverse position of entities in relationship
" e.g. "a --> b : comment" becomes "b --> a : comment"
function! UmlReverseEntity()
  silent! s/\v(\w+)\s+([-<>\.a-zA-Z0-9]+)\s+(\w+)(.*)/\3 \2 \1\4/
  nohlsearch
endfunction

" reverse the direction of arrow in relationship
" e.g. "a --> b : comment" becomes "a <-- b : comment"
function! UmlReverseArrow()
  silent! s/\v\<([-\.a-zA-Z0-9]+)/\1\}/
  silent! s/\v([-\.a-zA-Z0-9]+)\>/\{\1/
  silent! s/\v(\{)([-\.a-zA-Z0-9]+)/<\2/
  silent! s/\v([-\.a-zA-Z0-9]+)(\})/\1>/

  " turn off search highlight after completing substitutions
  nohlsearch
endfunction

nmap <Leader>ura :call UmlReverseArrow()<CR>
vmap <Leader>ura :'<,'>call UmlReverseArrow()<CR>

nmap <Leader>ure :call UmlReverseEntity()<CR>
vmap <Leader>ure :'<,'>call UmlReverseEntity()<CR>

nmap <Leader>urr :call UmlReverseEntity()<CR>:call UmlReverseArrow()<CR>
vmap <Leader>urr :'<,'>call UmlReverseEntity()<CR>:call UmlReverseArrow()<CR>


