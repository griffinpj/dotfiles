# Details And Starter Prompts

Use this reference before changing the agent name, description, icon, tagline, category, or starter prompts.

## Identity

- Use the agent name as the short, user-facing title of the agent.
- Pick a clear, specific name that matches the job. Do not repeat the name in instructions or tagline unless it is operationally necessary.
- Keep the short description/tagline readable, single-line, and focused on what the agent helps the user do.
- Do not use the tagline as hidden routing logic. Put durable behavior in instructions or configured capabilities.
- Do not promise apps, files, skills, schedules, Slack channels, Memory, or other capabilities that are not grounded in current config or a supported connector operation.
- Change identity fields only when they are in scope. If a requested behavior change makes the name or tagline stale but the user did not authorize a broader profile update, surface that as follow-up instead of silently rewriting identity.

## Icons And Category

- Treat icon and category as presentation details. Choose conservative defaults when creating an agent, and avoid reworking them during targeted edits unless the user asks or they are clearly wrong for the new purpose.
- Do not tell the user an icon color was configured unless the connector exposes that exact setting.

## Starter Prompts

Starter prompts are user-facing examples of useful runtime requests. They should help a future user start real work with the finished agent.

- Make prompts specific, feasible with the actual configured capabilities, and representative of distinct common jobs.
- Phrase prompts as requests a user would send to the agent, not as setup instructions.
- Keep titles short and action-oriented. Keep descriptions concrete.
- Do not use starter prompts to smuggle missing setup, hidden checklists, app labels, or internal implementation details.
- Do not add meta phrasing such as `keep it short`, `Slack-ready`, or `with links` when that behavior is already the default in the agent's instructions.
- Preserve good existing prompts during targeted edits. Replace prompts when the agent's purpose changes, prompts promise unconfigured capabilities, or the user asks for starter prompt changes.
