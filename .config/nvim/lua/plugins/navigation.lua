local M = {
  -- Changes vim working directory to project root
  {
    "airblade/vim-rooter",
    init = function()
      vim.g.rooter_patterns = { "pom.xml", "build.xml", "package.json", ".git" }
    end
  },

  -- Allows ctrl-h/j/k/l to work for both vim splits and tmux panes
  "christoomey/vim-tmux-navigator",

  -- fzf
  {
    "junegunn/fzf.vim",
    name = "fzf.vim",
    cond = not vim.g.vscode, -- use built-in search when in VS Code
    dependencies = {
      {
        "junegunn/fzf",
        lazy = false,
        build = "~/.fzf/install --all",
      },
    },
    lazy = false,
    init = function()
      -- Sort vimwiki diary by reverse path to make entries appear in chronological
      -- order (prefer recent results to random results in previous years)
      vim.cmd [[
          set rtp+=~/.fzf
          let g:ripgrep_fzf_sort = ''
          autocmd FileType vimwiki let g:ripgrep_fzf_sort = '--sortr path'

          function! RipgrepFzf(query, fullscreen)
            let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case ' . g:ripgrep_fzf_sort . ' -- %s || true'
            let initial_command = printf(command_fmt, shellescape(a:query))
            let reload_command = printf(command_fmt, '{q}')
            let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
            call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
          endfunction

          command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)
        ]]

      -- Search filenames with Ctrl-p
      vim.keymap.set("n", "<C-p>", ":FZF<CR>")

      -- Search file contents with <leader>//
      vim.keymap.set("n", "<Leader>//", ":Rg<CR>")
      vim.keymap.set("n", "<Leader>/b", ":Buffers<CR>")
      vim.keymap.set("n", "<Leader>/f", ":Files<CR>")
      vim.keymap.set("n", "<Leader>/h", ":History<CR>")
      vim.keymap.set("n", "<Leader>/l", ":Lines<CR>")
      vim.keymap.set("n", "<Leader>/t", ":Rg<CR>")
    end
  },

  -- Jump to text with `s` plus two letters
  -- Use ; and , to find next/prev match
  "justinmk/vim-sneak",

  -- Customized and functional default starting screen
  {
    "mhinz/vim-startify",
    lazy = false,
    init = function()
      vim.g.startify_custom_header = 'startify#pad(startify#fortune#boxed())'
      vim.g.startify_fortune_use_unicode = 1
      vim.g.startify_lists = {
        { type = "files" },
        { type = "bookmarks" },
        { type = "commands" }
      }

      vim.g.startify_bookmarks = {
        { ["."] = "." },
        { ["w"] = vim.env.VIMWIKI_DIR },
        { ["t"] = vim.env.VIMWIKI_DIR .. "/TODO.md" },
        { ["n"] = vim.env.VIMWIKI_DIR .. "/QuickNote.md" },
        { ["c"] = vim.env.CONFIG_DIR },
        { ["l"] = vim.env.CONFIG_LOCAL_DIR }
      }

      vim.keymap.set("n", "<leader>;", ":Startify<CR>", { noremap = true, silent = true })
    end,
  },

  -- Open project tree view buffer on left
  {
    "scrooloose/nerdtree",
    cond = not vim.g.vscode, -- Use built-in file explorer instead of NERDTree
    init = function()
      vim.g.NERDTreeHijackNetrw = 0
      vim.g.NERDTreeShowHidden = 1
      vim.keymap.set("n", "<leader>t", ":NERDTreeToggle<CR>", { noremap = true })
      vim.keymap.set("n", "<leader>tt", ":NERDTreeToggle<CR>", { noremap = true })
    end
  },

  -- Replace netrw for file browser (see oil-settings.vim)
  {
    "stevearc/oil.nvim",
    cond = not vim.g.vscode, -- see oil.code settings for VSCode below
    init = function()
      vim.cmd([[
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

        function! OilPwd()
          lua print(require("oil").get_current_dir())
        endfunction

        " shortcuts to open key directories in file explorer (more leader-dot mappings)
        nmap <silent> <leader>.~ :exec "edit " . $HOME<CR>:call OilPwd()<CR>
        nmap <silent> <Leader>.w :exec "edit " . $VIMWIKI_DIR<CR>:call OilPwd()<CR>
        nmap <silent> <Leader>.d :exec "edit " . $DOC_DIR<CR>:call OilPwd()<CR>
        nmap <silent> <Leader>.k :exec "edit " . $DESKTOP_DIR<CR>:call OilPwd()<CR>
        nmap <silent> <Leader>.p :exec "edit " . $PROJECTS_DIR<CR>:call OilPwd()<CR>
        nmap <silent> <Leader>.c :exec "edit " . $CONFIG_DIR<CR>:call OilPwd()<CR>
        nmap <silent> <Leader>.l :exec "edit " . $CONFIG_LOCAL_DIR<CR>:call OilPwd()<CR>

        " shortcut to show current buffer dir since it's not onscreen like netrw
        autocmd FileType oil nmap <buffer> _ :call OilPwd()<CR>

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
      ]])

      require("oil").setup({
        default_file_explorer = true,
        use_default_keymaps = false,
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["-"] = "actions.parent",
          ["g|"] = "actions.select_vsplit",
          ["g-"] = "actions.select_split",
          ["gp"] = "actions.preview",
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
          ["g\\"] = "actions.toggle_trash",
        },
      })
    end
  },

  -- Jump to/from 'alternate files' e.g. implemenation/test source files
  {
    "tpope/vim-projectionist",
    init = function()
      vim.keymap.set("n", "<Leader>ja", ":A<CR>", { silent = true })

      -- Set up file alternate mappings based on file extensions using
      -- global-projections.json (in this directory). I want to be able to jump
      -- between implementation source file and test file without having to add a
      -- .projections.json to every project I work on.
      --
      -- See `:help projectionist` and vim-projectionist plugin.
      vim.api.nvim_create_autocmd("User", {
        pattern = "ProjectionistDetect",
        callback = function()
          -- fixme: there's probably a native lua way to do this
          local global_projections_file = vim.env.HOME .. "/.config/nvim/global-projections.json"
          local json = vim.call("readfile", global_projections_file)
          local dict = vim.call("projectionist#json_parse", json)
          local cwd = vim.call("getcwd")
          vim.call("projectionist#append", cwd, dict)
        end
      })
    end
  },

  -- Open file in browser (dependency of plantuml-previewer.vim)
  {
    "tyru/open-browser.vim",
    init = function()
      vim.keymap.set("n", "gx", "<Plug>(openbrowser-smart-search)")
      vim.keymap.set("v", "gx", "<Plug>(openbrowser-smart-search)")
      vim.g.netrw_nogx = 1 -- disable netrw's gx mapping in favor of open-browser.vim
    end
  },

  -- Toggle expanding current split to full window
  {
    "vim-scripts/zoomwintab.vim",
    init = function()
      vim.g.zoomwintab_remap = 0
      vim.keymap.set("n", "<leader>z", ":ZoomWinTabToggle<CR>")
    end
  },

  -- Display plantuml image output in browser with live updating
  {
    "weirongxu/plantuml-previewer.vim",
    init = function()
      -- vim.g['plantuml_previewer#plantuml_jar_path'] =
      --       \ trim(system('plantuml --jarpath'))
    end
  },
}

