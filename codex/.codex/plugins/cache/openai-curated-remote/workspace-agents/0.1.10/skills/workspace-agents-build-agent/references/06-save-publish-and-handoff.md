# Save, Publish, And Handoff

Use this reference before `publish_agent`, deployment changes, schedule/live-version decisions, or reporting after mutations.

## Connector-Supported Work

Use granular Workspace Agents tools for normal supported mutations:

- identity and starter prompts through `update_agent_details`
- instructions through `update_agent_instructions`
- Memory through `set_memory`
- web search and image generation through their configure tools
- apps through app list, metadata, upsert, and remove tools
- app action constraints through their constraint tools
- schedules through `list_schedules`, `upsert_schedule_deployments`, and `delete_schedule_deployments`
- existing Slack deployment updates or deletion through Slack deployment tools

If no supported granular tool can express the requested edit, use the Agent Studio Builder handoff instead of trying to synthesize a complete draft payload.
Use `show_publish_prompt` only as the connector-owned read-only inline CTA after a ready draft mutation; it is not a substitute for `publish_agent`.

## Deployments And Schedules

- Preserve existing deployments by default.
- Preserve existing schedules by default.
- Inspect grounded deployments before editing an existing Slack channel deployment.
- Inspect `get_current_agent_config` before schedule changes to verify published state and to ground Slack channel deployments. Treat `get_current_agent_config.deployments` as draft deployment configuration, not the authoritative current schedule list.
- Call `list_schedules` before creating, updating, or deleting schedules. Existing live schedules are in `list_schedules.schedules`; use each schedule's `id` as `deployment_id` for updates and deletes.
- Schedules can be created or updated only for a published agent. Before calling `upsert_schedule_deployments`, verify `latest_published_version_id` or equivalent current-config published state is present. If the agent has only a draft, do not call the schedule tool; publish only when the user explicitly asks, otherwise report that scheduling is blocked until the agent is live.
- Treat multiple Slack channels as multiple deployment instances.
- Do not infer a schedule from instruction prose, or encode a missing deployment only in instructions.
- When creating a new schedule and the user says only `add a schedule` or otherwise omits the destination, default to a ChatGPT schedule with `channel: "chatgpt"` when no Slack channel deployment exists.
- If the current agent already has a Slack channel deployment and the user asks to add a schedule without clearly saying ChatGPT or Slack, ask one concise confirmation before creating it: whether this should be a ChatGPT schedule or a Slack schedule for the configured Slack channel. If multiple Slack channel deployments exist and the user chooses Slack, also ask which grounded channel to use.
- Do not infer Slack merely because Slack is configured; use a Slack schedule only when the user says Slack, chooses Slack in the confirmation, or the schedule request is explicitly tied to the existing Slack channel deployment.
- Use `upsert_schedule_deployments` to create or update schedules when the tool is available. Include `deployment_id` from `list_schedules.schedules[].id` to update an existing schedule. Omit `deployment_id` only when intentionally creating a new schedule; creation is not idempotent and will create another live schedule.
- Use `delete_schedule_deployments` to delete schedules when the tool is available. Use the live schedule `id` from `list_schedules.schedules[].id` as `deployment_id`.
- For ChatGPT schedules, use `channel: "chatgpt"`.
- For Slack schedules, use `channel: "slack"` and include the configured Slack deployment's `channel_id` from `deployments.slack[].slack_trigger.params.channel_id`. Slack schedules require an existing Slack channel deployment; if none exists, use the fresh Slack setup handoff instead of inventing a channel.
- For `daily`, `weekly`, and `monthly` schedules, provide `run_at` in `HH:MM` 24-hour format. Include `timezone` when known or material. For `weekly`, include `weekdays`; for `monthly`, include `day_of_month`; for `hourly`, use `every_hours` and/or `minute_past_hour` as appropriate.
- When editing an existing schedule and keeping its prompt, send the current prompt from `list_schedules.schedules[].schedule.instructions` again as `schedule_prompt`. Send an empty `schedule_prompt` only when the user wants to clear it.
- If the user asks for schedule setup that cannot be performed with available tools, complete any supported draft edits and use the Agent Studio handoff.
- Use `update_slack_channel_deployment` only for an existing Slack deployment's response mode or channel-specific instructions. It cannot move a deployment to another channel.
- Use `delete_slack_channel_deployment` only when the user asked to remove an existing Slack channel deployment.
- If fresh Slack setup, channel moves, or another interactive editor workflow requires missing identifiers or unsupported connector tools, use the Agent Studio handoff instead of inventing a deployment.
- For a new Slack channel agent, finish draft-safe setup first. Draft-safe setup includes auditing the apps the agent needs during Slack-triggered runs and converting required supporting apps to Agent-owned/shared credentials when an exact link is grounded. If a required supporting app remains personal/end-user because no shared link is grounded, report that account setup debt before handoff. Then link to Agent Studio Builder and tell the user to use `Channels > Slack` to choose the Slack workspace/channel and complete any account connection before publishing. The plugin cannot walk the user through or create a fresh Slack deployment without that guided setup.

