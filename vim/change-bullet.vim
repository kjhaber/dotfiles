" change bullet list character
function! ChangeBullet(newChar)
  call setline(line('.'), substitute(getline('.'), '\v^( *)([^ ]+)(.*)$', '\1'.a:newChar.'\3', ''))
endfunction

function! ToggleBullet()
  " switch between '*' and '-' bullet characters
  if match(getline('.'), '\v^( *)\*') != -1
    call ChangeBullet('-')
  elseif match(getline('.'), '\v^( *)\-') != -1
    call ChangeBullet('*')
  else
    echom "No dash or asterisk bullet found on line"
  endif
endfunction

nmap <Leader>b- :call ChangeBullet('-')<CR>
nmap <Leader>b* :call ChangeBullet('*')<CR>
nmap <Leader>b> :call ChangeBullet('>')<CR>
nmap <Leader>b+ :call ChangeBullet('+')<CR>
nmap <Leader>b. :call ChangeBullet('..')<CR>

vmap <Leader>b- :'<,'>call ChangeBullet('-')<CR>
vmap <Leader>b* :'<,'>call ChangeBullet('*')<CR>
vmap <Leader>b> :'<,'>call ChangeBullet('>')<CR>
vmap <Leader>b+ :'<,'>call ChangeBullet('+')<CR>
vmap <Leader>b. :'<,'>call ChangeBullet('..')<CR>

nmap <Leader>bb :call ToggleBullet()<CR>
vmap <Leader>bb :'<,'>call ToggleBullet()<CR>
imap <C-b> <C-o>:call ToggleBullet()<CR>

" Bullet indent/outdent with toggle
nmap <Leader>bi :><CR>:call ToggleBullet()<CR>
nmap <Leader>bo :<<CR>:call ToggleBullet()<CR>
nmap <Leader>bI :><CR>:call ToggleBullet()<CR>A
nmap <Leader>bO :<<CR>:call ToggleBullet()<CR>A

vmap <Leader>bi :'<,'>><CR>:'<,'>call ToggleBullet()<CR>
vmap <Leader>bo :'<,'><<CR>:'<,'>call ToggleBullet()<CR>

