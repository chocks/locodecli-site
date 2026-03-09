# CLAUDE.md — locodecli-site

Documentation site for [Locode](https://github.com/chocks/locode), a local-first AI coding CLI.
npm package: `@chocks-dev/locode`

## Tech Stack

- **Astro** + **Starlight** (docs framework) + **Tailwind CSS v4**
- Deployed on **Cloudflare Pages** (built-in CI/CD, no GitHub Actions needed for deploy)
- Content in MDX at `src/content/docs/`

## Project Structure

```
src/
  content/docs/        # MDX pages (index.mdx is the splash landing page)
    getting-started/   # Installation, Setup, Quick Start
    usage/             # Interactive REPL, Single-shot, CLI Reference
    configuration/     # locode.yaml, Routing Rules, Model Selection
    advanced/          # MCP Servers, Benchmarking, Telemetry
  components/          # Custom Astro components (HowItWorks, CostComparison)
  styles/global.css    # Starlight theme overrides + Tailwind (teal accent)
astro.config.mjs       # Starlight config, sidebar, social links
.github/workflows/
  sync-docs.yml        # Syncs docs from the main locode repo via repository_dispatch
  ci.yml               # Runs astro check + build on PRs
```

## Commands

- `npm run dev` — local dev server
- `npm run build` — production build (outputs to `dist/`)
- `npm run preview` — preview production build locally
- `npx astro check` — validate Astro/MDX files for type errors and bad imports

## Key Conventions

- Landing page (`index.mdx`) uses Starlight's `splash` template with custom components
- Sidebar is explicitly defined in `astro.config.mjs` (not auto-generated)
- Starlight built-in components (`Card`, `CardGrid`, `Aside`, etc.) are preferred over custom ones
- The site includes an alpha software warning matching the locode README
- npm version badge from shields.io on the landing page
- Theme colors: teal accent (`#14b8a6` dark / `#0d9488` light)

## CI

The `ci.yml` workflow runs on all PRs to main. It runs `astro check` (validates MDX/Astro files) and `npm run build` (full production build). Both must pass before merge.

## Docs Sync

The `sync-docs.yml` workflow pulls docs from the main locode repo when triggered via `repository_dispatch` (type: `docs-updated`) or manually. It runs `scripts/sync-docs.sh`.
