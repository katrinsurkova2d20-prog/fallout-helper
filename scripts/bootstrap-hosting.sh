#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${1:-https://github.com/katrinsurkova2d20-prog/fallout-helper.git}"
TARGET_DIR="${2:-fallout-helper}"

if ! command -v git >/dev/null 2>&1; then
  echo "❌ git is required"
  exit 1
fi

if [[ -d "$TARGET_DIR/.git" ]]; then
  echo "🔄 Repository already exists, pulling latest changes..."
  git -C "$TARGET_DIR" pull --ff-only
else
  echo "⬇️ Cloning repository..."
  git clone "$REPO_URL" "$TARGET_DIR"
fi

echo "🚀 Running setup script..."
"$TARGET_DIR/scripts/setup-dev.sh"
