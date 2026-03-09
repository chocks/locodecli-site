# Locode Landing Page + Docs Site — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a landing page and documentation site for locode using Astro + Starlight, deployed on Cloudflare Pages.

**Architecture:** Astro + Starlight with Tailwind CSS for custom landing page styling. The site has a splash hero page at `/` and Starlight-powered docs under `/docs/`. GitHub Actions handles builds, deploys, and syncing docs from the locode repo.

**Tech Stack:** Astro, Starlight, Tailwind CSS, TypeScript, Cloudflare Pages, GitHub Actions

---

### Task 1: Scaffold the Astro + Starlight project

**Files:**
- Create: `package.json`, `astro.config.mjs`, `tsconfig.json`, `src/content/docs/index.mdx`

**Step 1: Initialize the project with Starlight + Tailwind template**

```bash
cd /Users/chockalingameswaramurthy/Documents/repos/locodecli-site
npm create astro@latest -- --template starlight/tailwind . --typescript strict
```

Accept defaults when prompted. This scaffolds the full project structure.

**Step 2: Verify the project builds**

```bash
npm run build
```

Expected: Build succeeds, output in `dist/`.

**Step 3: Verify dev server runs**

```bash
npm run dev
```

Expected: Dev server starts at `http://localhost:4321`.

**Step 4: Commit**

```bash
git init
git add .
git commit -m "chore: scaffold Astro + Starlight project with Tailwind"
```

---

### Task 2: Configure Starlight (social links, title, colors)

**Files:**
- Modify: `astro.config.mjs`
- Modify: `src/styles/global.css` (or equivalent Tailwind theme file)

**Step 1: Update astro.config.mjs with site config**

```javascript
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  integrations: [
    starlight({
      title: 'Locode',
      social: [
        { icon: 'github', label: 'GitHub', href: 'https://github.com/chocks/locode' },
        { icon: 'npm', label: 'npm', href: 'https://www.npmjs.com/package/@chocks-dev/locode' },
      ],
      sidebar: [
        {
          label: 'Getting Started',
          items: [
            { label: 'Installation', slug: 'getting-started/installation' },
            { label: 'Setup', slug: 'getting-started/setup' },
            { label: 'Quick Start', slug: 'getting-started/quick-start' },
          ],
        },
        {
          label: 'Usage',
          items: [
            { label: 'Interactive REPL', slug: 'usage/interactive-repl' },
            { label: 'Single-shot Mode', slug: 'usage/single-shot' },
            { label: 'CLI Reference', slug: 'usage/cli-reference' },
          ],
        },
        {
          label: 'Configuration',
          items: [
            { label: 'locode.yaml', slug: 'configuration/locode-yaml' },
            { label: 'Routing Rules', slug: 'configuration/routing-rules' },
            { label: 'Model Selection', slug: 'configuration/model-selection' },
          ],
        },
        {
          label: 'Advanced',
          items: [
            { label: 'MCP Servers', slug: 'advanced/mcp-servers' },
            { label: 'Benchmarking', slug: 'advanced/benchmarking' },
            { label: 'Telemetry', slug: 'advanced/telemetry' },
          ],
        },
      ],
      customCss: ['./src/styles/global.css'],
    }),
  ],
  vite: {
    plugins: [tailwindcss()],
  },
});
```

**Step 2: Configure teal accent colors in global.css**

Update `src/styles/global.css` to set Starlight's CSS custom properties for the teal color scheme:

```css
@layer base, starlight, theme, components, utilities;
@import '@astrojs/starlight-tailwind';
@import 'tailwindcss/theme.css' layer(theme);
@import 'tailwindcss/utilities.css' layer(utilities);

:root {
  --sl-color-accent-low: #083344;
  --sl-color-accent: #14b8a6;
  --sl-color-accent-high: #ccfbf1;
}

:root[data-theme='light'] {
  --sl-color-accent-low: #ccfbf1;
  --sl-color-accent: #0d9488;
  --sl-color-accent-high: #134e4a;
}
```

