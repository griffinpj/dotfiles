local colors = require("colors")

-- The C helper (helper/) samples CPU and pushes to cpu.sys / cpu.user / cpu.top / cpu.percent.
-- It reads its label colors from the environment.
local HELPER = "git.felix.helper"
os.execute(string.format(
  "killall helper >/dev/null 2>&1; cd '%s/helper' && make -s >/dev/null"
    .. " && (RED=0x%x ORANGE=0x%x YELLOW=0x%x LABEL_COLOR=0x%x ./helper %s >/dev/null 2>&1 &)",
  os.getenv("CONFIG_DIR"), colors.red, colors.orange, colors.yellow, colors.white, HELPER
))

sbar.add("item", "cpu.top", {
  position = "right",
  width = 0,
  padding_right = 15,
  y_offset = 6,
  icon = { drawing = false },
  label = { string = "CPU", font = "SF Pro:Semibold:7.0" },
})

local cpu_percent = sbar.add("item", "cpu.percent", {
  position = "right",
  width = 55,
  padding_right = 15,
  y_offset = -4,
  update_freq = 4,
  icon = { drawing = false },
  label = { string = "CPU", font = "SF Pro:Heavy:12.0" },
})

-- sketchybar resolves the helper's mach port when this is set, so wait for the new helper to register
sbar.delay(1, function()
  cpu_percent:set({ mach_helper = HELPER })
end)

sbar.add("graph", "cpu.sys", 75, {
  position = "right",
  width = 0,
  graph = { color = colors.red, fill_color = colors.red },
  icon = { drawing = false },
  label = { drawing = false },
  background = { height = 30, drawing = true, color = colors.transparent },
})

sbar.add("graph", "cpu.user", 75, {
  position = "right",
  graph = { color = colors.blue },
  icon = { drawing = false },
  label = { drawing = false },
  background = { height = 30, drawing = true, color = colors.transparent },
})
