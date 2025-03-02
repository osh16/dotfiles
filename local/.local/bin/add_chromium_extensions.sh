#!/usr/bin/env bash

EXTENSIONS=("kcdolhjbipnfgefpjaopfbjbannphidh", "bcjindcccaagfpapjjmafapmmgkkhgoa")
PROFILE_DIR="$HOME/snap/chromium/common/chromium"

for PROFILE in "$PROFILE_DIR"/Default "$PROFILE_DIR"/Profile*; do
    PREFERENCES_FILE="$PROFILE/Preferences"
    if [[ -f "$PREFERENCES_FILE" ]]; then
        for EXTENSION in "${EXTENSIONS[@]}"; do
            jq --arg ext "$EXTENSION" '
                .extensions.settings[$ext] += {"install_source": "webstore"}
            ' "$PREFERENCES_FILE" > tmp.json && mv tmp.json "$PREFERENCES_FILE"
        done
    fi
done
