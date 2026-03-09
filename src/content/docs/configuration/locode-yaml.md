---
title: locode.yaml
description: Configuration file format for locode.
---

Locode reads its configuration from a `locode.yaml` file. This file controls which models are used, how tasks are routed, and when to escalate to Claude.

## Key settings

| Key | Description | Default |
|-----|-------------|---------|
| `local_llm.model` | Ollama model to use for local tasks | `qwen2.5-coder:7b` |
| `routing.rules` | Regex patterns that route tasks to local or Claude | — |
| `routing.escalation_threshold` | Confidence below this value escalates to Claude | — |

## Example configuration

```yaml
local_llm:
  model: qwen2.5-coder:7b

routing:
  escalation_threshold: 0.6
  rules:
    - pattern: "rename|format|lint"
      target: local
    - pattern: "architect|refactor|debug"
      target: claude
```

## Using a custom config file

Pass the `--config` flag to use a config file at a non-default location:

```bash
locode chat --config ./custom.yaml
```

## Schema validation

The configuration file is validated at startup using a Zod schema. If your config contains invalid keys or values, locode will report an error with details about what needs to be fixed.

## Related

- [Routing Rules](/configuration/routing-rules) — how pattern-based routing works
- [Model Selection](/configuration/model-selection) — choosing the right local model
