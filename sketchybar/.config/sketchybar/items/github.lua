local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- My open PRs across the repos the pr-tracker skill tracks; same CI/review fields as its note
local github = sbar.add("item", "github", {
  position = "right",
  update_freq = 300,
  icon = { string = icons.pull_request, color = colors.grey },
  label = { string = "–", font = "SF Pro:Heavy:12.0" },
  popup = { align = "right", height = 28 },
})

local query = [[query { search(query: "is:pr is:open author:@me archived:false sort:updated-desc", type: ISSUE, first: 50) {
  nodes { ... on PullRequest { number title url isDraft reviewDecision repository { name nameWithOwner }
    commits(last: 1) { nodes { commit { statusCheckRollup { state } } } } } } } }]]

local filter = [['[.data.search.nodes[]
  | select(.repository.nameWithOwner as $r | $cfg[0].repos | index($r))
  | {repo: .repository.name, number, title, url, draft: .isDraft, review: .reviewDecision,
     ci: .commits.nodes[0].commit.statusCheckRollup.state}]']]

local cmd = "gh api graphql -f query='" .. query .. "' | jq -c --slurpfile cfg '"
  .. settings.pr_tracker_config .. "' " .. filter

local ci = {
  FAILURE = { rank = 3, color = colors.red },
  ERROR = { rank = 3, color = colors.red },
  PENDING = { rank = 2, color = colors.yellow },
  EXPECTED = { rank = 2, color = colors.yellow },
  SUCCESS = { rank = 1, color = colors.green },
}
local no_checks = { rank = 0, color = colors.grey }

local review = {
  APPROVED = "approved",
  CHANGES_REQUESTED = "changes requested",
  REVIEW_REQUIRED = "review required",
}

local TITLE_CHARS = 55
local function truncate(s, n)
  local len = utf8.len(s)
  if len and len > n then return s:sub(1, utf8.offset(s, n) - 1) .. "…" end
  return s
end

local rows = 0 -- popup rows currently in the bar; updated in place so an open popup doesn't flicker
local fetching = false

local function refresh()
  if fetching then return end
  fetching = true
  sbar.exec(cmd, function(prs)
    fetching = false
    if type(prs) ~= "table" then
      github:set({ icon = { color = colors.grey }, label = "!" })
      return
    end

    local worst = no_checks
    for i, pr in ipairs(prs) do
      local status = ci[pr.ci] or no_checks
      if status.rank > worst.rank then worst = status end

      local state = pr.draft and "draft" or review[pr.review] or "not requested"
      local props = {
        icon = { string = "●", color = status.color },
        label = string.format("%s#%d · %s · %s", pr.repo, pr.number, state, truncate(pr.title, TITLE_CHARS)),
        click_script = "open '" .. pr.url .. "'; sketchybar --set github popup.drawing=off",
      }
      if i <= rows then
        sbar.set("github.pr." .. i, props)
      else
        props.position = "popup.github"
        props.scroll_texts = false
        sbar.add("item", "github.pr." .. i, props)
      end
    end
    for i = #prs + 1, rows do
      sbar.remove("github.pr." .. i)
    end
    rows = #prs

    github:set({ icon = { color = #prs > 0 and worst.color or colors.grey }, label = tostring(#prs) })
  end)
end

local function close()
  github:set({ popup = { drawing = false } })
end

github:subscribe({ "forced", "routine", "system_woke" }, refresh)

github:subscribe("mouse.clicked", function()
  if github:query().popup.drawing == "on" then
    close()
  else
    github:set({ popup = { drawing = rows > 0 } })
    refresh()
  end
end)

github:subscribe({ "mouse.exited.global", "front_app_switched" }, close)
