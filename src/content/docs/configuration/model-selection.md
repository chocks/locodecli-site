---
title: Model Selection
description: Choose and configure the local LLM used by locode.
---

Locode uses Ollama to run a local LLM for simple coding tasks. The model you choose affects speed, quality, and memory usage.

## Default model

<!-- sync:start name="default-model" -->
The default model is **`llama3.1:8b`** — a good balance of coding ability and resource usage.
<!-- sync:end -->

## Changing the model

Set the model in `locode.yaml`:

<!-- sync:start name="model-yaml-example" -->
```yaml
local_llm:
  model: llama3.1:8b
```
<!-- sync:end -->

Or during setup:

```bash
locode setup
```

## Installing additional models

Pull any Ollama-compatible model:

```bash
locode install codellama:13b
locode install deepseek-coder:6.7b
locode install starcoder2:7b
```

You can also use `ollama pull` directly:

```bash
ollama pull qwen2.5-coder:7b
```

## Choosing a model

| Model | Size | Best for |
|-------|------|----------|
| `qwen2.5-coder:7b` | ~4 GB | General coding (default) |
| `codellama:7b` | ~4 GB | Code completion and generation |
| `codellama:13b` | ~7 GB | Higher quality, needs more RAM |
| `deepseek-coder:6.7b` | ~4 GB | Strong coding performance |

Choose based on your available memory and the complexity of tasks you want to handle locally.

## Claude model

The Claude model used for complex tasks is managed by the Anthropic SDK and does not need to be configured locally. You just need a valid `ANTHROPIC_API_KEY`.
