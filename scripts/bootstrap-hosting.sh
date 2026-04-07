#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${1:-https://github.com/katrinsurkova2d20-prog/fallout-helper.git}"
TARGET_DIR="${2:-fallout-helper}"
REPO_SLUG="${REPO_URL#https://github.com/}"
REPO_SLUG="${REPO_SLUG%.git}"
BRANCH="${BRANCH:-main}"
ARCHIVE_URL="https://codeload.github.com/${REPO_SLUG}/tar.gz/refs/heads/${BRANCH}"

download_archive() {
  local archive_path="$1"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$ARCHIVE_URL" -o "$archive_path"
    return 0
  fi
  if command -v wget >/dev/null 2>&1; then
    wget -qO "$archive_path" "$ARCHIVE_URL"
    return 0
  fi
  echo "❌ Need one of: curl or wget (git is not installed)."
  exit 1
}

if command -v git >/dev/null 2>&1; then
  if [[ -d "$TARGET_DIR/.git" ]]; then
    echo "🔄 Repository already exists, pulling latest changes..."
    git -C "$TARGET_DIR" pull --ff-only
  else
    echo "⬇️ Cloning repository with git..."
    git clone "$REPO_URL" "$TARGET_DIR"
  fi
else
  echo "ℹ️ git not found, downloading source archive..."
  tmp_dir="$(mktemp -d)"
  archive_path="$tmp_dir/repo.tar.gz"
  download_archive "$archive_path"

  extracted_dir="$tmp_dir/${REPO_SLUG##*/}-${BRANCH}"
  tar -xzf "$archive_path" -C "$tmp_dir"

  rm -rf "$TARGET_DIR"
  mv "$extracted_dir" "$TARGET_DIR"
fi

echo "🚀 Running setup script..."
"$TARGET_DIR/scripts/setup-dev.sh"
