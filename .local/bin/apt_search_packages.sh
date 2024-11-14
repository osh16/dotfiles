#!/usr/bin/env bash

sudo apt-cache search "${1}" | fzf --sync | awk '{print $1}' | xargs -r sudo apt install
