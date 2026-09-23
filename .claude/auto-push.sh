#!/usr/bin/env bash
# Commit + push automatique de tout changement du dossier vers GitHub.
# Appelé par le hook "Stop" de Claude Code (.claude/settings.json) ou à la main via Publier.cmd.
cd "$(dirname "$0")/.." || exit 0
LOG=".claude/auto-push.log"

[ -z "$(git status --porcelain)" ] && exit 0

git add -A
FILES=$(git diff --cached --name-only | head -20)
git commit -q -m "Mise à jour auto $(date '+%Y-%m-%d %H:%M')" -m "$FILES" || exit 0

if git pull -q --rebase origin main && git push -q origin main; then
  echo "$(date '+%F %T') OK  $(git rev-parse --short HEAD)" >> "$LOG"
  echo "Poussé sur GitHub : $(git rev-parse --short HEAD)" >&2
else
  echo "$(date '+%F %T') ÉCHEC du push (le commit reste en local)" >> "$LOG"
  echo "Push GitHub en échec, voir $LOG" >&2
fi
exit 0
