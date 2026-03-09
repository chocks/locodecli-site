---
title: CLI Reference
description: Complete reference of all locode commands and flags.
---

## Commands

| Command | Description |
|---------|-------------|
| `locode` | Start the interactive REPL (default) |
| `locode chat` | Start the interactive REPL (explicit) |
| `locode run "<prompt>"` | Single-shot task execution |
| `locode setup` | First-run wizard — installs Ollama, picks a model, saves API key |
| `locode install [model]` | Pull a specific Ollama model |
| `locode update` | Update locode to the latest version |
| `locode benchmark` | Compare token cost across routing modes |

## Flags

### Chat / REPL flags

```bash
locode chat --claude-only          # skip local, send everything to Claude
locode chat --local-only           # skip Claude, use Ollama only
locode chat --config ./custom.yaml # use a custom config file
```

These flags also work with `locode run`:

```bash
locode run "your prompt" --claude-only
locode run "your prompt" --local-only
locode run "your prompt" --config ./custom.yaml
```

### Benchmark flags

```bash
locode benchmark --prompt "build a REST API" --output report.html
```

| Flag | Description |
|------|-------------|
| `--prompt` | The prompt to benchmark across routing modes |
| `--output` | Output file for the benchmark report (HTML) |

## Automatic local-only mode

If no `ANTHROPIC_API_KEY` is set, locode automatically runs in local-only mode. All tasks are handled by Ollama and no requests are sent to Claude.

## Environment variables

| Variable | Description |
|----------|-------------|
| `ANTHROPIC_API_KEY` | Anthropic API key for Claude routing |
| `SENTRY_DSN` | Opt-in telemetry endpoint (see [Telemetry](/advanced/telemetry)) |
