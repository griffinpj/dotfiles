# Examples

These examples are patterns, not templates. Replace or omit options that are not visible, eligible, or buildable.

| User request | Ask | Omit |
| --- | --- | --- |
| `Build an agent that routes high priority bugs.` | Source coverage, routing destination, and high-priority criteria. Source options may mix Slack trigger intake with durable sources; if the user later selects only durable sources, follow up for run mode only after the source is bounded. | An initial schedule question when Slack trigger intake is a plausible source option. |
| `In Slack, monitor support channels, classify requests, dedupe reports, tag severity, route owners, draft first responses, and update resolved threads.` | Missing operating policies: routing map, severity rules, dedupe policy, and resolution policy. | Whether to use Slack, generic response-style choices, or a schedule question. |
| `Create a weekly product feedback digest.` | Feedback sources, delivery target, and weekly timing. Use regular Slack read labels for scheduled Slack sources. | Monthly cadence options or Slack channel trigger labels as scheduled sources. |
| `Create a private readout from a broad personal source, such as email, calendar, or files.` | Provider or account family when multiple are visible, input criteria for which items count, and run mode only when the request implies automation or a recurring digest. | Defaulting to the provider with an existing link, baking in arbitrary source scope such as recent unread items, creating the draft before source criteria are resolved, or asking shared delivery questions when the user only asked for a private readout. |
| `Create an executive slide deck.` | Source material, concrete slide output type, and content contract. Example output options: `Create Google Slides`, `Downloadable PPTX`, then optionally `Text outline of slide content in ChatGPT`. | Ambiguous ChatGPT labels that imply actual slides were created. |
| `Create a doc that summarizes customer interview themes.` | Interview source and concrete doc output type. Example output options: `Create a Google Doc`, `Downloadable DOCX`, `Downloadable PDF`, then optionally `Text draft of doc content in ChatGPT`. | Ambiguous ChatGPT labels that imply an actual doc file was created. |
