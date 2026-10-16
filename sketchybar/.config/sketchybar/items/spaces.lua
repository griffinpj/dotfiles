local colors = require("colors")
local icons = require("icons")
local app_icons = require("helpers.icon_map")
app_icons["Ghostty"] = app_icons["Ghostty"] or ":terminal:" -- not in font v2.0.25

-- Triggered by aerospace.toml on workspace change and on focus change
sbar.add("event", "aerospace_workspace_change")

local spaces = {}

local workspaces = io.popen("aerospace list-workspaces --all")
for ws in workspaces:lines() do
  spaces[ws] = sbar.add("item", "space." .. ws, {
    position = "left",
    drawing = false,
    padding_left = 2,
    padding_right = 2,
    icon = { string = ws, padding_left = 10, padding_right = 10, highlight_color = colors.red },
    label = {
      padding_right = 20,
      color = colors.grey,
      highlight_color = colors.white,
      font = "sketchybar-app-font:Regular:16.0",
      y_offset = -1,
    },
    background = { color = colors.bg1, border_color = colors.bg2 },
    click_script = "aerospace workspace " .. ws,
  })
end
workspaces:close()

local function icon_strip(apps)
  if #apps == 0 then return " —" end
  local strip = " "
  for _, app in ipairs(apps) do
    strip = strip .. " " .. (app_icons[app] or ":default:")
  end
  return strip
end

local function refresh()
  sbar.exec(
    "aerospace list-workspaces --all --format '%{workspace}|%{monitor-appkit-nsscreen-screens-id}|%{workspace-is-focused}';"
      .. "echo ---; aerospace list-windows --all --format '%{workspace}|%{app-name}'",
    function(out)
      local apps, info, in_windows = {}, {}, false
      for line in out:gmatch("[^\n]+") do
        if line == "---" then
          in_windows = true
        elseif in_windows then
          local ws, app = line:match("^(.-)|(.*)$")
          if ws then
            apps[ws] = apps[ws] or {}
            table.insert(apps[ws], app)
          end
        else
          local ws, display, focused = line:match("^(.-)|(.-)|(.*)$")
          if ws then info[ws] = { display = tonumber(display), focused = focused == "true" } end
        end
      end

      for ws, item in pairs(spaces) do
        local i = info[ws] or {}
        local windows = apps[ws] or {}
        item:set({
          drawing = i.focused or #windows > 0,
          display = i.display,
          icon = { highlight = i.focused },
          label = { string = icon_strip(windows), highlight = i.focused },
          background = { border_color = i.focused and colors.grey or colors.bg2 },
        })
      end
    end
  )
end

local separator = sbar.add("item", "space_separator", {
  position = "left",
  display = "active",
  padding_left = 10,
  padding_right = 8,
  icon = { string = icons.chevron, font = "SF Pro:Heavy:16.0" },
  label = { drawing = false },
})

separator:subscribe(
  { "forced", "aerospace_workspace_change", "front_app_switched", "space_windows_change", "system_woke" },
  refresh
)
