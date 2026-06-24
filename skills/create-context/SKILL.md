---
name: create-context
description: >
    Create a context file at the root project folder. This context must respect a strucuture. It is an agent guideline document.
---

## Goal

Create or update `CONTEXT.md` at root of current project. File is an agent guideline document. Follow `CONTEXT-FORMAT.md` for structure.

## When to create

- User explicitly asks to create/update project context.
- A term, variable, or project-specific concept needs to be recorded and no `CONTEXT.md` exists yet.
- Create lazily: only when first real content is ready to write, not preemptively.

## Structure

Follow the format defined in `CONTEXT-FORMAT.md`. Template:

```md
# {Context Name}

{One or two sentence description of what this context is and why it exists.}

## Vocabulary

{Project-specific terms only. General programming concepts excluded.}

**Term**:
{One or two sentence definition of what it IS.}
_Avoid_: <list of bad synonyms>

## Variables

project_name = ""
guidelines_to_load = []
```

## Rules

- **Check first.** Before creating, check if `CONTEXT.md` exists at project root. If it does, update — do not overwrite.
- **Vocabulary: project-specific only.** Ask before adding a term: is this unique to this project's domain, or a general programming concept? Only the former belongs.
- **Be opinionated on vocabulary.** When multiple words name the same concept, pick the canonical one and list alternatives under `_Avoid_`.
- **Definitions tight.** One or two sentences. Define what it IS, not what it does.
- **Group under subheadings** when natural clusters emerge. Flat list is fine if all terms belong to a single area.
- **Variables section** holds agent-facing key-value config (e.g. `project_name`, `guidelines_to_load`). One per line, `key = value` format.
- **No fluff.** No generic descriptions, no restating obvious things.
