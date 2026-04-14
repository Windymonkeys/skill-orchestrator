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
# Only skill payload: ClawHub web rejects extensionless dotfiles (.gitignore, .clawhubignore);
# omit dev-only paths (scripts/, etc.).
git -C "$ROOT" archive HEAD SKILL.md references | tar -x -C "$DEST"

exported="$(find "$DEST" -type f | wc -l | awk '{print $1}')"

echo "Exported to: $DEST"
echo "Upload bundle files: $exported (SKILL.md + references/ only)"
echo "Use this folder in ClawHub; do not select the repo root that contains .git/."
