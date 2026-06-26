---
name: workspace-agents-api-triggers
description: Inspect and plan Workspace Agents API-trigger integrations from Codex. Use when the user asks about Workspace Agents API channels, API triggers, stable trigger IDs, triggering published ChatGPT workspace agents from backend systems, Workspace Agent access tokens, idempotency, or automation plans around agent triggers.
---

# Workspace Agents API Triggers

Use this skill for developer questions about triggering published ChatGPT workspace agents through the Workspace Agents API channel.

Use `[$Workspace Agents](app://connector_6a0529e9cfcc81909a0212e07b04b875)` for grounded workspace-agent reads.

## Capability Boundary

This skill can inspect configured API channels for a selected agent, return grounded stable trigger IDs and endpoints, explain the API contract, draft placeholder-only requests, and review implementation plans. It cannot create API-trigger channels, provision Workspace Agent access tokens, save external automations, retrieve agent responses, or mutate an agent's configuration unless the connector exposes that exact supported operation.

If the user asks to create or edit the agent itself, load `workspace-agents-build-agent`. If the user needs help selecting an existing agent, load `workspace-agents-manage-agent` first and resolve one stable `agent_id`.

Read [references/workspace-agents-api-channel.md](references/workspace-agents-api-channel.md) for the public endpoint, authentication, request, retry, response, and error contract. Treat its linked live developer docs as authoritative.

## Grounded Channel Discovery

For a known `agent_id`, call `get_agent_api_channels` before asking the user for an `agtch_...` ID or sending them to Agent Studio.

Interpret the result directly:

- `channels=[]`: no configured or visible API channel; hand off to Agent Studio to add and publish one.
- `caller_availability=unavailable`: API triggering is not currently available for this workspace caller; hand off to Agent Studio or the workspace admin without naming internal gates.
- `is_published=false`: hand off to Agent Studio to publish the agent. A grounded trigger record may exist, but public ingress will not run an unpublished agent.
- `pending_publish` or `setup_pending` without a live channel: hand off to Agent Studio to publish or finish API-channel setup.
- `active`: use the returned `api_trigger_id` and `endpoint` directly. Do not require manual copying.
- `pending_removal`: the returned endpoint remains live until the pending removal is published; explain that state before using it.
- Mixed live and pending entries: use the grounded live entry and describe the separate pending draft state.

If the tool is absent, unsupported, or returns an access/error result, do not guess an ID. Treat that as setup/access unavailable and hand off to Agent Studio. The availability result is caller-specific and is not a complete token or runtime preflight; public ingress still enforces credential, permission, publication, trigger-state, and rate-limit checks.

## Core Workflow

1. Resolve one stable `agent_id` and call `get_agent_api_channels`.
2. Use a grounded live `api_trigger_id` and `endpoint` when the agent is published and caller availability is available.
3. Ensure a workspace admin has enabled Workspace Agents and personal access-token creation.
4. Create a Workspace Agent access token from `Admin > Access tokens` with the Workspace Agents scope.
5. Store the token in a secrets manager.
6. Send required `input`, optional `conversation_key`, and optional `Idempotency-Key` to the returned endpoint.
7. Expect `202 Accepted` with no response body, public run ID, or API-readable agent response.

## Guardrails

- Never print, store, commit, or ask the user to paste a real Workspace Agent access token.
- Use placeholders such as `$WORKSPACE_AGENT_ACCESS_TOKEN`, `$API_TRIGGER_ID`, and `agtch_...` in examples.
- Never reconstruct or invent an API trigger ID. Use only a connector-grounded live ID or an exact user-supplied value.
- Do not treat `conversation_key` as a ChatGPT thread ID; it is caller-defined continuity state.
- Preserve workspace visibility and permission boundaries when explaining `403` and `404`.
- Do not claim that Codex created a channel, provisioned a token, saved an automation, or completed Agent Studio setup unless a connector tool performed it.

## Placeholder Request

```bash
curl -i -X POST \
  "$WORKSPACE_AGENT_TRIGGER_ENDPOINT" \
  -H "Authorization: Bearer $WORKSPACE_AGENT_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -H "Idempotency-Key: escalation-email-abc-001" \
  -d '{
    "conversation_key": "email_thread_abc",
    "input": "Summarize the newest escalation and recommend next steps."
  }'
```

Use the exact endpoint returned by `get_agent_api_channels`; the documented shape is `https://api.chatgpt.com/v1/workspace_agents/{api_trigger_id}/trigger`.

When reviewing an integration, cover credential storage, required input, conversation continuity, idempotent retries, `202` handling, route-specific `401`/`403`/`404`/`409`, shared `429`/`500`/`503`, bounded retry behavior, and the lack of a response-retrieval API.
