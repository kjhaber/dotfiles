return {
  -- Dims inactive windows to make active stand out visually
  "blueyed/vim-diminactive",

  -- When yanking text, makes yanked region blink
  {
    "machakann/vim-highlightedyank",
    init = function()
      vim.g.highlightedyank_highlight_duration = 300
    end
  },

  -- Color scheme (used with vimwiki)
  "morhetz/gruvbox",

  -- Color scheme (primary)
  "tomasr/molokai",

  -- Shows vertical lines at indent levels
  {
    "Yggdroot/indentLine",
    cond = not vim.g.vscode,
  },
}
