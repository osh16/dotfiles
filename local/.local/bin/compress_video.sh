#!/usr/bin/env bash

# Usage:
#   ./compress-to-size.sh input.mp4 100
#   ./compress-to-size.sh input.mp4 100 output.mp4

INPUT="$1"
TARGET_MB="$2"
OUTPUT="$3"

if [ -z "$INPUT" ] || [ -z "$TARGET_MB" ]; then
    echo "Usage: $0 <inputfile> <target_size_mb> [outputfile]"
    exit 1
fi

# Auto-generate output name if missing
if [ -z "$OUTPUT" ]; then
    BASENAME="${INPUT%.*}"
    EXT="${INPUT##*.}"
    OUTPUT="${BASENAME}_compressed.${EXT}"
fi

# Convert target MB → bits
TARGET_BITS=$(( TARGET_MB * 1024 * 1024 * 8 ))

# Get duration (integer seconds)
DUR=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$INPUT")
DUR=${DUR%.*}

# Audio bitrate
AUDIO_KBPS=128

# 15% safety margin
SAFETY=85

# Compute bitrate
TOTAL_KBPS=$(( TARGET_BITS / DUR / 1000 ))
TOTAL_KBPS=$(( TOTAL_KBPS * SAFETY / 100 ))
VIDEO_KBPS=$(( TOTAL_KBPS - AUDIO_KBPS ))

# Minimum safe video bitrate
if (( VIDEO_KBPS < 200 )); then VIDEO_KBPS=200; fi

echo "Duration: $DUR sec"
echo "Output: $OUTPUT"
echo "Video bitrate: ${VIDEO_KBPS}k, Audio: ${AUDIO_KBPS}k"

# Pass 1
ffmpeg -y -i "$INPUT" -c:v libx264 -b:v ${VIDEO_KBPS}k -pass 1 -an -f mp4 /dev/null

# Pass 2
ffmpeg -y -i "$INPUT" -c:v libx264 -b:v ${VIDEO_KBPS}k -c:a aac -b:a ${AUDIO_KBPS}k -pass 2 "$OUTPUT"

# Check size
SIZE_MB=$(du -m "$OUTPUT" | cut -f1)
echo "Initial size: ${SIZE_MB}MB"

# Force size under limit if needed
if (( SIZE_MB > TARGET_MB )); then
    echo "Applying -fs to enforce size cap..."
    ffmpeg -y -i "$OUTPUT" -fs ${TARGET_MB}M -c:v libx264 -c:a aac "${OUTPUT}.tmp"
    mv "${OUTPUT}.tmp" "$OUTPUT"
fi

echo "Final size: $(du -m "$OUTPUT" | cut -f1)MB"
echo "Done!"
