# Instructions Authoring

Use this reference when creating or materially revising a workspace agent's instructions.

## Objective

Write durable operating guidance for future runs of the agent, not a transcript of the Builder conversation. Treat the instructions like an `AGENTS.md` for the workspace agent: persistent guidance for future conversations, events, schedules, configured capabilities, skills, and attached context.

Write for a capable model. Spend instructions on what is specific to this agent: its role, recurring workflows, grounded sources, destinations, deliverables, lasting constraints, failure behavior, and domain judgment. Do not spend tokens on generic reasoning advice or obvious genre guidance.

## Authoring Priorities

- Expand the user's idea into a capable agent rather than a brittle command script. Support reasonable in-scope requests without requiring special invocation phrases.
- Preserve intent. Keep coherent existing organization, section names, and agent-specific sections unless the user requests or needs a rewrite.
- Preserve concrete setup. Keep exact grounded identifiers for sources, destinations, channels, teams, projects, recipients, rubrics, documents, datasets, links, schedules, and storage locations.
- Use local Codex project or file facts only when the user explicitly requested local project/file context or provided a path/file as source material. Do not turn locally discovered repo names, docs, configs, or file contents into assumed agent sources, policies, destinations, or defaults.
- Separate setup from runtime input. Stable values belong in Builder configuration or instructions. Ordinary per-run variation can come from the user's request, event payload, or schedule prompt.
- Keep Codex's setup behavior out of the agent instructions. Describe what the workspace agent should do at runtime.

## Design Runtime Behavior

- Design for sparse input. Future users may provide only a short request. Let the agent proceed from configured context and sensible defaults instead of interviewing the user before doing useful work.
- Make the normal completion path explicit. If the agent should create, save, send, post, update, notify, remember, or produce a named artifact, state that as the default outcome for the relevant workflow.
- Let the right outcome finish the work. A response, saved document, sent email, posted update, created issue, memory entry, or intentional no-action decision can each be the correct result.
- Do the useful work before asking questions whenever the available context is enough. Do not turn the agent into an intake form unless the agent's actual job is to gather information or a missing answer is required for correctness.
- Support reasonable in-scope variation. Do not make the core workflow so narrow that it blocks corrections, narrower requests, or related work that fits the role.
- Specify meaningful failure behavior: evidence requirements, unsafe actions to avoid, missing-access handling, missing-data handling, escalation paths, and intentional no-action cases.

## Capability-Aware Instructions

- Separate configuration from prose. Apps, tools, files, skills, Memory, schedules, and deployments must be configured through supported Builder actions. Instructions explain how the agent uses capabilities that actually exist.
- Mention only capabilities that materially shape this agent's workflow. Do not dump tool schemas or restate every enabled capability.
- Preserve or reuse grounded references to apps, skills, files, destinations, channels, and Memory exactly. Do not invent identifiers or reference syntax.
- For multi-item or independently researchable workflows, allow the agent to use native generic subagents when useful, then integrate and verify results. Require sequential processing only when order affects correctness.
- Keep recurring workflow behavior in instructions and let schedule prompts supply ordinary run-specific context such as reporting window, cadence, or destination.

## Files And Skills Before Instruction Edits

For an existing agent, instructions must stay consistent with attached files and skills. Before creating or materially revising instructions when files or skills are attached:

- Use `get_current_agent_config` to identify whether an agent file tree exists via `file_tree_id` and to get attached skill IDs.
- Inspect the relevant artifacts before writing. Start with metadata reads: `list_agent_files` or `list_agent_file_tree` for attached agent files. For attached skills, use `get_current_agent_config` to list skill IDs, names, and descriptions, then call `get_agent_skill` for each relevant known skill ID to inspect its definition, instructions, default prompt, descriptions, `file_count`, and `tree_revision`.
- If `get_agent_skill` shows `file_count > 0` or the skill may have reference material, inspect the skill files with the tool that matches the skill type from `get_current_agent_config`: use `list_agent_skill_files` or `list_agent_skill_file_tree` for `uploaded_skill`, and use `list_chatgpt_skill_files` for `chatgpt_skill_ref`. Prefer reading likely instruction-bearing text files such as `SKILL.md`, files under `references/`, examples, rubrics, schemas, policies, templates, and other files whose names match the requested edit. Use returned uploaded-skill node IDs or ChatGPT-skill paths for later reads.
- Read selected supported text content directly with `read_agent_file`, `read_agent_skill_file`, or `read_chatgpt_skill_file` when checking for conflicts or citing the correct reference in instructions. Use `prepare_agent_file_download`, `prepare_agent_skill_file_download`, or `prepare_agent_skill_archive_download` only for raw bytes, unsupported formats, large files, or full-bundle fallback, then fetch the temporary signed URL promptly.
- Treat skill instructions and attached file contents as grounded source-of-truth context for the agent. Do not rewrite the agent instructions in a way that contradicts an attached skill's purpose, workflow, safety rule, default prompt, or an attached file's facts, schema, policy, rubric, examples, or source boundaries.
- If the user's requested instruction edit conflicts with an attached file or skill, tell the user what conflicts and why. Do not save an instruction-only workaround that hides the conflict.
- If resolving the conflict requires adding a new ordinary attached agent file, call `upload_agent_file` with `path` set to an unused agent-relative destination. If it requires overwriting or editing an existing file, mutating a skill file, or another unsupported file operation, explain that limitation and direct the user to update it in the web Builder at `https://chatgpt.com/agents/studio/edit/{agent_id}`.

