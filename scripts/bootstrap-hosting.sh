#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${1:-https://github.com/katrinsurkova2d20-prog/fallout-helper.git}"
TARGET_DIR_INPUT="${2:-${TARGET_DIR:-}}"
if [[ -n "$TARGET_DIR_INPUT" ]]; then
  TARGET_DIR="$TARGET_DIR_INPUT"
elif [[ "$(basename "$PWD")" == "www" ]]; then
  TARGET_DIR="."
else
  TARGET_DIR="fallout-helper"
fi
REPO_SLUG="${REPO_URL#https://github.com/}"
REPO_SLUG="${REPO_SLUG%.git}"
BRANCH="${BRANCH:-main}"
ARCHIVE_URL="https://codeload.github.com/${REPO_SLUG}/tar.gz/refs/heads/${BRANCH}"

run_remote_script() {
  local url="$1"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" | bash
    return 0
  fi
  if command -v wget >/dev/null 2>&1; then
    wget -qO- "$url" | bash
    return 0
  fi
  return 1
}

ensure_node_tooling() {
  if command -v npm >/dev/null 2>&1 && command -v npx >/dev/null 2>&1; then
    return 0
  fi

  echo "ℹ️ npm/npx not found. Trying to install Node.js LTS via nvm..."
  local nvm_install_url="https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh"

  if ! run_remote_script "$nvm_install_url"; then
    echo "❌ Failed to download nvm installer. Install Node.js 22+ manually and rerun."
    exit 1
  fi

  export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
  if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    # shellcheck source=/dev/null
    . "$NVM_DIR/nvm.sh"
  else
    echo "❌ nvm installation was not detected at $NVM_DIR. Install Node.js 22+ manually and rerun."
    exit 1
  fi

  nvm install --lts >/dev/null
  nvm use --lts >/dev/null

  if ! command -v npm >/dev/null 2>&1 || ! command -v npx >/dev/null 2>&1; then
    echo "❌ Node.js was installed but npm/npx are still unavailable."
    exit 1
  fi

  echo "✅ Node.js tooling installed: $(node -v), $(npm -v)"
}

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

prepare_target_dir() {
  if [[ "$TARGET_DIR" != "." ]]; then
    return 0
  fi

  if [[ "${FORCE_OVERWRITE:-0}" != "1" ]] && [[ -n "$(find . -mindepth 1 -maxdepth 1 -not -name '.well-known' -print -quit)" ]]; then
    echo "❌ Current directory is not empty."
    echo "   Use an empty www directory, or rerun with FORCE_OVERWRITE=1 to overwrite files in place."
    exit 1
  fi

  echo "ℹ️ Target directory is current folder (.)"
}

extract_archive_to_target() {
  local tmp_dir archive_path extracted_dir
  tmp_dir="$(mktemp -d)"
  archive_path="$tmp_dir/repo.tar.gz"
  download_archive "$archive_path"

  if [[ "$TARGET_DIR" == "." ]]; then
    if [[ "${FORCE_OVERWRITE:-0}" == "1" ]]; then
      find . -mindepth 1 -maxdepth 1 -not -name '.well-known' -exec rm -rf {} +
    fi
    tar -xzf "$archive_path" -C . --strip-components=1
  else
    extracted_dir="$tmp_dir/${REPO_SLUG##*/}-${BRANCH}"
    tar -xzf "$archive_path" -C "$tmp_dir"
    rm -rf "$TARGET_DIR"
    mv "$extracted_dir" "$TARGET_DIR"
  fi
}

prepare_target_dir

if command -v git >/dev/null 2>&1 && [[ "$TARGET_DIR" != "." ]]; then
  if [[ -d "$TARGET_DIR/.git" ]]; then
    echo "🔄 Repository already exists, pulling latest changes..."
    git -C "$TARGET_DIR" pull --ff-only
  else
    echo "⬇️ Cloning repository with git..."
    git clone "$REPO_URL" "$TARGET_DIR"
  fi
else
  if [[ "$TARGET_DIR" == "." ]]; then
    echo "ℹ️ Installing into current directory from source archive..."
  else
    echo "ℹ️ git not found, downloading source archive..."
  fi
  extract_archive_to_target
fi

ensure_node_tooling

echo "🚀 Running setup script..."
"${TARGET_DIR}/scripts/setup-dev.sh"
