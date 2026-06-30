---
name: obsidian-vault-note
description: Create new notes in the user's Obsidian vault / zk notebook. Use when Codex is asked to add a knowledge note, article/source note, pasted source material, URL/repository/paper/video note, summary note, linked evergreen note, or other Markdown note in the vault identified by $ZK_NOTEBOOK_DIR, while preserving the vault's 8-character ID filenames, YAML frontmatter, inline wiki links, and bidirectional Up/Down graph links.
---

# Obsidian Vault Note

## Overview

Create notes in the Obsidian vault managed by `zk`. The notebook path comes from
`$ZK_NOTEBOOK_DIR`; do not hard-code a vault path.

Use `zk` as the primary notebook interface, and fall back to direct Markdown
inspection only when existing notes have malformed frontmatter or incomplete
metadata.

## Notebook Commands

Set the notebook path before running commands:

```bash
NOTEBOOK="${ZK_NOTEBOOK_DIR:?ZK_NOTEBOOK_DIR is not set}"
```

Run `zk` with both notebook and working directory flags, especially when the
current shell directory is outside the vault:

```bash
zk --notebook-dir "$NOTEBOOK" --working-dir "$NOTEBOOK" list --format json --quiet --no-pager
zk --notebook-dir "$NOTEBOOK" --working-dir "$NOTEBOOK" new --title "$TITLE" --print-path --no-input
zk --notebook-dir "$NOTEBOOK" --working-dir "$NOTEBOOK" index
```

The vault's `zk` config owns note ID generation. Use `zk new` for new files so
filenames stay 8-character lowercase alphanumeric IDs. If an exact ID is ever
required, pass `--id <id>` rather than renaming after creation.

## Workflow

1. Confirm `$ZK_NOTEBOOK_DIR` is set and points to the notebook.
2. Build a title index before drafting:
   - Prefer `zk list --format json --quiet --no-pager`.
   - In JSON output, use `absPath` for the file, `filenameStem` for the ID, and
     `metadata.title` or `title` for the display title.
   - If `zk` emits YAML warnings or omits titles, supplement with a direct scan
     of `*.md` frontmatter for `title:` values.
   - Keep `id`, absolute path, title, tags, and existing graph links available
     while drafting.
3. Choose a short title with letters and spaces only. Avoid colons, dashes,
   underscores, and decorative punctuation. Prefer 3-5 words.
4. Create the note with `zk new --title "$TITLE" --print-path --no-input`.
5. Edit the generated file into the vault structure below.
6. Inline-link the first body occurrence of each existing note title.
7. Wire every Up/Down graph link bidirectionally in the referenced note.
8. Run `zk index` after creating or updating notes.

## Note Structure

Use this structure for ordinary knowledge notes:

```markdown
---
title: "Note Title"
created: June 02, 2026
tags: ["tag_one", "tag_two"]
---

# Note Title

[content]

---
### Up
[[parentid8|Parent Concept]]

### Down
[[childid8|Child Concept]]
```

Rules:

- `title` is always a quoted YAML string.
- `created` uses the current local date as `Month DD, YYYY`, no quotes, with a
  leading zero on the day.
- `tags` is a JSON-style array of quoted strings; use underscores for spaces.
- Links use `[[8charid|Display Name]]`, always ID first.
- Keep both `### Up` and `### Down` sections for ordinary notes, even when
  empty.

## Inline Links

While drafting body content, replace mentions of existing note titles with
inline links:

- Match titles case-insensitively.
- Link only the first occurrence of each existing title.
- Do not link inside YAML frontmatter, the H1, `### Up`, or `### Down`.
- Do not link the new note's own title.
- Preserve user wording where possible; use the canonical note title as the link
  label.

Example:

```markdown
CASS API behavior depends on [[abcd1234|API Architecture]] decisions.
```

## Bidirectional Graph Links

Every Up/Down reference is a two-way contract.

When the new note links to an existing note in `### Up`, add the reciprocal link
to that existing note's `### Down`:

```markdown
[[newid123|New Note Title]]
```

When the new note links to an existing note in `### Down`, add the reciprocal
link to that existing note's `### Up`.

Before editing an existing note:

- Read the target note and preserve its current frontmatter, body, and link
  ordering.
- Add the reciprocal link only if it is missing.
- Insert inside the correct section, not in the body.
- Do not duplicate links with the same ID.

## Article And Source Notes

When the user provides source material, always create two notes. Source material
includes pasted article text, excerpts, URLs, GitHub repositories, papers,
videos, documentation pages, citations, or any external reference that should be
kept distinct from the user's own analysis.

Do not merge the source and analysis into one note. The source note preserves the
reference; the content note captures the useful interpretation.

Create a source note for the reference itself:

- Title is the source title verbatim when known.
- Tags are exactly `["source"]`.
- Body contains only the URL, citation, or pasted source material. Do not add
  summary, commentary, takeaways, or analysis to the source note.
- Include only `### Up` graph links, usually pointing to the content note that
  analyzes this source and optionally to broader parent concepts.
- Do not include `### Down`; source notes have no children in this graph model.

Create a content note for the ideas:

- Title describes the topic, not the source title.
- Tags describe the topic.
- Body contains the summary, takeaways, analysis, or commentary.
- `### Down` points to the source note, making the source a child/reference of
  the analysis.
- `### Up` points to parent concepts when appropriate.

Wire the pair bidirectionally:

```text
Content Note --Down--> Source Note
Source Note  --Up----> Content Note
```

For pasted source material, preserve only enough source text in the source note
to make the reference useful. If the paste is very long, keep the supplied URL or
citation plus a short excerpt marker, then put the summary and synthesis in the
content note.

## Common Mistakes

- Creating files outside `$ZK_NOTEBOOK_DIR`.
- Calling `zk new` from outside the notebook without `--working-dir`.
- Using title filenames instead of the `zk` generated ID filename.
- Skipping reciprocal Up/Down updates.
- Inline-linking inside graph sections.
- Leaving frontmatter title unquoted.
- Putting source summaries in source notes.
- Giving an article content note the same title as the article.
