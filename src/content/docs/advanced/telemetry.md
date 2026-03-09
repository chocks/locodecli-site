---
title: Telemetry
description: Locode's opt-in telemetry and how to control it.
---

Telemetry in locode is **off by default**. No data is collected unless you explicitly opt in.

## Opting in

To enable telemetry, export the `SENTRY_DSN` environment variable in your shell profile:

```bash
export SENTRY_DSN="https://your-key@o123.ingest.sentry.io/456"
```

## What is collected

When telemetry is enabled:

- **Unhandled exceptions** — crash reports to help improve stability
- **Performance traces** — sampled at 20% to identify bottlenecks

## What is never collected

The following data is **never sent**, even when telemetry is enabled:

- Prompts or conversation content
- API keys or credentials
- File contents from your projects

## Disabling telemetry

Unset the `SENTRY_DSN` variable to disable telemetry:

```bash
unset SENTRY_DSN
```

Or remove it from your shell profile entirely. Locode will stop sending any telemetry data immediately.
