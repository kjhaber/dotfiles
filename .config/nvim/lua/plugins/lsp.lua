local M = {
  -- LSP and auto-completion tool
  {
    "neoclide/coc.nvim",
    cond = not vim.g.vscode, -- don't load in VS Code since it has built-in LSP
    branch = "release",
    init = function()
      vim.cmd( [[
        let g:coc_global_extensions = [
        \  'coc-calc',
        \  'coc-css',
        \  'coc-eslint',
        \  'coc-go',
        \  'coc-html',
        \  'coc-java',
        \  'coc-json',
        \  'coc-lua',
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
        nnoremap <Leader>=a <Plug>(coc-calc-result-append)
        nnoremap <Leader>=r <Plug>(coc-calc-result-replace)

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
      ]] )
    end
  },
}

-- VS Code-specific LSP mappings (outside of plugin specs)
if vim.g.vscode then
    local vscode = require('vscode')
    local map = vim.keymap.set

        map("n", "<leader>eb", function() vscode.action("") end) -- <Plug>(coc-diagnostic-prev)
        map("n", "<leader>ef", function() vscode.action("") end) -- <Plug>(coc-diagnostic-next)
        map("n", "<leader>el", function() vscode.action("") end) -- :CocDiagnostics<CR>
        map("n", "<leader>ff", function() vscode.action("editor.action.format") end)
        map("n", "<leader>jd", function() vscode.action("editor.action.revealDefinition") end)
        map("n", "<leader>ji", function() vscode.action("editor.action.goToImplementation") end)
        map("n", "<leader>jr", function() vscode.action("editor.action.goToReferences") end)
        map("n", "<leader>jt", function() vscode.action("editor.action.goToTypeDefinition") end)

        map("n", "<leader>l<Space>", function() vscode.action("") end) -- <Plug>(coc-codeaction)
        map("v", "<leader>l<Space>", function() vscode.action("") end) -- <Plug>(coc-codeaction-selected)
        map("n", "<leader>lf", function() vscode.action("editor.action.format") end)
        map("v", "<leader>lf", function() vscode.action("editor.action.formatSelection") end)
        map("n", "<leader>lo", function() vscode.action("editor.action.organizeImports") end)
        map("n", "<leader>lsd", function() vscode.action("") end) -- :<C-u>CocList outline<cr>
        map("n", "<leader>lsw", function() vscode.action("") end) -- :<C-u>CocList -I symbols<cr>
        map("n", "<leader>lr", function() vscode.action("editor.action.rename") end)
        map("n", "<leader>lx", function() vscode.action("editor.action.quickFix") end)
        map("n", "<leader>ll", function() vscode.action("editor.action.showHover") end)
end

return M
