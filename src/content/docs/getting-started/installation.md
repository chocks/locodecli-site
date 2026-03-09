---
title: Installation
description: How to install locode on your machine.
---

Locode is distributed as an npm package. You need Node.js 18 or later.

## Install via npm

```bash
npm install -g @chocks-dev/locode
```

This installs the `locode` command globally on your system.

## Verify the installation

```bash
locode --version
```

## Update to the latest version

```bash
locode update
```

Or reinstall manually:

```bash
npm install -g @chocks-dev/locode@latest
```

## Prerequisites

- **Node.js** 18+ — [download](https://nodejs.org/)
- **Ollama** (optional) — installed automatically during `locode setup`, or grab it from [ollama.com](https://ollama.com)
- **Anthropic API key** (optional) — required for Claude routing. Without it, locode runs in local-only mode automatically.

## Next steps

Run [`locode setup`](/getting-started/setup) to configure Ollama, pick a model, and save your API key.
