#!/usr/bin/env bash
# Build a clean folder for ClawHub web upload (tracked files only, no .git).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="${1:-"$ROOT/../skill-orchestrator-for-clawhub"}"

if [[ ! -d "$ROOT/.git" ]]; then
  echo "error: need a git clone at: $ROOT" >&2
  exit 1
fi

rm -rf "$DEST"
mkdir -p "$DEST"
git -C "$ROOT" archive HEAD | tar -x -C "$DEST"

tracked="$(git -C "$ROOT" ls-files | wc -l | awk '{print $1}')"
exported="$(find "$DEST" -type f | wc -l | awk '{print $1}')"

echo "Exported to: $DEST"
echo "Files: $exported (git tracked: $tracked)"
echo "Use this folder in ClawHub; do not select the repo root that contains .git/."
