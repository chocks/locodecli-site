---
title: Interactive REPL
description: Use locode's interactive REPL for back-and-forth coding conversations.
---

The interactive REPL is locode's default mode. It gives you a conversational interface where you can describe tasks, iterate on solutions, and let locode route each request to the best model.

## Start the REPL

```bash
locode
```

Or explicitly:

```bash
locode chat
```

## How routing works

When you type a prompt, locode's orchestrator evaluates the task:

- **Simple tasks** (renaming, formatting, boilerplate) are routed to your local Ollama model — fast and free.
- **Complex tasks** (architecture, debugging, multi-file refactors) are routed to Claude — more capable but costs tokens.

The routing is controlled by rules and a confidence threshold defined in your [`locode.yaml`](/configuration/locode-yaml).

## Force a specific model

```bash
locode chat --claude-only    # send everything to Claude
locode chat --local-only     # send everything to Ollama
```

## REPL commands

Inside the REPL you can use built-in commands:

| Command | Description |
|---------|-------------|
| `stats` | Show token usage and estimated savings |

## Tools

Locode agents have access to built-in tools:

- **readFile** — read file contents from your project
- **shell** — execute shell commands (from an allow-list)
- **git** — run git operations

These tools let the AI understand your codebase and make changes directly.
