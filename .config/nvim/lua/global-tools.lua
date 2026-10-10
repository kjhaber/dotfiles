-- Pin Neovim to the mise tools selected outside a project.
--
-- Mise shims choose a version from the working directory on every exec.
-- Started inside a repo, Neovim would otherwise run coc and other tools
-- with that repo's node, python, go, and java. Resolve tools from $HOME
-- (global config, plus ~/.config/mise/config.local.toml) and put those
-- install directories ahead of the shims.
local M = {}

local function mise_bin()
  local configured = vim.env.MISE_INSTALL_PATH
  if configured and vim.fn.executable(configured) == 1 then
    return configured
  end
  local fallback = vim.env.HOME .. "/.local/bin/mise"
  if vim.fn.executable(fallback) == 1 then
    return fallback
  end
end

local function prepend_install_bins(path, install_dirs)
  local seen = {}
  local parts = {}
  local function add(dir)
    if dir ~= "" and not seen[dir] then
      seen[dir] = true
      table.insert(parts, dir)
    end
  end
  for _, dir in ipairs(install_dirs) do
    add(dir)
  end
  for dir in string.gmatch(path or "", "[^:]+") do
    add(dir)
  end
  return table.concat(parts, ":")
end

function M.pin_mise()
  local mise = mise_bin()
  if not mise or not vim.system then
    return
  end

  local result = vim.system(
    { mise, "-C", vim.env.HOME, "env", "-J" },
    { text = true, timeout = 5000 }
  ):wait()
  if result.code ~= 0 or not result.stdout or result.stdout == "" then
    return
  end

  local ok, env = pcall(vim.json.decode, result.stdout)
  if not ok or type(env) ~= "table" then
    return
  end

  local install_dirs = {}
  if type(env.PATH) == "string" then
    for dir in string.gmatch(env.PATH, "[^:]+") do
      if dir:find("/mise/installs/", 1, true) then
        table.insert(install_dirs, dir)
      end
    end
  end
  if #install_dirs > 0 then
    vim.env.PATH = prepend_install_bins(vim.env.PATH, install_dirs)
  end

  for _, key in ipairs({ "GOROOT", "GOBIN", "JAVA_HOME" }) do
    if type(env[key]) == "string" and env[key] ~= "" then
      vim.env[key] = env[key]
    end
  end

  for _, dir in ipairs(install_dirs) do
    if dir:find("/installs/node/", 1, true) then
      local node = dir .. "/node"
      if vim.fn.executable(node) == 1 then
        -- coc looks up `node` itself. An absolute path skips the shim.
        vim.g.coc_node_path = node
      end
      break
    end
  end
end

return M
