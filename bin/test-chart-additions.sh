# shellcheck shell=bash
set -euo pipefail

chart="$1"

if [[ -f "$chart/ci/test-migration.sh" ]]; then
  bash "$chart/ci/test-migration.sh" "$chart"
fi
