#!/usr/bin/env bash

cd $ZK_NOTEBOOK_DIR
git add .
git commit -m "zk auto-save $(date '+%Y-%m-%d %H:%M:%S')"
git push
cd -
