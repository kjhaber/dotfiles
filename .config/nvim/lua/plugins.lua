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
-- Include hook for local-specific plugins in CONFIG_LOCAL_DIR/nvim/lua/plugins/local.lua
-- (CONFIG_LOCAL_DIR/nvim/lua must be on LUA_PATH)
local pluginSpecs = {
  {import = "plugins.appearance"},
  {import = "plugins.filetypes"},
  {import = "plugins.git"},
  {import = "plugins.llm"},
  {import = "plugins.lsp"},
  {import = "plugins.navigation"},
  {import = "plugins.shortcuts"},
  {import = "plugins.textobjects"},
  {import = "plugins.vimwiki"},
}
local localLuaModulePath = vim.env.CONFIG_LOCAL_DIR .. "/nvim/lua"
local localPluginConfig = localLuaModulePath .. "/plugins/local.lua"
if vim.fn.filereadable(localPluginConfig) ~= 0 then
  table.insert(pluginSpecs, require("plugins.local"))
end

require("lazy").setup({
  spec = pluginSpecs,

  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "molokai" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
  change_detection = { enabled = false },
  ui = {
    icons = {
      cmd = "> ",
      config = "> ",
      event = "> ",
      favorite = "+ ",
      ft = "> ",
      init = "* ",
      import = "+ ",
      keys = "> ",
      lazy = "~ ",
      loaded = "●",
      not_loaded = "○",
      plugin = "> ",
      runtime = "> ",
      require = "> ",
      source = "> ",
      start = ".. ",
    }
  }
})
