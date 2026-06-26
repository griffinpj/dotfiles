# Apps And Capabilities

Use this reference before changing configured capabilities: apps, app actions, action constraints, web search, image generation, Memory, files, skills, deployments, schedules, or live channels.

The top-level mutation gate owns whether a setup choice is material. App grounding answers what can be configured; it does not decide whether a user choice may be defaulted.

## Capability Buckets

Reason about capabilities in three buckets:

1. **Built-in runtime behavior**: ordinary model behavior that does not require extra Builder configuration.
2. **Runtime-provided capabilities**: runtime tools such as web search or image generation when they are explicitly enabled in structured configuration.
3. **Editor-configured capabilities**: apps, app actions, app action constraints, attached files, attached skills, Memory, deployments, schedules, and channels.

Instructions and skills tell an agent how to use available capabilities. They do not grant access, attach artifacts, create deployments, or enable Memory by themselves.

Web search and image generation are enabled by default for workspace agents; use `configure_web_search` or `configure_image_generation` only to change an explicit setting. When generated instructions mention them, use the entity-tag format from [03-instructions-authoring.md](03-instructions-authoring.md).

Do not add editor setup for ordinary runtime work such as drafting, analysis, local artifact creation, data transformation, or producing a report in chat. Add editor-configured capabilities only when the requested behavior needs durable setup, external access, attached context, cross-run Memory, channel triggers, or real-world actions such as sending, posting, updating, or creating records.

Treat native model orchestration as runtime behavior, not saved-agent setup. If a workflow has many independent items or research tracks, instructions may tell the agent to use native generic subagents when useful, but do not describe those subagents as configured workspace agents.

## Files, Memory, And Runtime Output

Do not conflate these:

- **Attached files** are fixed reference material available to the agent.
- **Memory** is runtime-maintained durable state that can improve later runs.
- **Runtime output** is an artifact created during a run, such as a report, message, or document.

Use attached files for stable source material. Use Memory for evolving defaults or continuity state. Use runtime outputs for one-off deliverables.

Attached files are input grounding. A requested generated artifact such as a report, CSV, document, deck, or code bundle is usually runtime output, not an agent file, unless the user specifically wants that artifact attached as fixed future reference material.

When an agent needs to collect runtime defaults at first use, configure Memory with `set_memory` only when durable state is supported and useful. Then describe the collection and reuse behavior in instructions. If Memory is unavailable or inappropriate, write non-persistent first-use prompting behavior instead. Do not claim that a separate onboarding skill, business-context file, or reference file exists unless current config or a supported connector operation grounds it.

## App Grounding

- Use `list_available_apps` before adding apps. Copy app IDs from `id`. Treat `links[]` only as available account-connection evidence; do not copy link fields into an app mutation unless the account mode has already been resolved to `SHARED`.
- Fetch `get_app_metadata` before adding, changing, or reasoning about app-specific actions or schemas that are not already grounded.
- Use `catalog` mode for action discovery. Use `action_schemas` with exact action names only when selected action parameter or return schemas are needed.
- Configure apps with `upsert_agent_apps` and remove them with `remove_agent_apps`. Omit apps that should remain unchanged.
- Copy exact connector IDs, action names, link IDs, account labels, auth types, and schema fields from returned evidence. Do not guess variants.
- Default `enabled_actions` to `READ_ONLY` unless the agent's core job explicitly requires creates, updates, sends, posts, deletes, or other consequential operations.
- Default `write_action_approval_required_from` to `END_USER`. Use `NONE` only when the user explicitly asks to let the agent write without confirmation.
- Default `auth_type` to `PERSONAL`. Use `SHARED` only when the user asks for one Agent-owned account, Slack channel setup means the app must work without a specific end user, or another connector/product requirement grounds shared credentials, and `list_available_apps` returns the exact link to use.
- For `PERSONAL`, omit `link_id`, `link_auth_type`, and `link_account_label` entirely. Passing any link field means the app is being configured as Agent-owned/shared account setup, not ordinary end-user account setup.
- Before setting `auth_type = SHARED`, identify the grounding reason in the work: explicit user request, channel setup requirement, guided setup result, or another connector/product requirement. An existing `links[]` entry by itself is never that reason.
- Keep account linkage separate from approval policy. A linked account identifies credentials; it does not imply that every action should run without approval.

Do not treat a connected or visible app as proof that the agent already has durable access to it. The structured draft configuration is the source of truth.

