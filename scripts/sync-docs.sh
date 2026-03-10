#!/usr/bin/env bash
# scripts/sync-docs.sh
# Pulls locode.yaml from the locode repo and syncs specific sections
# into the docs using <!-- sync:start name="..." --> / <!-- sync:end --> markers.

set -euo pipefail

LOCODE_REPO="chocks/locode"
BRANCH="main"
TMPDIR_WORK=$(mktemp -d)
trap "rm -rf $TMPDIR_WORK" EXIT

# Download locode.yaml
curl -sL "https://raw.githubusercontent.com/${LOCODE_REPO}/${BRANCH}/locode.yaml" \
  -o "$TMPDIR_WORK/locode.yaml"

echo "Downloaded locode.yaml from ${LOCODE_REPO}@${BRANCH}"

# Helper: replace content between sync markers in a file
# Usage: sync_section <file> <name> <new_content>
sync_section() {
  local file="$1"
  local name="$2"
  local content="$3"

  python3 - "$file" "$name" "$content" <<'PYEOF'
import sys, re

file_path, name, content = sys.argv[1], sys.argv[2], sys.argv[3]

with open(file_path, 'r') as f:
    text = f.read()

start_tag = f'<!-- sync:start name="{name}" -->'
end_tag   = '<!-- sync:end -->'
pattern   = rf'({re.escape(start_tag)}\n).*?(\n{re.escape(end_tag)})'

if not re.search(pattern, text, flags=re.DOTALL):
    print(f"  WARNING: marker '{name}' not found in {file_path}", file=sys.stderr)
    sys.exit(0)

new_text = re.sub(pattern, rf'\g<1>{content}\2', text, flags=re.DOTALL)

with open(file_path, 'w') as f:
    f.write(new_text)

print(f"  Synced '{name}' in {file_path}")
PYEOF
}

# ── Extract values from locode.yaml with Python ──────────────────────────────

read_yaml() {
  python3 - "$TMPDIR_WORK/locode.yaml" "$1" <<'PYEOF'
import sys, re

with open(sys.argv[1]) as f:
    content = f.read()

key = sys.argv[2]

# Extract a top-level block (key: ...) up to the next top-level key or EOF
pattern = rf'^({re.escape(key)}:.*?)(?=^\w|\Z)'
m = re.search(pattern, content, re.MULTILINE | re.DOTALL)
if m:
    print(m.group(1).rstrip())
PYEOF
}

DEFAULT_MODEL=$(python3 -c "
import re
with open('$TMPDIR_WORK/locode.yaml') as f:
    content = f.read()
m = re.search(r'^\s*model:\s*(\S+)', content, re.MULTILINE)
if m:
    print(m.group(1))
")

ROUTING_BLOCK=$(read_yaml "routing")
FULL_YAML=$(cat "$TMPDIR_WORK/locode.yaml")

# ── 1. configuration/locode-yaml.md — full default config ────────────────────
sync_section \
  "src/content/docs/configuration/locode-yaml.md" \
  "default-config" \
  "\`\`\`yaml
${FULL_YAML}
\`\`\`"

# ── 2. configuration/locode-yaml.md — key settings table ─────────────────────
ESCALATION_THRESHOLD=$(python3 -c "
import re
with open('$TMPDIR_WORK/locode.yaml') as f:
    content = f.read()
m = re.search(r'escalation_threshold:\s*(\S+)', content)
if m:
    print(m.group(1))
")

sync_section \
  "src/content/docs/configuration/locode-yaml.md" \
  "key-settings" \
  "| Key | Description | Default |
|-----|-------------|---------|
| \`local_llm.model\` | Ollama model to use for local tasks | \`${DEFAULT_MODEL}\` |
| \`routing.rules\` | Regex patterns that route tasks to local or Claude | — |
| \`routing.escalation_threshold\` | Confidence below this value escalates to Claude | \`${ESCALATION_THRESHOLD}\` |"

# ── 3. configuration/model-selection.md — default model description ───────────
sync_section \
  "src/content/docs/configuration/model-selection.md" \
  "default-model" \
  "The default model is **\`${DEFAULT_MODEL}\`** — a good balance of coding ability and resource usage."

# ── 4. configuration/model-selection.md — yaml snippet ───────────────────────
sync_section \
  "src/content/docs/configuration/model-selection.md" \
  "model-yaml-example" \
  "\`\`\`yaml
local_llm:
  model: ${DEFAULT_MODEL}
\`\`\`"

# ── 5. configuration/routing-rules.md — routing rules example ────────────────
sync_section \
  "src/content/docs/configuration/routing-rules.md" \
  "routing-rules" \
  "\`\`\`yaml
${ROUTING_BLOCK}
\`\`\`"

# ── 6. configuration/routing-rules.md — escalation threshold blurb ───────────
sync_section \
  "src/content/docs/configuration/routing-rules.md" \
  "escalation-threshold" \
  "The \`escalation_threshold\` is a confidence value between 0 and 1. When the router's confidence that a task can be handled locally falls below this threshold, the task is escalated to Claude.

- **Lower threshold** (e.g., 0.3) — more tasks stay local, saves tokens, but some complex tasks may get weaker responses.
- **Higher threshold** (e.g., 0.8) — more tasks go to Claude, better quality, but higher token cost.
- **Current default**: \`${ESCALATION_THRESHOLD}\`"

echo "Docs synced from ${LOCODE_REPO}@${BRANCH}"
