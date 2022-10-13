--- === Headphones ===
--- Utilities for managing bluetooth headphones.  Disconnects bluetooth headphones
--- when entering sleep, and provides a global hotkey to toggle connect/disconnect.
---
--- Based on https://manojkarthick.com/posts/2022/01/disconnect-bluetooth-lid-close/
---
--- Requirements:
--- * blueutil (https://github.com/toy/blueutil, `brew install blueutil`)
--- * HEADPHONES_MAC env var is set in $DOTFILE_LOCAL_HOME/headphonesrc to MAC
---   address of headphones (obtain with `blueutil --paired`)
--- * $DOTFILE_HOME/bin/headphones script (test with `headphones toggle` in shell)

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "headphones"
obj.version = "0.1"
obj.author = "Keith Haber <kjhaber@gmail.com>"
obj.license = "MIT"
obj.homepage = "https://github.com/kjhaber/dotfiles"

-- wrapper function for shell commands
local function shell(command)
    hs.execute(command .. ' &', true)
end

-- add bluetooth caffeine integration
local headphonesCmd = os.getenv("HOME") .. "/.config/dotfiles/bin/headphones"
local function disconnectHeadphonesOnSleep(eventType)
    if eventType == hs.caffeinate.watcher.systemWillSleep then
        shell(headphonesCmd .. " disconnect")
    end
end
local headphonesWatcher = hs.caffeinate.watcher.new(disconnectHeadphonesOnSleep)

-- expose Spoon api
function obj:start()
  headphonesWatcher:start()
end

function obj:stop()
  headphonesWatcher:stop()
end

function obj:toggleHeadphoneConnect()
  hs.alert.show(headphonesCmd .. " toggle")
  shell(headphonesCmd .. " toggle")
end

function obj:bindHotKeys(mapping)
  if mapping and mapping["toggle"] then
    hs.hotkey.bind(mapping["toggle"][1], mapping["toggle"][2], function()
      self:toggleHeadphoneConnect()
    end)
  end
end

return obj

