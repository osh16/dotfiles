#!/usr/bin/env bash

set -e

if [ -z "$ZK_NOTEBOOK_DIR" ] || [ ! -d "$ZK_NOTEBOOK_DIR" ]; then
    echo "Error: ZK_NOTEBOOK_DIR is not set or does not exist."
    exit 1
fi

cd "$ZK_NOTEBOOK_DIR/work"
git pull
git add .
if ! git diff --cached --quiet; then
    git commit -m "zk auto-save $(date '+%Y-%m-%d %H:%M:%S')"
    git push
fi
cd -

cd "$ZK_NOTEBOOK_DIR/personal"
git pull
git add .
if ! git diff --cached --quiet; then
    git commit -m "zk auto-save $(date '+%Y-%m-%d %H:%M:%S')"
    git push
fi
cd -