When the user's requested instruction edit is compatible with attached files and skills, preserve the references and make the smallest coherent instruction change.

## Do Not Include

Do not put these in the workspace agent's instructions:

- Codex's own behavior, editor mechanics, hidden prompts, connector payload details, or storage internals.
- Tool approval, authorization, confirmation, or human-review mechanics that the platform handles.
- One-off conversation details that will not matter across future runs.
- Generic response-style rules, reasoning basics, or motivational language unless they materially change a specific deliverable.
- Full attached-skill procedures, long generic checklists, or low-level runtime paths.
- Low-level local workspace paths, git/runtime mechanics, or connector implementation details unless the user explicitly wants operational detail.

## Shape

Use natural sections that fit the agent. Preserve equivalent existing sections rather than forcing a generic template. Common useful sections are:

- `## Role`: mission and scope.
- `## Skill Directory`: optional pointers to attached skills.
- Workflow, source, decision, tool, onboarding, or deliverable sections: inputs, judgments, actions, destinations, and output expectations.
- `## Default <Deliverable> Guide`: recurring artifact requirements when outputs need consistency.
- `## Memory`: only when durable state is configured and materially useful.
- `## Safety`: agent-specific boundaries, evidence requirements, or escalation rules.

Keep `## Role` high-level. Put workflow gates, thresholds, ignore rules, output fields, destinations, and long identifier lists in specific sections.

## Default Deliverable Guides

Do not add a generic `## Response Style` section by default. When the agent repeatedly creates the same artifact, use `## Default <Deliverable> Guide` to describe the expected substance, structure, destination, and meaningful exclusions for that artifact.

## Memory

Use Memory only when enabled and the job benefits from durable, runtime-maintained state. State what should be retained and why.

- Name the files or folders the agent should maintain, such as `briefing-memory.md`, `channel-defaults.md`, or `requester-defaults.yaml`.
- Say what durable state each file stores and how future runs should use it.
- Prefer Markdown for human-readable continuity and YAML or JSON for structured defaults.
- Use Memory for state that should evolve across runs. Use attached files for fixed reference material, Builder configuration or instructions for stable setup, and runtime output for one-off artifacts.
- Remember that Memory scope differs by surface: per user in ChatGPT and per channel in Slack. Namespace requester-specific Slack defaults explicitly or avoid storing them as unqualified shared channel state.

## Runtime Defaults

When runtime defaults are needed, write task-triggered behavior rather than a session-start script. The agent should ask for required defaults only when a matching task is requested and the missing value is needed for correctness.

- Put fixed builder choices directly in instructions or editor configuration.
- Put reusable, evolving runtime defaults in Memory when Memory is configured.
- For missing required defaults, tell the agent exactly what to ask, where to store the answer when Memory is configured, and when to skip onboarding and proceed.
- Do not block ordinary requests on optional preferences.
- Do not describe a generated onboarding skill, business-context file, or attached reference unless it is actually attached in current config.

## Entity Tags

Use entity tags when instructions should mention a specific grounded configured entity. Prefer tags over plain text when current config supplies a reliable ID.

Persist tags in this format:

```text
{{label:<display label>,id:<entity id>,type:<app|skill|file|slack_channel|web_search|file_persistence|image_generation>}}
```

Rules:

- Source labels and IDs from `get_current_agent_config`, the current Builder context, or an exact tagged user reference. Do not invent, reconstruct, or paraphrase IDs.
- For attached skills, use skill IDs from `get_current_agent_config`; `get_agent_skill` can then inspect a known skill ID. For attached files, use file-node IDs returned by `list_agent_files` or `list_agent_file_tree`; `get_current_agent_config` exposes only `file_tree_id`, not individual file node IDs.
- Use tags only in the instructions field or skill instruction bodies, not in the agent name, description, tagline, starter prompts, or Codex's user-facing replies.
- For an app, use its grounded connector ID.
- For an attached skill, use its grounded skill ID.
- For an attached file, use its grounded file-node ID rather than its path.
- For a Slack channel, use its grounded deployment ID rather than the raw Slack channel ID.
- For built-in capabilities, use literal IDs: `web_search`, `file_persistence`, or `image_generation`.
- Escape `\`, `,`, or `}` in a label, ID, or type with a leading `\`.

Examples:

```text
Use {{label:Gmail,id:connector_gmail,type:app}} to draft replies from the connected inbox.
Reference {{label:README.md,id:file_readme,type:file}} when answering deployment questions.
Use {{label:Security questionnaire workflow,id:skill_security_questionnaire,type:skill}} for questionnaire intake and drafting.
Post release summaries to {{label:#team-updates,id:deployment_team_updates,type:slack_channel}}.
Use {{label:Memory,id:file_persistence,type:file_persistence}} to keep reusable state across future runs.
```
