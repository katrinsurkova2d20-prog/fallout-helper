#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACK_DIR="$ROOT_DIR/back"
FRONT_DIR="$ROOT_DIR/front"

if ! command -v npm >/dev/null 2>&1; then
  echo "❌ npm not found. Install Node.js 22+ (or run scripts/bootstrap-hosting.sh which can install Node via nvm)."
  exit 1
fi

if ! command -v npx >/dev/null 2>&1; then
  echo "❌ npx not found. Install Node.js 22+ (or run scripts/bootstrap-hosting.sh which can install Node via nvm)."
  exit 1
fi

if [[ ! -f "$BACK_DIR/.env" ]]; then
  cp "$BACK_DIR/.env.example" "$BACK_DIR/.env"
  echo "ℹ️ Created back/.env from back/.env.example"
  echo "⚠️ Edit back/.env and set DATABASE_URL for your PostgreSQL before starting the backend."
fi

echo "📦 Installing backend dependencies..."
cd "$BACK_DIR"
npm install --include=dev

if [[ ! -x "$BACK_DIR/node_modules/.bin/drizzle-kit" || ! -x "$BACK_DIR/node_modules/.bin/tsx" ]]; then
  echo "ℹ️ Dev tools are missing after npm install (some hostings force production-only install)."
  echo "ℹ️ Installing required CLI tools locally (without changing package.json)..."
  npm install --no-save drizzle-kit tsx
fi

echo "🗄️ Running migrations..."
npm run db:migrate

echo "🌱 Seeding database..."
npm run db:seed

echo "📦 Installing frontend dependencies..."
cd "$FRONT_DIR"
npm install --include=dev

echo "✅ Setup complete."
echo "Run in two terminals:"
echo "  1) cd back && npx tsx src/index.ts"
echo "  2) cd front && npm run dev"
