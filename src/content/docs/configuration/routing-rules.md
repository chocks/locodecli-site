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

<!-- sync:start name="routing-rules" -->
```yaml
routing:
  ambiguous_resolver: local
  escalation_threshold: 0.7
  rules:
  - agent: claude
    pattern: refactor|architect|design|generate|write test|add .* test|fix|bug|debug
  - agent: local
    pattern: grep|search|ls|cat|read|explore|where is
  - agent: local
    pattern: git log|git diff|git status|git blame
  - agent: local
    pattern: ^(hi|hello|hey|thanks|thank you|good morning|good evening|good night|how
      are you|what'?s up|sup|yo|bye|goodbye)
```
<!-- sync:end -->

Each rule has:

| Field | Description |
|-------|-------------|
| `pattern` | A regex pattern matched against the prompt |
| `agent` | Where to route: `local` (Ollama) or `claude` |

Rules are evaluated in order. The first match wins.

## Escalation threshold

<!-- sync:start name="escalation-threshold" -->
The `escalation_threshold` is a confidence value between 0 and 1. When the router's confidence that a task can be handled locally falls below this threshold, the task is escalated to Claude.

- **Lower threshold** (e.g., 0.3) — more tasks stay local, saves tokens, but some complex tasks may get weaker responses.
- **Higher threshold** (e.g., 0.8) — more tasks go to Claude, better quality, but higher token cost.
- **Current default**: `0.7`
<!-- sync:end -->

## Overriding routing at runtime

You can bypass routing entirely with flags:

```bash
locode chat --claude-only    # everything goes to Claude
locode chat --local-only     # everything stays local
```
