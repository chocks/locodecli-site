---
title: Single-shot Mode
description: Run a single task from the command line without entering the REPL.
---

Single-shot mode lets you run a coding task in one command. Useful for scripting, CI pipelines, or quick one-off tasks.

## Usage

```bash
locode run "<prompt>"
```

### Examples

```bash
locode run "add input validation to the signup form"
locode run "write unit tests for the auth module"
locode run "refactor the database layer to use connection pooling"
```

## Routing behaviour

Single-shot mode uses the same routing logic as the interactive REPL. The task is evaluated against your [routing rules](/configuration/routing-rules) and sent to either the local Ollama model or Claude.

You can override routing:

```bash
locode run "<prompt>" --claude-only
locode run "<prompt>" --local-only
```

## When to use single-shot vs REPL

| Scenario | Recommended mode |
|----------|-----------------|
| Quick, self-contained task | Single-shot (`locode run`) |
| Multi-step conversation | Interactive REPL (`locode`) |
| Script or CI integration | Single-shot (`locode run`) |
| Exploring and iterating | Interactive REPL (`locode`) |
