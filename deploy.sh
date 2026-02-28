#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# Selwin Murzello — GitHub Pages Deploy Script
# Run this once from the folder containing portfolio.html and resume.pdf
# Usage: bash deploy.sh
# ─────────────────────────────────────────────────────────────────────────────

set -e

GITHUB_USER="selmurzello10"
REPO_NAME="${GITHUB_USER}.github.io"
REMOTE_URL="https://${GITHUB_USER}@github.com/${GITHUB_USER}/${REPO_NAME}.git"

echo ""
echo "🚀  Deploying to GitHub Pages..."
echo "    Repo: https://github.com/${GITHUB_USER}/${REPO_NAME}"
echo ""

# ── STEP 1: Rename portfolio.html → index.html (GitHub Pages entry point) ──
if [ -f "portfolio.html" ] && [ ! -f "index.html" ]; then
  cp portfolio.html index.html
  echo "✅  Copied portfolio.html → index.html"
fi

# ── STEP 2: Init git repo ────────────────────────────────────────────────────
git init
git checkout -b main 2>/dev/null || git checkout main

# ── STEP 3: Configure git identity (update if needed) ───────────────────────
git config user.name  "Selwin Murzello"
git config user.email "smurzello10@gmail.com"

# ── STEP 4: Stage files ──────────────────────────────────────────────────────
git add index.html resume.pdf
echo "✅  Staged: index.html, resume.pdf"

# ── STEP 5: Commit ───────────────────────────────────────────────────────────
git commit -m "Launch: Security Engineer portfolio site"
echo "✅  Committed"

# ── STEP 6: Create repo on GitHub (skip if already exists) ──────────────────
echo ""
echo "📦  Creating GitHub repo (you'll be prompted for your PAT as password)..."
curl -s -X POST https://api.github.com/user/repos \
  -H "Accept: application/vnd.github.v3+json" \
  -u "${GITHUB_USER}" \
  -d "{\"name\":\"${REPO_NAME}\",\"description\":\"Selwin Murzello — Security Engineer Portfolio\",\"homepage\":\"https://${GITHUB_USER}.github.io\",\"private\":false}" \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print('  Repo:', d.get('html_url','(already exists — that is fine)'))" 2>/dev/null || true

# ── STEP 7: Push ─────────────────────────────────────────────────────────────
echo ""
echo "⬆️   Pushing to GitHub (enter your PAT when prompted for password)..."
git remote remove origin 2>/dev/null || true
git remote add origin "${REMOTE_URL}"
git push -u origin main --force

echo ""
echo "🎉  Done! Your site will be live in ~60 seconds at:"
echo "    https://${GITHUB_USER}.github.io"
echo ""
echo "    If the page isn't live yet, go to:"
echo "    https://github.com/${GITHUB_USER}/${REPO_NAME}/settings/pages"
echo "    → Source: Deploy from branch → Branch: main → / (root) → Save"
echo ""
