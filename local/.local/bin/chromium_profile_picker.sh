#!/usr/bin/env bash

cat "$HOME/snap/chromium/common/chromium/Local State" | jq -r '.profile.info_cache | to_entries[] | "\(.key): \(.value.name)"' | fzf --sync | awk -F ":" '{print $1}' | xargs -I {} chromium --profile-directory="{}" --new-tab
