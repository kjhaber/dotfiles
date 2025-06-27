local M = {

  -- Display git changes of lines in left gutter
  {
    "airblade/vim-gitgutter",
    -- Don't load GitGutter in VS Code since it has built-in git gutter
    cond = not vim.g.vscode,
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

  -- Git interface within vim
  {
    "tpope/vim-fugitive",
    -- Don't load Fugitive in VS Code since it has built-in git integration
    cond = not vim.g.vscode,
    init = function()
      vim.keymap.set("n", "<Leader>gb", ":Git blame<CR>")
      vim.keymap.set("n", "<Leader>gc", ":Git commit<CR>")
      vim.keymap.set("n", "<Leader>gd", ":Gdiff<CR>")
      vim.keymap.set("n", "<Leader>gp", ":Ggrep<Space>")
      vim.keymap.set("n", "<Leader>gs", ":Git<CR>") -- "Git Status"
    end
  },

  -- Shortcut to display urls of current/selected lines in Git repo website
  {
    "kjhaber/vim-codeurl",
    lazy = true,
    cmd = {
      "CodeUrl",
    },
    -- Don't load in VS Code, we'll use VS Code commands instead
    cond = not vim.g.vscode,
    init = function()
      vim.keymap.set("n", "<leader>cu", ":CodeUrl<CR>", { noremap = true })
      vim.keymap.set("v", "<leader>cu", ":'<,'>CodeUrl<CR>", { noremap = true })
    end
  },

  -- Show git status flags in NERDTree
  {
    "Xuyuanp/nerdtree-git-plugin",
    dependencies = { "scrooloose/nerdtree" },
    -- Don't load in VS Code since it has built-in explorer with git status
    cond = not vim.g.vscode
  },
}

-- VS Code-specific Git mappings (outside of plugin specs)
if vim.g.vscode then
  -- Helper function to call VS Code commands
  local function vscode_call(command)
    return function()
      vim.fn.VSCodeNotify(command)
    end
  end

  -- Git Gutter equivalents (hunk operations)
  vim.keymap.set("n", "<leader>hr", vscode_call("git.revertSelectedRanges"), { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>hs", vscode_call("git.stageSelectedRanges"), { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>hb", vscode_call("workbench.action.editor.previousChange"), { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>hf", vscode_call("workbench.action.editor.nextChange"), { noremap = true, silent = true })

  -- Git Fugitive equivalents
  vim.keymap.set("n", "<Leader>gb", vscode_call("gitlens.toggleFileBlame"), { noremap = true, silent = true })
  vim.keymap.set("n", "<Leader>gc", vscode_call("git.commit"), { noremap = true, silent = true })
  vim.keymap.set("n", "<Leader>gd", vscode_call("git.openChange"), { noremap = true, silent = true })
  vim.keymap.set("n", "<Leader>gp", vscode_call("workbench.action.findInFiles"), { noremap = true, silent = true })
  vim.keymap.set("n", "<Leader>gs", vscode_call("workbench.view.scm"), { noremap = true, silent = true })

  -- CodeUrl equivalent
  vim.keymap.set("n", "<leader>cu", vscode_call("gitlens.copyRemoteFileUrlToClipboard"), { noremap = true, silent = true })
  vim.keymap.set("v", "<leader>cu", vscode_call("gitlens.copyRemoteFileUrlFromUrl"), { noremap = true, silent = true })

  -- Additional useful Git mappings for VS Code
  vim.keymap.set("n", "<leader>ga", vscode_call("git.stage"), { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>gu", vscode_call("git.unstage"), { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>gl", vscode_call("git.viewHistory"), { noremap = true, silent = true })

  -- Git diff in sidebar
  vim.keymap.set("n", "<leader>gD", vscode_call("workbench.scm.action.scmSourceControl"), { noremap = true, silent = true })
end

return M
