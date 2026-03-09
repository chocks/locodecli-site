---
title: Routing Rules
description: Configure how locode decides which model handles each task.
---

Locode's routing rules determine whether a task is handled by your local Ollama model or sent to Claude. This is the core mechanism that saves you tokens and money.

## How routing works

When you submit a prompt, the orchestrator:

1. Evaluates the prompt against your `routing.rules` regex patterns.
2. If a pattern matches, the task is sent to the specified target (`local` or `claude`).
3. If no pattern matches, the router estimates a confidence score. If the score falls below the `escalation_threshold`, the task is escalated to Claude.

## Configuring rules

Rules are defined in `locode.yaml` under `routing.rules`:

```yaml
routing:
  escalation_threshold: 0.6
  rules:
    - pattern: "rename|format|lint|boilerplate"
      target: local
    - pattern: "architect|refactor|debug|security"
      target: claude
```

Each rule has:

| Field | Description |
|-------|-------------|
| `pattern` | A regex pattern matched against the prompt |
| `target` | Where to route: `local` (Ollama) or `claude` |

Rules are evaluated in order. The first match wins.

## Escalation threshold

The `escalation_threshold` is a confidence value between 0 and 1. When the router's confidence that a task can be handled locally falls below this threshold, the task is escalated to Claude.

- **Lower threshold** (e.g., 0.3) — more tasks stay local, saves tokens, but some complex tasks may get weaker responses.
- **Higher threshold** (e.g., 0.8) — more tasks go to Claude, better quality, but higher token cost.

## Overriding routing at runtime

You can bypass routing entirely with flags:

```bash
locode chat --claude-only    # everything goes to Claude
locode chat --local-only     # everything stays local
```
