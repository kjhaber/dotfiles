let g:coc_global_extensions = [
\  'coc-calc',
\  'coc-css',
\  'coc-eslint',
\  'coc-html',
\  'coc-java',
\  'coc-json',
\  'coc-prettier',
\  'coc-pyright',
\  'coc-rls',
\  'coc-sh',
\  'coc-snippets',
\  'coc-solargraph',
\  'coc-tsserver',
\  'coc-vimlsp',
\  'coc-xml',
\  'coc-yaml',
\  'coc-yank'
\ ]
let g:coc_snippet_next = '<C-j>'
let g:coc_snippet_prev = '<C-k>'

function! s:show_documentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  elseif (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  endif
endfunction



" LSP key bindings
nmap <silent> <Leader>eb <Plug>(coc-diagnostic-prev)
nmap <silent> <Leader>ef <Plug>(coc-diagnostic-next)
nmap <silent> <Leader>el :CocDiagnostics<CR>
nmap <silent> <Leader>ff :call CocActionAsync('format')<CR>
nmap <silent> <Leader>jd <Plug>(coc-definition)
nmap <silent> <Leader>ji <Plug>(coc-implementation)
nmap <silent> <Leader>jr <Plug>(coc-references)
nmap <silent> <Leader>jt <Plug>(coc-type-definition)

nmap <silent> <Leader>l<Space> <Plug>(coc-codeaction)
vmap <silent> <Leader>l<Space> <Plug>(coc-codeaction-selected)
nmap <silent> <Leader>lf <Plug>(coc-format)
vmap <silent> <Leader>lf <Plug>(coc-format-selected)
nnoremap <silent> <Leader>lo :call CocAction('runCommand', 'editor.action.organizeImport')<CR>
nnoremap <silent> <Leader>lsd :<C-u>CocList outline<cr>
nnoremap <silent> <Leader>lsw :<C-u>CocList -I symbols<cr>
nmap <silent> <Leader>lr <Plug>(coc-rename)
nmap <silent> <leader>lx <Plug>(coc-fix-current)
nnoremap <silent> <Leader>ll :call <SID>show_documentation()<CR>

" Snippets
imap <C-s> <Plug>(coc-snippets-expand)
vmap <C-j> <Plug>(coc-snippets-select)

" Coc-calc
nnoremap <Leader>ca <Plug>(coc-calc-result-append)
nnoremap <Leader>cr <Plug>(coc-calc-result-replace)

" Toggle completion with ctrl-space (even in normal mode)
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif


" Make Enter and tab work more like I'm used to from IDEs
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
