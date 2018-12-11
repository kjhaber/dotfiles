## Vim Leader Mappings

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
  bo -- outdent and toggle bullet
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
  hh -- highlight toggle (fast)
  hs -- gitgutter Hunk Stage
  hr -- gitgutter Hunk Revert
i
j
  jd -- LSP Jump to Definition
  jr -- LSP Jump to References (find references)
k - redraw buffer/terminal
l
  lf  -- LSP Format (range format when in visual mode)
  ll  -- LSP Hover
  lr  -- LSP Rename
  lsd -- LSP Symbols: Document
  lwd -- LSP Symbols: Workspace
m - :Make
n
  nn -- toggle line numbers
  nr -- toggle between relative and absolute line numbers
o - Open (CtrlP search)
p - Paste from system clipboard
q
r
s
  ss  strip trailing whitespace
t - nerdTree
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
- - horizontal split (:Sexplore)
| - vertical split (:Vexplore)
{
}
[
]
= - indent entire file
