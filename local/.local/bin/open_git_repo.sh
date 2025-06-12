#!/usr/bin/env bash

if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == "true" ]]; then
  xdg-open "$(git config --get remote.origin.url \
    | sed -E 's#git@github.com:([^/]+)/([^\.]+)\.git#https://github.com/\1/\2#' \
    | sed -E 's#git@ssh.dev.azure.com:v3/([^/]+)/([^/]+)/([^/]+)#https://dev.azure.com/\1/\2/_git/\3#' \
    | sed 's/%20/ /g')"
fi
