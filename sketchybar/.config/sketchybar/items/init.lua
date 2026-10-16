-- Left
require("items.spaces")
require("items.front_app")

-- Right (first added sits furthest right)
require("items.calendar")
require("items.battery")
require("items.volume")
require("items.vpn")
require("items.github")
require("items.memory")
require("items.cpu")
require("items.weather")

local colors = require("colors")
sbar.add("bracket", "status", { "battery", "volume", "volume_icon", "vpn" }, {
  background = { color = colors.bg1, border_color = colors.bg2 },
})