If [02-setup-question-design.md](02-setup-question-design.md) says provider, account family, source scope, destination, run mode, or write policy is material, ask before attaching the app, even when exactly one recommended or linked app appears to fit.

User-facing terminology:

- `PERSONAL` means each user uses or connects their own account.
- `SHARED` means one Agent-owned/shared account is used for this agent.
- Approval decides whether consequential actions need confirmation; it is separate from which account is used.

## Interpreting Available Apps

Read `list_available_apps` as a ranked inventory of what can be configured, not as a command to attach everything visible.

Response shape:

- `available_apps.recommended_apps`: generally good starting points for workspace agents. Prefer these when they fit the requested source, destination, or action family.
- `available_apps.workspace_apps`: workspace-provided or internal apps. Prefer these over public alternatives when they match the user's named system, business workflow, or workspace-specific source of truth.
- `available_apps.public_apps`: generally available apps. Use these when they are the best fit or no recommended/workspace app matches.
- Each app has `id`, `label`, optional `description`, optional `disabled_by_admin`, and `links[]`.
- Each link has `id`, `auth_type`, optional `display_name`, and optional `user_email`.

Use the response to reason about setup this way:

- Match app candidates by domain fit from `label` and `description`, not by bucket alone. An app must plausibly cover the requested source material, destination, artifact type, or action.
- Exclude apps with `disabled_by_admin = true` from setup options unless the user is asking why the app cannot be used. Explain that the workspace admin has disabled the app.
- If exactly one eligible app matches a requested source or destination family and setup materiality does not require asking, default to it and name the concrete app in the setup or recap.
- If multiple eligible apps match the same family, ask a focused provider question. Rank options by explicit user mention, existing `links[]`, then bucket order: recommended, workspace, public.
- If no eligible app matches a required family, do not offer a generic app label. Ask how the source or destination should be provided, or give buildable fallbacks such as pasted context, uploads, ChatGPT replies, or connecting the app later.
- Do not infer companion products from the same vendor or account. A Gmail app does not imply Google Calendar access; a calendar app does not imply email access; a file store does not imply task-tracker access.
- Use `links[]` to reason about account setup, not action capability. A non-empty `links[]` means there is at least one existing account connection available to the current user; it does not mean the app is already attached to the agent.
- Default to `auth_type = PERSONAL` even when links exist. A missing link does not by itself block a `PERSONAL` app setup; the eventual agent user may connect their own account at runtime or in the Builder. Use `SHARED` only when the user asks for one Agent-owned/shared account, the channel setup requires an Agent-owned account, or a guided setup path grounds that account choice.
- For `SHARED`, copy the selected `links[].id` into `link_id`, copy `links[].auth_type` into `link_auth_type`, and use `display_name` or `user_email` as `link_account_label` when useful.
- If an existing attached app is `PERSONAL` but the agent now needs that app during Slack-channel-triggered runs, treat the account mode as mismatched setup. Use `list_available_apps` to ground an exact shared link and `upsert_agent_apps` to convert that app to `SHARED`, or report the missing account setup as Builder follow-up if no link is available.
- After choosing a candidate app, call `get_app_metadata` before deciding read/write access, action constraints, or whether the requested behavior is actually supported.

## App Action Constraints

- Use app action constraint rules only to narrow action input parameters for an already-attached app. They do not filter action outputs.
- Before creating or updating constraints, inspect current rules in `get_current_agent_config` and use exact existing rule IDs when replacing rules.
- Use `upsert_agent_app_action_constraint_rules` to create or replace rules and `remove_agent_app_action_constraint_rules` to remove rules by ID.

## Channels, Triggers, And Versions

- A channel is where the agent runs, such as ChatGPT or Slack.
- A trigger is how a channel starts a run, such as chat, schedule, Slack message, or Slack mention.
- The ChatGPT chat surface is the default ad hoc channel.
- Slack channel deployments are channel setup; the regular Slack app is app/tool setup.
- Draft edits are saved as draft changes. Existing live channel-triggered runs continue using the latest published version until the draft is published.
- `get_current_agent_config.deployments` is draft deployment configuration. Use `list_schedules` for current live schedules; draft schedule deployment entries can lag live schedule state.
- Schedule creation, update, and delete tools mutate live schedules for an already-published agent. Do not publish merely to make a successful schedule mutation live.
- Schedule prompts are kickoff payloads for scheduled runs, not replacements for system instructions.
- Do not infer a configured trigger or schedule from instruction prose. If the connector cannot create the trigger or schedule, use the Agent Studio handoff path.

