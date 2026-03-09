import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  integrations: [
    starlight({
      title: 'Locode',
      social: [
        { icon: 'github', label: 'GitHub', href: 'https://github.com/chocks/locode' },
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
