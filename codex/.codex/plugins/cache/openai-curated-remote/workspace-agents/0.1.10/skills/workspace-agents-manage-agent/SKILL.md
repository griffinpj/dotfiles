---
name: workspace-agents-manage-agent
description: Find and inspect workspace agents or custom agents from Codex without changing their configuration. Use when the user wants to browse agents they created, search editable agents across their workspace, resolve an agent ID, compare candidates, or inspect one agent's draft and published state rather than edit it.
---

# Workspace Agents Management

Use this skill for finding and understanding agents without changing them.

Use `[$Workspace Agents](app://connector_6a0529e9cfcc81909a0212e07b04b875)` for workspace-agent connector tools.

## Choose the narrowest read

- Use `list_agents` for owner-scoped inventory: browsing agents created by the current user, answering questions such as "what agents do I have?", or recovering an `agent_id` for one of the user's drafts. Results are newest-created first. Do not present this as the complete workspace agent directory.
- Use `search_agents` for workspace-scoped discovery by name or description when the target may be shared, created by another workspace user, or described fuzzily. It returns editable agents available to the caller and requires workspace context. Prefer a concise query such as `release notes` before trying broader variants.
- Use `get_agent` for exactly one known `agent_id`. Call it directly when the user supplied a stable ID; otherwise call it after `list_agents` or `search_agents` identifies the intended result. It returns richer detail for the current editable draft head, the latest published version when one exists, and the caller's viewer capability.
- Use `get_current_agent_config` when the answer depends on the exact editable draft configuration, such as instructions, tools/apps, constraints, Memory, starter prompts, deployments, file tree references, linked connectors, or attached skills. It can also provide attached skill IDs, names, descriptions, and skill types.
- Use `list_agent_files` or `list_agent_file_tree` for attached-file metadata and node IDs. Use `get_agent_skill` for a selected known skill's definition. If it has files or may include references, use `list_agent_skill_files` or `list_agent_skill_file_tree` plus `read_agent_skill_file` for uploaded skills, and `list_chatgpt_skill_files` plus `read_chatgpt_skill_file` for ChatGPT skill refs. Use `read_agent_file` for selected attached-agent text files. Request download URLs only for raw bytes, unsupported formats, large files, or full-bundle fallback.
- Do not chain reads mechanically. A list or search result is enough when the user only needs names, IDs, short descriptions, or publication state. Fetch `get_agent` or `get_current_agent_config` only when the answer depends on one agent's exact configuration, artifact contents, or draft-versus-published detail.

## Resolve ambiguity

- If multiple agents plausibly match before a later edit, present the ambiguity and get the user's selection.
- Preserve pagination tokens when the requested inventory or search may span multiple pages. Fetch another page only when the current results do not answer the question.
- Answer from returned evidence. Distinguish the current editable draft from the latest published version when that difference matters. Summarize plainly rather than dumping raw connector results unless the user asks for them.
- Load `workspace-agents-build-agent` only when the request becomes a configuration change.

## Grounding

- Treat returned configuration and state as evidence. Do not infer enabled capabilities merely from an agent name, description, or instruction text.
- Treat web search and image generation as available by default unless returned configuration explicitly says otherwise.
- Preserve entity tags when exact instruction text matters; otherwise explain them by friendly label.
- When explaining Slack state, distinguish configured Slack channel deployments from the regular Slack app. A visible or connected Slack app is not proof that the agent has Slack channel messages, mentions, schedules, or bot-persona posting configured.
- Treat attached file and skill contents as grounded context. If they appear to conflict with an instruction change the user is considering, surface that conflict. Ordinary agent files can be attached only by calling `upload_agent_file` with `path` set to an unused agent-relative destination; skill files and other unsupported file mutations still require the web Builder at `https://chatgpt.com/agents/studio/edit/{agent_id}`.
- Treat `viewer_capability` as the grounded caller access level for a selected agent. Do not promise that a later edit is available merely because an agent was discoverable.
- If `search_agents` cannot run because workspace context is unavailable, state that workspace search is unavailable in the current context. Use `list_agents` only if an owner-scoped inventory remains useful; do not describe that fallback as equivalent workspace discovery.
- Keep inspection read-only. Do not save a draft, publish, or change configuration to make an explanation easier.

## Current Limits

- The plugin can summarize file-tree references, attached skill references, schedule/deployment metadata, and selected supported file or skill text that the Workspace Agents connector returns.
- This read-only management skill does not change schedules. When the user wants to add, update, or delete a schedule for an agent, load `workspace-agents-build-agent` and use the grounded schedule mutation tools when available.
- This read-only management skill does not change files. When the user wants to upload an ordinary agent file to a new path, load `workspace-agents-build-agent`.
- Skill-file mutations, agent-file rename/delete/detach, and fresh Slack channel setup are still unsupported from the plugin. For those flows on a known `agent_id`, link to `[Open this agent in Agent Studio](https://chatgpt.com/agents/studio/edit/<agent_id>)`, URL-encoding the exact ID if needed. If no agent is known yet, resolve the agent first when possible; otherwise link to `https://chatgpt.com/agents/studio/new`.
