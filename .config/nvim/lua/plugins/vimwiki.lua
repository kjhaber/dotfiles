return {
  -- Displays calendar in left pane, integrates with vimwiki diary
  "mattn/calendar-vim",

  -- Personal wiki/diary
  {
    "vimwiki/vimwiki",
    init = function()
      vim.cmd("source " .. vim.env.HOME .. "/.config/nvim/vimwiki-settings.vim")
      -- vim.g.vimwiki_list = {{path = vim.env.VIMWIKI_DIR, syntax = "markdown", ext = ".md"}}
      -- vim.g.vimwiki_global_ext = 0
      -- vim.g.vimwiki_url_maxsave = 0
      -- vim.g.vimwiki_use_mouse = 1
      -- vim.g.vimwiki_auto_chdir = 1
      -- vim.g.vimwiki_hl_cb_checked = 2
      -- vim.g.vimwiki_conceallevel = 0
      -- vim.g.vimwiki_listsyms = " .x"

      -- vim.api.nvim_create_autocmd("FileType", {
      --   pattern = "vimwiki",
      --   callback = function()
      --     vim.g.indentLine_enabled = 0
      --     vim.keymap.set("n", "<leader>wc", ":Calendar<CR>", {buffer = true})

      --     -- Sometimes I use my LSP 'jump to definition' shortcut to follow urls out of
      --     -- habit - map same shortcut for urls in vimwiki
      --     vim.keymap.set("n", "<leader>jd", "gx", {buffer = true})
      --   end
      -- })

      -- local toggle_dash_checkbox = function()
      --   -- if vim.re.match(vim.fn.getline("."), '[-]')
      --   --   vim.cmd("substitute/\\v[-]/[ ]/")
      --   -- else
      --   --   vim.cmd("substitute/\\v[.]/[-]/")
      --   -- endif
      --   vim.cmd("normal! ``<CR>")
      -- end

      -- local wiki_journal = function()
      --   -- " yank current line into the 'j' register
      --   -- execute "normal! \"jyy"

      --   -- " jump to the 't' mark, go up two lines, paste 'j' register
      --   -- execute "normal! `tkk\"jp"

      --   -- " replace everything up to the first occurrence of single char in square
      --   -- " brackets (checklist state) with top-level asterisk bullet
      --   -- silent! substitute/\v.*\[.\] /* /

      --   -- " append timestamp to current line
      --   -- call WikiTimestamp()

      --   -- " clear search highlight
      --   -- call feedkeys(":nohlsearch\<CR>")
      -- end

      -- local wiki_timestamp = function()
      --   -- " set 't' register to current time (in square brackets)
      --   -- let @t = system("date +'[\%H:\%M]'")

      --   -- " remove trailing newline from 't' register
      --   -- call setreg('t', substitute(@t, "\n$", "", ""), 'v')

      --   -- " remove timestamp from end of line if present
      --   -- silent! substitute/\v *\[..:..\]$//

      --   -- " append 't' register to end of current line
      --   -- execute "normal! A " . @t
      -- end

      -- local open_yesterday_wiki_split = function()
      --   -- vsplit
      --   -- execute "normal \<c-w>h"
      --   -- execute "normal \<Plug>VimwikiDiaryPrevDay"
      -- end

      -- vim.keymap.set("n", "<leader>wc", ":Calendar<CR>")
      -- vim.keymap.set("n", "<leader>w<space>w", "<Plug>VimwikiMakeDiaryNote")
      -- vim.keymap.set("n", "<leader>w<space>i", "<Plug>VimwikiMakeDiaryNote")
      -- vim.keymap.set("n", "<leader>wy", "<Plug>VimwikiDiaryPrevDay")
      -- vim.keymap.set("n", "<leader>wY", "<Plug>VimwikiDiaryNextDay")
      -- vim.keymap.set("n", "<leader>w-", toggle_dash_checkbox)
    end
  },
}
