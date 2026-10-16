local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local vpn = sbar.add("item", "vpn", {
  position = "right",
  update_freq = 30,
  icon = { string = icons.vpn_off, font = settings.nerd_font .. ":Regular:16.0", color = colors.grey },
  label = { drawing = false },
  click_script = "open -a GlobalProtect",
})

-- GlobalProtect up == some utun interface holds an IPv4 address
-- (macOS keeps several IPv6-only utuns around for iCloud etc.)
local cmd = [[ifconfig | awk '/^utun/{u=1; next} /^[^ \t]/{u=0} u && /inet /{print "up"; exit}']]

vpn:subscribe({ "forced", "routine", "system_woke", "wifi_change" }, function()
  sbar.exec(cmd, function(out)
    local up = out:find("up") ~= nil
    vpn:set({ icon = { string = up and icons.vpn_on or icons.vpn_off, color = up and colors.green or colors.grey } })
  end)
end)
