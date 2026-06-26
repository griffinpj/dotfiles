---
name: workspace-agents-build-agent
description: Build or edit a workspace agent or custom agent from Codex. Use for Agent Builder work such as creating an agent or changing its instructions, identity, configured capabilities, Memory, skills, starter prompts, attached references, deployments, or published version.
---

# Workspace Agent Builder

Use this skill when the user is creating or changing one workspace agent.

Use `[$Workspace Agents](app://connector_6a0529e9cfcc81909a0212e07b04b875)` for workspace-agent connector tools.

## Operating Model

Codex edits the agent; Codex is not the agent. Requests about the agent's voice, behavior, sources, destinations, tools, schedules, Memory, files, skills, channels, or live state are agent-configuration requests unless the user clearly asks Codex to perform the task directly.

The top-level workflow is authoritative. References explain how to execute a step; they must not be used to bypass this flow.

When the requested agent involves Slack channel messages, `@` mentions, Slack schedules, or posting as the agent in Slack, call `get_slack_channel_setup_readiness` before promising fresh Slack channel setup. This is a setup probe that may validate Slack permissions, so call it at most once for the current setup attempt and reuse its result. Treat fresh Slack channel setup as available when workspace agents are enabled for the workspace; do not require all readiness fields to be complete. Before handing off to Slack channel setup, also audit any supporting app attachments the agent needs during Slack-triggered runs and make sure they are Agent-owned/shared when grounded.

## Workflow

1. **Resolve state and target.** For existing-agent work, identify the editable agent with `list_agents`, `search_agents`, `get_agent`, or the already-resolved agent in this conversation. Before edits that depend on current state, call `get_current_agent_config`. See [references/01-state-and-target-resolution.md](references/01-state-and-target-resolution.md).
2. **Classify the request.** Decide whether this is a new setup, a materially underconfigured agent, or a targeted edit to a coherent existing agent. Preserve existing useful structure for targeted edits.
3. **Run the mutation gate.** Before `create_agent`, `update_agent_*`, app changes, Memory changes, deployments, or `publish_agent` for a new or materially underconfigured agent, verify that every material building block is resolved: input source, input criteria, output target, push mechanism, and output format. Treat broad categories, visible apps, linked accounts, common defaults, and likely providers as unresolved when they could change first useful behavior. If anything material is unresolved, use the Codex user input request UX when available, then stop. Do not mutate in the same turn after asking setup questions. See [references/02-setup-question-design.md](references/02-setup-question-design.md).
4. **Ground capabilities before changing them.** Apps, action schemas, account mode, write approval, Memory, web search, image generation, app constraints, files, skills, channels, schedules, and deployments are structured configuration, not prose. Use only connector-supported operations and exact grounded IDs. When behavior depends on an app or action whose operations or schema are not already grounded, call `get_app_metadata` before drafting the change. See [references/04-apps-and-capabilities.md](references/04-apps-and-capabilities.md).
5. **Write coherent instructions and details.** Instructions describe how the agent uses actually configured capabilities; they do not grant access. Details and starter prompts must not promise unconfigured behavior. Before materially revising instructions for an existing agent with attached files or skills, inspect the relevant current file and skill contents using supported file and skill read tools. Do not hide conflicts between the requested instruction edit and attached files or skills. See [references/03-instructions-authoring.md](references/03-instructions-authoring.md) and [references/05-details-and-starter-prompts.md](references/05-details-and-starter-prompts.md).
6. **Mutate with the narrowest tool.** Prefer granular tools: `create_agent`, `update_agent_details`, `update_agent_instructions`, `set_memory`, `configure_web_search`, `configure_image_generation`, `upsert_agent_apps`, `remove_agent_apps`, app action constraint tools, `list_schedules` plus schedule add/update/delete tools, and existing Slack deployment update/delete tools. If no supported tool can express the requested edit, use the Agent Studio Builder handoff instead.
7. **Refresh and report.** After successful mutation, refresh config when needed, distinguish draft from live, summarize what actually changed, include the agent link `https://chatgpt.com/agents/a/<agent_id>`, mention unsupported setup debt, and suggest at most one next step. Publish only when the user explicitly asks. If the current draft is ready to go live and the user did not already ask to publish, call `show_publish_prompt` before finishing the turn so the connector-owned inline widget can offer the grounded `Create` or `Update` CTA alongside the report. See [references/06-save-publish-and-handoff.md](references/06-save-publish-and-handoff.md).

## Tool Schema Recovery

If a Workspace Agents tool call fails before producing a normal tool result, or returns a structured validation error about missing or unknown fields, re-check the currently exposed tool schema and retry once with corrected parameter names. Prefer the tool schema over nearby product or config field names. Do not retry create, publish, schedule, or other write tools when the first call may have partially succeeded; inspect current state first.

## New Agent Creation

Use `create_agent` only after the mutation gate passes and the initial name, instructions, and short description are clear. `create_agent` creates a draft, not a live agent. Fetch `get_current_agent_config` immediately afterward before enriching that draft.

For a new or materially underconfigured agent, read [references/02-setup-question-design.md](references/02-setup-question-design.md) before deciding to ask or proceed. Do not rely on app visibility, existing account links, or common defaults to fill material setup choices.

## Existing Agent Edits

If this conversation has already resolved or created exactly one editable agent, follow-up edit requests such as `also`, `now make it`, `publish it`, or `add Gmail` refer to that same agent unless the user names a different one, multiple agents are in play, the previous target is ambiguous, or capability/published-version context is needed.

For coherent existing agents, make the smallest supported change that satisfies the request. Treat instructions, apps/tools, files, skills, Memory, deployments, and live publishing as separate meaningful changes unless the user explicitly requests them together. If the requested outcome requires a broader bundle, describe that bundle and get confirmation, or make only the requested change and surface remaining setup debt.

## Capability Limits

Use only Workspace Agents connector tools currently available and state those tools return. The plugin cannot complete unsupported editor flows such as template staging, preview runs, analytics, agent sharing or access-control changes, new Slack channel setup, schedule creation/update when no tool is available, or any file or skill mutation the current connector does not expose.

When the current connector exposes file or skill read tools, use them for relevant inspection before instruction changes. For ordinary agent files, call `upload_agent_file` and set `path` to an unused agent-relative destination. Do not imply that this permits overwriting or editing an existing file, skill-file mutation, file rename/delete/detach, or other unsupported file operations. If an attached skill or another unsupported file flow needs edits, direct the user to the web Builder: `https://chatgpt.com/agents/studio/edit/{agent_id}`.

For supported schedule work, use the schedule connector tools described in [references/06-save-publish-and-handoff.md](references/06-save-publish-and-handoff.md). Call `list_schedules` to inspect existing live schedules before creating, updating, or deleting one. Schedules require a published agent; if only a draft exists, publish only when the user explicitly asks, otherwise report that scheduling is blocked until the agent is live. For unsupported schedule, skill, file-rename/delete/detach, or fresh Slack channel setup work, complete any supported draft-safe pieces the user authorized, then hand off to Agent Studio Builder with a direct agent link when available.
