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

" ChangeBullet - Fixed Char (normal mode mappings use repeat.vim)
nmap <silent> <Plug>ChangeBulletDash :call ChangeBullet('-')<CR>
\:call repeat#set("\<Plug>ChangeBulletDash")<CR>
nmap <Leader>b- <Plug>ChangeBulletDash

nmap <silent> <Plug>ChangeBulletStar :call ChangeBullet('*')<CR>
\:call repeat#set("\<Plug>ChangeBulletStar")<CR>
nmap <Leader>b* <Plug>ChangeBulletStar

nmap <silent> <Plug>ChangeBulletGt :call ChangeBullet('>')<CR>
\:call repeat#set("\<Plug>ChangeBulletGt")<CR>
nmap <Leader>b> <Plug>ChangeBulletGt

nmap <silent> <Plug>ChangeBulletPlus :call ChangeBullet('+')<CR>
\:call repeat#set("\<Plug>ChangeBulletPlus")<CR>
nmap <Leader>b+ <Plug>ChangeBulletPlus

nmap <silent> <Plug>ChangeBulletDot :call ChangeBullet('..')<CR>
\:call repeat#set("\<Plug>ChangeBulletDot")<CR>
nmap <Leader>b. <Plug>ChangeBulletDot

vmap <silent> <Leader>b- :'<,'>call ChangeBullet('-')<CR>
vmap <silent> <Leader>b* :'<,'>call ChangeBullet('*')<CR>
vmap <silent> <Leader>b> :'<,'>call ChangeBullet('>')<CR>
vmap <silent> <Leader>b+ :'<,'>call ChangeBullet('+')<CR>
vmap <silent> <Leader>b. :'<,'>call ChangeBullet('..')<CR>

" ToggleBullet (normal mode mappings use repeat.vim)
nmap <silent> <Plug>ToggleBulletN :call ToggleBullet()<CR>
\:call repeat#set("\<Plug>ToggleBulletN")<CR>
nmap <Leader>bb <Plug>ToggleBulletN

vmap <silent> <Leader>bb :'<,'>call ToggleBullet()<CR>
imap <C-b> <C-o>:call ToggleBullet()<CR>

" Bullet indent/outdent with toggle
nmap <silent> <Plug>ChangeBulletIndent :><CR>:call ToggleBullet()<CR>
\:call repeat#set("\<Plug>ChangeBulletIndent")<CR>
nmap <Leader>bi <Plug>ChangeBulletIndent

nmap <silent> <Plug>ChangeBulletOutdent :<<CR>:call ToggleBullet()<CR>
\:call repeat#set("\<Plug>ChangeBulletOutdent")<CR>
nmap <Leader>bo <Plug>ChangeBulletOutdent

vmap <silent> <Leader>bi :'<,'>><CR>:'<,'>call ToggleBullet()<CR>
vmap <silent> <Leader>bo :'<,'><<CR>:'<,'>call ToggleBullet()<CR>

