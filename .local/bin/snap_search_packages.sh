#!/usr/bin/env bash

sudo snap search "${1}" | awk '{$2=$3=$4=""; print $0}' | tail -n +2 | sed 's/    / - /g' | fzf --sync | xargs -r sudo snap install
