local icons = require("icons")
local settings = require("settings")

local w = icons.weather
local loc = settings.weather

local weather = sbar.add("item", "weather", {
  position = "right",
  update_freq = 900,
  icon = { string = w.cloudy, font = settings.nerd_font .. ":Regular:16.0", color = 0xff5edaff },
  label = "…",
})

local url = string.format(
  "https://api.open-meteo.com/v1/forecast?latitude=%s&longitude=%s&current=temperature_2m,weather_code,is_day&temperature_unit=%s",
  loc.latitude, loc.longitude, loc.unit
)

-- WMO weather codes: https://open-meteo.com/en/docs#weather_variable_documentation
local function describe(code, day)
  if code == 0 then return day and w.sunny or w.night, "Clear" end
  if code <= 2 then return day and w.partly_cloudy or w.night_partly_cloudy, "Partly cloudy" end
  if code == 3 then return w.cloudy, "Overcast" end
  if code <= 48 then return w.fog, "Fog" end
  if code <= 57 then return w.rainy, "Drizzle" end
  if code <= 67 then return code == 65 and w.pouring or w.rainy, "Rain" end
  if code <= 77 then return w.snowy, "Snow" end
  if code <= 82 then return code == 82 and w.pouring or w.rainy, "Showers" end
  if code <= 86 then return w.snowy, "Snow showers" end
  return w.lightning, "Thunderstorm"
end

local function refresh()
  sbar.exec("curl -sf --max-time 10 '" .. url .. "'", function(data)
    if type(data) ~= "table" or not data.current then
      weather:set({ label = "–" })
      return
    end
    local c = data.current
    local icon, desc = describe(c.weather_code, c.is_day == 1)
    local unit = loc.unit == "fahrenheit" and "F" or "C"
    weather:set({ icon = icon, label = string.format("%d°%s • %s", math.floor(c.temperature_2m + 0.5), unit, desc) })
  end)
end

weather:subscribe({ "forced", "routine", "system_woke", "mouse.clicked" }, refresh)
