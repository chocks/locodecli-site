# Locode Landing Page + Docs Site — Design

## Overview

A landing page and documentation site for [locode](https://github.com/chocks/locode), a local-first AI coding CLI that routes tasks between Ollama and Claude to save tokens. The site serves as both a marketing page and documentation entry point.

## Tech Stack

- **Astro + Starlight** — docs framework with custom landing page support
- **Tailwind CSS** — custom landing page styling
- **TypeScript** — consistent with the locode project
- **Cloudflare Pages** — hosting with git-based deploys
- **GitHub Actions** — build pipeline and docs sync from locode repo

## Color Scheme

- Primary accent: Teal/cyan (#0ED3CF / #14B8A6)
- Dark mode background: Near-black (#0F172A)
- Light mode background: White/off-white
- Code blocks: Terminal-style dark background in both modes
- Subtle teal-to-blue gradients for visual depth
- Dark/light mode toggle in header

## Site Structure

```
/                  → Custom landing page (hero + sections)
/docs/             → Starlight docs
```

## Header

```
[Locode]    [Docs]    [GitHub icon]    [npm icon]    [dark/light toggle]
```

- GitHub links to https://github.com/chocks/locode
- npm links to https://www.npmjs.com/package/@chocks-dev/locode

## Landing Page Sections

### 1. Hero

- Headline: "Local-first AI coding CLI"
- Subline: "Routes simple tasks to Ollama, complex tasks to Claude. Save tokens, save money."
- Animated terminal showing `npm install -g @chocks-dev/locode`
- Two CTAs: "Get Started" (→ docs) and "GitHub" (→ repo)

### 2. How It Works

Three-step horizontal flow:
1. **You type** — prompt input
2. **Locode routes** — smart classification (regex + LLM)
3. **Right model responds** — Ollama (simple) or Claude (complex)

Clean diagram, developer-friendly, no marketing fluff.

### 3. Key Features (4 cards)

- **Smart Routing** — regex rules + LLM-assisted classification
- **Token Savings** — track usage, estimate costs in USD
- **Offline Ready** — works without an API key via Ollama
- **MCP Support** — extend with Model Context Protocol servers

### 4. Cost Comparison

Table or bar chart comparing:
- Claude-only vs Hybrid vs Local-only
- Estimated monthly savings for typical usage
- Data sourced from locode's benchmark feature

### 5. Quick Start

Three terminal blocks:
1. `npm install -g @chocks-dev/locode`
2. `locode setup`
3. `locode`

Links into full docs.

## Docs Sidebar Structure

```
Getting Started
  ├── Installation
  ├── Setup
  └── Quick Start
Usage
  ├── Interactive REPL
  ├── Single-shot Mode
  └── CLI Reference
Configuration
  ├── locode.yaml
  ├── Routing Rules
  └── Model Selection
Advanced
  ├── MCP Servers
  ├── Benchmarking
  └── Telemetry
```

## Docs Sync Strategy

The site repo is separate from the locode repo. Sync is handled via:

1. **GitHub Action on the site repo** — triggers on push and on `repository_dispatch`
2. **Pulls README.md** from the locode repo as a content source
3. **Optionally pulls** `locode.yaml` defaults for config reference
4. **User-facing docs live in the site repo** — this is the canonical docs source
5. **GitHub Action on the locode repo** — sends `repository_dispatch` to site repo when README or relevant files change

The locode repo README links to the site for full documentation.

## Deployment

- Git push to GitHub → GitHub Actions → build → deploy to Cloudflare Pages
- Build command: `npm run build`
- Output directory: `dist/`
