" oil.nvim configs
"
" Replaces netrw for file browser. I'm happy about the minimalistic view and
" directory editing - been using vidir for this, but oil.nvim makes that more
" seamless.
"
" I have a lot of muscle memory for the netrw Explore/Vexplore/Sexplore
" commands, even with leader shortcuts, so this restores equivalent commands.
" Also some of oil.nvim's default settings conflict with my other settings and
" shortcuts, and I only want to use a subset of its features.  Plus my usual
" leader reset shortcut ("space-space") can refresh the directory view too
" instead of remembering an oil-specific shortcut for that.

if has('nvim')

  command! Explore silent call OilCur()
  function! OilCur()
    if expand("%:p:h") == ''
      Oil .
    else
      Oil %:p:h
    endif
  endfunction

  command! Sexplore silent call OilSplit()
  function! OilSplit()
    split
    call OilCur()
  endfunction

  command! Vexplore silent call OilVsplit()
  function! OilVsplit()
    vsplit
    call OilCur()
  endfunction

  " shortcut to show current buffer dir since it's not onscreen like netrw
  autocmd FileType oil nmap <buffer> _ :lua print(require("oil").get_current_dir())<CR>

  " go to home dir quickly
  autocmd FileType oil nmap <buffer> <silent> <leader>~ :Oil ~<CR>

  " integrate dir refresh into my usual reset shortcut
  autocmd FileType oil nmap <buffer> <silent> <leader><leader> :call OilLeaderReset()<cr>
  autocmd FileType oil nmap <buffer> <silent> <leader><space> :call OilLeaderReset()<cr>

  function! OilLeaderReset()
    let p = getpos('.')
    call LeaderReset()
    lua require("oil.actions").refresh.callback()

    " restore cursor position after oil refresh, which runs async -
    " this is best-effort but hopefully better than always resetting to 0,0
    let restore_pos_exec = "call setpos('.', [" . join(p, ',') . "])"
    call timer_start(100, {-> execute(restore_pos_exec)})
  endfunction

  " Initialize oil.nvim
lua << EOF
  require("oil").setup({
    default_file_explorer = true,
    use_default_keymaps = false,
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      -- ["<C-s>"] = "actions.select_vsplit",
      -- ["<C-h>"] = "actions.select_split",
      -- ["<C-t>"] = "actions.select_tab",
      -- ["<C-p>"] = "actions.preview",
      -- ["<C-c>"] = "actions.close",
      -- ["<C-l>"] = "actions.refresh",
      ["-"] = "actions.parent",
      -- ["_"] = "actions.open_cwd",
      -- ["`"] = "actions.cd",
      -- ["~"] = "actions.tcd",
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
      ["g\\"] = "actions.toggle_trash",
    },
  })
EOF
endif

