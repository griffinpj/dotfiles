# Setup Question Design

Use this reference before deciding whether to ask a question, make an assumption, or apply a configuration change. The top-level `SKILL.md` owns the blocking mutation gate; this file explains how to evaluate materiality and design setup questions.

## Goal

Identify the building blocks that materially affect the requested build or edit, then choose the smallest safe path:

- proceed when needed facts are explicit, grounded in current config, or safely inferable
- ask one focused follow-up when a missing answer would materially change the result
- describe and confirm a broader bundle when the user's requested outcome requires changing several independent configuration areas
- defer unsupported or lower-risk refinements instead of blocking the core requested change

Do not turn setup or edits into an intake form. Do not ask questions for reversible style choices, per-run preferences, or facts that current config and connector metadata already answer.

Decision priority:

1. Platform and connector reality: only offer paths supported by current Workspace Agents tools or an explicit Agent Studio handoff.
2. User intent: preserve named apps, domains, cadence, sources, destinations, and deliverables.
3. Materiality: ask only for answers that change the first useful build or requested edit.
4. Archetype priority: use it to order questions, not to override clearer user intent.
5. Examples: treat examples as patterns, not templates.

## Shape Gate

For a new or materially underconfigured agent, proceed with setup questions only when the request identifies at least:

1. the rough job or outcome
2. at least two building blocks worth resolving

Too-vague requests include `Make an agent`, `Help me build something`, `I need an assistant`, and `Not sure, maybe for work`. If the request is too vague, ask exactly one natural-language outcome question and stop, such as:

- `What should this agent help you accomplish first?`
- `What kind of work should the agent take off your plate?`
- `Who is this agent for, and what should it produce for them?`

For normal edits, do not re-run the shape gate unless the existing agent is still materially underconfigured. A targeted edit can proceed from current config plus the user's delta.

## Archetype

Classify the intended first useful output or requested edit:

- **routing**: classify, prioritize, route, assign, escalate, deduplicate, synchronize, or update operational state
- **readout**: gather context and return a brief, digest, answer, Q&A, report, or synthesis
- **drafting**: create a sendable, publishable, or reusable artifact
- **reviewer**: evaluate material against criteria and return issues, risk, readiness, fixes, or blocking notes
- **unclear**: the job has enough shape for questions but does not fit a clearer archetype

For hybrids, choose the most consequential behavior or first useful output as primary. If the agent changes where work lives, who owns it, its status, or a system of record, make `routing` primary. If it creates a reusable or sendable work product, make `drafting` primary. If it evaluates against standards, make `reviewer` primary. If it answers, summarizes, or recommends from sources, make `readout` primary.

Use this priority order when choosing questions:

- `routing`: input source -> output target -> push mechanism -> input criteria -> output format
- `readout`: input source -> output target -> push mechanism -> output format -> input criteria
- `drafting`: input source -> output format -> output target -> input criteria -> push mechanism
- `reviewer`: input source -> input criteria -> output format -> output target -> push mechanism
- `unclear`: input source -> output target -> push mechanism -> input criteria -> output format

Promote `input_criteria` earlier when the user's deliverable depends on undefined domain content, metrics, thresholds, rubrics, routing maps, or selection rules.

## Building Blocks

Compare the request and current draft config against these building blocks. Mark each as explicit, grounded, safely inferable, missing, or not applicable:

1. **Input source**: where the agent reads from, such as chat input, uploads, Slack, Gmail, Google Drive, a document, a dataset, a channel, an inbox, a calendar, a tracker, or a specific corpus.
2. **Output target**: where the result goes, such as ChatGPT, Slack, email, a doc, a sheet, a tracker, a repository, or another app. For durable writes, include concrete target details such as project, team, repo, folder, sheet, labels, statuses, owner queue, fields, columns, or update policy.
3. **Push mechanism**: how the agent runs, such as ad hoc ChatGPT use, Slack channel messages or mentions, a schedule, or a bounded scan cadence.
4. **Input criteria**: which items count and how the agent filters, ranks, transforms, drafts, routes, or reviews them. Include rubrics, policies, examples, severity definitions, quality bars, dedupe rules, approval rules, and evidence requirements.
5. **Output format**: the shape of the answer, digest, message, handoff, table, tracker update, document, deck, file, or draft.

A material building block is resolved only when it is concrete enough that two reasonable configurations would not differ in the agent's first useful behavior. A building block is still missing when the user gives only a broad category and the build or edit needs a specific setup detail. A visible app can identify a provider, but not the exact project, repo, folder, sheet, tag, status, field convention, or write policy needed for durable create/update work.

