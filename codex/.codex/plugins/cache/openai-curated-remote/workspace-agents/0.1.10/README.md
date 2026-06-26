# Workspace Agents

Codex plugin for working with workspace agents.

This plugin intentionally does not make every agent task enter Builder mode. It bundles the Workspace Agents connector and provides directly selected, task-specific skills:

- `workspace-agents-build-agent`: use Builder-grade draft editing only while creating or configuring one agent. It grounds edits in the current draft configuration, prefers narrow mutation tools, and loads focused references for setup, capabilities, instructions, apps, channels, and publishing.
- `workspace-agents-manage-agent`: browse the user's created agents, search workspace-scoped editable agents, and inspect one selected agent without drifting into Builder mutation.
- `workspace-agents-api-triggers`: inspect configured API channels and plan developer-owned trigger integrations for published workspace agents. It uses the connector's grounded read tool for stable public trigger IDs, endpoints, lifecycle state, publication state, and caller availability. It cannot create API-trigger channels, provision Workspace Agent access tokens, save external automations, retrieve run responses, or mutate agent configuration unless a current connector tool supports that exact operation.

The connector owns typed workspace-agent tools. Each skill's description gives Codex the intent boundary for selecting that skill directly; its body supplies the workflow guidance once selected.

The build skill mirrors the important Agent Builder runtime principles that make sense in plugin form: keep Codex distinct from the agent being built, keep follow-up edits anchored to the resolved agent, ground every edit in the current draft configuration, identify material setup building blocks before asking questions, prefer safe assumptions for low-risk choices, and report saved-draft versus live state plainly.

The plugin is not the full in-editor runtime. The connector now exposes one Codex inline widget, `show_publish_prompt`, for the ready-draft create/update publish CTA. Template staging, preview cards, app-connection widgets, and other guided editor surfaces are represented only when the Workspace Agents connector exposes a supported tool. The plugin can inspect agent files or skills when the connector exposes matching read tools, add, update, or delete schedules when grounded schedule mutation tools are available, and call `upload_agent_file` with `path` set to an unused agent-relative destination to attach an ordinary agent file. It still cannot overwrite or edit existing agent files, rename, detach, or remove agent files, mutate skill files, or walk the user through new Slack channel setup. For unsupported flows, the build skill should make supported draft edits, then hand the user to Agent Studio Builder with a link to the agent instead of inventing editor state.

Slack is treated as two related but distinct setup surfaces: the regular Slack app for broad Slack data/actions, and Slack channel setup for installing the agent into a channel as a runnable/posting agent. The plugin prepares and publishes the draft when asked, but fresh channel installation remains a guided Agent Studio Builder step unless a grounded connector operation exists for it.

API triggers are treated as developer-owned runtime integrations. The connector can read configured API-channel information for a selected agent so users do not have to copy `agtch_...` IDs manually. The skill guidance points to the live Workspace Agents developer docs and keeps setup boundaries explicit: API-channel creation, access-token provisioning, and external automation deployment remain outside this plugin until corresponding Workspace Agents connector tools exist.
