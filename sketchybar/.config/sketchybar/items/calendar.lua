local icons = require("icons")

local calendar = sbar.add("item", "calendar", {
  position = "right",
  padding_left = 15,
  update_freq = 15,
  icon = { string = icons.calendar, font = "SF Pro:Black:12.0", padding_right = 0 },
  label = { align = "right" },
})

calendar:subscribe({ "forced", "routine", "system_woke" }, function()
  calendar:set({ label = os.date("%m/%d | %I:%M %p") })
end)

-- Click the clock to toggle zen mode (hide everything but spaces and clock)
local zen_items = {
  "front_app", "space_separator", "/cpu\\..*/", "memory", "github", "weather", "vpn", "volume", "volume_icon", "status",
}
local zen = false

calendar:subscribe("mouse.clicked", function()
  zen = not zen
  for _, name in ipairs(zen_items) do
    sbar.set(name, { drawing = not zen })
  end
  calendar:set({ icon = { drawing = not zen } })
end)
