#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/rhpds/rhdp-skills-marketplace.git"
BRANCH="main"
PROJECT_ROOT="$(git rev-parse --show-toplevel)"
TARGET_DIR="${PROJECT_ROOT}/.claude"
PROMPTS_DIR="${PROJECT_ROOT}/showroom/prompts"

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

echo "Cloning rhdp-skills-marketplace (branch: ${BRANCH})..."
git clone --depth 1 --branch "$BRANCH" --single-branch "$REPO_URL" "$TMPDIR/repo" 2>&1

echo "Installing showroom skills into ${TARGET_DIR}..."
rsync -a \
  --exclude='.claude-plugin' \
  --exclude='README.md' \
  --exclude='prompts' \
  "$TMPDIR/repo/showroom/" "$TMPDIR/repo/ftl/" "$TMPDIR/repo/health/" \
  "$TARGET_DIR/"

echo "Copying prompts into ${PROMPTS_DIR}..."
rsync -a \
  "$TMPDIR/repo/showroom/prompts/" \
  "$PROMPTS_DIR/"

echo "Done. Showroom skills installed into ${TARGET_DIR}/ and prompts into ${PROMPTS_DIR}/"