**Step 3: Verify the build**

```bash
npm run build
```

Expected: Build succeeds with updated config.

**Step 4: Commit**

```bash
git add astro.config.mjs src/styles/global.css
git commit -m "feat: configure Starlight with social links, sidebar, and teal color scheme"
```

---

### Task 3: Create the landing/splash page

**Files:**
- Modify: `src/content/docs/index.mdx`

**Step 1: Create the splash landing page**

Replace `src/content/docs/index.mdx` with:

```mdx
---
title: Locode
description: Local-first AI coding CLI. Routes simple tasks to Ollama, complex tasks to Claude. Save tokens, save money.
template: splash
hero:
  title: Local-first AI coding CLI
  tagline: Routes simple tasks to Ollama, complex tasks to Claude. Save tokens, save money.
  actions:
    - text: Get Started
      link: /getting-started/installation/
      icon: right-arrow
    - text: GitHub
      link: https://github.com/chocks/locode
      icon: external
      variant: minimal
---

import { Card, CardGrid } from '@astrojs/starlight/components';

## How It Works

<CardGrid>
  <Card title="1. You type" icon="pencil">
    Write your prompt — a question, a task, a code request.
  </Card>
  <Card title="2. Locode routes" icon="random">
    Smart classification using regex rules and LLM-assisted routing decides which model handles it.
  </Card>
  <Card title="3. Right model responds" icon="rocket">
    Simple tasks go to Ollama (free, local). Complex tasks go to Claude (powerful, cloud).
  </Card>
</CardGrid>

## Features

<CardGrid>
  <Card title="Smart Routing" icon="setting">
    Regex rules + LLM-assisted classification. Configurable thresholds and patterns in `locode.yaml`.
  </Card>
  <Card title="Token Savings" icon="approve-check-circle">
    Track per-agent and total token usage with USD cost estimates. Benchmark hybrid vs claude-only vs local-only.
  </Card>
  <Card title="Offline Ready" icon="laptop">
    Works entirely offline without an API key. Falls back to Ollama automatically when Claude is unavailable.
  </Card>
  <Card title="MCP Support" icon="puzzle">
    Extend with Model Context Protocol servers — including remote ones like Linear.
  </Card>
</CardGrid>

## Quick Start

```bash
# Install
npm install -g @chocks-dev/locode

# First-time setup
locode setup

# Start coding
locode
```
```
```

**Step 2: Verify the landing page renders**

```bash
npm run dev
```

Expected: Landing page shows at `http://localhost:4321` with hero, cards, and quick start.

**Step 3: Commit**

```bash
git add src/content/docs/index.mdx
git commit -m "feat: add landing page with hero, features, and quick start"
```

---

### Task 4: Create documentation pages (stubs)

**Files:**
- Create: `src/content/docs/getting-started/installation.md`
- Create: `src/content/docs/getting-started/setup.md`
- Create: `src/content/docs/getting-started/quick-start.md`
- Create: `src/content/docs/usage/interactive-repl.md`
- Create: `src/content/docs/usage/single-shot.md`
- Create: `src/content/docs/usage/cli-reference.md`
- Create: `src/content/docs/configuration/locode-yaml.md`
- Create: `src/content/docs/configuration/routing-rules.md`
- Create: `src/content/docs/configuration/model-selection.md`
- Create: `src/content/docs/advanced/mcp-servers.md`
- Create: `src/content/docs/advanced/benchmarking.md`
- Create: `src/content/docs/advanced/telemetry.md`

**Step 1: Create all doc stubs**

Create each file with appropriate frontmatter and initial content pulled from the locode README. Each file should have:

```markdown
---
title: [Page Title]
description: [Brief description]
---

[Content derived from locode README and CLI help]
```

Populate the Getting Started pages with real content from the locode README (installation commands, setup wizard description, first-run instructions). Other pages can start as stubs with TODO markers.

**Step 2: Verify all sidebar links resolve**