## Slack: Channels Versus Apps

Treat a channel as a runtime surface and an app as a configured data or action capability.

Slack channel deployment and the regular Slack app are different:

- A Slack channel deployment represents channel-triggered agent behavior and posting as the agent in that configured channel.
- The regular Slack app represents broader Slack data access or user-authenticated actions, such as searching unrelated conversations or working with direct messages.
- Adding the regular Slack app does not create a Slack channel deployment, mention trigger, message trigger, bot persona, or Slack schedule.
- Slack channel setup does not grant broad Slack reads, direct-message access, or arbitrary posting outside the configured channel behavior.

Infer the required surface from the request:

- Use Slack channel setup when the agent should be installed in a channel, respond to mentions or channel messages, post as the agent in that configured channel, or run from a Slack-channel schedule.
- Use the regular Slack app when the agent needs broad Slack history, unrelated channels, DMs, search, or connected-user Slack actions.
- Use both only when both behaviors are required, such as a channel agent that also searches prior Slack threads outside the configured channel.

When explaining this to the user, say that channel setup controls where the agent runs in Slack, while the Slack app controls broad Slack data access or user-authenticated Slack actions.

## Slack Channel Setup Readiness

Before offering fresh Slack channel setup, call `get_slack_channel_setup_readiness` at most once for the current setup attempt. It is a setup probe, not a passive catalog read: it may validate Slack user-group permissions by creating, renaming, and disabling a temporary probe user group, then persisting probe completion. Do not poll it or call it repeatedly; reuse the first result unless the user explicitly retries setup later.

Use workspace enablement as the availability gate. Do not require all readiness fields to be complete before offering the guided Slack setup path.

- `workspace_agents_enabled_in_chatgpt = false`: fresh Slack channel setup is blocked for this workspace. Do not treat the regular Slack app as a substitute for channel triggers.
- `workspace_agents_enabled_in_chatgpt = true`: fresh Slack channel setup is available and can be offered when the requested workflow needs channel, mention, schedule, or bot-persona behavior.
- `workspace_agents_slack_app_connected_once = false` or `user_group_permissions_enabled = false`: these are not availability blockers when workspace agents are enabled. The guided setup flow handles Slack connection, reauthorization, permission completion, handle creation, channel selection, response mode, and channel app membership.

Existing Slack deployments in current config remain grounded even if current readiness is disabled. Use existing deployment IDs for edits or removals, but still use the guided setup flow for adding a new Slack channel.

## Slack Setup Questions And Labels

Use Slack channel setup for bot/channel trigger behavior: channel messages, mentions, channel-specific replies, Slack schedules, or posting as the agent in a configured channel.

Use the regular Slack app only when Slack is visible in `list_available_apps` and the agent needs broad Slack search/read access, DMs, unrelated message history, or connected-user actions.

Infer the needed Slack setup from the user's words:

- **Channel setup only**: the user wants the agent to be used in a Slack channel, respond when mentioned, react to new channel messages, post as the agent in that configured channel, or run a Slack-channel schedule.
- **Regular Slack app only**: the user wants the agent to search, summarize, or reason over Slack history, threads, DMs, or broad team chat without being installed as a channel bot.
- **Both**: the user wants channel-triggered behavior plus broader Slack context or user-authenticated Slack actions outside the configured channel, such as searching past unrelated threads before replying in the channel.

Fresh Slack setup rules:

- Do not ask for workspace, handle, channel name, channel ID, channel link, exact channel, or response mode; guided setup collects those later.
- If the user asks for Slack channel or mention-based intake, ask or default the high-level trigger behavior, such as `@mentions in a Slack channel` versus `New messages in a Slack channel`, without asking for the exact channel.
- Before handing off to fresh Slack channel setup, inspect current app attachments. Any non-Slack supporting app that the agent must use during Slack-triggered runs must be configured as `SHARED` / Agent-owned with a grounded `link_id`; do not leave it as `PERSONAL` unless the app is optional for Slack runs or the user explicitly accepts that setup debt.
- If Slack channel setup is required and `workspace_agents_enabled_in_chatgpt = true`, direct the user to the Builder Slack setup modal at `/agents/studio/edit/{agent_id}/channels/slack/setup` before publishing or telling them Slack channel integration is live. Slack setup can begin before the agent has a live version; publishing is still needed later for Slack-triggered runs to use the configured agent.
- If Slack channel setup is unavailable from the connector/plugin surface, do not offer high-level Slack trigger behavior as already buildable. Draft the agent's identity and instructions, then use the Agent Studio handoff so the user can finish Slack setup in `Channels > Slack` from the Agent Studio edit surface.
- Do not attach the regular Slack app merely to satisfy a channel-trigger request. Attach the regular Slack app only for broad Slack read/search or connected-user Slack actions that the user requested or that are required for the agent's job.
- For scheduled Slack reads, use regular Slack app labels such as `New posts in a Slack channel`, `Past Slack messages or threads`, `Slack threads`, or `Slack DMs`. Do not use channel-trigger labels as scheduled sources.
- Do not pair Slack channel trigger behavior with a schedule unless the user asks for scheduled batch triage, a digest, or a periodic sweep.
- Do not replace a material Slack intake/run question with a reply-style question. Reply behavior matters only after the intake/run surface is clear or when editing an existing Slack deployment.

