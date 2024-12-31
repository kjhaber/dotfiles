-- Bootstrap lazy.nvim
local vim = vim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)


-- Setup lazy.nvim
require("lazy").setup({
  spec = {

    -- Diff ranges of lines in same file (rarely used)
    "AndrewRadev/linediff.vim",

    -- TypeScript syntax highlighting
    "HerringtonDarkholme/yats.vim",

    -- Text object for portions of a variable name (iv, av) - snake or camel case
    {
      "Julian/vim-textobj-variable-segment",
      dependencies = { "kana/vim-textobj-user" }
    },

    -- Prerequisite for something, I can't remember
    "MarcWeber/vim-addon-mw-utils",

    -- Edit all lines in quickfix list (run `:EnMasse`)
    "Olical/vim-enmasse",

    -- Display git changes of lines in left gutter
    {
      "airblade/vim-gitgutter",
      init = function()
        -- update signs on file save
        vim.api.nvim_create_autocmd("BufWritePost", {
          pattern = { "*" },
          callback = function()
            vim.cmd("GitGutter")
          end
        })
        vim.keymap.set("n", "<leader>hr", ":GitGutterUndoHunk<CR>", { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>hs", ":GitGutterStageHunk<CR>", { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>hb", ":GitGutterPrevHunk<CR>", { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>hf", ":GitGutterNextHunk<CR>", { noremap = true, silent = true })
      end
    },

    -- Changes vim working directory to project root
    {
      "airblade/vim-rooter",
      init = function()
        vim.g.rooter_patterns = { "pom.xml", "build.xml", "package.json", ".git" }
      end
    },

    -- PlantUML syntax highlighting
    "aklt/plantuml-syntax",

    -- Dims inactive windows to make active stand out visually
    "blueyed/vim-diminactive",

    -- TOML syntax highlighting (rarely used)
    "cespare/vim-toml",

    -- MediaWiki syntax highlighting (rarely used)
    "chikamichi/mediawiki.vim",

    -- Allows ctrl-h/j/k/l to work for both vim splits and tmux panes
    "christoomey/vim-tmux-navigator",

    -- Applies project-specific editor-agnostic settings
    "editorconfig/editorconfig-vim",

    -- JSON syntax highlighting
    {
      "elzr/vim-json",
      init = function()
        vim.g.vim_json_syntax_conceal = 0
      end
    },

    -- Text object for backticks (yi`)
    {
      "fvictorio/vim-textobj-backticks",
      dependencies = { "kana/vim-textobj-user" }
    },

    -- Format delimited text as table (rarely used)
    {
      "godlygeek/tabular",
      init = function()
        vim.keymap.set("n", "<Leader>a=", ":Tabularize /=<CR>")
        vim.keymap.set("v", "<Leader>a=", ":Tabularize /=<CR>")
        vim.keymap.set("n", "<Leader>a,", ":Tabularize /,<CR>")
        vim.keymap.set("v", "<Leader>a,", ":Tabularize /,<CR>")
        vim.keymap.set("n", "<Leader>a<Space>", ":Tabularize /<Space><CR>")
        vim.keymap.set("v", "<Leader>a<Space>", ":Tabularize /<Space><CR>")
      end
    },

    -- Snippet contents - used by coc.nvim
    "honza/vim-snippets",

    -- Smart inserts closing parentheses
    "itmammoth/doorboy.vim",

    -- Smithy syntax highlighting
    "jasdel/vim-smithy",

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
        -- -- https://github.com/junegunn/fzf.vim#example-advanced-ripgrep-integration
        -- -- Sort vimwiki diary by reverse path to make entries appear in chronological
        -- -- order (prefer recent results to random results in previous years)
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

        -- -- Search file contents with <leader>/
        vim.keymap.set("n", "<Leader>/", ":Rg<CR>")
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

    -- Text object for the entire doc (ae, ie) - ie skips leading/trailing lines
    -- (rarely used)
    {
      "kana/vim-textobj-entire",
      dependencies = { "kana/vim-textobj-user" }
    },

    -- Text object for last searched pattern (a/, i/) (rarely used)
    {
      "kana/vim-textobj-lastpat",
      dependencies = { "kana/vim-textobj-user" }
    },

    -- Text object for text between underscores (a_, i_) (rarely used)
    {
      "kana/vim-textobj-underscore",
      dependencies = { "kana/vim-textobj-user" }
    },

    -- Text object for entire line (al, il)
    {
      "kana/vim-textobj-line",
      dependencies = { "kana/vim-textobj-user" }
    },


    -- Shortcuts for bullet lists
    "kjhaber/vim-bullet-shortcuts",

    -- Shortcuts for plantuml files
    "kjhaber/vim-plantuml-shortcuts",

    -- Personal wiki/diary
    {
      "vimwiki/vimwiki",
      init = function()
        vim.cmd("source " .. vim.env.HOME .. "/.config/nvim/vimwiki-settings.vim")
        -- vim.g.vimwiki_list = {{path = vim.env.VIMWIKI_DIR, syntax = "markdown", ext = ".md"}}
        -- vim.g.vimwiki_global_ext = 0
        -- vim.g.vimwiki_url_maxsave = 0
        -- vim.g.vimwiki_use_mouse = 1
        -- vim.g.vimwiki_auto_chdir = 1
        -- vim.g.vimwiki_hl_cb_checked = 2
        -- vim.g.vimwiki_conceallevel = 0
        -- vim.g.vimwiki_listsyms = " .x"

        -- vim.api.nvim_create_autocmd("FileType", {
        --   pattern = "vimwiki",
        --   callback = function()
        --     vim.g.indentLine_enabled = 0
        --     vim.keymap.set("n", "<leader>wc", ":Calendar<CR>", {buffer = true})

        --     -- Sometimes I use my LSP 'jump to definition' shortcut to follow urls out of
        --     -- habit - map same shortcut for urls in vimwiki
        --     vim.keymap.set("n", "<leader>jd", "gx", {buffer = true})
        --   end
        -- })

        -- local toggle_dash_checkbox = function()
        --   -- if vim.re.match(vim.fn.getline("."), '[-]')
        --   --   vim.cmd("substitute/\\v[-]/[ ]/")
        --   -- else
        --   --   vim.cmd("substitute/\\v[.]/[-]/")
        --   -- endif
        --   vim.cmd("normal! ``<CR>")
        -- end

        -- local wiki_journal = function()
        --   -- " yank current line into the 'j' register
        --   -- execute "normal! \"jyy"

        --   -- " jump to the 't' mark, go up two lines, paste 'j' register
        --   -- execute "normal! `tkk\"jp"

        --   -- " replace everything up to the first occurrence of single char in square
        --   -- " brackets (checklist state) with top-level asterisk bullet
        --   -- silent! substitute/\v.*\[.\] /* /

        --   -- " append timestamp to current line
        --   -- call WikiTimestamp()

        --   -- " clear search highlight
        --   -- call feedkeys(":nohlsearch\<CR>")
        -- end

        -- local wiki_timestamp = function()
        --   -- " set 't' register to current time (in square brackets)
        --   -- let @t = system("date +'[\%H:\%M]'")

        --   -- " remove trailing newline from 't' register
        --   -- call setreg('t', substitute(@t, "\n$", "", ""), 'v')

        --   -- " remove timestamp from end of line if present
        --   -- silent! substitute/\v *\[..:..\]$//

        --   -- " append 't' register to end of current line
        --   -- execute "normal! A " . @t
        -- end

        -- local open_yesterday_wiki_split = function()
        --   -- vsplit
        --   -- execute "normal \<c-w>h"
        --   -- execute "normal \<Plug>VimwikiDiaryPrevDay"
        -- end

        -- vim.keymap.set("n", "<leader>wc", ":Calendar<CR>")
        -- vim.keymap.set("n", "<leader>w<space>w", "<Plug>VimwikiMakeDiaryNote")
        -- vim.keymap.set("n", "<leader>w<space>i", "<Plug>VimwikiMakeDiaryNote")
        -- vim.keymap.set("n", "<leader>wy", "<Plug>VimwikiDiaryPrevDay")
        -- vim.keymap.set("n", "<leader>wY", "<Plug>VimwikiDiaryNextDay")
        -- vim.keymap.set("n", "<leader>w-", toggle_dash_checkbox)
      end
    },

    -- When yanking text, makes yanked region blink
    {
      "machakann/vim-highlightedyank",
      init = function()
        vim.g.highlightedyank_highlight_duration = 300
      end
    },

    -- Displays calendar in left pane, integrates with vimwiki diary
    "mattn/calendar-vim",

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

    -- JSX syntax highlighting and indenting
    {
      "MaxMEllon/vim-jsx-pretty",
      init = function()
        vim.g.jsx_ext_required = 0
      end
    },

    -- Navigate node/js `require` statements with `gf` (rarely used)
    "moll/vim-node",

    -- Color scheme (used with vimwiki)
    "morhetz/gruvbox",

    -- Mustache template syntax highlighting, motions (rarely used)
    "mustache/vim-mustache-handlebars",

    -- Text object for Ruby blocks (ar, ir) (rarely used)
    {
      "nelstrom/vim-textobj-rubyblock",
      dependencies = { "kana/vim-textobj-user" }
    },

    -- LSP and auto-completion tool
    {
      "neoclide/coc.nvim",
      branch = "release",
      init = function()
        vim.cmd("source " .. vim.env.HOME .. "/.config/nvim/coc-settings.vim")
      end
    },

    -- JavaScript syntax highlighting and indenting
    "pangloss/vim-javascript",

    -- Markdown syntax highlighting
    {
      "preservim/vim-markdown",
      branch = "master",
      init = function()
        vim.g.vim_markdown_folding_disabled = 1
        vim.g.vim_markdown_conceal = 0
        vim.g.indentLine_fileTypeExclude = { "markdown" }

        vim.keymap.set("v", "*", "S*", { noremap = true })
        vim.keymap.set("v", "_", "S_", { noremap = true })

        -- -- disable vim-markdown open-url feature in favor of open-browser plugin
        vim.keymap.set("", "<Plug>", "<Plug>Markdown_OpenUrlUnderCursor")
      end
    },

    -- Prerequisite for certain async plugins
    "prabirshrestha/async.vim",

    -- Rust syntax highlighting
    {
      "rust-lang/rust.vim",
      init = function()
        vim.g.rustfmt_autosave = 1
        vim.g.rust_clip_command = "pbcopy"
      end
    },

    -- Open project tree view buffer on left
    {
      "scrooloose/nerdtree", --, { 'on':  'NERDTreeToggle' }
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

    -- Repeat 'v' key to grow visual selection, 'V' (shift-V) to shrink
    {
      "terryma/vim-expand-region",
      init = function()
        vim.keymap.set("v", "v", "<Plug>(expand_region_expand)", { noremap = true })
        vim.keymap.set("v", "V", "<Plug>(expand_region_shrink)", { noremap = true })
      end
    },

    -- tmux.conf syntax highlighting
    "tmux-plugins/vim-tmux",

    -- Color scheme (primary)
    "tomasr/molokai",

    -- Prerequisite for something...
    "tomtom/tlib_vim",

    -- Filetype-aware comment toggling (gcc)
    "tpope/vim-commentary",

    -- Git interface within vim
    {
      "tpope/vim-fugitive",
      init = function()
        vim.keymap.set("n", "<Leader>gb", ":Git blame<CR>")
        vim.keymap.set("n", "<Leader>gc", ":Git commit<CR>")
        vim.keymap.set("n", "<Leader>gd", ":Gdiff<CR>")
        vim.keymap.set("n", "<Leader>gp", ":Ggrep<Space>")
        vim.keymap.set("n", "<Leader>gs", ":Git<CR>")
      end
    },

    -- Allows repeating plugin commands with .
    "tpope/vim-repeat",

    -- Mappings to add/remove parens, brackets, etc around text objects
    "tpope/vim-surround",

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

    -- Shortcuts for common Ex commands
    -- (e.g. ]q == :cnext, [q == :cprevious, ]a == :next, [b == :bprevious
    "tpope/vim-unimpaired",

    -- Open file in browser (dependency of plantuml-previewer.vim)
    {
      "tyru/open-browser.vim",
      init = function()
        vim.keymap.set("n", "gx", "<Plug>(openbrowser-smart-search)")
        vim.keymap.set("v", "gx", "<Plug>(openbrowser-smart-search)")

        vim.g.netrw_nogx = 1 -- disable netrw's gx mapping in favor of open-browser.vim
      end

    },

    -- Ruby syntax highlighting and formatting
    "vim-ruby/vim-ruby",

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
      end
      -- au FileType plantuml let g:plantuml_previewer#plantuml_jar_path =
      --       \ trim(system('plantuml --jarpath'))
    },

    -- Show git status flags in NERDTree
    {
      "Xuyuanp/nerdtree-git-plugin",
      dependencies = { "scrooloose/nerdtree" }
    },

    -- Shows vertical lines at indent levels
    "Yggdroot/indentLine",

    -- Extend % to jump to matching html tags
    -- runtime macros/matchit.vim

    -- netrw options
    -- vim.g.netrw_altv=1    " open files on right


  },

  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "molokai" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
})