```bash
npm run build
```

Expected: Build succeeds with no broken links.

**Step 3: Commit**

```bash
git add src/content/docs/
git commit -m "feat: add documentation pages with initial content"
```

---

### Task 5: Populate docs with content from locode README

**Files:**
- Modify: All doc pages from Task 4

**Step 1: Read the locode README**

```bash
cat /Users/chockalingameswaramurthy/Documents/repos/locode/README.md
```

**Step 2: Distribute README content into doc pages**

Map README sections to doc pages:
- Installation section → `getting-started/installation.md`
- Setup wizard section → `getting-started/setup.md`
- Quick start / usage → `getting-started/quick-start.md`
- REPL mode → `usage/interactive-repl.md`
- `locode run` → `usage/single-shot.md`
- CLI flags and commands → `usage/cli-reference.md`
- Config file format → `configuration/locode-yaml.md`
- Routing rules → `configuration/routing-rules.md`
- Model config → `configuration/model-selection.md`
- MCP → `advanced/mcp-servers.md`
- Benchmark → `advanced/benchmarking.md`
- Telemetry → `advanced/telemetry.md`

**Step 3: Verify build**

```bash
npm run build
```

Expected: Build succeeds.

**Step 4: Commit**

```bash
git add src/content/docs/
git commit -m "docs: populate documentation from locode README"
```

---

### Task 6: Add custom landing page sections with Tailwind

**Files:**
- Create: `src/components/HowItWorks.astro`
- Create: `src/components/CostComparison.astro`
- Modify: `src/content/docs/index.mdx`

**Step 1: Create the HowItWorks component**

A horizontal 3-step flow diagram using Tailwind:

```astro
---
// src/components/HowItWorks.astro
---
<section class="py-16 px-4">
  <div class="max-w-4xl mx-auto">
    <div class="grid grid-cols-1 md:grid-cols-3 gap-8 text-center">
      <div>
        <div class="text-4xl mb-4">⌨️</div>
        <h3 class="text-lg font-semibold mb-2">You type</h3>
        <p class="text-sm opacity-75">Write your prompt — a question, a task, a code request.</p>
      </div>
      <div>
        <div class="text-4xl mb-4">🔀</div>
        <h3 class="text-lg font-semibold mb-2">Locode routes</h3>
        <p class="text-sm opacity-75">Smart classification decides which model handles it.</p>
      </div>
      <div>
        <div class="text-4xl mb-4">🚀</div>
        <h3 class="text-lg font-semibold mb-2">Right model responds</h3>
        <p class="text-sm opacity-75">Ollama for simple tasks. Claude for complex ones.</p>
      </div>
    </div>
  </div>
</section>
```

**Step 2: Create the CostComparison component**

A comparison table showing token savings:

```astro
---
// src/components/CostComparison.astro
---
<section class="py-16 px-4">
  <div class="max-w-3xl mx-auto">
    <h2 class="text-2xl font-bold text-center mb-8">Save on Every Session</h2>
    <table class="w-full text-left border-collapse">
      <thead>
        <tr class="border-b border-gray-600">
          <th class="py-3 px-4">Mode</th>
          <th class="py-3 px-4">Claude Tokens</th>
          <th class="py-3 px-4">Estimated Cost</th>
        </tr>
      </thead>
      <tbody>
        <tr class="border-b border-gray-800">
          <td class="py-3 px-4">Claude-only</td>
          <td class="py-3 px-4">100%</td>
          <td class="py-3 px-4">$$$</td>
        </tr>
        <tr class="border-b border-gray-800">
          <td class="py-3 px-4 font-semibold text-teal-400">Hybrid (locode)</td>
          <td class="py-3 px-4 font-semibold text-teal-400">~40-60%</td>
          <td class="py-3 px-4 font-semibold text-teal-400">$</td>
        </tr>
        <tr>
          <td class="py-3 px-4">Local-only</td>
          <td class="py-3 px-4">0%</td>
          <td class="py-3 px-4">Free</td>
        </tr>
      </tbody>
    </table>
  </div>
</section>
```

