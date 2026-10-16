return {
  font = "SF Pro", -- Needs Regular, Semibold, Heavy and Black variants
  nerd_font = "Hack Nerd Font",
  paddings = 3,

  weather = { latitude = 47.33, longitude = -122.58, unit = "fahrenheit" }, -- Gig Harbor, WA

  -- Repo list is shared with the Claude pr-tracker skill
  pr_tracker_config = os.getenv("HOME") .. "/.claude/skills/pr-tracker/config.json",
}
