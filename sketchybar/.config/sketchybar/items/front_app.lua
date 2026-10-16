local front_app = sbar.add("item", "front_app", {
  position = "left",
  display = "active",
  label = { font = "SF Pro:Black:12.0" },
  icon = { background = { drawing = true, image = { scale = 0.8 } } },
  click_script = "open -a 'Mission Control'",
})

front_app:subscribe("front_app_switched", function(env)
  front_app:set({ label = env.INFO, icon = { background = { image = "app." .. env.INFO } } })
end)
