-----------------------------
-- Hammerspoon             --
-- https://hammerspoon.org --
-----------------------------

-- === Headphones ===
-- * disables bluetooth headphones on sleep
-- * sets global hotkey to connect/disconnect
--
-- Requirements:
-- * blueutil (https://github.com/toy/blueutil, `brew install blueutil`)
-- * HEADPHONES_MAC env var is set in $DOTFILE_LOCAL_HOME/headphonesrc to MAC
--   address of headphones (obtain with `blueutil --paired`)
-- * $DOTFILE_HOME/bin/headphones script (test with `headphones toggle` in shell)
hs.loadSpoon("Headphones")
spoon.Headphones:start()
spoon.Headphones:bindHotKeys({toggle={{"cmd", "alt", "ctrl"}, "H"}})

