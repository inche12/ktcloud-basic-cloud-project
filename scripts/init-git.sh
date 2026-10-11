#!/usr/bin/env bash
set -euo pipefail

if [ ! -d .git ]; then
  git init
fi

git branch -M main
git status

echo "Review .gitignore and secrets before running:"
echo "  git add ."
echo "  git diff --cached"
echo "  git commit -m 'Initial KT Cloud basic project notes'"