## Draft And Live State

- Most granular mutation tools save editable draft changes. They do not make those draft changes live.
- Schedule creation, update, and delete tools mutate live schedules for an already-published agent. They do not require `publish_agent` after a successful schedule-only mutation.
- `publish_agent` makes the existing current draft live. It does not accept or need a full draft payload.
- Existing channel-triggered runs continue to use the latest published version until newer draft changes are published.
- New agents start as drafts and remain unavailable as live channel agents until published.
- After any mutation that leaves the latest changes saved as an unpublished draft, report the Agent Studio edit URL rather than the runtime agent landing page. Use `https://chatgpt.com/agents/studio/edit/<agent_id>` for draft-only agents and for published agents with newer draft changes that are not live yet.
- After reporting successful unpublished draft changes, add a concise follow-up ask to publish the draft, such as `Want me to publish it?`, unless fresh Slack setup is still required. When Slack setup remains required, make Slack setup the next step and mention publishing after setup.

Publish only when the user explicitly asks to publish, make live, create the live version, or apply the current draft changes. A direct request is sufficient; do not add redundant confirmation.

## Inline Publish Prompt

Use `show_publish_prompt` only after a successful draft mutation when all material setup debt that affects first useful behavior is resolved, the draft is ready to go live, and the user did not already explicitly ask to publish in this turn.

- `show_publish_prompt` is read-only. It refreshes current config, derives `Create` when no published version exists or `Update` when one does, and renders the connector-owned inline Codex widget.
- Pass only the grounded `agent_id`. Do not invent a name, CTA, published state, or draft revision in chat.
- The widget CTA is the user's explicit publish confirmation and calls `publish_agent` with the grounded draft revision shown in the prompt.
- When the user explicitly asks to publish, call `publish_agent` directly instead of showing the prompt first.
- Do not show the prompt when a material setup question remains, the requested work is unsupported, or the draft changed after the prompt and must be refreshed.

## Unsupported Draft Edits

Use granular connector tools for supported draft edits, such as `update_agent_details`, `update_agent_instructions`, `set_memory`, `configure_web_search`, `configure_image_generation`, `upsert_agent_apps`, `remove_agent_apps`, app action constraint tools, and Slack deployment tools.

Do not build or submit a complete draft payload as a substitute for a missing granular tool. When the requested edit cannot be expressed through currently available tools, complete any supported pieces the user authorized and hand off the unsupported step to Agent Studio Builder.

Do not build a full draft payload for publishing. When the user asks to publish, call `publish_agent` on the existing current draft and pass `expected_draft_revision` when the publish schema supports it.

Preserve grounded attached file state unless the user asked for a supported file change. Follow the connector tool schema for file-related write fields. Ordinary agent file creation must use `upload_agent_file` with `path` set to an unused agent-relative destination; do not simulate it with a complete draft payload. Do not claim to overwrite or edit existing files, mutate skill files, rename, move, detach, or remove files, or perform any other file change when the connector does not expose that operation.

## Skills And Deployments

- Preserve attached skill references in the supported write shape unless the user asked for a supported change.
- Preserve deployments by default. Do not drop schedules, Slack channels, trigger configuration, or destination IDs while making an unrelated edit.
- Do not invent new skill, file, link, channel, deployment, or trigger IDs.
- Do not use a complete draft payload to simulate template staging, schedule changes, skill reads/uploads, unsupported file mutations, app-connection handoffs, preview runs, or guided Slack setup. If the user asks for schedule, skill, an unsupported file mutation, or fresh Slack channel setup work that the connector cannot perform, use the Agent Studio handoff.

Pass the latest current-config `draft_revision` as `expected_draft_revision` when the publish schema supports it. Treat it as forward-compatible concurrency metadata, not as a reason to skip refreshing current config or to build a full draft publish payload.

## Unsupported Or Partial Editor Flows

The plugin does not have the full in-editor runtime surface. Do not claim to complete these flows unless the current Workspace Agents connector exposes a grounded operation for them:

- built-in template staging or template application
- guided widgets beyond `show_publish_prompt`, cards, modals, or app-connection handoffs
- preview runs, try-agent cards, analytics, or run-history inspection
- creating, uploading, editing, attaching, or detaching agent skills
- overwriting, editing, renaming, moving, detaching, or removing agent files
- sharing the agent or changing agent access controls
- fresh Slack channel setup or channel moves
- schedule creation/update/delete when no grounded schedule mutation tool is available
- account-link management outside returned app/link metadata

