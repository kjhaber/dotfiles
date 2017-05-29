# TerminalVim.app

Utility for opening files in iTerm Vim from Finder.

Maybe I should make up a proper github repo for this, but for now this works for me.  This is just my adaptation of TerminalVim.app. https://thepugautomatic.com/2015/02/open-in-iterm-vim-from-finder/ .  For whatever reason I decided I didn't want to use MacVim - maybe it had just enough differences from Terminal Vim and I wanted to keep things consistent.  Or just force myself to learn things "the vim way."

Just extract the zip file into /Applications or wherever (I usually use ~/Applications).

This program is meant to be used as a default application in Finder.  For a given filetype:

* Select a file of type to open (e.g. a .js file) in Finder
* Command-I to 'Get Info' (or right-click menu)
* Under "Open With" section select TerminalVim.app
* Click "Change All.." button and confirm

Double-clicking the application will give an error ("The action 'Run AppleScript' encountered an error").  Maybe someday I'll tweak it to just open an empty file, but for now I live in the terminal enough to not be affected by that use case.

This relies on making a symlink to vim or nvim in ~/Library/dotfiles/bin.

To create this from scratch:

* Open Automator
* Create a new Application
* Select "Run Applescript" action
* Change script to this:

```
on run {input, parameters}
    set filePath to POSIX path of input
    set quotedPath to quote & filePath & quote
    set cmd to "~/Library/dotfiles/bin/vi " & quotedPath

    tell application "iTerm"
        set myWindow to (create window with default profile command cmd)
    end tell
end run
```

* Save as /Applications/TerminalVim.app

I usually do a Get Info, click on the icon, and paste the MacVim icon into the application to make it look a little nicer.

This works for me on macOS Sierra 10.12.4.

