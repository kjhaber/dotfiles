return {
  -- Edit all lines in quickfix list (run `:EnMasse`)
  "Olical/vim-enmasse",

  -- Format delimited text as table (rarely used)
  {
    "godlygeek/tabular",
    init = function()
      vim.keymap.set("v", "<Leader>>,", ":Tabularize /,<CR>")
      vim.keymap.set("v", "<Leader>><Bar>", ":Tabularize /<Bar><CR>")
    end
  },

  -- Snippet contents - used by coc.nvim
  "honza/vim-snippets",

  -- Smart inserts closing parentheses
  "itmammoth/doorboy.vim",

  -- Shortcuts for bullet lists
  "kjhaber/vim-bullet-shortcuts",

  -- Shortcuts for plantuml files
  "kjhaber/vim-plantuml-shortcuts",

  -- Repeat 'v' key to grow visual selection, 'V' (shift-V) to shrink
  {
    "terryma/vim-expand-region",
    init = function()
      vim.keymap.set("v", "v", "<Plug>(expand_region_expand)", { noremap = true })
      vim.keymap.set("v", "V", "<Plug>(expand_region_shrink)", { noremap = true })
    end
  },

  -- Filetype-aware comment toggling (gcc)
  "tpope/vim-commentary",

  -- Allows repeating plugin commands with .
  "tpope/vim-repeat",

  -- Mappings to add/remove parens, brackets, etc around text objects
  "tpope/vim-surround",

  -- Shortcuts for common Ex commands
  -- (e.g. ]q == :cnext, [q == :cprevious, ]a == :next, [b == :bprevious
  "tpope/vim-unimpaired",
}
