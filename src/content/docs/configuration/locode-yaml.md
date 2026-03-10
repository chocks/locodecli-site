---
title: locode.yaml
description: Configuration file format for locode.
---

Locode reads its configuration from a `locode.yaml` file. This file controls which models are used, how tasks are routed, and when to escalate to Claude.

## Key settings

<!-- sync:start name="key-settings" -->
| Key | Description | Default |
|-----|-------------|---------|
| `local_llm.model` | Ollama model to use for local tasks | `qwen3:8b` |
| `routing.rules` | Regex patterns that route tasks to local or Claude | — |
| `routing.escalation_threshold` | Confidence below this value escalates to Claude | `0.7` |
<!-- sync:end -->

## Default configuration

<!-- sync:start name="default-config" -->
```yaml
local_llm:
  provider: ollama
  model: qwen3:8b
  base_url: http://localhost:11434
  # Ollama per-request options (passed directly to the Ollama API).
  # num_ctx:    context window size in tokens (lower = faster, uses less RAM)
  # num_thread: number of CPU threads for inference (match your core count)
  # See https://github.com/ollama/ollama/blob/main/docs/modelfile.md#valid-parameters
  options:
    num_ctx: 2048
    num_thread: 4

claude:
  model: claude-sonnet-4-6
  token_threshold: 0.99

routing:
  rules:
    - pattern: "refactor|architect|design|generate|write test|add .* test|fix|bug|debug"
      agent: claude
    - pattern: "grep|search|ls|cat|read|explore|where is"
      agent: local
    - pattern: "git log|git diff|git status|git blame"
      agent: local
    - pattern: "^(hi|hello|hey|thanks|thank you|good morning|good evening|good night|how are you|what'?s up|sup|yo|bye|goodbye)\b"
      agent: local
  ambiguous_resolver: local
  escalation_threshold: 0.7

context:
  handoff: summary
  max_summary_tokens: 500
  max_file_bytes: 51200
  repo_context_files: ["CLAUDE.md"]

token_tracking:
  enabled: true
  log_file: ~/.locode/usage.log

# mcp_servers:
#   linear:
#     type: remote
#     url: https://mcp.linear.app/sse
```
<!-- sync:end -->

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
