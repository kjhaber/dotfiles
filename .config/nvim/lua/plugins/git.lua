return {

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

  -- Show git status flags in NERDTree
  {
    "Xuyuanp/nerdtree-git-plugin",
    dependencies = { "scrooloose/nerdtree" }
  },
}