Slack option labels:

| Mode | Use when | User-facing label |
| --- | --- | --- |
| Slack channel trigger | Incoming channel messages or mentions run the agent | `New messages in a Slack channel` or `@mentions in a Slack channel` |
| Regular Slack source read | Scheduled, recurring, or broader Slack reads | `New posts in a Slack channel`, `Past Slack messages or threads`, `Slack threads`, or `Slack DMs` |
| Slack channel output | The agent posts as itself in a configured channel and Slack channel setup is available | `Post in a Slack channel` |
| Regular Slack connected-user action | The agent acts as the connected user through a visible, write-capable Slack app | Task-specific labels such as `Post in a Slack channel` or `Send a Slack message` |

## Slack App Attachment

Attach the regular Slack app only for regular-app behavior. Do not add it merely because the user wants Slack channel setup.

For ordinary broad Slack reads/searches, use the normal app defaults unless the user asks otherwise:

- `enabled_actions`: `READ_ONLY`
- `auth_type`: `PERSONAL`
- no `link_id`

For connected-user Slack writes, use the minimum write-capable action set grounded by `get_app_metadata` and keep `write_action_approval_required_from` as `END_USER` unless the user explicitly asks for no confirmation.

For Slack channel setup, the Builder-guided channel flow may attach Slack with a selected Agent-owned/shared Slack link so the channel agent can run and post as itself. When that exact shared link is grounded by the setup flow or returned metadata, configure Slack with:

- `enabled_actions`: `ALL`
- `write_action_approval_required_from`: `END_USER`
- `auth_type`: `SHARED`
- `link_id`: the exact returned Slack `links[].id`

Do not guess or reuse a personal Slack connection as a channel setup substitute. If the shared link, workspace, or channel is not grounded, leave the draft-safe setup complete and hand the user to Agent Studio Builder for Slack setup before recommending publish.

For a Slack-channel agent that also needs supporting apps during Slack-triggered runs, remember that the run is not launched as a specific end user. Treat these supporting apps as part of Slack readiness:

1. Inspect `get_current_agent_config.tools.connectors`.
2. Identify each supporting app required for Slack-triggered runs, such as Gmail, Google Drive, Calendar, task trackers, databases, or broad Slack reads.
3. If a required app is missing, add it with `upsert_agent_apps` only after grounding it with `list_available_apps`.
4. If a required app is attached with `PERSONAL`, convert it to `SHARED` with an exact grounded `links[].id`, `links[].auth_type`, and account label.
5. If no grounded shared link exists, do not silently keep or add a personal app. Report that Slack channel setup still needs an Agent-owned account connection in Builder.

Do not tell the user Slack channel setup is ready when a required supporting app is still configured as end-user/personal credentials.

## Limits

Use only Workspace Agents connector tools that currently exist. Prefer granular tools for normal edits, and use the Agent Studio Builder handoff when no supported tool can express the requested change. The connector may expose read tools for selected attached file or skill content, and it can call `upload_agent_file` with `path` set to an unused agent-relative destination to attach an ordinary agent file. It does not support agent sharing or access-control changes, overwriting or editing existing files, skill-file mutation, agent-file rename/delete/detach, or walking the user through new Slack channel setup.

When the required operation is unavailable, state the missing user-visible step and continue with supported work that remains useful. For unsupported schedule, skill, agent-file rename/delete/detach, agent sharing or access-control changes, or fresh Slack channel setup requests, link the user to Agent Studio Builder for the agent rather than using instructions or a complete draft payload as a substitute.
