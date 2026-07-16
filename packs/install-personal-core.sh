#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
PACK="$ROOT/packs/personal-core.json"
SKILLS=$(node -e "console.log(require('./packs/personal-core.json').install.skills_csv)")
TARGET="${1:-agents}"
case "$TARGET" in
  agents) DEST="${HOME}/.agents/skills" ;;
  claude) DEST="${HOME}/.claude/skills" ;;
  cursor) DEST="${PWD}/.cursor/skills" ;;
  codex)  DEST="${HOME}/.codex/skills" ;;
  *) DEST="$TARGET" ;;
esac
echo "Installing personal-core -> $DEST"
test -d node_modules || npm ci
node tools/bin/install.js --path "$DEST" --skills "$SKILLS"
echo "Done."
