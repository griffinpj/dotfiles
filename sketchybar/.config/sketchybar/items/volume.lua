local colors = require("colors")
local icons = require("icons")

local SLIDER_WIDTH = 100

local volume = sbar.add("slider", "volume", 0, {
  position = "right",
  updates = true,
  label = { drawing = false },
  icon = { drawing = false },
  slider = {
    highlight_color = colors.blue,
    knob = { string = icons.knob, drawing = true },
    background = { height = 5, corner_radius = 3, color = colors.bg2 },
  },
})

local volume_icon = sbar.add("item", "volume_icon", {
  position = "right",
  padding_left = 10,
  icon = { string = icons.volume._100, color = colors.grey, font = "SF Pro:Regular:14.0", width = 25, align = "left" },
  label = { drawing = false },
})

local open = false
local function show(state)
  open = state
  sbar.animate("tanh", 30, function()
    volume:set({ slider = { width = state and SLIDER_WIDTH or 0 } })
  end)
end

-- Bumped on every change so only the latest change collapses the slider
local generation = 0

volume:subscribe("volume_change", function(env)
  local v = tonumber(env.INFO) or 0
  local icon = v >= 60 and icons.volume._100
    or v >= 30 and icons.volume._66
    or v >= 10 and icons.volume._33
    or v > 0 and icons.volume._10
    or icons.volume._0

  volume_icon:set({ icon = icon })
  volume:set({ slider = { percentage = v } })

  generation = generation + 1
  local mine = generation
  if not open then show(true) end
  sbar.delay(2, function()
    if mine == generation then show(false) end
  end)
end)

volume:subscribe("mouse.clicked", function(env)
  sbar.exec("osascript -e 'set volume output volume " .. env.PERCENTAGE .. "'")
end)

volume_icon:subscribe("mouse.clicked", function()
  show(not open)
end)
