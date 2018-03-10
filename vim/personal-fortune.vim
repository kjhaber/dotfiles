" personal-fortune.vim
"
" Sets g:personal_fortune list variable to the contents of
" $DOTFILE_LOCAL_HOME/personal-fortune.  Elements of list are
" each a list of strings.  In the personal-fortune file,
" elements are separated by blank lines.
"
" This format matches what is expected for Startify.vim's
" g:startify_custom_header_quotes value.

let g:personal_fortune = []
let s:personal_fortune_path = fnameescape($DOTFILE_LOCAL_HOME . '/personal-fortune')
if filereadable(s:personal_fortune_path)
  let s:personal_fortune_contents = readfile(s:personal_fortune_path)
  let s:last_fortune_entry = []
  for s:i in s:personal_fortune_contents
    if strlen(s:i) > 0
      call add(s:last_fortune_entry, s:i)
    else
      if !empty(s:last_fortune_entry)
        call add(g:personal_fortune, s:last_fortune_entry)
      endif
      let s:last_fortune_entry = []
    endif
  endfor

  if !empty(s:last_fortune_entry)
    call add(g:personal_fortune, s:last_fortune_entry)
  endif
endif

