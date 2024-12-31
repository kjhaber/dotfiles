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
    {import = "plugins.appearance"},
    {import = "plugins.filetypes"},
    {import = "plugins.git"},
    {import = "plugins.lsp"},
    {import = "plugins.navigation"},
    {import = "plugins.shortcuts"},
    {import = "plugins.textobjects"},
    {import = "plugins.vimwiki"},
  },

  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "molokai" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
})
