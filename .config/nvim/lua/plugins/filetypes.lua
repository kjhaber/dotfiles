return {
  -- TypeScript syntax highlighting
  "HerringtonDarkholme/yats.vim",

  -- PlantUML syntax highlighting
  "aklt/plantuml-syntax",

  -- TOML syntax highlighting (rarely used)
  "cespare/vim-toml",

  -- MediaWiki syntax highlighting (rarely used)
  "chikamichi/mediawiki.vim",

  -- JSON syntax highlighting
  {
    "elzr/vim-json",
    init = function()
      vim.g.vim_json_syntax_conceal = 0
    end
  },

  -- Smithy syntax highlighting
  "jasdel/vim-smithy",

  -- JSX syntax highlighting and indenting
  {
    "MaxMEllon/vim-jsx-pretty",
    init = function()
      vim.g.jsx_ext_required = 0
    end
  },

  -- Navigate node/js `require` statements with `gf` (rarely used)
  "moll/vim-node",

  -- Mustache template syntax highlighting, motions (rarely used)
  "mustache/vim-mustache-handlebars",

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

  -- Rust syntax highlighting
  {
    "rust-lang/rust.vim",
    init = function()
      vim.g.rustfmt_autosave = 1
      vim.g.rust_clip_command = "pbcopy"
    end
  },

  -- tmux.conf syntax highlighting
  "tmux-plugins/vim-tmux",

  -- Ruby syntax highlighting and formatting
  "vim-ruby/vim-ruby",
}
