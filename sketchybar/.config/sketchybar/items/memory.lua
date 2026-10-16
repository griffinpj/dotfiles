local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local memory = sbar.add("item", "memory", {
  position = "right",
  update_freq = 15,
  icon = { string = icons.memory, font = settings.nerd_font .. ":Regular:16.0" },
  label = { font = "SF Pro:Heavy:12.0" },
  click_script = "open -a 'Activity Monitor'",
})

memory:subscribe({ "forced", "routine", "system_woke" }, function()
  sbar.exec("memory_pressure -Q", function(out)
    local free = tonumber(out:match("(%d+)%%"))
    if not free then return end
    local used = 100 - free
    local color = used >= 85 and colors.red or used >= 70 and colors.yellow or colors.white
    memory:set({ label = { string = used .. "%", color = color } })
  end)
end)
