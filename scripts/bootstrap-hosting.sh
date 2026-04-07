#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${1:-https://github.com/ReynierMatth/fallout2d20-helper.git}"
TARGET_DIR="${2:-fallout2d20-helper}"

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
