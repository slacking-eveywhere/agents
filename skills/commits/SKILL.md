````yaml
---
name: commits
description: Inspect git changes, create focused commits and write concise Conventional Commit messages.
---

# Purpose

Create one logical git commit from the current repository state.

When this skill is invoked, execute the workflow immediately.
Do not ask the user for git status, git diff or file contents.
Never push.

## Workflow

1. Inspect the repository:

```sh
git --no-pager status
git --no-pager diff
git --no-pager diff --staged
git --no-pager log --oneline -10
````

2. Determine the requested scope.

Supported forms:

* commit
* commit all changes
* commit <file>
* commit all changes but <file>

Default behavior: commit all tracked changes.

3. Stage files.

Examples:

```sh
git add -A
git add <file>
git restore --staged <file>
```

Never stage:

* .env
* node_modules/
* .next/
* .DS_Store
* CONTEXT.md
* .docs/

If credentials are found in tracked files, do not commit them and ensure they are ignored.

4. Review the staged diff:

```sh
git --no-pager diff --staged
```

5. Group changes into logical commits.

If unrelated changes exist, create multiple commits rather than one large commit.

If there are no staged or unstaged changes, reply exactly:

```
No changes to commit.
```

6. Write the commit message.

Subject format:

```
<type>(<scope>): <summary>
```

Scope is optional.

Allowed types:

* feat
* fix
* refactor
* perf
* docs
* test
* build
* ci
* chore
* style
* revert

Rules:

* imperative mood
* present tense
* explain why rather than what
* concise
* no trailing period
* target 50 characters, maximum 72

Examples:

```
fix(auth): prevent token reuse
```

```
refactor(cache): simplify eviction logic
```

Body:

Omit unless it adds useful context.

Include only:

* non-obvious motivation
* migration notes
* breaking changes
* issue references

Wrap body at 72 characters.

7. Commit.

Use:

```sh
GIT_EDITOR=true git commit -m "<subject>"
```

or

```sh
GIT_EDITOR=true git commit \
  -m "<subject>" \
  -m "<body>"
```

8. Report only:

* commit hash
* commit subject

Stop after the commit.
Never push.

## Principles

* Prefer several small commits over one large commit.
* One commit should represent one logical change.
* Read the diff before writing the message.
* The message explains intent, not implementation.
* Never mention AI or code generation.