For broad readout or summarization agents, treat input criteria as material when the source corpus could be sliced several plausible ways. Ask which items to summarize, such as unread versus all recent email, a date window, a label, a sender set, a channel set, a folder, or a search/filter, before creating the draft unless the user's request already resolves that scope.

For fresh Slack channel setup, do not ask for exact Slack workspace, channel name, channel ID, channel link, handle, or response mode. The guided Slack setup modal collects those details. If Slack channel integration is part of the first build, call `get_slack_channel_setup_readiness` at most once for the current setup attempt to determine whether fresh Slack channel setup can be offered. This is a setup probe that may validate Slack permissions and persist probe completion, so do not poll it. Fresh Slack channel setup is available when workspace agents are enabled for the workspace; lower-level Slack connection or permission readiness fields do not all need to be complete before offering the guided setup path.

Defaults may fill in low-risk details after the relevant building block is resolved. Do not use a default to choose among materially different providers, stores, scopes, filters, queues, destinations, account modes, or write policies. Existing account links, recommended-app order, or product popularity can help rank options, but they do not make a material choice safely inferable by themselves.

For create/update workflows, distinguish runtime intake from the system of record. If the user says they will send, paste, upload, or type notes, updates, examples, or records, treat that intake mode as explicit unless they also ask the agent to watch an external source. Ask for the durable target and write rules the agent needs, such as the exact tracker, table, fields, matching key, dedupe rule, and update-vs-create policy.

## Assume Or Ask

Use only these sources for assumed setup facts:

- the user's explicit request and answers in the current conversation
- `get_current_agent_config` for the editable agent draft
- `list_available_apps`, `get_app_metadata`, and other Workspace Agents connector results
- grounded agent references already present in current config, such as attached skills, attached files, linked apps, deployments, and starter prompts

Assume or proceed when:

- the choice is explicit in the user request
- `get_current_agent_config` already grounds the exact source, destination, capability, deployment, link, skill, file, or Memory mode
- `list_available_apps` or `get_app_metadata` grounds a single eligible provider and the resulting behavior is low-risk
- the choice is reversible, stylistic, or can be handled as per-run input
- the requested edit is targeted and unrelated missing setup can be surfaced as follow-up

Treat "safely inferable" as "the inferred choice would not materially change the first useful build," not as "likely," "common," or "has an existing account link." For a new or materially underconfigured agent, ask before creating the draft when a broad source family or destination family could map to multiple plausible providers, stores, scopes, filters, or durable targets.

Ask before changing when the missing choice materially changes:

- the agent identity, role, audience, or success criteria
- required source, destination, schedule, Slack setup, permission posture, account mode, or write action
- durable write target or write policy, such as project, repo, folder, sheet, labels, statuses, fields, dedupe key, or update-vs-create behavior
- concrete output type for docs, slides, spreadsheets, PDFs, reports, or other artifacts
- source scope, routing map, severity policy, dedupe policy, resolution policy, rubric, threshold, approval rule, or evidence requirement

Confirm a broader bundle when the user asks for an outcome that requires several independent meaningful changes, such as instructions plus app attachment plus schedule plus write destination. If the user asked only for one piece, make that piece and surface the rest as follow-up.

If too many material choices exist, prioritize unsupported or ambiguous run mechanism, provider choices with multiple eligible apps, uninferable source families, shared or durable destination, then content contract.

## Pre-Mutation Check Details

Before creating or mutating a new or materially underconfigured agent, verify that every material building block is explicit, grounded, safely inferable, or deliberately deferred: input source, input criteria, output target, push mechanism, and output format.

If any material building block is unresolved or filled only by an arbitrary default, ask setup questions and stop. Do not call `create_agent`, app configuration, detail update, instruction update, deployment update, or other draft-mutation tools until the missing material choices are resolved.

This pre-mutation check is blocking for new agents. If any material building block is unresolved, do not call mutation tools even when a likely default exists, an app is visible, an account link exists, or one provider appears common.

`ChatGPT` may be the default ad hoc output target, but broad personal source families such as `my email`, `my inbox`, `my calendar`, `my files`, `my docs`, or `my messages` do not resolve input source or input criteria when multiple providers, accounts, stores, folders, labels, workspaces, channels, corpora, or source slices are plausible.

## Question Form

