#!/bin/bash
# Auto-commit and push changes in ~/hiya when the watcher triggers
cd /home/eli/hiya || exit 1

# Nothing to commit? Exit quietly (handles untracked files too).
if git status --porcelain | grep -q .; then
    :
else
    exit 0
fi

git add .
git commit -m "Auto-backup: $(date '+%Y-%m-%d %H:%M:%S')" || exit 0
git push origin main
