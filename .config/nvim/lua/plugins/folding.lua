return {
  -- Treesitter parsers, used by nvim-ufo below to compute accurate folds
  -- (e.g. per JSON object/array) instead of falling back to indent-based folds.
  -- Only installs parsers here (no highlight/indent modules enabled), so this
  -- doesn't interfere with the existing regex-based syntax plugins.
  -- (Install treesitter CLI: `brew install tree-sitter-cli`)
  {
    "nvim-treesitter/nvim-treesitter",
    cond = not vim.g.vscode,
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "go",
        "java",
        "javascript",
        "json",
        "markdown",
        "markdown_inline",
        "python",
        "ruby",
        "typescript",
      })
    end
  },

  {
    "kevinhwang91/nvim-ufo",
    cond = not vim.g.vscode,
    dependencies = { "kevinhwang91/promise-async" },
    init = function()
      vim.o.foldcolumn = "auto"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.opt.fillchars:append({
        foldopen = "▾",
        foldclose = "▸",
        foldsep = " ",
        foldinner = " ",
      })
    end,
    config = function()
      local ufo = require("ufo")
      ufo.setup({
        provider_selector = function(bufnr, filetype, buftype)
          if buftype ~= "" then
            return ""
          end
          return { "treesitter", "indent" }
        end,
      })

      vim.keymap.set("n", "zR", ufo.openAllFolds)
      vim.keymap.set("n", "zM", ufo.closeAllFolds)
      vim.keymap.set("n", "zK", ufo.peekFoldedLinesUnderCursor)

      -- Toggle the fold column's visibility (folds themselves are unaffected)
      vim.keymap.set("n", "<leader>zf", function()
        vim.wo.foldcolumn = (vim.wo.foldcolumn == "0") and "auto" or "0"
      end)
    end
  },
}