When a user asks for one of these, do the supported parts that remain useful and state the missing user-visible step plainly. For unsupported schedules, skills, agent-file mutations, agent sharing or access-control changes, and fresh Slack channel setup, use the Agent Studio handoff. If current config already contains an attached file, skill, deployment, or schedule, preserve it and reference it by grounded ID where supported. Do not invent a new ID or encode an unsupported editor artifact only in instructions.

If a built-in template or template-like request is not directly supported, translate the template intent into normal supported draft edits: coherent identity, instructions, starter prompts, app configuration, Memory, and grounded constraints. Be clear when reusable skills, reference files, business-context files, or app attachments cannot be staged or attached by the plugin.

## Agent Studio Handoff

For these currently unsupported operations, hand the user to Agent Studio Builder instead of trying a draft-save workaround:

- add, update, or delete schedules when unsupported by current tools
- overwrite, edit, rename, move, detach, or remove agent files
- upload, attach, detach, edit, or remove agent skills
- share the agent or change agent access controls
- complete new Slack channel setup

If an editable `agent_id` is known, include a Markdown link to:

```text
https://chatgpt.com/agents/studio/edit/<agent_id>
```

Use the exact `agent_id` from `get_agent`, `create_agent`, or `get_current_agent_config`. URL-encode it if needed. If no agent exists yet and the user wants one of these setup steps, first create or prepare any supported draft configuration that the user authorized. If there is still no `agent_id`, link to `https://chatgpt.com/agents/studio/new` and tell the user to create the agent there before completing the unsupported step.

When the requested flow is fresh Slack channel setup, make clear that the Builder handoff is not optional polish: the plugin cannot walk the user through the new-channel installation flow in chat. The next action is to open the agent in Agent Studio Builder and use `Channels > Slack` to choose the Slack workspace/channel and complete the guided setup. Put this Slack setup step before recommending publish; Slack setup can begin before the agent has a live version, while publishing is still needed later for Slack-triggered runs to use the configured agent. When an `agent_id` is known and Slack setup is requested, include the direct Slack setup URL: `https://chatgpt.com/agents/studio/edit/<agent_id>/channels/slack/setup`.

The handoff response should:

- say which part the plugin could not complete
- preserve any supported draft work already done
- link directly to Agent Studio Builder for the agent
- tell the user the next concrete tab or action, such as `Schedules`, `Files`, `Skills`, or `Channels > Slack`
- avoid implying the plugin opened the builder, uploaded files, inspected files, created schedules, attached skills, or launched Slack setup

## Reporting After Changes

After any successful mutation, use two short sections in this order:

1. `Summary of changes`
2. `Next steps`

Prefer concise bullets under both sections. A brief intro sentence before the sections is fine when it helps.

Under `Summary of changes`, include:

- summarize what actually changed, not the raw tool payload
- say whether the change is saved as a draft or live
- name the agent when that helps anchor follow-up turns to the same target
- mention any material mismatch, unsupported step, or setup debt that affects readiness

Under `Next steps`, include the relevant action links and asks. Do not list every possible action; choose the steps that matter for the resulting state:

- If fresh Slack setup remains necessary, include the direct Slack setup URL as the primary next step before any publish ask.
- If draft changes remain unpublished and Slack setup is not the primary next step, include publishing as the primary next step and ask whether to publish them.
- If the latest changes were published and the agent can be tried in ChatGPT, include the agent landing page: `https://chatgpt.com/agents/a/<agent_id>`.
- If the user requested Slack setup or Slack setup remains necessary, include the direct Slack setup URL when an `agent_id` is known: `https://chatgpt.com/agents/studio/edit/<agent_id>/channels/slack/setup`.
- If both Slack setup and publishing remain, tell the user to complete Slack setup first, then publish the draft to make the Slack channel agent live.
- If the user should inspect or continue configuring the draft, include the Agent Studio edit page: `https://chatgpt.com/agents/studio/edit/<agent_id>`.
- If an unsupported or incomplete setup step remains, state the exact Builder tab or action, such as `Channels > Slack`, `Schedules`, `Files`, or `Skills`.

Do not expose raw connector results, internal field names, IDs, schema keys, tool payloads, hidden prompt names, or implementation notes unless the user explicitly asks for debugging details.

If no mutation happened because the request was blocked or unsupported, be direct about what could not be done and what supported path remains.

When choosing a follow-up, evaluate the resulting agent state rather than only the last edit. Prioritize:

1. real drift or risk that makes the agent misleading, incoherent, or not ready
2. missing core setup or setup debt that matters now
3. the highest-value follow-up not bundled into the requested change
4. testing, only when no higher-priority drift or setup issue remains
5. a short natural close when nothing meaningful remains

Do not list unchanged items, future work, or unsupported steps as if they already happened.