-- VS Code-specific Navigation mappings (outside of plugin specs)
if vim.g.vscode then
    local vscode = require('vscode')
    local map = vim.keymap.set
    local openOilCode = function() vscode.action('oil-code.open') end

    -- Use built-in file explorer instead of NERDTree
    map("n", "<leader>tt", function() vscode.action('workbench.action.toggleSidebarVisibility') end)

    -- oil.code plugin (substitute for oil.nvim)
    vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
        pattern = {"*"},
        callback = function()
            map("n", "-", openOilCode)
            vim.api.nvim_create_user_command('Explore', openOilCode, {})
        end,
    })

    vim.api.nvim_create_autocmd({'FileType'}, {
        pattern = {"oil"},
        callback = function()
            map("n", "<leader>..", function() vscode.action('oil-code.openParent') end)
            map("n", "-", function() vscode.action('oil-code.openParent') end)
            map("n", "_", function() vscode.action('oil-code.openCwd') end)
            map("n", "<CR>", function() vscode.action('oil-code.select') end)
            map("n", "<C-t>", function() vscode.action('oil-code.selectTab') end)
            map("n", "<C-l>", function() vscode.action('oil-code.refresh') end)
            map("n", "`", function() vscode.action('oil-code.cd') end)
        end,
    })

    -- Search file contents with `<leader>//` (requires "fzf fuzzy quick open" VS Code extension)
    -- (Leaving "ctrl-p" mapping as VS Code default behavior for now)
    vim.keymap.set("n", "<leader>//", function() vscode.action("fzf-quick-open.runFzfSearchProjectRoot") end)

    -- Trying to map <C-h/j/k/l> to move between buffers doesn't seem to work, but "<C-w>h/j/k/l" does.
    -- https://github.com/vscode-neovim/vscode-neovim/blob/284df247b4ff9843c12b57ea517495b0d83c2b18/runtime/vscode/overrides/vscode-window-commands.vim#L90-L98
    -- Annoying, but will adapt to using these for now.
end

return M
