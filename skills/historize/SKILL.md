---
name: historize
description: >
  Guidelines for writting a agent discussion and action summaries.
  Each call to this skill should produce a concise summary of the agent's discussion and actions taken, suitable for logging or user feedback. Focus on clarity, brevity, and relevance to the user's query or task.
---

You are responsible for maintaining a persistent record of agent discussions. After each call, generate a concise summary of the discussion and append it to a history file located at the root of the project.

## Objectives

1. Summarize the Discussion
- Capture the key decisions, actions taken, important reasoning, and outcomes.
- Exclude unnecessary details, repetition, or raw dialogue.
- Ensure the summary is clear, factual, and concise.

2. Maintain a Historical Record
- Store all summaries in a single file named `.docs/history/agent_discussion_history.md` at the root of the project.
- If the directory structure does not exist, create it lazylly.
- Each new invocation must append a new entry to the file without modifying or deleting existing content.
- Follow this structure :
```bash
.docs/
    |-history/
        |-agent_discussion_history.md
```
Commands : `test .docs/history/agent_discussion_history.md || (mkdir -p .docs/history && touch .docs/history/agent_discussion_history.md)`

3. Entry Structure
- Each summary entry must include:
- Timestamp (ISO 8601 format).
- Context/Objective of the discussion.
- Key Points or decisions made.
- Actions Taken.
- Outcome/Next Steps.

4. File Handling Rules
- If the file does not exist, create it at the project root.
- If the file exists, append the new summary to the end of this file.
- Preserve chronological order.
- Ensure idempotency—only one entry is added per call.

## Output Format

Append entries using the following Markdown template:

``` markdown
## Entry - <ISO 8601 Timestamp>

**Context/Objective:**
- <Brief description of the purpose of the discussion>

**Key Points:**
- <Key decision or insight 1>
- <Key decision or insight 2>

**Actions Taken:**
- <Action performed by the agent>

**Outcome / Next Steps:**
- <Result or planned follow-up>
```

Example Behavior (Pseudocode)

``` python
from datetime import datetime
from pathlib import Path

FILE_PATH = Path("agent_discussion_history.md")

def append_summary(summary: str):
    timestamp = datetime.utcnow().isoformat()
    entry = f"""
## Entry - {timestamp}

{summary}
"""
    with open(FILE_PATH, "a", encoding="utf-8") as f:
        f.write(entry)
```

## Additional Constraints

- Do not include raw conversation transcripts.
- Keep summaries succinct and objective.
- Use Markdown formatting consistently.
- Ensure the file remains readable and well-structured over time.
