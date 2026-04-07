#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACK_DIR="$ROOT_DIR/back"
FRONT_DIR="$ROOT_DIR/front"
DEFAULT_DATABASE_URL="postgresql://fallout:fallout2d20@localhost:5432/fallout2d20"

if ! command -v npm >/dev/null 2>&1; then
  echo "❌ npm not found. Install Node.js 22+ (or run scripts/bootstrap-hosting.sh which can install Node via nvm)."
  exit 1
fi

if ! command -v npx >/dev/null 2>&1; then
  echo "❌ npx not found. Install Node.js 22+ (or run scripts/bootstrap-hosting.sh which can install Node via nvm)."
  exit 1
fi

created_env=0
if [[ ! -f "$BACK_DIR/.env" ]]; then
  cp "$BACK_DIR/.env.example" "$BACK_DIR/.env"
  created_env=1
  echo "ℹ️ Created back/.env from back/.env.example"
fi

database_url="$(awk -F= '/^DATABASE_URL=/{print substr($0, index($0,$2)); exit}' "$BACK_DIR/.env")"
if [[ -z "$database_url" ]]; then
  echo "❌ DATABASE_URL is empty in back/.env."
  echo "   Edit back/.env and set your PostgreSQL connection string, then rerun setup."
  exit 1
fi

if [[ "$created_env" -eq 1 ]]; then
  echo "⚠️ back/.env was just created with template values."
  echo "   Set your real DATABASE_URL in back/.env, then rerun the same bootstrap command."
  exit 0
fi

if [[ "$database_url" == "$DEFAULT_DATABASE_URL" ]]; then
  echo "⚠️ DATABASE_URL is still the default local example value: $DEFAULT_DATABASE_URL"
  echo "   On hosting this usually causes ECONNREFUSED 127.0.0.1:5432."
  echo "   Update back/.env with your hosting PostgreSQL URL, then rerun setup."
  exit 1
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
set +e
migration_output="$(npm run db:migrate 2>&1)"
migration_status=$?
set -e
echo "$migration_output"

if [[ $migration_status -ne 0 ]]; then
  echo "❌ Migration failed."
  if echo "$migration_output" | grep -qiE '28P01|password authentication failed'; then
    echo "   PostgreSQL auth failed (28P01). Check user/password in back/.env DATABASE_URL."
    echo "   If password contains special chars like !, ), @, #, encode them in URL format (%21, %29, %40, %23)."
  elif echo "$migration_output" | grep -q 'ECONNREFUSED'; then
    echo "   Cannot connect to PostgreSQL host/port from DATABASE_URL. Verify host, port and firewall rules."
  else
    echo "   Verify DATABASE_URL in back/.env and test credentials with your hosting panel/client."
  fi
  exit 1
fi

echo "🌱 Seeding database..."
npm run db:seed

echo "📦 Installing frontend dependencies..."
cd "$FRONT_DIR"
npm install --include=dev

echo "✅ Setup complete."
echo "Run in two terminals:"
echo "  1) cd back && npx tsx src/index.ts"
echo "  2) cd front && npm run dev"
