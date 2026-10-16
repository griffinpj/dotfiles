sbar = require("sketchybar")

-- Hide the macOS volume OSD; the volume slider replaces it
os.execute("launchctl unload -F /System/Library/LaunchAgents/com.apple.OSDUIHelper.plist >/dev/null 2>&1 &")

sbar.begin_config()
require("bar")
require("default")
require("items")
sbar.end_config()

sbar.hotload(true)
sbar.event_loop()
