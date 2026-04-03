#!/usr/bin/env bash
set -euo pipefail

# Fetches the 3 most recent releases from chocks/locode and writes src/data/updates.json
# Requires: gh CLI authenticated, jq

REPO="chocks/locode"
OUTPUT="src/data/updates.json"

gh release list --repo "$REPO" --limit 3 --json tagName,publishedAt,name \
  --jq '[.[] | {
    title: (if .name != "" then .name else .tagName end),
    date: (.publishedAt | split("T")[0]),
    description: "",
    link: ("https://github.com/'"$REPO"'/releases/tag/" + .tagName)
  }]' > /tmp/updates_base.json

# Fetch release body for each and extract the first feat/fix line as description
for i in 0 1 2; do
  tag=$(jq -r ".[$i].link" /tmp/updates_base.json | xargs basename)
  body=$(gh release view "$tag" --repo "$REPO" --json body --jq '.body' 2>/dev/null || echo "")

  # Extract first feat: or fix: line from "* feat: description by @user ..." format
  desc=$(echo "$body" | grep -m1 -E '\* (feat|fix):' | sed 's/.*\* feat: //' | sed 's/.*\* fix: //' | sed 's/ by @.*//' || true)
  # Capitalize first letter
  if [ -n "$desc" ]; then
    desc="$(echo "$desc" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')"
  fi

  if [ -z "$desc" ]; then
    desc="See release notes for details."
  fi

  jq --argjson i "$i" --arg desc "$desc" '.[$i].description = $desc' /tmp/updates_base.json > /tmp/updates_tmp.json
  mv /tmp/updates_tmp.json /tmp/updates_base.json
done

jq '.' /tmp/updates_base.json > "$OUTPUT"
echo "Updated $OUTPUT with latest 3 releases from $REPO"
