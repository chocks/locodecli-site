---
title: Setup
description: Run the setup wizard to configure Ollama, models, and API keys.
---

The `locode setup` wizard walks you through first-run configuration in a single command.

## Run the wizard

```bash
locode setup
```

The wizard handles three things:

1. **Ollama installation** — checks if Ollama is installed and offers to install it if not.
2. **Model selection** — pulls a local LLM for fast, token-free coding tasks. The default model is `qwen2.5-coder:7b`.
3. **Anthropic API key** — saves your `ANTHROPIC_API_KEY` for routing complex tasks to Claude.

## Pull additional models

You can install extra Ollama models at any time:

```bash
locode install [model]
```

For example:

```bash
locode install codellama:13b
```

## Running without an API key

If no `ANTHROPIC_API_KEY` is set, locode automatically runs in **local-only mode**. All tasks are handled by Ollama — no requests are sent to Claude.

This is useful for offline work or when you want to avoid cloud API costs entirely.

## Next steps

Once setup is complete, head to [Quick Start](/getting-started/quick-start) to run your first task.
