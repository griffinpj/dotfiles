# Workspace Agents Plugin Maintenance Guidance

These instructions apply to changes under `plugins/workspace-agents/`.

## Reference Ownership

Keep reference files medium-grained and organized by decision point, not by every product noun.

- `skills/workspace-agents-build-agent/SKILL.md` owns the top-level build workflow and routing to references.
- `skills/workspace-agents-api-triggers/SKILL.md` owns API-trigger channel inspection, developer guidance, and routing to the public API-channel reference. It must use grounded connector reads for configured channel IDs and state, while keeping channel creation, access-token provisioning, response retrieval, and external automation persistence as explicit unsupported boundaries unless exact tools are added.
- `references/01-state-and-target-resolution.md` owns role separation, target resolution, current-config grounding, and request classification.
- `references/02-setup-question-design.md` owns all general question-asking policy: ask-vs-assume logic, setup-question materiality, building-block identification, archetype priority, and option eligibility.
- `references/03-instructions-authoring.md` owns instruction authoring guidance, runtime behavior design, Memory guidance, and entity-tag usage.
- `references/04-apps-and-capabilities.md` owns capability buckets, app setup, app metadata interpretation, account/auth defaults, Slack app versus Slack channel behavior, Slack setup-question labels, deployments, schedules, and publishing.
- `references/05-details-and-starter-prompts.md` owns name, short description, icon/category, and starter prompt best practices.
- `references/06-save-publish-and-handoff.md` owns publish rules, unsupported editor flows, Agent Studio handoffs, and post-change reporting.
- `references/examples.md` owns compact scenario examples for applying the workflow.

Avoid duplicating the same rule across several references. If a rule spans files, put the durable rule in the owner file and reference it from the caller.

## Reference Shape

Do not split this plugin into many tiny overlapping `best-practices-*` files. Tiny files are okay only when the topic is truly standalone and rarely needed. Ordinary agent-building turns should not require chasing a long chain of micro-references.

Do not collapse the plugin into one large runtime-prompt transplant either. Large all-purpose references defeat progressive disclosure and make stale or conflicting guidance harder to notice.

Prefer compact references that answer one practical question:

- Should Codex ask, assume, or act?
- Which current config must be inspected or preserved?
- Which narrow connector tool supports this edit?
- Which unsupported step needs an Agent Studio handoff?
- How should the resulting agent instructions be written?

## Connector Reality First

This plugin runs from Codex through the Workspace Agents connector. Keep guidance aligned with the connector tools currently available to the plugin.

- Use `get_current_agent_config` as the source of current editable draft configuration before edits.
- Use narrow mutation tools for normal edits.
- Use schedule mutation tools for schedule edits, and hand off unsupported editor operations to Agent Studio Builder.
- Keep `publish_agent` explicit-only.
- Use `show_publish_prompt` only for the connector-owned inline create/update publish CTA after a ready draft save when the user has not already explicitly asked to publish.
- Do not import in-editor Pluto/Agent Builder runtime guidance that assumes unavailable tools, widgets beyond `show_publish_prompt`, cards, modals, previews, file staging directories, or editor-state fields.
- Do not reintroduce `get_agent_builder_context` guidance.

As of this plugin shape, the plugin can inspect agent files or skills when grounded read tools are available, and it can call `upload_agent_file` with `path` set to an unused agent-relative destination to attach an ordinary agent file. It still cannot overwrite or edit existing agent files, rename, detach, or remove agent files, mutate skill files, or walk the user through fresh Slack channel setup. Unsupported flows should be represented as Agent Studio Builder handoffs with a link to the agent when an `agent_id` is known.

## Slack And Apps

Keep Slack channel setup distinct from the regular Slack app:

- Slack channel setup is for bot/channel runs, mentions, channel messages, and posting as the agent in a configured channel.
- The regular Slack app is for broader Slack reads/searches, DMs, or connected-user Slack actions.
- Adding the regular Slack app must not be described as creating a Slack channel deployment.

Default app access to read-only, write approval to end-user confirmation, and account mode to personal/end-user unless the user clearly asks otherwise or grounded connector metadata requires another setup.

## Local Context

Do not let assumed agent setup facts come from Codex's local workspace, repository files, or user home files unless the user explicitly asks to use local project/file context or provides a path/file as source material.

## Validation

Also scan for stale or unavailable-tool guidance:

```bash
rg -n "current_agent_editor_state|patch_agent_instructions|read_agent_file|read_agent_skill|stream_" plugins/workspace-agents
```
