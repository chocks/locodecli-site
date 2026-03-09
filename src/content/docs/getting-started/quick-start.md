---
title: Quick Start
description: Get up and running with locode in under a minute.
---

## Three commands to start coding

```bash
npm install -g @chocks-dev/locode
locode setup    # installs Ollama, picks a model, saves API key
locode          # start chatting
```

## Interactive mode

Run `locode` with no arguments to open the interactive REPL:

```bash
locode
```

Type a coding task and locode will route it — simple tasks go to your local LLM (Ollama), complex tasks go to Claude. You save tokens automatically.

## Single-shot mode

Run a one-off task without entering the REPL:

```bash
locode run "add input validation to the signup form"
```

## Check your savings

Inside the REPL, type `stats` to see token usage and estimated cost savings:

```
> stats
```

## What's next?

- [Interactive REPL](/usage/interactive-repl) — learn REPL features in depth
- [Single-shot mode](/usage/single-shot) — run tasks from scripts and CI
- [Configuration](/configuration/locode-yaml) — customise routing, models, and thresholds
