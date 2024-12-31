return {
  -- LSP and auto-completion tool
  {
    "neoclide/coc.nvim",
    branch = "release",
    init = function()
      vim.cmd("source " .. vim.env.HOME .. "/.config/nvim/coc-settings.vim")
    end
  },
}
