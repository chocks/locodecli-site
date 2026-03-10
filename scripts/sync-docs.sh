#!/usr/bin/env bash
# scripts/sync-docs.sh
# Pulls locode.yaml from the locode repo and syncs specific sections
# into the docs using <!-- sync:start name="..." --> / <!-- sync:end --> markers.
#
# Requires: curl, yq (pre-installed on ubuntu-latest), python3

set -euo pipefail

LOCODE_REPO="chocks/locode"
BRANCH="main"
LOCODE_YAML="locode.yaml"

# Download locode.yaml
curl -sL "https://raw.githubusercontent.com/${LOCODE_REPO}/${BRANCH}/locode.yaml" \
  -o "$LOCODE_YAML"

echo "Downloaded locode.yaml from ${LOCODE_REPO}@${BRANCH}"

# ── Extract values ────────────────────────────────────────────────────────────
# yq -r strips surrounding quotes from scalar values (works with both
# mikefarah/yq used on ubuntu-latest CI and the kislyuk/yq jq wrapper).
# For the routing block we use python3+PyYAML to guarantee YAML output
# regardless of which yq flavour is installed.

DEFAULT_MODEL=$(yq -r '.local_llm.model' "$LOCODE_YAML")
ESCALATION_THRESHOLD=$(yq -r '.routing.escalation_threshold' "$LOCODE_YAML")
ROUTING_BLOCK=$(python3 -c "
import yaml
with open('$LOCODE_YAML') as f:
    data = yaml.safe_load(f)
print(yaml.dump({'routing': data['routing']}, default_flow_style=False).rstrip())
")
FULL_YAML=$(cat "$LOCODE_YAML")

# ── Replace content between sync markers ─────────────────────────────────────
# Usage: sync_section <file> <name> <new_content>

sync_section() {
  local file="$1" name="$2" content="$3"

  python3 - "$file" "$name" "$content" <<'PYEOF'
import sys, re

file_path, name, content = sys.argv[1], sys.argv[2], sys.argv[3]

with open(file_path) as f:
    text = f.read()

start = f'<!-- sync:start name="{name}" -->'
end   = '<!-- sync:end -->'
pat   = rf'({re.escape(start)}\n).*?(\n{re.escape(end)})'

if not re.search(pat, text, flags=re.DOTALL):
    print(f"  WARNING: marker '{name}' not found in {file_path}", file=sys.stderr)
    sys.exit(0)

with open(file_path, 'w') as f:
    f.write(re.sub(pat, rf'\g<1>{content}\2', text, flags=re.DOTALL))

print(f"  Synced '{name}' in {file_path}")
PYEOF
}

# ── Sync sections ─────────────────────────────────────────────────────────────

# configuration/locode-yaml.md
sync_section \
  "src/content/docs/configuration/locode-yaml.md" \
  "key-settings" \
  "| Key | Description | Default |
|-----|-------------|---------|
| \`local_llm.model\` | Ollama model to use for local tasks | \`${DEFAULT_MODEL}\` |
| \`routing.rules\` | Regex patterns that route tasks to local or Claude | — |
| \`routing.escalation_threshold\` | Confidence below this value escalates to Claude | \`${ESCALATION_THRESHOLD}\` |"

sync_section \
  "src/content/docs/configuration/locode-yaml.md" \
  "default-config" \
  "\`\`\`yaml
${FULL_YAML}
\`\`\`"

# configuration/model-selection.md
sync_section \
  "src/content/docs/configuration/model-selection.md" \
  "default-model" \
  "The default model is **\`${DEFAULT_MODEL}\`** — a good balance of coding ability and resource usage."

sync_section \
  "src/content/docs/configuration/model-selection.md" \
  "model-yaml-example" \
  "\`\`\`yaml
local_llm:
  model: ${DEFAULT_MODEL}
\`\`\`"

# configuration/routing-rules.md
sync_section \
  "src/content/docs/configuration/routing-rules.md" \
  "routing-rules" \
  "\`\`\`yaml
${ROUTING_BLOCK}
\`\`\`"

sync_section \
  "src/content/docs/configuration/routing-rules.md" \
  "escalation-threshold" \
  "The \`escalation_threshold\` is a confidence value between 0 and 1. When the router's confidence that a task can be handled locally falls below this threshold, the task is escalated to Claude.

- **Lower threshold** (e.g., 0.3) — more tasks stay local, saves tokens, but some complex tasks may get weaker responses.
- **Higher threshold** (e.g., 0.8) — more tasks go to Claude, better quality, but higher token cost.
- **Current default**: \`${ESCALATION_THRESHOLD}\`"

echo "Docs synced from ${LOCODE_REPO}@${BRANCH}"
