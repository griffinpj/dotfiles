# Workspace Agents API Channel

Use this reference for API-trigger endpoint shape, authentication, request fields, response behavior, and integration-review guidance.

Live public documentation:

- [Trigger workspace agent runs](https://developers.openai.com/workspace-agents/trigger-runs)
- [Authenticate with Workspace Agent access tokens](https://developers.openai.com/workspace-agents/authentication)

## What It Is

The Workspace Agents API lets developers programmatically trigger a published ChatGPT workspace agent through its API channel.

Use it when a developer-owned external system has an event or job that should kick off a workspace agent run, such as a customer escalation, support ticket, CRM update, scheduled operational review, incident alert, or internal intake workflow.

## Endpoint

```text
POST https://api.chatgpt.com/v1/workspace_agents/{id}/trigger
```

`id` is the stable public API trigger identifier for the published API channel. The documented format is `agtch_...`.

## Grounded Channel Information

For a selected workspace `agent_id`, call the Workspace Agents connector's `get_agent_api_channels` read tool first. A live channel entry returns its grounded `api_trigger_id` and full `endpoint`; use those values directly instead of asking the user to copy an ID from Agent Studio.

The tool distinguishes these stored states:

- `active`: a visible persisted API trigger with a grounded ID and endpoint.
- `pending_removal`: a visible endpoint that remains live until its pending removal is published.
- `pending_publish`: a draft API channel that does not have a live public ID yet.
- `setup_pending`: draft state refers to a materialized channel that the authorized live-trigger read cannot confirm; do not use or reconstruct its ID.

An empty channel list means no configured or visible API channel. `caller_availability=unavailable` means API triggering is not currently enabled for the connector caller even if a channel record exists. `is_published=false` means the agent must be published before public ingress can run it. These are Agent Studio or workspace-admin handoffs, not reasons to guess an ID.

This read is not a complete runtime preflight. The public API still checks the access token, workspace and agent permissions, publication and trigger state, rate limits, and other admission requirements.

## Authentication

Authenticate with a Workspace Agent access token:

```text
Authorization: Bearer $AGENT_ACCESS_TOKEN
```

Workspace Agent access tokens are provisioned from the ChatGPT admin access-token flow and are scoped to Workspace Agents API operations.

Provisioning prerequisites and flow:

1. A workspace admin enables Workspace Agents.
2. A workspace admin enables personal access-token creation in `Admin > Permissions & roles`.
3. The user opens `Admin > Access tokens`.
4. The user creates an access token and selects the Workspace Agents scope.
5. The user copies the token once and stores it in a secrets manager.
6. The caller uses the token as a bearer credential on `api.chatgpt.com`.

## Request Body

```json
{
  "conversation_key": "email_thread_abc",
  "input": "Summarize the customer escalation and recommend a response."
}
```

Fields:

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `input` | string | Yes | Message text passed to the agent as trigger input. |
| `conversation_key` | string | No | Caller-defined stable identifier for continuing the same logical agent conversation across multiple trigger events. |

Do not describe `conversation_key` as a ChatGPT thread ID. It is caller-defined continuity state for API-triggered events.

## Idempotency

To safely retry the same trigger event, send an optional `Idempotency-Key` header. Reuse the same key only when retrying the same event. The route still reruns current admission checks before dedupe, including rollout, authorization, visibility, runnable-state, and rate-limit checks, so same-key retries may still surface current `401`, `403`, `404`, `409`, `429`, or other errors. Once current admission checks pass, reusing the same key prevents enqueueing a second trigger event.

Do not blindly retry trigger calls. Retry only when the caller can prove it is retrying the same event, with the same `Idempotency-Key`, and when the failure mode is retryable, such as rate limiting or temporary service unavailability. For `429` or `503`, honor a numeric `Retry-After` header when present. Do not retry unchanged requests for credential, permission, missing-resource, disabled-trigger, or unpublished-agent failures.

## Response

The API durably queues the trigger event and returns:

```text
HTTP/1.1 202 Accepted
```

The response has no body. It does not return a public run ID, and the agent response cannot currently be retrieved through the API.

## Errors

Errors produced by Identity Edge or Workspace agents use the standard OpenAI API error envelope:

```json
{
  "error": {
    "message": "Incorrect API key provided",
    "type": "invalid_request_error",
    "param": null,
    "code": "invalid_api_key"
  }
}
```

For those errors, the top-level response contains `error`; it does not contain a numeric `status` field. Those public responses do not include Identity Edge diagnostic headers or internal dependency-specific error payloads. Responses generated locally by the gateway before Identity Edge or Workspace agents receives the request, such as source-network policy rejections, are outside this guarantee.

Common route-specific statuses:

| Status | Typical meaning |
| --- | --- |
| `401 Unauthorized` | The bearer credential is missing, expired, revoked, or invalid. |
| `403 Forbidden` | The token is valid but does not have permission to trigger the requested workspace agent. |
| `404 Not Found` | The `id` does not exist or is not visible to the caller's workspace. |
| `409 Conflict` | The trigger could not be accepted because the channel or agent is not in a runnable state. |

Shared API and infrastructure statuses can also apply:

| Status | Typical meaning | Retry guidance |
| --- | --- | --- |
| `429 Too Many Requests` | Route or auth rate limit. The error `type` is `rate_limit_error` and the `code` is usually `rate_limit_exceeded`. | Retry only the same event with the same `Idempotency-Key`; honor `Retry-After` when present. |
| `500 Internal Server Error` | Identity Edge, Workspace agents dependency, or unexpected internal failure. The error `type` is `server_error` and `code` is usually `null`. | Do not blindly retry in a tight loop. Retry only with bounded backoff and the same `Idempotency-Key` when the caller can safely treat it as the same event. |
| `503 Service Unavailable` | Temporary service unavailability. The error `type` is `service_unavailable_error` and `code` is usually `null`. | Retry only the same event with the same `Idempotency-Key`; honor `Retry-After` when present. |

## Example: Customer Escalation

```bash
curl -i -X POST \
  "https://api.chatgpt.com/v1/workspace_agents/$API_TRIGGER_ID/trigger" \
  -H "Authorization: Bearer $WORKSPACE_AGENT_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -H "Idempotency-Key: escalation-email-abc-001" \
  -d '{
    "conversation_key": "email_thread_abc",
    "input": "Summarize the newest escalation and recommend next steps."
  }'
```

Expected result:

```text
HTTP/1.1 202 Accepted
```

Use placeholders in examples. Never ask users to paste real Workspace Agent access tokens.

## Example: Internal Intake

```bash
curl -i -X POST \
  "https://api.chatgpt.com/v1/workspace_agents/$API_TRIGGER_ID/trigger" \
  -H "Authorization: Bearer $WORKSPACE_AGENT_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "conversation_key": "intake_request_456",
    "input": "Review this access request, identify the owning team, and draft the next action."
  }'
```

## Implementation Review Points

- Resolve a stable `agent_id`, call `get_agent_api_channels`, and use a returned live ID and endpoint directly.
- Confirm the tool reports `is_published=true` and caller availability before treating a grounded endpoint as ready for integration work.
- Hand off to Agent Studio for an empty channel list, pending-only setup, an unpublished agent, unavailable caller access, or an absent/unsupported connector tool.
- Confirm Workspace Agents and personal access-token creation are enabled for the workspace.
- If a known-correct `agtch_...` ID still returns `404`, check whether the workspace and caller are enabled for Workspace Agents API-trigger access before assuming the trigger ID is wrong.
- Store the Workspace Agent access token in a secrets manager.
- Use `conversation_key` only when repeated events should continue the same logical agent conversation.
- Use `Idempotency-Key` when retrying the same event after timeout, transport failure, `429`, or `503`; for `500`, use bounded backoff and the same idempotency key only when the caller can safely treat it as the same event.
- Treat `202 Accepted` as asynchronous acceptance, not completion.
- Handle route-specific `401`, `403`, `404`, and `409` distinctly from shared `429`, `500`, and `503` infrastructure failures.
- Track caller-side event IDs, logs, and retry attempts because the API does not return a public run ID today.
