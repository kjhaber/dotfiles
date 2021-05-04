## Vim Leader Mappings

```
a - Align (Tabularize) or ALE
  a| -- align using bar character
  a: -- align using colon character
  a= -- align using equal character

  aa -- toggle ALE lint
  af -- ALE fix
  an -- ALE next error
  ap -- ALE previous error
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
d
  dd -- Delete line (cut to system clipboard)
  dt -- Insert today's date in YYYY-MM-DD format, leave in insert mode
e
f - autoFormat
  ff -- format (uses format external prog if available)
  fi -- indent
g - fuGitive
  gs -- git status
  gc -- git commit
h - Highlight toggle
  hb -- gitgutter Hunk Back (previous)
  hf -- gitgutter Hunk Forward (next)
  hh -- highlight toggle (faster)
  hr -- gitgutter Hunk Revert
  hs -- gitgutter Hunk Stage
i
j
  jd -- LSP Jump to Definition
  ji -- LSP Jump to Implementation
  jr -- LSP Jump to References (find references)
  jt -- LSP Jump to Type Definition
k - redraw buffer/terminal
l
  lf  -- LSP Format (range format when in visual mode)
  ll  -- LSP Hover
  lr  -- LSP Rename
  loi -- LSP Organize Imports
  lsd -- LSP Symbols: Document
  lwd -- LSP Symbols: Workspace
  l?  -- LSP Status
  lx  -- LSP Fix
  l<space> -- LSP Code Action (Quick Fix)
m
  mm  -- bookmark toggle
  ma  -- bookmark annotated
  mf  -- bookmark next (forward)
  mb  -- bookmark prev (back)
  ml  -- bookmark list
  mx  -- bookmark clear (current file)
  mX  -- bookmark clear (all files)

n
  nn -- toggle line numbers
  nr -- toggle between relative and absolute line numbers
o - Open (CtrlP search)
p - Paste from system clipboard
q
r
s
  ss  strip trailing whitespace
  sq  strip smart quotes
t
  tt -- NERDTree
u
  uas -- UML arrow swap
v - vimux
  vv -- prompt command
  vr -- repeat last command
  vi -- inspect runner pane
  vz -- zoom runner pane
  vq -- quit runner pane
w
  ww         -- vimwiki main
  w<leader>w -- vimwiki diary today
  w<leader>y -- vimwiki diary yesterday
  wi         -- vimwiki diary index
  w<leader>i -- vimwiki diary index generate links
  wc         -- open calendar (enter on date opens diary)
  wf         -- set filetype=vimwiki (vimwiki filetype sometimes changes to 'conf' when splitting window)
  wt         -- open vimwiki diary to-do page
  w<leader>t -- write vimwiki diary to-do page
x
y - Yank to system clipboard
z - Zoom (ZoomWinTab)
/ - search (fzf + ripgrep) (same as <leader>[t )
  // -- search text (all files under vim pwd - on enter, uses loclist)
  /b -- search buffers
  /f -- search files
  /h -- search history
  /l -- search lines (current file)
  /t -- search text (all files under vim pwd - live fuzzy match)
space - visual select current line (why?)
. - open file explorer (:Explore)
- - open file explorer in horizontal split (:Sexplore)
| - open file explorer in vertical split (:Vexplore)
{
}
[
]
= - indent entire file
\ - toggle paste mode
` - insert markdown code block
  `<space> -- insert markdown code block, set into insert mode (normal or visual mode)
  `p -- insert current clipboard content inside markdown code block
; -- Startify
```