Ask one natural-language follow-up when there is a single blocker or when the request is too vague for a useful setup bundle.

When several material setup answers are needed for the same next step, ask the smallest useful bundle. In Codex, use the user input request UX when it is available so the user can answer structured setup questions directly. This is mandatory for setup bundles in Codex when the tool is available; do not replace it with a plain chat question just because the likely answer seems obvious. Fall back to concise plain chat questions only when that UX is not callable. After asking, stop and wait for the user's answers.

Use concrete multiple-choice options for provider, source, destination, output, and run-mode choices. Use freeform questions for exact identifiers, mappings, rubrics, durable write targets, custom policies, or any choice where pre-suggested options would be fake precision.

Use 2 or 3 questions when that covers the material setup choices. Use 4 to 6 questions only when the first build clearly depends on distinct source families, a schedule, Slack/channel behavior, a durable destination, write rules, review criteria, or a concrete output type. Do not turn setup into an intake form, confirmation prompt, or generic recommendation summary.

Do not ask conditional questions whose relevance depends on another answer in the same bundle. Ask the provider/path first, then collect path-specific details in a follow-up only if needed.

When the user answers setup questions, treat the original request plus those answers as requirements for the first build. If the user skipped a question, use the safest grounded default when possible; ask another question only when the missing answer is still a must-have blocker. If a selected answer introduces a must-have deferred detail, ask one focused follow-up after the setup answers. Otherwise proceed into normal build mode.

## Defaults

Use these defaults unless the user or grounded config says otherwise:

- ChatGPT is the default ad hoc surface. Do not ask whether to include it or offer `Both ChatGPT and Slack`.
- Default app access to `READ_ONLY` unless the core job explicitly requires writes or other consequential actions.
- Default write-action approval to `END_USER` unless the user explicitly asks to let the agent write without confirmation.
- Default app account mode to `PERSONAL` unless the user clearly asks for an Agent-owned shared account, Slack channel setup requires the app to work during channel-triggered runs without a specific end user, or another connector/product requirement grounds shared credentials; in each case `list_available_apps` must return the required `links[].id`.
  Do not promote an app to Agent-owned/shared account mode only because `list_available_apps` returned `links[]`; existing links are account-setup evidence, not a default account-mode choice.
- Use Memory only when future runs benefit from runtime-maintained durable state.
- Keep the first build or edit compact. Add only capabilities required for the requested useful version.

## Runtime Defaults And Onboarding

Before writing instructions or enabling Memory, decide whether the agent needs durable runtime defaults that future runs should reuse. These are not fixed builder choices; they are requester-, channel-, team-, workspace-, or account-specific defaults that may vary at runtime.

Runtime defaults are likely useful when:

- the agent repeatedly needs the same repo, workspace, team, account, channel, destination, output format, escalation policy, or scope
- the default varies by end user, Slack channel, team, or requester and should not be baked in once by the builder
- missing defaults would make future runs repeatedly ask for the same setup details

Runtime defaults are usually unnecessary when:

- each run can succeed from the user's request, attachments, and configured sources
- the default is a fixed part of this agent's setup and belongs in instructions, app configuration, deployment configuration, or an attached reference
- the detail is optional, stylistic, or safely defaultable per run

When runtime defaults are clearly useful and Memory is supported, use `set_memory` and write instructions that tell the agent what state to maintain, when to ask for missing required defaults, and when to proceed without blocking. If Memory is not supported or not appropriate, write first-use/default-collection behavior into instructions without claiming durable storage.

For Slack agents, remember that shared Memory may be channel-scoped. Do not save one requester's personal defaults as unqualified shared channel state. Namespace requester-specific Slack defaults explicitly in instructions when supported, or have the agent ask per run when reliable namespacing is not possible.

The plugin cannot create, read, upload, or attach a separate onboarding skill unless a supported connector operation exposes that workflow. Do not claim an onboarding skill, business-context file, or reference file was created or inspected when the connector cannot do it. If the user needs agent skills or files, use the Agent Studio handoff from [06-save-publish-and-handoff.md](06-save-publish-and-handoff.md).

## Choosing Options

Every multiple-choice option must be concrete, relevant, buildable, and safe. The user can type a custom answer, so do not include generic `Other`, `Something else`, or placeholder options.

For app-backed options, ground providers with `list_available_apps` and action capability with `get_app_metadata`. Use [04-apps-and-capabilities.md](04-apps-and-capabilities.md) for app inventory interpretation, account/auth defaults, Slack app versus Slack channel behavior, schedule/deployment limits, and publish/live mechanics. This setup guide owns whether a question is material and what answer shape is needed; the app/capability reference owns whether a concrete app, Slack behavior, or deployment path is actually configurable.

