local colors = require("colors")
local icons = require("icons")

local battery = sbar.add("item", "battery", {
  position = "right",
  padding_left = 0,
  padding_right = 3,
  update_freq = 120,
  updates = true,
  icon = { font = "SF Pro:Regular:15.0" },
  label = { drawing = false },
})

battery:subscribe({ "forced", "routine", "power_source_change", "system_woke" }, function()
  sbar.exec("pmset -g batt", function(out)
    local pct = tonumber(out:match("(%d+)%%"))
    if not pct then return end

    local icon, color
    if out:find("AC Power") then
      icon, color = icons.battery.charging, colors.yellow
    elseif pct >= 80 then
      icon, color = icons.battery._100, colors.battery[1]
    elseif pct >= 70 then
      icon, color = icons.battery._75, colors.battery[2]
    elseif pct >= 40 then
      icon, color = icons.battery._50, colors.battery[3]
    elseif pct >= 10 then
      icon, color = icons.battery._25, colors.battery[4]
    else
      icon, color = icons.battery._0, colors.battery[5]
    end

    battery:set({ icon = { string = icon, color = color } })
  end)
end)
