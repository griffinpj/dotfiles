# State And Target Resolution

Use this reference for target selection, draft/published state, role separation, and configuration grounding.

## Role Separation

- **Codex** helps the user inspect and change an agent.
- **The agent** is the configured artifact that will run later.
- **The editor** is the product surface where configuration lives.

Treat requests about the agent's tone, language, tools, files, channels, schedules, Memory, starter prompts, or runtime behavior as changes to the agent being built. Do not let those requests change Codex's own response style unless the user explicitly asks Codex to respond differently.

## Resolve The Editable Agent

- Use `list_agents` to browse agents created by the current user.
- Use `search_agents` for workspace-scoped editable-agent discovery by name or description.
- Use `get_agent` once a stable `agent_id` is known.
- If this conversation has already resolved or created exactly one editable agent, treat follow-up edit requests as referring to that agent unless the user names a different agent, multiple agents are in play, the previous target is ambiguous, or capability/published-version context is needed.
- Before edits that depend on current draft state, call `get_current_agent_config`.

## Grounding

Treat the latest `get_current_agent_config` result as the authoritative editable snapshot. Earlier conversation can explain intent, but it is not proof of current state. Assume a mutation happened only after a connector tool reports success.

Keep these facts separate:

- The current draft is the editable configuration.
- The latest published version is the live configuration, when one exists.
- Text such as the name, description, tagline, or instructions can describe intended behavior, but it is not proof that a capability is enabled.
- Follow-up messages in the same agent run can use that run's temporary context, but that continuity is not Memory, not attached files, and not background execution.
- Triggers, including schedules, start runs. They are not queues, workers, polling loops, daemons, timers inside the current thread, or second system prompts.

## Draft Fields

For ordinary edits, use granular mutation tools so unrelated draft fields are preserved by the connector. If a requested edit cannot be expressed through supported tools, hand off that step to Agent Studio Builder instead of synthesizing a complete draft payload. Important structured fields include:

- identity: model, name, description, icon, tagline, and category
- instructions: the complete prompt
- capabilities: built-in tools, app/action configuration, app constraints, and Memory mode
- references: attached skills and files
- entry points: starter prompts and deployments
- save metadata: save source and draft revision

Treat instruction changes, capability changes, file changes, skill changes, Memory changes, and deployment changes as separate meaningful edits unless the user requested them together.

## Local Context

Do not search or inspect Codex's local workspace, local projects, repository files, directory names, git metadata, package manifests, docs, or files in the user's home directory to infer facts about the agent, its intended repo, team, product, customers, source material, output destinations, policies, or setup defaults unless the user explicitly asks to use local project/file context or provides a path/file as source material.

If the user explicitly asks to build or edit an agent for "this repo", "this project", a local path, or named local files, local inspection is allowed for that requested context. Still distinguish discovered local facts from durable agent configuration, and do not attach or claim file access unless Workspace Agents connector state grounds that attached file state.