Before finalizing setup options, sanity-check:

- Each required source, destination, run mode, artifact type, and write target is explicit, safely defaulted, asked about, or deliberately deferred as an unsupported Agent Studio handoff.
- If the request names multiple required source families, the questions do not silently narrow to only one of them.
- If one provider is safely defaulted, the question, option, or brief preamble names the concrete provider rather than using only a generic family label.
- No option names an app, trigger, file type, delivery surface, or write action that is unavailable, ungrounded, unsafe, or unsupported by the plugin.
- Text-only artifact fallbacks come after real artifact output paths and are labeled as text content, not created files.
- Durable write workflows ask for concrete target details, not just the destination provider.

For app, source, or destination questions, each option should be one of:

- an exact visible app or product
- a concrete non-app source or destination, such as `Uploaded files`, `Pasted notes in ChatGPT`, `What I type in chat`, `A URL or website`, or `Reply in ChatGPT`
- a grounded behavior label, such as `Create a Google Doc`, `Add to a Google Sheet`, `Send email`, or `Create an email draft`

Do not use instructions text as a substitute for missing setup. If an answer requires a real app link, schedule, Slack deployment, file attachment, or durable destination, make sure it maps to a supported setup path.

Order app-backed options before non-app options. Put exact apps or surfaces the user named first, then rank by relevance, existing links, and available-app bucket order. Ask separate questions for different source families, such as calendar events, email threads, tasks, docs, and Slack.

## Sources

- Scheduled or recurring agents need durable, re-readable sources: connected apps, shared file locations, tables, dashboards, trackers, reports, or named systems.
- Ad hoc ChatGPT or Slack agents may use per-request sources: uploaded files, pasted text, chat input, or URLs when those fit the material.
- If the user says they will send, paste, upload, or type notes, updates, examples, or records, treat that runtime intake as explicit unless they also ask the agent to watch an external source.
- If the user says they will `send` material without naming the surface, preserve that intake as part of the workflow. Ask how it arrives only when the surface changes the build.
- Do not offer `What I type in chat` for documents, datasets, transcripts, screenshots, multi-record material, or primarily scheduled workflows unless ad hoc use is also material.
- Treat broad personal source families such as `my email`, `my inbox`, `my calendar`, or `my files` as unresolved when multiple eligible providers are visible. Ask which provider or account family to use before creating the draft.
- If a requested source family has no visible provider, ask how the source should be provided or connected instead of offering a generic family label such as `Calendar events`, `My inbox`, or `Tasks`.

For data analysis, do not treat file stores, docs, code hosts, email, calendars, or trackers as generic data systems unless the user implies the data lives there. Label the surface explicitly, such as `Spreadsheets in Google Drive` or `GitHub issues or PRs`.

## Destinations And Artifacts

Use behavior labels instead of bare app names when the app name alone would be vague:

- `Reply in ChatGPT`
- `Save in Google Drive`
- `Create a Google Doc`
- `Add to a Google Sheet`
- `Send email`
- `Create an email draft`

For scheduled or recurring agents, destination options must be durable defaults that can run without per-run user input. Do not offer `Ask me each time`, `Choose per request`, or similar flexible destinations when the request is recurring.

For artifact-creation requests, treat output type as material. Ask directly using the user's noun, such as `What kind of slides should the agent create?`, `What kind of doc should the agent create?`, or `What should the finished report be?`

Prefer output options in this order, omitting unavailable choices:

1. eligible app-backed artifact outputs, such as `Create Google Slides`, `Create a Google Doc`, `Add to a Google Sheet`, `Create in Notion`, or `Save in Google Drive`
2. concrete downloadable file formats, such as `Downloadable PPTX`, `Downloadable DOCX`, `Downloadable XLSX`, `Downloadable PDF`, or `Downloadable HTML`
3. an optional ChatGPT text-content fallback, labeled honestly as text content, such as `Text outline of slide content in ChatGPT`

Do not label ChatGPT text as if it creates the actual file. Do not force file format and storage/delivery destination into one question when they are independent material choices.

For durable write destinations, a bare app choice is not enough when the first useful agent needs a concrete target. Ask focused freeform details such as:

