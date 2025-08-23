#!/usr/bin/env bash
set -euo pipefail

CHARTS_DIR="charts"
GHCR_ORG="https://github.com/users/ocraviotto/packages/container/package/charts%2F"
README_FILE="README.md"

START_MARK="<!-- CHARTS_TABLE_START -->"
END_MARK="<!-- CHARTS_TABLE_END -->"

# Detect sed in-place option (macOS vs GNU)
if sed --version >/dev/null 2>&1; then
  SED_INPLACE=(sed -i)
else
  SED_INPLACE=(sed -i '')
fi

# Collect chart rows
rows=""
for chart in "$CHARTS_DIR"/*; do
  if [[ -d "$chart" && -f "$chart/Chart.yaml" ]]; then
    name=$(yq e '.name' "$chart/Chart.yaml")
    desc=$(yq e '.description' "$chart/Chart.yaml")
    version=$(yq e '.version' "$chart/Chart.yaml")
    readme_link="[$name]($chart/README.md)"
    ghcr_link="[ghcr.io](${GHCR_ORG}$name)"
    rows+="| $readme_link | $desc | $version | $ghcr_link |\n"
  fi
done

# Build table
table="| Chart | Description | Version | Packages |
|-------|-------------|---------|----------|
${rows%\\n}"

if grep -q "$START_MARK" "$README_FILE"; then
  # 1. Delete only the lines between the markers (exclusive)
  "${SED_INPLACE[@]}" "/$START_MARK/,/$END_MARK/{//!d}" "$README_FILE"

  # 2. Insert table right after START_MARK
  awk -v start="$START_MARK" -v tbl="$table" '
    { print }
    $0 ~ start { print tbl }
  ' "$README_FILE" >"$README_FILE.tmp" && mv "$README_FILE.tmp" "$README_FILE"
else
  # Append fresh block at end
  {
    echo
    echo "$START_MARK"
    echo "$table"
    echo "$END_MARK"
  } >>"$README_FILE"
fi

echo "✅ Updated charts table in $README_FILE"
