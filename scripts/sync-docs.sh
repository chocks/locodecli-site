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