**Step 3: Import components into the landing page**

Update `src/content/docs/index.mdx` to import and use these components alongside or replacing the Card-based sections.

**Step 4: Verify rendering**

```bash
npm run dev
```

Expected: Landing page shows custom HowItWorks flow and CostComparison table.

**Step 5: Commit**

```bash
git add src/components/ src/content/docs/index.mdx
git commit -m "feat: add custom HowItWorks and CostComparison landing page sections"
```

---

### Task 7: Set up Cloudflare Pages deployment config

**Files:**
- Create: `wrangler.toml` (optional, for local preview)
- Create: `.github/workflows/deploy.yml`

**Step 1: Create the GitHub Actions deploy workflow**

```yaml
# .github/workflows/deploy.yml
name: Deploy to Cloudflare Pages

on:
  push:
    branches: [main]
  repository_dispatch:
    types: [docs-updated]

jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      deployments: write
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20

      - run: npm ci
      - run: npm run build

      - name: Deploy to Cloudflare Pages
        uses: cloudflare/wrangler-action@v3
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          command: pages deploy dist --project-name=locode
```

**Step 2: Create .gitignore if not present**

Ensure `node_modules/`, `dist/`, and `.astro/` are in `.gitignore`.

**Step 3: Verify build still works**

```bash
npm run build
```

Expected: Build succeeds.

**Step 4: Commit**

```bash
git add .github/workflows/deploy.yml .gitignore
git commit -m "ci: add Cloudflare Pages deployment workflow"
```

---

### Task 8: Set up docs sync from locode repo

**Files:**
- Create: `.github/workflows/sync-docs.yml`
- Create: `scripts/sync-docs.sh`

**Step 1: Create the sync script**

```bash
#!/usr/bin/env bash
# scripts/sync-docs.sh
# Pulls README.md from locode repo and places it for reference

set -euo pipefail

LOCODE_REPO="chocks/locode"
BRANCH="main"

# Download README
curl -sL "https://raw.githubusercontent.com/${LOCODE_REPO}/${BRANCH}/README.md" \
  -o src/content/docs/_locode-readme.md

# Download default config for reference
curl -sL "https://raw.githubusercontent.com/${LOCODE_REPO}/${BRANCH}/locode.yaml" \
  -o src/content/docs/configuration/_locode-default.yaml

echo "Docs synced from ${LOCODE_REPO}@${BRANCH}"
```

**Step 2: Create the sync workflow**

```yaml
# .github/workflows/sync-docs.yml
name: Sync docs from locode repo

on:
  repository_dispatch:
    types: [docs-updated]
  workflow_dispatch:

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Sync docs
        run: bash scripts/sync-docs.sh

      - name: Check for changes
        id: changes
        run: |
          git diff --quiet || echo "changed=true" >> $GITHUB_OUTPUT

      - name: Commit and push
        if: steps.changes.outputs.changed == 'true'
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add -A
          git commit -m "docs: sync from locode repo"
          git push
```

**Step 3: Commit**

```bash
chmod +x scripts/sync-docs.sh
git add scripts/sync-docs.sh .github/workflows/sync-docs.yml
git commit -m "ci: add docs sync workflow from locode repo"
```

---

### Task 9: Final polish and verification

**Step 1: Run full build**

```bash
npm run build
```

Expected: Clean build, no warnings.

**Step 2: Preview locally**

```bash
npm run preview
```

Expected: Site renders correctly at localhost with:
- Landing page with hero, how it works, features, cost comparison, quick start
- GitHub and npm links in header
- Dark/light mode toggle works
- All docs pages accessible via sidebar
- No broken links

**Step 3: Final commit**

```bash
git add -A
git commit -m "chore: final polish and cleanup"
```

**Step 4: Push to GitHub**

```bash
git remote add origin https://github.com/chocks/locodecli-site.git
git push -u origin main
```
