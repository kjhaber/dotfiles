return {
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
    init = function()
      vim.cmd("source " .. vim.env.HOME .. "/.config/nvim/oil-settings.vim")
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
