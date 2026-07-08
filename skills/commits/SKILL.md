---
name: commits
description: >
  Guidelines for writing good commit messages.
  Focus on clarity, brevity, and explaining the "why" behind changes.
  Use present tense and keep the summary line concise.
  Optional body for additional context.  
---

Write commit messages terse and exact. Conventional Commits format. No fluff. Why over what.

## Philosophy

Commits are for you, not a team. Write them so that future-you can understand what happened and why. Keep it simple.  
If you can't explain it in a few words, you probably need to break the change into smaller commits.  
Use `git` commands, understand the change, `git commit` but never push.  
Use `git commit -m` command to create the commit. Do not ask for permission to commit. 

## Parameters

- No parameters, or explicit `all changes` parameter. Commit all changes in the working directory.
- `all changes` parameter may be followed by a `but ...` with a filename as `...` to commit all changes except that file.
- A file name parameter can be optional. Commit only changes to that file. 

## How to track changes

Run these commands in order before writing any commit message:

```sh
git status                  # list modified, staged, untracked files
git diff                    # unstaged changes (full patch)
git diff --staged           # staged changes (full patch)
git log --oneline -10       # recent history for context
```

Read every hunk. Understand *what* changed and *why* it was needed.
Group related hunks mentally. If hunks are unrelated, split into multiple commits.

Then synthesise a one-line answer to: "Why does this change exist?"
That answer becomes the commit message subject. Apply the Rules below to shape it.

## Format

```
Short summary in present tense

Optional longer explanation if needed.
```

That's it. No ticket numbers, no tags, no formal structure.

## Rules

**Subject line:**
- `<type>(<scope>): <imperative summary>` — `<scope>` optional
- Types: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `chore`, `build`, `ci`, `style`, `revert`
- Imperative mood: "add", "fix", "remove" — not "added", "adds", "adding"
- ≤50 chars when possible, hard cap 72
- No trailing period
- Match project convention for capitalization after the colon

**Body (only if needed):**
- Skip entirely when subject is self-explanatory
- Add body only for: non-obvious *why*, breaking changes, migration notes, linked issues
- Wrap at 72 chars
- Bullets `-` not `*`
- Reference issues/PRs at end: `Closes #42`, `Refs #17`

**What NEVER goes in:**
- "This commit does X", "I", "we", "now", "currently" — the diff says what
- "As requested by..." — use Co-authored-by trailer
- "Generated with Claude Code" or any AI attribution
- Emoji (unless project convention requires)
- Restating the file name when scope already says it

## The Summary Line

- **Length**: 50 characters or less.
- **Tense**: Present tense, imperative mood ("Add feature", not "Added feature" or "Adds feature").
- **Capitalize**: Start with a capital letter.
- **No period**: Do not end with a period.
- **Be specific**: "Fix login bug" is better than "Fix bug".

## Workflow — How to Commit

1. Run `git status` + `git diff` + `git diff --staged` — read all hunks.
2. Identify logical groups. If multiple unrelated changes exist, stage and commit each group separately.
3. Stage the right files:
   - All: `git add -A`
   - Specific file: `git add <file>`
   - Exclude a file: `git add -A && git restore --staged <file>`
4. Write subject line: answer "why does this exist?" in ≤50 chars imperative mood.
5. Commit: `git commit -m "<subject>"` — add `-m "<body>"` only if subject is insufficient.
6. Never push. Stop after commit.

## When to Commit

- When calling this skill, commit all changes unless a file is excluded via `but <file>` parameter.
- After completing a logical change (a function, a fix, a refactor).
- Before switching tasks or taking a break.
- Before trying something risky (so you can revert easily).

## What to ignore
- If a file contains credentials, ensure it is in .gitignore file.
- Do not commit `.env`, `node_modules`, `.next`, `.DS_Store`, ...
- Do not commit `CONTEXT.md` file and `.docs`.

## Checklist

- [ ] Summary is 50 characters or less
- [ ] Summary uses present tense imperative mood
- [ ] Commit contains only one logical change
- [ ] Code compiles and runs without errors
- [ ] Commit message explains why, not just what
