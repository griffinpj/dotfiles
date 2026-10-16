local colors = require("colors")

sbar.bar({
  height = 45,
  color = colors.transparent,
  shadow = false,
  position = "top",
  sticky = true,
  padding_left = 10,
  padding_right = 10,
  y_offset = -5,
  margin = -2,
  topmost = "window",
})
