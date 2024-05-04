## Vim Leader Mappings

```
space -- reset default states (paste mode, search highlight, etc) and refresh terminal/tmux

a - Align (Tabularize)
  a| -- align using bar character
  a: -- align using colon character
  a= -- align using equal character
b
  bb -- toggle bullet character between * and -
  bi -- indent and toggle bullet
  bI -- indent and toggle bullet, enter insert mode
  bo -- outdent and toggle bullet
  bO -- outdent and toggle bullet, enter insert mode
  b- -- change bullet character to -
  b* -- change bullet character to * 
  b> -- change bullet character to >
  b+ -- change bullet character to +
  b. -- change bullet character to ..
c - list hidden Characters
  ca -- coc-Calc Append
  cc -- list hidden Characters
  cr -- coc-Calc Replace
d
  dn -- Date Normalize: change date under cursor to YYYY-MM-DD format
  dt -- Insert today's date in YYYY-MM-DD format, leave in insert mode
e
  eb -- error back (previous)
  ef -- error forward (next)
  el -- error list
f - autoFormat
  ff -- format (uses format external prog if available)
g - fuGitive
  gb -- git blame
  gc -- git commit
  gd -- git diff
  gp -- git grep
  gs -- git status
h
  hb -- gitgutter Hunk Back (previous)
  hf -- gitgutter Hunk Forward (next)
  hr -- gitgutter Hunk Revert
  hs -- gitgutter Hunk Stage
i
j
  ja -- Jump to Alternate File (test file/source file)
  jd -- LSP Jump to Definition
  ji -- LSP Jump to Implementation
  jr -- LSP Jump to References (find references)
  jt -- LSP Jump to Type Definition
k
l
  lf  -- LSP Format (range format when in visual mode)
  ll  -- LSP Hover
  lo  -- LSP Organize Imports
  lr  -- LSP Rename
  lsd -- LSP Symbols: Document
  lwd -- LSP Symbols: Workspace
  lx  -- LSP Fix
  l?  -- LSP Status
  l<space> -- LSP Code Action (Quick Fix)
m
n
  nn -- toggle line numbers
  nr -- toggle between relative and absolute line numbers
o
p - Paste without clobbering system clipboard
q
r
s
  ss  strip trailing whitespace
  sq  strip smart quotes
t
  tt -- NERDTree toggle
u
  ura -- UML reverse arrow
  ure -- UML reverse entity
  urr -- UML reverse both entity + arrow
v 
w
  ww         -- vimwiki main
  w<leader>w -- vimwiki diary today
  wi         -- vimwiki diary index
  w<leader>i -- vimwiki diary index generate links
  wc         -- open calendar (enter on date opens diary)
  wf         -- set filetype=vimwiki (vimwiki filetype sometimes changes to 'conf' when splitting window)
  wj         -- copy diary todo item to journal
  wm         -- append or update HH:MM timestamp to current line ('wiki Minute')
  wn         -- open vimwiki quickNote page
  w<leader>n -- write vimwiki quickNote page at current location
  wt         -- open vimwiki to-do page
  w<leader>t -- write vimwiki to-do page at current location
  wy         -- vimwiki diary yesterday
  wY         -- vimwiki diary tomorrow
  w-         -- toggle checkbox with dash instead of X (to mark as N/A)
  w<         -- open yesterday's wiki journal in new vsplit
x
y 
z - Zoom (ZoomWinTab)
/ - search (fzf + ripgrep) (same as <leader>[t )
  // -- search text (all files under vim pwd - on enter, uses loclist)
  /b -- search buffers
  /f -- search files
  /h -- search history
  /l -- search lines (current file)
  /t -- search text (all files under vim pwd - live fuzzy match)

-  -- open horizontal split (:split)
|  -- open vertical split (:vsplit)

. - open file explorer
  ..  -- open file explorer (:Explore)
  .-  -- open file explorer in horizontal split (:Sexplore)
  .|  -- open file explorer in vertical split (:Vexplore)

~  -- open file explorer in home directory (only if file explorer already open)

\ - toggle paste mode
` - insert markdown code block
  `<space> -- insert markdown code block, set into insert mode (normal or visual mode)
  `p -- insert current clipboard content inside markdown code block
; -- Startify

```

