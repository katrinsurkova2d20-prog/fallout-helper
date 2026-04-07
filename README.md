# Fallout 2d20 Helper

A companion web app for the **Fallout 2d20 TTRPG** (by Modiphius Entertainment), designed to help Game Masters and players at the table.

> Built with React + Vite (frontend) and Express + Drizzle ORM + PostgreSQL (backend). Installable as a PWA from the browser.

![Home](public/home.png)

---

## Features

- **Character creation** — step-by-step wizard: origin, SPECIAL, skills, tag skills, perks, equipment packs
- **Character sheet** — HP, AP, inventory management, body resistance map
- **Session manager** — track multiple sessions, manage participants and action points
- **Dice roller** — 2d20 roll with success/complication counting
- **Loot generator** — generate loot by area type, size and location level
- **Merchant generator** — generate merchant inventory by wealth rating
- **Encyclopedia** — browse all weapons, armor, chems, ammo and other items
- **Bilingual** — French and English UI

---

## Quick Start (Docker — recommended)

The easiest way to run the app. No build required, just pull the official image.

**1. Download the compose file**
```bash
curl -O https://raw.githubusercontent.com/katrinsurkova2d20-prog/fallout-helper/main/docker-compose.yml
```

**2. Start the app**
```bash
docker compose up -d
```

The app is available at [http://localhost:3000](http://localhost:3000).

> On first start, the database is automatically migrated and seeded with all game data.

### Environment variables

| Variable | Default | Description |
|---|---|---|
| `DATABASE_URL` | *(set in compose)* | PostgreSQL connection string |
| `PORT` | `3001` | Backend API port (internal) |
| `NODE_ENV` | `production` | Node environment |

### Change the exposed port

Edit `docker-compose.yml` and change `"3000:80"` to your desired port, e.g. `"8080:80"`.

---

## Build from source

**Requirements:** Node.js 22+, Docker, PostgreSQL

**1. Clone the repo**
```bash
git clone https://github.com/katrinsurkova2d20-prog/fallout-helper.git
cd fallout-helper
```

**2. Build and start**
```bash
docker compose -f docker-compose.yml up -d --build
```

Or run without Docker:

### Option A — automatic setup script (recommended on hosting/VPS)

```bash
# Download and run directly
curl -fsSL https://raw.githubusercontent.com/katrinsurkova2d20-prog/fallout-helper/main/scripts/bootstrap-hosting.sh | bash
```

Or with `wget`:

```bash
wget -qO- https://raw.githubusercontent.com/katrinsurkova2d20-prog/fallout-helper/main/scripts/bootstrap-hosting.sh | bash
```

<<<<<<< codex/translate-app-and-data-to-russian-ub1e0t

By default, if you run the bootstrap command **from a folder named `www`**, it now installs directly into `www` (without creating `fallout-helper`).

=======
>>>>>>> main
Install directly into the current `www` folder (no `fallout-helper/` subdirectory):

```bash
wget -qO- https://raw.githubusercontent.com/katrinsurkova2d20-prog/fallout-helper/main/scripts/bootstrap-hosting.sh | bash -s -- https://github.com/katrinsurkova2d20-prog/fallout-helper.git .
```

If `www` is not empty and you still want to overwrite files, add `FORCE_OVERWRITE=1`:

```bash
wget -qO- https://raw.githubusercontent.com/katrinsurkova2d20-prog/fallout-helper/main/scripts/bootstrap-hosting.sh | FORCE_OVERWRITE=1 bash -s -- https://github.com/katrinsurkova2d20-prog/fallout-helper.git .
```

This command will:
1. Clone (or update) the repository.
2. Run `scripts/setup-dev.sh`.
3. Create `back/.env` automatically if missing.
4. Stop once so you can set `DATABASE_URL` (first run only).
5. On rerun: install dependencies, run DB migrations/seeders.

`bootstrap-hosting.sh` works even if `git` is missing: it will download the source archive via `curl`/`wget` as a fallback.
`setup-dev.sh` installs devDependencies too, and if hosting still forces production-only mode, it auto-installs required CLI tools (`drizzle-kit`, `tsx`) locally.

### Option B — manual commands

```bash
# Backend
cd back
cp .env.example .env   # edit DATABASE_URL
npm install --include=dev
npm run db:migrate
npm run db:seed
npx tsx src/index.ts

# Frontend (separate terminal)
cd front
npm install --include=dev
npm run dev
```

If you see `npm: command not found`, install Node.js first (22+).  
`Option A` script can try to install Node.js automatically via `nvm`.

### What does `cp .env.example .env` mean?

- `cp` = copy file.
- `.env.example` = template file with example environment variables.
- `.env` = your local/private configuration file used by the backend.

So this command creates your real config file from the template:

```bash
cp .env.example .env
```

Then open `back/.env` and set `DATABASE_URL` for your PostgreSQL instance before running backend commands.

<<<<<<< codex/translate-app-and-data-to-russian-ub1e0t
If your DB password has special characters (`!`, `)`, `@`, `#`, etc.), URL-encode them in `DATABASE_URL`.
Example: `!` -> `%21`, `)` -> `%29`, `@` -> `%40`, `#` -> `%23`.

=======
>>>>>>> main
---


## Tech stack

| Layer | Tech |
|---|---|
| Frontend | React 18, Vite, TypeScript, Tailwind CSS, i18next |
| Backend | Express, Drizzle ORM, PostgreSQL |
| Infra | Docker, nginx, GitHub Actions, GHCR |

---

## License

[MIT](LICENSE)

---

## Screenshots

### Character creation
![Character creation](public/createpj.png)

### PC / NPC list
![PC/NPC list](public/listpcnpc.png)

### Loot generator
![Loot generator](public/loot.png)

### Merchant generator
![Merchant](public/merch.png)

### Encyclopedia
![Encyclopedia](public/encyclo.png)

### Item details
![Item details](public/itemdetails.png)

### Session manager
![Session manager](public/session.png)

---

> This is an unofficial fan-made tool. Fallout is a trademark of Bethesda Softworks. The Fallout 2d20 system is published by [Modiphius Entertainment](https://www.modiphius.net/).
