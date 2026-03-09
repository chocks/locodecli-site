---
title: Benchmarking
description: Compare token cost across routing modes with locode benchmark.
---

The `locode benchmark` command lets you compare token usage and cost across different routing modes. Use it to understand how much you save by routing simple tasks locally.

## Usage

```bash
locode benchmark
```

### With options

```bash
locode benchmark --prompt "build a REST API" --output report.html
```

| Flag | Description |
|------|-------------|
| `--prompt` | The prompt to benchmark across routing modes |
| `--output` | Output file for the benchmark report (HTML) |

## What it measures

The benchmark runs your prompt through each routing mode and compares:

- **Token usage** — how many tokens were consumed by the local model vs Claude
- **Cost estimate** — approximate dollar cost for the Claude portion
- **Response quality** — side-by-side comparison of outputs

## Viewing stats in the REPL

You can also check token usage during an interactive session. Type `stats` in the REPL:

```
> stats
```

This shows cumulative token usage and estimated savings for your current session.