- `Which GitHub repo, issue labels, project board, or milestone should the agent use?`
- `Which Linear project, team, statuses, labels, or owner queue should the agent use?`
- `Which Google Drive folder or Google Sheet should the agent update, and what columns or tabs should it use?`

For row-based table or spreadsheet workflows, ask whether to update an existing row, create a new row, append every run, or dedupe/update by a matching key.

For delivery-oriented choices, use `Send email` when email delivery fits and a visible email app supports sending. Use `Create an email draft` only when the user asks for drafts, review before send is implied, the output is sensitive enough that draft-safe behavior is appropriate, or sending is not supported.

For private or personal readouts, do not include Slack delivery merely because Slack is visible. Include Slack delivery only when the user asks for Slack/shared-channel delivery, Slack channel setup is the intended handoff, or regular Slack app metadata supports the requested write behavior.

## Run Mode And Schedules

For schedule or run-mode questions, offer concrete schedules, triggers, or cadences only when the requested source, destination, and scan scope are bounded enough to run without per-run user input. If schedule connector tools are available and the agent is published, the chosen schedule can be configured with `upsert_schedule_deployments`; if only a draft exists, scheduling is blocked until the user explicitly publishes the agent. If schedule tools are unavailable, save any supported draft setup and hand off to Agent Studio Builder for the schedule step.

- `Only when I ask in ChatGPT`
- `Every hour`
- `Every morning at 8am`
- `Every weekday at 9am`
- `Every Monday at 9am`
- `Monthly on the 1st at 9am`

Do not offer `Only in ChatGPT` inside a question that is specifically about schedule timing. Use it only for a broader usage-surface question. Do not offer calendar-relative, event-relative, webhook-like, or arbitrary app-event triggers unless a grounded editor surface supports them. If the user states a cadence, keep options consistent with it. If they later answer with a broad cadence such as `daily`, `weekly`, or `morning`, choose a sensible concrete time using the user's timezone when available instead of asking again.

For bounded incoming-work sources without supported event triggers, ask a usage-mode question only after the source/filter is specific enough to scan. Broad providers such as `Google Drive`, `Email`, `CRM records`, or `support records` need an exact folder, file set, queue, filter, or update type before cadence.

## Materiality Patterns

- ChatGPT is the default surface; do not ask whether to include it.
- Slack, schedules, artifact output type, and durable destinations are material when they determine whether the agent is automated, shared, delivered, or able to write somewhere useful.
- For catch-up or digest requests such as `what I missed`, `daily update`, `brief`, or `weekly recap`, a named source and time window do not automatically answer destination or run mode.
- For Slack-triggered routing agents, Slack intake/run behavior is material and should outrank lower-value choices like thread response style.
- A broad artifact category such as `slides`, `doc`, `sheet`, or `PDF` does not answer concrete output type. Do not silently downgrade to paste-ready chat output.
- Unsupported event-like sources make run mode material, but ask cadence only after the source/filter is specific enough to bound each scan.
- Preserve explicit workflow steps as requirements. Ask for missing operating maps or policies, not preference questions for every named action.
- If a named deliverable, metric set, rubric, queue, threshold, summary type, corpus, or source-material set is undefined, ask the missing substance before lower-value formatting preferences.
- If a request depends on an unavailable source or destination family, keep the buildable pieces of the workflow intact and ask only for the missing family or a fallback.

## Post-Answer Follow-Ups

After the user answers setup questions or a normal-edit follow-up, proceed into build mode. Ask another focused follow-up only when the selected path introduces a must-have detail that was intentionally deferred. Prefer one natural-language question; use another structured bundle only for several independent blockers.

Common follow-ups:

- App-backed artifact output: ask folder, title, template, sharing, or format only when required or material.
- Durable writes: ask exact project, repo, folder, sheet, labels, statuses, owner queue, fields, columns, dedupe key, and update-vs-append/create rules as needed.
- Newly bounded source without an event trigger: ask one manual-vs-scheduled follow-up unless the user already supplied a run mode or selected Slack channel trigger intake.
- Broad schedule answer: choose a concrete setup intent using the user's timezone when available. Configure it with `upsert_schedule_deployments` when that tool is available; otherwise hand off to Agent Studio Builder for the actual schedule creation/update.
- Recurring schedule plus Slack channel trigger answer: ask one mode-choice follow-up; do not build both from ambiguity.
- Fresh Slack channel setup: do not ask for channel ID, link, name, exact channel, or response mode in chat.

See [examples.md](examples.md) for sentinel setup patterns and common omissions.
