let g:vimwiki_list = [{'path': '$VIMWIKI_DIR', 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_global_ext = 0
let g:vimwiki_url_maxsave = 0
let g:vimwiki_use_mouse = 1
let g:vimwiki_auto_chdir = 1
let g:vimwiki_hl_cb_checked = 2
let g:vimwiki_conceallevel = 0
let g:vimwiki_listsyms = ' .x'
autocmd FileType vimwiki let g:indentLine_enabled = 0

" Vimwiki mappings
" (Replace 'VimwikiColorize' buffer-level mapping of `<leader>wc`: cannot disable
" mapping with g:vimwiki_key_mappings without disabling all global mappings:
" https://github.com/vimwiki/vimwiki/blob/fea8bee382b2051b0137fd2cacf0862823ee69b3/ftplugin/vimwiki.vim#L463)
autocmd FileType vimwiki nmap <buffer> <Leader>wc :Calendar<CR>
nmap <Leader>wc :Calendar<CR>
nmap <Leader>ww :edit $VIMWIKI_DIR<CR>
nmap <Leader>w<Space>w <Plug>VimwikiMakeDiaryNote
nmap <Leader>w<Space>i <Plug>VimwikiDiaryGenerateLinks
nmap <Leader>wy <Plug>VimwikiDiaryPrevDay
nmap <Leader>wY <Plug>VimwikiDiaryNextDay
nmap <silent> <Leader>w- :call ToggleDashCheckbox()<CR>

" In vimwiki, I sometimes mark a 'checkbox' task with [-]` instead of `[X]` to
" indicate the item as 'not applicable' instead of complete (such as for a
" meeting being canceled).  This mapping toggles between 'n/a' and 'not done',
" while vimwiki's <ctrl-space> mapping toggles between 'done' and 'not done'.
function! ToggleDashCheckbox()
  if getline('.') =~ '\[-\]'
    substitute/\v\[-\]/[ ]/
  else
    substitute/\v\[.\]/[-]/
  endif
  normal! ``<CR>
endfunction

" Copy todo item to journal item (relies on mark t to indicate top of Todo
" section, see InitDiary command)
" nnoremap <Leader>wj :execute "normal! yy`tkkp" <bar> :s/\v\[.\] // <bar> :nohlsearch<CR>
nnoremap <Leader>wj :call WikiJournal()<CR>:w<CR>

function! WikiJournal()
  " yank current line into the 'j' register
  execute "normal! \"jyy"

  " jump to the 't' mark, go up two lines, paste 'j' register
  execute "normal! `tkk\"jp"

  " replace everything up to the first occurrence of single char in square
  " brackets (checklist state) with top-level asterisk bullet
  silent! substitute/\v.*\[.\] /* /

  " append timestamp to current line
  call WikiTimestamp()

  " clear search highlight
  call feedkeys(":nohlsearch\<CR>")
endfunction

" Append the current time (hour and minute) in square brackets to the end of
" the current line.  Replace existing if already present.
nnoremap <Leader>wm :call WikiTimestamp()<CR>:w<CR>
function! WikiTimestamp()
  " set 't' register to current time (in square brackets)
  let @t = system("date +'[\%H:\%M]'")

  " remove trailing newline from 't' register
  call setreg('t', substitute(@t, "\n$", "", ""), 'v')

  " remove timestamp from end of line if present
  silent! substitute/\v *\[..:..\]$//

  " append 't' register to end of current line
  execute "normal! A " . @t
endfunction

" Mappings to quickly access todo and quicknote wikis and write them (into daily diary)
nmap <Leader>wn :edit $VIMWIKI_DIR/QuickNote.md<CR>
nmap <Leader>w<Space>n :read $VIMWIKI_DIR/QuickNote.md<CR>
nmap <Leader>wt :edit $VIMWIKI_DIR/TODO.md<CR>
nmap <Leader>w<Space>t :read $VIMWIKI_DIR/TODO.md<CR>


" Open yesterday's journal entry in a new vsplit
function! OpenYesterdayWikiSplit()
  vsplit
  execute "normal \<c-w>h"
  execute "normal \<Plug>VimwikiDiaryPrevDay"
endfunction
nmap <Leader>w< :call OpenYesterdayWikiSplit()<CR>


" Sometimes I use my LSP 'jump to definition' shortcut to follow urls out of
" habit - map same shortcut for urls in vimwiki
autocmd FileType vimwiki nmap <buffer> <Leader>jd gx


" Make Enter and tab work more like I'm used to from IDEs (handle vimwiki mappings)
autocmd Filetype vimwiki inoremap <silent><expr><buffer> <cr> coc#pum#visible() ? coc#pum#confirm()
                           \: "<C-]><Esc>:VimwikiReturn 1 5<CR>"
autocmd Filetype vimwiki inoremap <silent><expr><buffer> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
autocmd Filetype vimwiki inoremap <silent><expr><buffer> <S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

