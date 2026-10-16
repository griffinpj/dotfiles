local colors = require("colors")
local settings = require("settings")

local p = settings.paddings

sbar.default({
  updates = "when_shown",
  padding_left = p,
  padding_right = p,
  scroll_texts = true,
  icon = {
    font = settings.font .. ":Regular:14.0",
    color = colors.white,
    padding_left = p,
    padding_right = p,
  },
  label = {
    font = settings.font .. ":Semibold:13.0",
    color = colors.white,
    padding_left = p,
    padding_right = p,
    shadow = { drawing = true, distance = 2, color = 0xff000000 },
  },
  background = { height = 26, corner_radius = 9, border_width = 2 },
  popup = {
    blur_radius = 20,
    background = {
      border_width = 2,
      corner_radius = 9,
      border_color = colors.white,
      color = colors.bg0,
      shadow = { drawing = true },
    },
  },
})
